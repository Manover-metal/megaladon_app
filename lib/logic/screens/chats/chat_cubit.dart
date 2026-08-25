import 'dart:async';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/chat/chat_model.dart';
import 'package:megaladon/data/models/chat/message_model.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/request/params/create/message_create_request_params.dart';
import 'package:megaladon/data/models/request/params/index/message_index_request_params.dart';
import 'package:megaladon/data/repositories/chat_repository.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';

part 'chat_state.dart';

/// Чаты работают на polling: пока открыт экран списка — по таймеру опрашиваем
/// список чатов, пока открыт конкретный чат — его сообщения. Real-time через
/// websockets/пуши здесь намеренно не используется.
class ChatCubit extends Cubit<ChatState> with WidgetsBindingObserver {
  ChatCubit(this.authBloc) : super(const ChatState()) {
    WidgetsBinding.instance.addObserver(this);
    _listenAuth(authBloc.state);
    _authSub = authBloc.stream.listen(_listenAuth);
  }

  final ChatRepository _repository = ChatRepository();
  final AuthBloc authBloc;

  static const Duration _pollInterval = Duration(seconds: 5);

  /// Список чатов опрашивается и вне экрана чатов — иначе бейдж непрочитанных
  /// в меню оставался бы тем, каким его увидели при последнем заходе в чаты.
  /// Реже, чем на самом экране: он нужен только для счётчика.
  static const Duration _backgroundListInterval = Duration(seconds: 30);

  /// Размер страницы сообщений. Должен совпадать с
  /// [MessageIndexRequestParams.rowsPerPage].
  static const int _pageSize = 50;

  StreamSubscription<AuthState>? _authSub;
  Timer? _chatTimer;
  Timer? _listTimer;
  bool _listActive = false;
  bool _chatPollInFlight = false;

  /// Генератор временных id для оптимистичных сообщений. Отрицательный и
  /// убывающий — чтобы гарантированно не пересекаться с серверными id.
  int _tempIdSeq = -1;

  /// До какого сообщения чат уже помечен прочитанным, по chatId. Нужен, чтобы
  /// опрос открытой переписки не слал отметку каждые пять секунд.
  final Map<int, int> _markedReadUpTo = {};

  // --- Lifecycle -----------------------------------------------------------

  Future<void> initial() async {
    if (authBloc.state is AuthLoginState) {
      await fetchChats();
      _restartListTimer();
    }
  }

  void _listenAuth(AuthState state) {
    if (state is AuthLoginState) {
      initial();
    } else if (state is AuthLogoutState) {
      _dispose();
    }
  }

  void _dispose() {
    _chatTimer?.cancel();
    _listTimer?.cancel();
    _chatTimer = null;
    _listTimer = null;
    _listActive = false;
    _markedReadUpTo.clear();
    emit(const ChatState());
  }

  // --- Список чатов --------------------------------------------------------

  Future<void> fetchChats({bool silent = false}) async {
    if (!silent) {
      if (state.status == ChatScreenMainStatus.loading && state.error == null) {
        return;
      }
      emit(state.copyWith(status: ChatScreenMainStatus.loading, error: null));
    }

    try {
      final chats = await _repository.index();
      // Сохраняем уже загруженные сообщения открытых чатов при обновлении списка
      // (index возвращает чаты без сообщений).
      final merged = chats.map((c) {
        final existing = _chatById(c.id);
        if (existing != null && existing.messages.isNotEmpty) {
          return c.mergeMessages(existing.messages);
        }
        return c;
      }).toList();
      emit(state.copyWith(
        chats: merged,
        status: ChatScreenMainStatus.success,
      ));
    } catch (error) {
      _handleError(error, silent: silent);
    }
  }

  /// Экран чатов открыт — переключаемся на частый опрос.
  void startListPolling() {
    _listActive = true;
    _restartListTimer();
  }

  /// Экран чатов закрыт. Опрос не останавливаем, а замедляем: бейдж в меню
  /// должен обновляться и с других экранов.
  void stopListPolling() {
    _listActive = false;
    _restartListTimer();
  }

  void _restartListTimer() {
    _listTimer?.cancel();
    _listTimer = null;
    if (authBloc.state is! AuthLoginState) return;
    _listTimer = Timer.periodic(
      _listActive ? _pollInterval : _backgroundListInterval,
      (_) => fetchChats(silent: true),
    );
  }

  // --- Конкретный чат ------------------------------------------------------

  Future<void> openChat(int chatId) async {
    // Если список ещё не загружен, подтягиваем его, чтобы чат существовал в state.
    if (_chatById(chatId) == null) {
      await fetchChats(silent: true);
    }
    emit(state.copyWith(activeChatId: chatId));
    await _fetchAndMerge(chatId, 0, silent: true);
    await _markRead(chatId);
    _restartChatTimer();
  }

  void closeChat() {
    _chatTimer?.cancel();
    _chatTimer = null;
    emit(state.copyWith(clearActiveChatId: true));
  }

  void _restartChatTimer() {
    _chatTimer?.cancel();
    if (state.activeChatId == null) return;
    _chatTimer = Timer.periodic(_pollInterval, (_) => _pollActiveChat());
  }

  Future<void> _pollActiveChat() async {
    final id = state.activeChatId;
    if (id == null || _chatPollInFlight) return;
    _chatPollInFlight = true;
    try {
      await _fetchAndMerge(id, 0, silent: true);
      // Пока переписка открыта, пришедшее сообщение сразу считается
      // прочитанным: опрос списка мог успеть поднять счётчик.
      await _markRead(id);
    } finally {
      _chatPollInFlight = false;
    }
  }

  /// Гасит счётчик непрочитанных у чата: сначала локально, чтобы бейдж исчез
  /// без ожидания сети, затем на сервере. Ошибку глушим — ближайший опрос
  /// списка вернёт настоящий счётчик, и отметка повторится.
  ///
  /// Отметку привязываем к последнему сообщению: пока в открытой переписке
  /// ничего нового не появилось, запрос не повторяется, а как только придёт
  /// новое — уходит сразу, не дожидаясь, пока опрос списка поднимет счётчик.
  Future<void> _markRead(int chatId) async {
    final chat = _chatById(chatId);
    if (chat == null || chat.messages.isEmpty) return;

    final lastId = chat.messages.last.id;
    if (_markedReadUpTo[chatId] == lastId && !chat.hasUnread) return;

    if (chat.hasUnread) {
      emit(state.copyWith(
        chats: state.chats
            .map((c) => c.id == chatId ? c.copyWith(unreadCount: 0) : c)
            .toList(),
      ));
    }

    try {
      await _repository.markRead(chatId);
      _markedReadUpTo[chatId] = lastId;
    } catch (error) {
      // ignore: avoid_print
      print('chat markRead error: $error');
    }
  }

  /// Пагинация вверх: подгружает более старые сообщения открытого чата.
  Future<void> loadOlder(int chatId) async {
    if (state.olderLoading[chatId] == true) return;
    if (state.hasMoreOlder[chatId] == false) return;

    final chat = _chatById(chatId);
    if (chat == null) return;

    emit(state.copyWith(
      olderLoading: {...state.olderLoading, chatId: true},
    ));

    final count = await _fetchAndMerge(chatId, chat.messages.length, silent: true);

    final hasMore = {...state.hasMoreOlder};
    if (count >= 0 && count < _pageSize) {
      hasMore[chatId] = false;
    }
    emit(state.copyWith(
      olderLoading: {...state.olderLoading, chatId: false},
      hasMoreOlder: hasMore,
    ));
  }

  /// Загружает страницу сообщений (начиная со [startRow]) и вливает её в чат.
  /// Возвращает число полученных сообщений или -1 при ошибке.
  Future<int> _fetchAndMerge(int chatId, int startRow,
      {bool silent = false}) async {
    try {
      final fetched = await _repository.getMessages(
          chatId, MessageIndexRequestParams(startRow));
      _mergeIntoChat(chatId, fetched);
      return fetched.length;
    } catch (error) {
      _handleError(error, silent: silent);
      return -1;
    }
  }

  void _mergeIntoChat(int chatId, List<MessageModel> incoming) {
    if (incoming.isEmpty) return;
    final chats = state.chats
        .map((c) => c.id == chatId ? c.mergeMessages(incoming) : c)
        .toList();
    emit(state.copyWith(chats: chats));
  }

  // --- Отправка ------------------------------------------------------------

  Future<void> sendMessage(int chatId, String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    if (authBloc.state is! AuthLoginState) return;

    final temp = MessageModel(
      id: _tempIdSeq--,
      createdAt: DateTime.now(),
      text: trimmed,
    );
    _addPending(chatId, temp);

    try {
      final msg = await _repository.sendMessage(
          MessageCreateRequestParams(message: trimmed, chatId: chatId));
      _removePending(chatId, temp);
      // Если ответ распарсился — сразу показываем реальное сообщение.
      // Если нет (msg == null) — его подтянет ближайший опрос.
      if (msg != null) _mergeIntoChat(chatId, [msg]);
    } catch (error) {
      _removePending(chatId, temp);
      _addFailed(chatId, temp);
    }
  }

  Future<void> sendFile(int chatId, PlatformFile file) async {
    if (authBloc.state is! AuthLoginState || file.bytes == null) return;

    final temp = MessageModel(
      id: _tempIdSeq--,
      createdAt: DateTime.now(),
      text: null,
      fileName: file.name,
    );
    _addPending(chatId, temp);

    try {
      final multipart = MultipartFile.fromBytes(
        file.bytes!,
        filename: file.name,
        contentType: _mediaTypeFor(file.name),
      );
      final msg = await _repository.sendMessage(
          MessageCreateRequestParams(chatId: chatId, file: multipart));
      _removePending(chatId, temp);
      if (msg != null) _mergeIntoChat(chatId, [msg]);
    } catch (_) {
      _removePending(chatId, temp);
      _addFailed(chatId, temp);
    }
  }

  DioMediaType? _mediaTypeFor(String name) {
    final ext = name.contains('.') ? name.split('.').last.toLowerCase() : '';
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return DioMediaType('image', 'jpeg');
      case 'png':
        return DioMediaType('image', 'png');
      case 'pdf':
        return DioMediaType('application', 'pdf');
      case 'doc':
        return DioMediaType('application', 'msword');
      case 'docx':
        return DioMediaType('application',
            'vnd.openxmlformats-officedocument.wordprocessingml.document');
      default:
        return null;
    }
  }

  Future<void> retryMessage(int chatId, MessageModel failed) async {
    final map = Map<int, List<MessageModel>>.from(state.errorMessages);
    map[chatId] = <MessageModel>[...?map[chatId]]
      ..removeWhere((e) => e.id == failed.id);
    emit(state.copyWith(errorMessages: map));
    await sendMessage(chatId, failed.text ?? '');
  }

  void _addPending(int chatId, MessageModel m) {
    final map = Map<int, List<MessageModel>>.from(state.loadingMessages);
    map[chatId] = <MessageModel>[...?map[chatId], m];
    emit(state.copyWith(loadingMessages: map));
  }

  void _removePending(int chatId, MessageModel m) {
    final map = Map<int, List<MessageModel>>.from(state.loadingMessages);
    map[chatId] = <MessageModel>[...?map[chatId]]
      ..removeWhere((e) => e.id == m.id);
    emit(state.copyWith(loadingMessages: map));
  }

  void _addFailed(int chatId, MessageModel m) {
    final map = Map<int, List<MessageModel>>.from(state.errorMessages);
    map[chatId] = <MessageModel>[...?map[chatId], m];
    emit(state.copyWith(errorMessages: map));
  }

  // --- Создание чатов ------------------------------------------------------

  /// Создаёт (или переиспользует существующий) личный чат с пользователем
  /// [userId]. Возвращает чат, чтобы экран мог сразу открыть переписку.
  Future<ChatModel?> createChat(int userId) async {
    final chat = await _repository.create(userId);
    await fetchChats(silent: true);
    return chat;
  }

  // --- Прочее --------------------------------------------------------------

  ChatModel? _chatById(int id) {
    for (final c in state.chats) {
      if (c.id == id) return c;
    }
    return null;
  }

  void _handleError(Object error, {bool silent = false}) {
    if (error is DioException && error.response?.statusCode == 403) {
      authBloc.add(AuthLogoutEvent());
      return;
    }
    if (silent) {
      // Фоновый опрос не должен ронять экран — просто логируем.
      // ignore: avoid_print
      print('chat poll error: $error');
      return;
    }
    emit(state.copyWith(
      status: ChatScreenMainStatus.error,
      error: error is DioException
          ? ErrorModel.parseDio(error)
          : ErrorModel.nothing,
    ));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _restartListTimer();
      if (this.state.activeChatId != null) _restartChatTimer();
    } else {
      _chatTimer?.cancel();
      _listTimer?.cancel();
    }
  }

  @override
  Future<void> close() {
    _authSub?.cancel();
    _chatTimer?.cancel();
    _listTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }
}

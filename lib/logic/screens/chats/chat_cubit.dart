import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/core/pusher/index.dart';
import 'package:megaladon/data/models/chat/chat_model.dart';
import 'package:megaladon/data/models/chat/message_model.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/request/params/create/message_create_request_params.dart';
import 'package:megaladon/data/models/request/params/index/message_index_request_params.dart';
import 'package:megaladon/data/repositories/chat_repository.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(this.authBloc) : super(ChatState()) {
    _listenAuth(authBloc.state);
    authBloc.stream.listen(_listenAuth);
  }
  final ChatRepository _repository = ChatRepository();
  final AuthBloc authBloc;

  Future<void> initial() async {
    if (authBloc.state is AuthLoginState) {
      var auth = (authBloc.state as AuthLoginState).auth;
      print(auth.token);
      await PusherService.init(auth.token!);
      await _connectUser();
      await fetch();
    }
  }

  void _listenAuth(state) {
    if (state is AuthLoginState) {
      initial();
    } else if (state is AuthLogoutState) {
      _dispose();
    }
  }

  Future getMessages(int chatId) async {
    var isLoading = state.isLoadingMessages[chatId] ?? false;

    if (!isLoading) {
      var isLoadingMessages = <int, bool>{chatId: true};
      emit(state.copyWith(
          isLoadingMessages: isLoadingMessages, update: state.update + 1));

      var chat = state.chats.singleWhere((element) => element.id == chatId);

      var params = MessageIndexRequestParams(chat.messages.length);

      return _repository.getMessages(chatId, params).then((value) {
        var allParams = state.params;
        allParams[chatId] = params;
        isLoadingMessages[chatId] = false;

        emit(state.copyWith(
            chats: state.chats.map((e) {
              if (chat.id == e.id) {
                return chat.addMessage(value.reversed.toList());
              }
              return e;
            }).toList(),
            isLoadingMessages: isLoadingMessages,
            params: allParams,
            update: state.update + 1));
      }).catchError((error) {
        print(error);
        isLoadingMessages[chatId] = false;
        emit(state.copyWith(
            isLoadingMessages: isLoadingMessages, update: state.update + 1));
      });
    }
  }

  Future fetch() async {
    if (state.status == ChatScreenMainStatus.loading && state.error == null)
      return;

    emit(state.copyWith(
      status: ChatScreenMainStatus.loading,
      error: null,
    ));

    return await _repository.index().then((value) {
      for (final chat in value) {
        _connectChat(chat);
      }
      emit(state.copyWith(
        chats: value,
        status: ChatScreenMainStatus.success,
      ));
    }).catchError((error) {
      print(error);
      if (error is DioException) {
        if (error.response?.statusCode == 403) {
          authBloc.add(AuthLogoutEvent());
        } else {
          emit(state.copyWith(
              status: ChatScreenMainStatus.error,
              error: ErrorModel.parseDio(error)));
        }
      } else {
        emit(state.copyWith(
            status: ChatScreenMainStatus.error, error: ErrorModel.nothing));
      }
    });
  }

  Future<void> _connectChat(ChatModel chat) async {
    await PusherService.instance.subscribe(
        channelName: 'chat.${chat.id}',

        /// TODO: проблема с подпиской на канал, при каждом новом сообщении происходит перерисовка всего списка сообщений, нужно оптимизировать так, чтобы перерисовывалось только новое сообщение
        // onEvent: _event(chat),
        onSubscriptionError: (e) {
          print(e);
        },
        onSubscriptionSucceeded: (e) {
          print(e);
        },
        onMemberAdded: (member) {
          print('Member added: $member');
        },
        onMemberRemoved: (member) {
          print('Member removed: $member');
        });
    await PusherService.instance.connect();
  }

  Future<void> _connectUser() async {
    print('connectUser');
    // if (authBloc.state is AuthLoginState) {
    //   print('connectUser 2');

    //   await PusherService.instance.subscribe(
    //       channelName:
    //           'userChats.${(authBloc.state as AuthLoginState).auth.user.id}',
    //       onEvent: _eventUser,
    //       onSubscriptionError: (e) {
    //         print(e);
    //       },
    //       onSubscriptionSucceeded: (e) {
    //         print(e);
    //       },
    //       onMemberAdded: (member) {
    //         print('Member added: $member');
    //       },
    //       onMemberRemoved: (member) {
    //         print('Member removed: $member');
    //       });
    //   await PusherService.instance.connect();
    // }
  }

  void _eventUser(event) {
    fetch();
  }

  // Future<void> Function(event) _event(ChatModel chatOne) =>
  //     (event) async {
  //       print(event);

  /// TODO: оптимизировать добавление сообщений, сейчас при каждом новом сообщении происходит перерисовка всего списка сообщений, нужно оптимизировать так, чтобы перерисовывалось только новое сообщение
  // if (event.eventName == 'new_message') {
  //   final data = jsonDecode(event.data);
  //   var message = MessageModel.fromJson(data['message']);
  //   var chat =
  //       state.chats.singleWhere((element) => element.id == chatOne.id);
  //   chat.messages.add(message);
  //   _changeLoadingMessages(
  //       chat.id,
  //       state.loadingMessages[chat.id]!
  //           .where((element) => element.text != message.text)
  //           .toList());
  //   emit(state.copyWith(
  //       chats: state.chats.map((e) {
  //         if (chat.id == e.id) {
  //           return chat;
  //         }
  //         return e;
  //       }).toList(),
  //       update: state.update + 1));
  // }
  // };

  Future createChatOrder(int orderId, int executorId) async =>
      await _repository.createOrder(orderId, executorId).then(print);

  Future createChatAdvert(int advertId) async =>
      await _repository.createAdvert(advertId).then(print);

  Future<void> _dispose() async {
    try {
      for (final element in state.chats) {
        await PusherService.instance
            .unsubscribe(channelName: 'chat.${element.id}');
      }

      await PusherService.instance.disconnect();
    } catch (e) {
      print(e);
    }
    emit(ChatState());
  }

  Future sendMessage(ChatModel chat, String text) async {
    if (text == '') return;

    if (authBloc.state is AuthLoginState) {
      _changeLoadingMessages(chat.id, [
        ...?state.loadingMessages[chat.id],
        MessageModel(id: 1, createdAt: DateTime.now(), text: text)
      ]);
      return await ChatRepository()
          .sendMessage(
              MessageCreateRequestParams(message: text, chatId: chat.id))
          .catchError((error) {
        _changeLoadingMessages(
            chat.id,
            state.loadingMessages[chat.id]!
                .where((element) => element.text != text)
                .toList());
        _changeErrorMessages(chat.id, [
          ...?state.loadingMessages[chat.id],
          MessageModel(id: 1, createdAt: DateTime.now(), text: text)
        ]);
      });
    }
    return;
  }

  void _changeLoadingMessages(int chatId, List<MessageModel> loadings) {
    var mapMessagesFromChat = state.loadingMessages;
    mapMessagesFromChat.addAll({chatId: loadings});
    emit(state.copyWith(
        loadingMessages: mapMessagesFromChat, update: state.update + 1));
  }

  void _changeErrorMessages(int chatId, List<MessageModel> errors) {
    var mapMessagesFromChat = state.errorMessages;
    mapMessagesFromChat[chatId] = errors;
    emit(state.copyWith(
        errorMessages: mapMessagesFromChat, update: state.update + 1));
  }
}

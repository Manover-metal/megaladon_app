import 'dart:async';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/core/fb_notification/index.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/repositories/notification_repository.dart';

part 'push_notification_state.dart';

class PushNotificationCubit extends Cubit<PushNotificationState> {
  PushNotificationCubit({NotificationRepository? repository})
      : _repository = repository ?? NotificationRepository(),
        super(const PushNotificationState());

  final NotificationRepository _repository;

  /// Окно debounce: быстрые тапы туда-сюда схлопываются в один запрос.
  static const _debounceDuration = Duration(milliseconds: 450);

  Timer? _debounce;

  /// Монотонный счётчик запросов. Каждый реальный POST помечается своим id;
  /// ответ применяется ТОЛЬКО если его id всё ещё актуален (== _requestId).
  /// Это и есть защита от гонок: устаревшие ответы игнорируются.
  int _requestId = 0;

  /// Первичная загрузка экрана: GET push-status.
  Future<void> init() async {
    emit(state.copyWith(
      status: PushNotificationStatus.loading,
      clearError: true,
    ));
    try {
      final enabled = await _repository.getPushStatus();
      emit(state.copyWith(
        status: PushNotificationStatus.loaded,
        confirmed: enabled,
        optimistic: enabled,
      ));
    } on DioException catch (e) {
      emit(state.copyWith(
        status: PushNotificationStatus.error,
        error: ErrorModel.parseDio(e),
      ));
    } catch (_) {
      emit(state.copyWith(
        status: PushNotificationStatus.error,
        error: ErrorModel.nothing,
      ));
    }
  }

  /// Тап по Switch. Мгновенно меняем UI (optimistic) и планируем отправку.
  // ignore: avoid_positional_boolean_parameters
  void toggle(bool value) {
    if (!state.isReady) return; // тапы до завершения загрузки игнорируем

    // 1. Optimistic update — UI откликается мгновенно, без ожидания сети.
    emit(state.copyWith(optimistic: value, clearError: true));

    // 2. Debounce — отменяем предыдущий отложенный вызов, ставим новый.
    _debounce?.cancel();
    _debounce = Timer(_debounceDuration, _flush);
  }

  /// Срабатывает по истечении debounce — отправляем ФИНАЛЬНОЕ намерение.
  void _flush() {
    final target = state.optimistic;
    if (target == null) return;

    // Пользователь «вернулся» к серверному значению (тык туда-сюда) —
    // сеть не нужна. Но если в полёте ещё висит старый запрос, он мог бы
    // перетереть текущее состояние своим ответом — инвалидируем его.
    if (target == state.confirmed) {
      _requestId++;
      emit(state.copyWith(syncing: false));
      return;
    }
    _send(target);
  }

  Future<void> _send(bool value) async {
    final requestId = ++_requestId; // помечаем запрос как самый свежий
    emit(state.copyWith(syncing: true));

    try {
      // FCM-токен достаём best-effort: если не получилось — не валим тоггл,
      // флаг push_notifications всё равно уходит (device_token опционален).
      String? deviceToken;
      try {
        deviceToken = await FbNotificationService.I.getToken();
      } catch (_) {
        deviceToken = null;
      }

      await _repository.changePushStatus(
        pushNotifications: value,
        deviceToken: deviceToken,
      );

      // Защита от гонок: пока летел ответ, пользователь мог переключить снова
      // и запустить более новый запрос — тогда этот ответ устарел.
      if (requestId != _requestId) return;

      emit(state.copyWith(
        confirmed: value,
        optimistic: value,
        syncing: false,
        clearError: true,
      ));
    } catch (error) {
      if (requestId != _requestId) return; // устаревшую ошибку тоже игнорируем

      // Rollback: возвращаем Switch к последнему подтверждённому значению
      // и поднимаем ошибку для снэкбара.
      emit(state.copyWith(
        optimistic: state.confirmed,
        syncing: false,
        error: error is DioException
            ? ErrorModel.parseDio(error)
            : ErrorModel.nothing,
      ));
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}

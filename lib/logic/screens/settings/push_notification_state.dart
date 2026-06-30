part of 'push_notification_cubit.dart';

/// Жизненный цикл первичной загрузки экрана.
enum PushNotificationStatus { loading, loaded, error }

class PushNotificationState extends Equatable {
  const PushNotificationState({
    this.status = PushNotificationStatus.loading,
    this.confirmed,
    this.optimistic,
    this.error,
    this.syncing = false,
  });

  final PushNotificationStatus status;

  /// Последнее значение, ПОДТВЕРЖДЁННОЕ сервером. null — пока не загрузились.
  /// Именно к нему откатываемся при ошибке.
  final bool? confirmed;

  /// Значение, которое отражает текущее намерение пользователя (optimistic).
  /// Именно его показывает Switch. null — пока не загрузились.
  final bool? optimistic;

  /// Ошибка последней операции (для снэкбара). null — ошибки нет.
  final ErrorModel? error;

  /// Идёт ли фоновая синхронизация с сервером (опциональный индикатор).
  final bool syncing;

  /// Значение, которое должен отрисовать Switch после загрузки.
  bool get value => optimistic ?? confirmed ?? false;

  /// Готов ли тогл к взаимодействию (первичная загрузка завершилась успехом).
  bool get isReady =>
      status == PushNotificationStatus.loaded && optimistic != null;

  PushNotificationState copyWith({
    PushNotificationStatus? status,
    bool? confirmed,
    bool? optimistic,
    bool? syncing,
    ErrorModel? error,
    bool clearError = false,
  }) =>
      PushNotificationState(
        status: status ?? this.status,
        confirmed: confirmed ?? this.confirmed,
        optimistic: optimistic ?? this.optimistic,
        syncing: syncing ?? this.syncing,
        error: clearError ? null : (error ?? this.error),
      );

  @override
  List<Object?> get props => [status, confirmed, optimistic, error, syncing];
}

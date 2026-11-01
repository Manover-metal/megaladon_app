import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/support_ticket_model.dart';
import 'package:megaladon/data/repositories/support_repository.dart';

enum SupportStatus { initial, loading, success, error }

class SupportState extends Equatable {
  const SupportState({
    this.status = SupportStatus.initial,
    this.tickets = const [],
    this.error,
  });

  final SupportStatus status;
  final List<SupportTicketModel> tickets;
  final ErrorModel? error;

  @override
  List<Object?> get props => [status, tickets, error];
}

/// Список своих обращений. Отправка нового идёт напрямую через
/// SupportRepository с экрана — состояния у неё нет, только Future кнопки.
class SupportCubit extends Cubit<SupportState> {
  SupportCubit() : super(const SupportState());

  final SupportRepository repository = SupportRepository();

  Future<void> fetch() async {
    emit(const SupportState(status: SupportStatus.loading));
    try {
      final tickets = await repository.tickets();
      emit(SupportState(status: SupportStatus.success, tickets: tickets));
    } on Object catch (error) {
      emit(SupportState(
        status: SupportStatus.error,
        error: error is DioException
            ? ErrorModel.parseDio(error)
            : ErrorModel.nothing,
      ));
    }
  }
}

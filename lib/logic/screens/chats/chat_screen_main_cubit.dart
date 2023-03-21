import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/chat_model.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/repositories/chat_repository.dart';

part 'chat_screen_main_state.dart';


class ChatScreenMainCubit extends Cubit<ChatScreenMainState> {
  final ChatRepository _repository = ChatRepository();
  ChatScreenMainCubit() : super(const ChatScreenMainState());

  Future fetch() async {
    if(state.status == ChatScreenMainStatus.loading
        && state.error == null
    ) return;

    emit(state.copyWith(
        status: ChatScreenMainStatus.loading,
        error: null,
      )
    );

    return await _repository.index().then((value) {
      emit(state.copyWith(
          chats: [],
          status: ChatScreenMainStatus.success,
      ));
    }).catchError(( error) {
      if(error is DioError) {
        emit(state.copyWith(
            status: ChatScreenMainStatus.error,
            error: ErrorModel.parseDio(error))
        );
      } else {
        emit(state.copyWith(
            status: ChatScreenMainStatus.error,
            error: ErrorModel.nothing)
        );
      }
    });
  }

}
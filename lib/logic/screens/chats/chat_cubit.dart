import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/core/pusher/index.dart';
import 'package:megaladon/data/models/auth/auth_model.dart';
import 'package:megaladon/data/models/chat/chat_model.dart';
import 'package:megaladon/data/models/chat/message_model.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/request/params/create/message_create_request_params.dart';
import 'package:megaladon/data/models/request/params/index/message_index_request_params.dart';
import 'package:megaladon/data/repositories/chat_repository.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';

part 'chat_state.dart';


class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _repository = ChatRepository();
  final AuthBloc authBloc;

  ChatCubit(this.authBloc) : super(ChatState()) {
    _listenAuth(authBloc.state);
    authBloc.stream.listen(_listenAuth);
  }

  initial() async {
    if(authBloc.state is AuthLoginState) {
      AuthModel auth = (authBloc.state as AuthLoginState).auth;
      print(auth.token);
      await PusherService.init(auth.token!);
      await fetch();
    }
  }

  _listenAuth(state) {
    if(state is AuthLoginState) {
      initial();
    } else if(state is AuthLogoutState){
      _dispose();
    }
  }

  Future getMessages(int chatId) async {
    bool isLoading = state.isLoadingMessages[chatId] ?? false;

    if(!isLoading) {
      Map<int, bool> isLoadingMessages = {
        chatId: true
      };
      emit(state.copyWith(
        isLoadingMessages: isLoadingMessages,
        update: state.update + 1
      ));

      ChatModel chat = state.chats.singleWhere((element) => element.id == chatId);
      // MessageIndexRequestParams stateParams = state.params[chatId] ?? MessageIndexRequestParams(0);

      MessageIndexRequestParams params = MessageIndexRequestParams(chat.messages.length);

      return _repository.getMessages(chatId, params).then((value) {
        Map<int, MessageIndexRequestParams> allParams = state.params;
        allParams[chatId] = params;
        isLoadingMessages[chatId] = false;

        emit(state.copyWith(
            chats: state.chats.map((e) {
              if(chat.id == e.id) {
                return chat.addMessage(value.reversed.toList());
              } return e;
            }).toList(),
            isLoadingMessages: isLoadingMessages,
            params: allParams,
            update: state.update + 1
        ));
      }).catchError((error) {
        print(error);
        isLoadingMessages[chatId] = false;
        emit(state.copyWith(
            isLoadingMessages: isLoadingMessages,
            update: state.update + 1
        ));
      });
    }

  }

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
      print(value);
      for (var chat in value) {
        _connectChat(chat);
      }
      emit(state.copyWith(
          chats: value,
          status: ChatScreenMainStatus.success,
      ));
    }).catchError((error) {
      if(error is DioError) {
        if(error.response?.statusCode == 403) {
          authBloc.add(AuthLogoutEvent());
        } else {
          emit(state.copyWith(
              status: ChatScreenMainStatus.error,
              error: ErrorModel.parseDio(error))
          );
        }
      } else {
        emit(state.copyWith(
            status: ChatScreenMainStatus.error,
            error: ErrorModel.nothing)
        );
      }
    });
  }

  _connectChat(ChatModel chat) async {
    await PusherService.instance.subscribe(channelName: 'chat.${chat.id}',
        onEvent: _event(chat),
        onSubscriptionError: (e) {
          print(e);
        },
        onSubscriptionSucceeded: (e) {
          print(e);
        },
        onMemberAdded: (member) {
          print("Member added: $member");
        },
        onMemberRemoved: (member) {
          print("Member removed: $member");
        }
    );
    await PusherService.instance.connect();
  }

  _event(ChatModel chatOne) => (event) async {
    print(event);
    if(event.eventName == 'new_message') {
      final data = jsonDecode(event.data);
      MessageModel message = MessageModel.fromJson(data['message']);
      ChatModel chat = state.chats.singleWhere((element) => element.id == chatOne.id);
      chat.messages.add(message);
      _changeLoadingMessages(chat.id, state.loadingMessages[chat.id]!.where((element) {
        return element.text != message.text;
      }).toList());
      emit(state.copyWith(chats: state.chats.map((e) {
        if(chat.id == e.id) {
          return chat;
        } return e;
      }).toList(), update: state.update + 1));
    }
  };


  Future createChatOrder(int orderId, executorId) async{
    return await _repository.createOrder(orderId, executorId).then((value) {
      print(value);
    });
  }

  Future createChatAdvert(int advertId) async{
    return await _repository.createAdvert(advertId).then((value) {
      print(value);
    });
  }

  _dispose() async {
    try {
      for (var element in state.chats) {
        await PusherService.instance.unsubscribe(channelName: 'chat.${element.id}');
      }
      await PusherService.instance.disconnect();
    } catch (e) {
      print(e);
    }
    emit(ChatState());
  }

  Future sendMessage(ChatModel chat, String text) async {
    if(text == '') return;

    if(authBloc.state is AuthLoginState) {
      _changeLoadingMessages(chat.id, [
        ...?state.loadingMessages[chat.id],
        MessageModel(id: 1, createdAt: DateTime.now(), text: text)
      ]);
      return await ChatRepository().sendMessage(MessageCreateRequestParams(
          message: text,
          chatId: chat.id
      )).catchError((error) {
        _changeLoadingMessages(chat.id, state.loadingMessages[chat.id]!.where((element) {
          return element.text != text;
        }).toList());
        _changeErrorMessages(chat.id, [
          ...?state.loadingMessages[chat.id],
          MessageModel(id: 1, createdAt: DateTime.now(), text: text)
        ]);
      });
    }
    return;
  }

  _changeLoadingMessages(int chatId, List<MessageModel> loadings) {
    Map<int, List<MessageModel>> mapMessagesFromChat = state.loadingMessages;
    mapMessagesFromChat.addAll({chatId: loadings});
    emit(state.copyWith(loadingMessages: mapMessagesFromChat, update: state.update + 1));
  }

  _changeErrorMessages(int chatId, List<MessageModel> errors) {
    Map<int, List<MessageModel>> mapMessagesFromChat = state.errorMessages;
    mapMessagesFromChat[chatId] = errors;
    emit(state.copyWith(errorMessages: mapMessagesFromChat, update: state.update + 1));
  }

}
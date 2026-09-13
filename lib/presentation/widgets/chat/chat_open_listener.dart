import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/chats/chat_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';

/// Открывает чат по [ChatState.openRequest] — единственное место, откуда
/// «Написать» / «Чат» ведут в переписку.
///
/// Висит в корне приложения (SplashScreen), а не на каждом экране: ChatCubit
/// один на всё приложение, и listener на каждом экране стека открыл бы
/// переписку столько раз, сколько таких экранов смонтировано.
class ChatOpenListener extends StatelessWidget {
  const ChatOpenListener({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) => BlocListener<ChatCubit, ChatState>(
        listenWhen: (prev, curr) =>
            curr.openRequest != null &&
            curr.openRequest!.id != prev.openRequest?.id,
        listener: (context, state) {
          final request = state.openRequest!;
          final chat = request.chat;
          if (chat != null) {
            context.router.push(DetailsChatRouter(
              chat: chat,
              draftMessage: request.draftMessage,
            ));
            return;
          }
          final error = request.error;
          CustomSnackBar.error(
            Text(
              error != null && error.messages.isNotEmpty
                  ? error.messages.first
                  : AppLocalizations.of(context)!.unknown_error,
            ),
          ).view(context);
        },
        child: child,
      );
}

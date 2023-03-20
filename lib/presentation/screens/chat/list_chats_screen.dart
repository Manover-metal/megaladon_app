import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/logic/screens/chats/chat_screen_main_cubit.dart';
import 'package:megaladon/presentation/widgets/card/chat_card.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';

class ListChatsScreen extends StatefulWidget {
  const ListChatsScreen({super.key});

  @override
  State<ListChatsScreen> createState() => _ListChatsScreenState();
}

class _ListChatsScreenState extends State<ListChatsScreen> {
  late ScrollController _scrollController;

  Future _refresh() async {
    return context.read<ChatScreenMainCubit>().fetch();
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _refresh();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool isBool) {
            return [
              const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: HeaderAppBar(
                      isMenu: true,
                      title: 'Чаты',
                    ),
                  )
              ),
            ];
          },
          body: RefreshIndicator(
            color: Colors.white,
            onRefresh: _refresh,
            child: CupertinoScrollbar(
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BlocBuilder<ChatScreenMainCubit, ChatScreenMainState>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          ...state.chats.map((chat) {
                            return ChatCard();
                          }).toList(),
                          if(state.status == ChatScreenMainStatus.loading) const Loader(padding: 10)
                          else if(state.status == ChatScreenMainStatus.error)  ErrorMessage(error: state.error!)
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

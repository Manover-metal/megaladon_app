import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/logic/screens/executors/my/executor_screen_my_cubit.dart';
import 'package:megaladon/presentation/widgets/card/executor_card.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';

class ListExecutorScreen extends StatefulWidget {
  const ListExecutorScreen({super.key});

  @override
  State<ListExecutorScreen> createState() => _ListExecutorScreenState();
}

class _ListExecutorScreenState extends State<ListExecutorScreen> {
  late ScrollController _scrollController;


  @override
  void initState() {
    _fetch();
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future _fetch() async {
    return await context.read<ExecutorScreenMyCubit>().fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: HeaderAppBar(
                    isMenu: true,
                    title: 'Исполнители',
                  ),
                ),
              )
            ];
          },
          body: RefreshIndicator(
            onRefresh: _fetch,
            child: CupertinoScrollbar(
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        BlocBuilder<ExecutorScreenMyCubit, ExecutorScreenMyState>(
                          builder: (context, state) {
                            return Column(
                              children: [
                                ...state.executors.map((executor) {
                                  return ExecutorCard(executor: executor);
                                }).toList(),
                                if(state.status == ExecutorScreenMyStatus.loading) const Loader(padding: 10,)
                                else if(state.status == ExecutorScreenMyStatus.error) ErrorMessage(error: state.error!)

                              ],
                            );
                          },
                        ),
                        // Column(
                        //   children: List.generate(6, (index) => ExecutorCard(executor: ,)),
                        // )
                      ],
                    ),
                ),
              ),
            ),
          ),
        )
      ),
    );
  }
}

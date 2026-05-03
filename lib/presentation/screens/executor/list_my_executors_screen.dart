import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/logic/screens/executors/my/executor_screen_my_cubit.dart';
import 'package:megaladon/presentation/widgets/card/executor_card.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/message/stock_message.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';

class ListMyExecutorsScreen extends StatefulWidget {
  const ListMyExecutorsScreen({super.key});

  @override
  State<ListMyExecutorsScreen> createState() => _ListMyExecutorsScreenState();
}

class _ListMyExecutorsScreenState extends State<ListMyExecutorsScreen> {
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
               SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: HeaderAppBar(
                    isMenu: true,
                    title: "Executor".tr(),
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
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        BlocBuilder<ExecutorScreenMyCubit, ExecutorScreenMyState>(
                          builder: (context, state) {
                            return Column(
                              children: [
                                if(state.executors.isEmpty) StockMessage(name: "Executor".tr()),
                                ...state.executors.map((executor) {
                                  return ExecutorCard(executor: executor);
                                }).toList(),
                                if(state.status == ExecutorScreenMyStatus.loading) const Loader(padding: 10,)
                                else if(state.status == ExecutorScreenMyStatus.error) ErrorMessage(error: state.error!)
                              ],
                            );
                          },
                        ),
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

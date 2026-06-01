import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
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

  Future _fetch() async => await context.read<ExecutorScreenMyCubit>().fetch();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: HeaderAppBar(
          isMenu: true,
          title: AppLocalizations.of(context)!.executor,
        ),
        body: RefreshIndicator(
          onRefresh: _fetch,
          child: CupertinoScrollbar(
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              child: Container(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    BlocBuilder<ExecutorScreenMyCubit, ExecutorScreenMyState>(
                      builder: (context, state) => Column(
                        children: [
                          if (state.executors.isEmpty)
                            StockMessage(
                                name: AppLocalizations.of(context)!.executor),
                          ...state.executors
                              .map((executor) =>
                                  ExecutorCard(executor: executor))
                              .toList(),
                          if (state.status == ExecutorScreenMyStatus.loading)
                            const Loader(
                              padding: 10,
                            )
                          else if (state.status == ExecutorScreenMyStatus.error)
                            ErrorMessage(error: state.error!)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

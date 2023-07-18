import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/logic/screens/executors/details/executor_screen_details_cubit.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/tiles/data_tile.dart';
import 'package:megaladon/presentation/widgets/tiles/executor_tile.dart';

class DetailsExecutorScreen extends StatefulWidget {
  final int executorId;

  const DetailsExecutorScreen({super.key, required this.executorId});

  @override
  State<DetailsExecutorScreen> createState() => _DetailsExecutorScreenState();
}

class _DetailsExecutorScreenState extends State<DetailsExecutorScreen> {

  @override
  void initState() {
    context.read<ExecutorScreenDetailsCubit>().fetch(executorId: widget.executorId);
    super.initState();
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
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: HeaderAppBar(isBack: true),
                ),
              )
            ];
          },
          body: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  BlocBuilder<ExecutorScreenDetailsCubit, ExecutorScreenDetailsState>(
                    builder: (context, state) {
                      if(state is ExecutorScreenDetailsSuccess) {
                        return Column(
                          children: [
                            ExecutorTile(executor: state.executor,),
                            const SizedBox(height: 20,),
                            DataTile(
                                title:"Organization".tr(),
                                data: state.executor.name),
                            DataTile(title: "BIN".tr(), data: state.executor.bin!),
                            DataTile(
                                title: "Rating".tr(),
                                data: state.executor.rating ?? '0'),
                            if (state.executor.city != null)
                              DataTile(
                                  title: "City".tr(),
                                  data: state.executor.city!.name),
                            if (state.executor.fullAddress != null)
                              DataTile(
                                  title: "Address".tr(),
                                  data: state.executor.fullAddress!),
                            if (state.executor.countOrders != null)
                              DataTile(
                                  title: 'The_number_of_orders'.tr(),
                                  data: state.executor.countOrders.toString()),
                            if (state.executor.description != null)
                              DataTile(
                                  title: 'Description'.tr(),
                                  data: state.executor.description ?? ''),
                            const Divider(thickness: 1),
                          ],
                        );
                      } else if(state is ExecutorScreenDetailsLoader) {
                        return const Loader();
                      } else if(state is ExecutorScreenDetailsError) {
                        return ErrorMessage(error: state.error);
                      }
                      return Container();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
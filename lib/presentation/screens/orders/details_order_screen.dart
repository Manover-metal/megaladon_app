import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/core/download/download_service.dart';
import 'package:megaladon/data/models/dictionary/file_model.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/screens/orders/delete/order_delete_cubit.dart';
import 'package:megaladon/logic/screens/orders/details/order_screen_details_cubit.dart';
import 'package:megaladon/logic/screens/orders/main/order_screen_main_cubit.dart';
import 'package:megaladon/logic/screens/orders/my/order_screen_my_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/list/file_download_list.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/snackbars/error_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';
import 'package:megaladon/presentation/widgets/tiles/executor_tile.dart';
import 'package:megaladon/presentation/widgets/tiles/user_tile.dart';

class DetailsOrderScreen extends StatefulWidget {
  const DetailsOrderScreen({required this.orderId, super.key});
  final int orderId;

  @override
  State<DetailsOrderScreen> createState() => _DetailsOrderScreenState();
}

class _DetailsOrderScreenState extends State<DetailsOrderScreen> {
  void _createOffer() {
    context.router.push(CreateOfferRoute(orderId: widget.orderId));
  }

  void _checkExecutors() {
    context.router.push(ListExecutorsRoute(orderId: widget.orderId));
  }

  Null Function() _complete(OrderModel order) => () {
        context.read<OrderScreenDetailsCubit>().complete().then((value) {
          context.router.push(ReviewRoute(order: order));
        });
      };

  // _toChat() {
  //  context.read<ChatCubit>().createChat(widget.orderId, executorId);
  // }

  Future<void> Function() _download(FileModel file) => () async {
        await DownloadService.download(
            url: file.url,
            callback: (prog, gres) {
              print('$prog, $gres');
            });
      };

  Null Function() _edit(OrderModel order) => () {
        context.router.navigate(UpdateOrderRoute(order: order));
      };

  Null Function() _delete(OrderModel order) => () {
        context.read<OrderDeleteCubit>().delete(order.id);
      };

  @override
  void initState() {
    context.read<OrderScreenDetailsCubit>().fetch(id: widget.orderId);
    super.initState();
  }

  void _listener(BuildContext context, OrderScreenDetailsState state) {
    if (state.status == OrderScreenDetailsStateStatus.errorMessage) {
      showErrorSnackBar(context, state.errorMessage!.messages[0]);
    }
  }

  void _deleteListener(BuildContext context, OrderDeleteState state) {
    if (state is OrderDeleteSuccess) {
      context.read<OrderScreenMainCubit>().fetch();
      context.read<OrderScreenMyCubit>().refresh();
      context.router.pop();
    } else if (state is OrderDeleteError) {
      showErrorSnackBar(
          context,
          state.error.messages.isNotEmpty
              ? state.error.messages.first
              : AppLocalizations.of(context)!.unknown_error);
    }
  }

  Null Function() _onTrailing(OrderModel order) => () {
        showModalBottomSheet(
            useRootNavigator: true,
            useSafeArea: true,
            context: context,
            builder: (context) => Container(
                  color: Theme.of(context).colorScheme.surface,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OutlinedButtonApp(
                        onPressed: _toUpdate(order),
                        child: Text(AppLocalizations.of(context)!.update),
                      ),
                      const SizedBox(height: 5),
                      ElevatedButtonApp(
                        onPressed: _toDelete(order),
                        child: Text(AppLocalizations.of(context)!.delete),
                      )
                    ],
                  ),
                ));
      };

  Null Function() _toUpdate(OrderModel order) => () {
        context.router.navigate(UpdateOrderRoute(order: order));
      };

  Null Function() _toDelete(OrderModel order) => () {
        context.read<OrderDeleteCubit>().delete(order.id);
      };

  @override
  Widget build(BuildContext context) =>
      BlocListener<OrderDeleteCubit, OrderDeleteState>(
        listener: _deleteListener,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: BlocBuilder<OrderScreenDetailsCubit, OrderScreenDetailsState>(
              builder: (context, state) =>
                  BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authState) => HeaderAppBar(
                    isBack: true,
                    title: state.order != null
                        ? AppLocalizations.of(context)!
                            .orderWithId(state.order!.id.toString())
                        : null,
                    onTrailing: (authState is AuthLoginState) &&
                            authState.auth.user.value?.id ==
                                state.order?.user?.id &&
                            state.order != null
                        ? _onTrailing(state.order!)
                        : null),
              ),
            ),
          ),
          body: SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height),
                  child: BlocConsumer<OrderScreenDetailsCubit,
                      OrderScreenDetailsState>(
                    listener: _listener,
                    builder: (context, state) {
                      if (state.status ==
                              OrderScreenDetailsStateStatus.success ||
                          state.status ==
                              OrderScreenDetailsStateStatus.errorMessage) {
                        var order = state.order!;
                        return Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  Text(order.title),
                                  Text(order.description),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  if (order.files.isEmpty &&
                                      order.images.isEmpty) ...[
                                    SubTitleApp(AppLocalizations.of(context)!
                                        .no_attached_files),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ] else ...[
                                    SubTitleApp(AppLocalizations.of(context)!
                                        .attached_files),
                                    if (order.files.isNotEmpty) ...[
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      FileDownloadList(files: order.files),
                                    ],
                                    if (order.images.isNotEmpty) ...[
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ...order.images.map((e) {
                                        print(e.url);
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Container(
                                                  width: double.infinity,
                                                  constraints:
                                                      const BoxConstraints(
                                                          minHeight: 100),
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  child: CachedNetworkImage(
                                                    imageUrl: e.url,
                                                    progressIndicatorBuilder: (context,
                                                            url,
                                                            downloadProgress) =>
                                                        Icon(
                                                            Icons
                                                                .image_outlined,
                                                            size: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                10),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        Icon(
                                                            Icons.error_outline,
                                                            size: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                10),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                right: 0,
                                                child: IconButton(
                                                    onPressed: _download(e),
                                                    icon: const Icon(
                                                        Icons.download)),
                                              )
                                            ],
                                          ),
                                        );
                                      }).toList()
                                    ]
                                  ],
                                ],
                              ),
                            ),
                            const Divider(thickness: 1),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(AppLocalizations.of(context)!
                                      .desiredBudgetUpToAmount(
                                          order.priceMax.toString())),
                                  Text(AppLocalizations.of(context)!
                                      .validToAmount(
                                          order.priceRecommended.toString())),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  BlocBuilder<AuthBloc, AuthState>(
                                    builder: (context, stateUser) {
                                      if (stateUser is AuthLoginState) {
                                        var user = stateUser.auth.user.value;
                                        print(order.executor);
                                        return Column(
                                          children: [
                                            if (order.user?.id != user?.id) ...[
                                              UserTile(user: order.user!),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                            ] else if (order.executor != null &&
                                                order.executor?.id !=
                                                    user?.id &&
                                                order.status.index >
                                                    OrderStatus
                                                        .active.index) ...[
                                              ExecutorTile(
                                                  executor: order.executor!),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                            if (order.user?.id != user?.id &&
                                                stateUser.auth.executor.value !=
                                                    null &&
                                                order.status ==
                                                    OrderStatus.active) ...[
                                              ElevatedButtonApp(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .offer_services,
                                                onPressed: _createOffer,
                                              ),
                                              // OutlinedButtonApp(
                                              //   text: "Discuss_in_chat".tr(),
                                              //   onPressed: _toChat,
                                              // ),
                                            ] else if (order.user?.id ==
                                                user?.id) ...[
                                              if (order.status ==
                                                  OrderStatus.active) ...[
                                                ElevatedButtonApp(
                                                  text: AppLocalizations.of(
                                                          context)!
                                                      .offersCount(order
                                                          .countOffers
                                                          .toString()),
                                                  onPressed: _checkExecutors,
                                                ),
                                                // OutlinedButtonApp(
                                                //   text: "Discuss_in_chat2".tr(),
                                                //   onPressed: _toChats,
                                                // ),
                                              ],
                                              if (order.status ==
                                                  OrderStatus.hasExecutor) ...[
                                                ElevatedButtonApp(
                                                  text: AppLocalizations.of(
                                                          context)!
                                                      .to_finish_work,
                                                  onPressed: _complete(order),
                                                ),
                                              ],
                                            ],
                                            if (order.user?.id == user?.id &&
                                                order.status.index <=
                                                    OrderStatus
                                                        .active.index) ...[
                                              ElevatedButtonApp(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .edit,
                                                onPressed: _edit(order),
                                              ),
                                              OutlinedButtonApp(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .delete,
                                                onPressed: _delete(order),
                                              ),
                                            ]
                                          ],
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      } else if (state.status ==
                          OrderScreenDetailsStateStatus.loading) {
                        return const Loader(
                          padding: 10,
                        );
                      } else if (state.status ==
                          OrderScreenDetailsStateStatus.error) {
                        return ErrorMessage(error: state.error!);
                      }
                      return Container();
                    },
                  ),
                ),
              ),
            ),
      );
}

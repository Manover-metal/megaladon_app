import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/core/download/download_service.dart';
import 'package:megaladon/core/icons/icons.dart';
import 'package:megaladon/data/models/dictionary/file_model.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/data/models/user_model.dart';
import 'package:megaladon/data/repositories/order_repository.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/screens/orders/details/order_screen_details_cubit.dart';
import 'package:megaladon/logic/screens/orders/main/order_screen_main_cubit.dart';
import 'package:megaladon/logic/screens/orders/my/order_screen_my_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/list/file_download_list.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/snackbars/error_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';
import 'package:megaladon/presentation/widgets/tiles/user_tile.dart';

class DetailsOrderScreen extends StatefulWidget {

  final int orderId;

  const DetailsOrderScreen({super.key, required this.orderId});

  @override
  State<DetailsOrderScreen> createState() => _DetailsOrderScreenState();
}

class _DetailsOrderScreenState extends State<DetailsOrderScreen> {
  _createOffer() {
    context.router.push(CreateOfferRoute(orderId: widget.orderId));
  }

  _checkExecutors() {
    context.router.push(ListExecutorsRoute(orderId: widget.orderId));
  }

  _complete(OrderModel order) => () {
    context.read<OrderScreenDetailsCubit>().complete().then((value) {
      context.router.push(ReviewRoute(order: order));
    });
  };

  _toChat() {
   context.router.navigate(const DetailsChatRouter());
  }

  _download(FileModel file) => () async {
    await DownloadService.download(url: file.url, callback: (prog, gres) {
      print('$prog, $gres');
    });
  };

  _edit(OrderModel order) => () {
    context.router.navigate(UpdateOrderRoute(order: order));
  };
  
  _delete(OrderModel order) => () {
    OrderRepository().delete(order.id).then((value) async {
      context.router.pop();
      context.read<OrderScreenMainCubit>().fetch();
      context.read<OrderScreenMyCubit>().refresh();
    });
  };
  
  _toChats() {
    context.router.navigate(const InitialRouter(
      children: [ProfileRouter(
        children: [ListChatsRoute()]
      )]
    ));
  }


  @override
  void initState() {
    context.read<OrderScreenDetailsCubit>().fetch(id: widget.orderId);
    super.initState();
  }


  _listener(BuildContext context, OrderScreenDetailsState state) {
    if(state.status == OrderScreenDetailsStateStatus.errorMessage) {
      showErrorSnackBar(context, state.errorMessage!.messages[0]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool isBool) {
            return [
              BlocBuilder<OrderScreenDetailsCubit, OrderScreenDetailsState>(
                builder: (context, state) {
                  if(state.status == OrderScreenDetailsStateStatus.success ||
                      state.status == OrderScreenDetailsStateStatus.errorMessage
                  ) {
                    return SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: HeaderAppBar(isBack: true, title: "Order".tr()+'${state.order!.id}'),
                        )
                    );
                  } else {
                    return const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: HeaderAppBar(isBack: true),
                        )
                    );
                  }

                }
              ),
            ];
          },
          body: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height
              ),
              child: BlocConsumer<OrderScreenDetailsCubit, OrderScreenDetailsState>(
                listener: _listener,
                builder: (context, state) {
                  if(state.status == OrderScreenDetailsStateStatus.success ||
                      state.status == OrderScreenDetailsStateStatus.errorMessage
                  ) {
                    OrderModel order = state.order!;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [

                              Text(order.title),
                              Text(order.description),
                              const SizedBox(height: 20,),
                              if(order.files.isEmpty && order.images.isEmpty) ...[
                                SubTitleApp("No_attached_files".tr()),
                                const SizedBox(height: 10,),
                              ]
                              else ...[
                                SubTitleApp("Attached_files".tr()),
                                if(order.files.isNotEmpty) ...[
                                  const SizedBox(height: 10,),
                                  FileDownloadList(files: order.files),
                                ],
                                if(order.images.isNotEmpty) ...[
                                  const SizedBox(height: 10,),
                                  ...order.images.map((e) {
                                    print(e.url);
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: Container(
                                              width: double.infinity,
                                              constraints: const BoxConstraints(
                                                  minHeight: 100
                                              ),
                                              color: Theme.of(context).colorScheme.secondary,
                                              child: CachedNetworkImage(
                                                imageUrl: e.url,
                                                progressIndicatorBuilder: (context, url, downloadProgress) => Icon(Icons.image_outlined, size: MediaQuery.of(context).size.width / 10),
                                                errorWidget: (context, url, error) => Icon(Icons.error_outline, size: MediaQuery.of(context).size.width / 10),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 0,
                                            child: IconButton(
                                                onPressed: _download(e),
                                                icon: const Icon(Icons.download)
                                            ),
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
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${"Desired_budget_up_to".tr()}${order.priceMax} ₸'),
                              Text('${"Valid_to".tr()} ${order.priceRecommended} ₸'),
                              const SizedBox(height: 20,),

                              UserTile(user: order.user!),
                              const SizedBox(height: 20,),
                              BlocBuilder<AuthBloc, AuthState>(
                                builder: (context, stateUser) {
                                  if(stateUser is AuthLoginState) {
                                    UserModel? user = stateUser.auth.user.value;
                                    return Column(
                                      children: [
                                        if(order.user?.id != user?.id
                                            && stateUser.auth.executor.value != null
                                            && order.status == OrderStatus.active
                                        )...[
                                          ElevatedButtonApp(
                                            text: "Offer_services".tr(),
                                            onPressed: _createOffer,
                                          ),
                                          // OutlinedButtonApp(
                                          //   text: "Discuss_in_chat".tr(),
                                          //   onPressed: _toChat,
                                          // ),
                                        ]
                                        else ...[
                                          if(order.status == OrderStatus.active) ...[
                                            ElevatedButtonApp(
                                              text: '${"Offers".tr()}(${order.countOffers} новых)',
                                              onPressed: _checkExecutors,
                                            ),
                                            // OutlinedButtonApp(
                                            //   text: "Discuss_in_chat2".tr(),
                                            //   onPressed: _toChats,
                                            // ),
                                          ],
                                          if(order.status == OrderStatus.hasExecutor) ...[
                                            ElevatedButtonApp(
                                              text: "To_finish_work".tr(),
                                              onPressed: _complete(order),
                                            ),
                                          ],
                                        ],
                                        if(order.user?.id == user?.id
                                          && order.status.index <= OrderStatus.active.index
                                        ) ...[
                                          ElevatedButtonApp(
                                            text: "Edit".tr(),
                                            onPressed: _edit(order),
                                          ),
                                          OutlinedButtonApp(
                                            text: "Delete".tr(),
                                            onPressed: _delete(order),
                                          ),
                                        ]
                                      ],
                                    );
                                  }
                                  else {
                                    return Container();
                                  }

                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  } else if(state.status == OrderScreenDetailsStateStatus.loading) {
                    return const Loader(padding: 10,);
                  } else if(state.status == OrderScreenDetailsStateStatus.error) {
                    return ErrorMessage(error: state.error!);
                  }
                  return Container();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
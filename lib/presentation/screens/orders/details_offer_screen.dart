import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/logic/screens/offers/details/offer_screen_details_cubit.dart';
import 'package:megaladon/logic/screens/orders/details/order_screen_details_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/snackbars/error_snackbar.dart';
import 'package:megaladon/presentation/widgets/tiles/data_tile.dart';
import 'package:megaladon/presentation/widgets/tiles/executor_tile.dart';

class DetailsOfferScreen extends StatefulWidget {
  
  final int orderId;
  final int offerId;

  const DetailsOfferScreen({super.key, required this.orderId, required this.offerId});
  
  @override
  State<DetailsOfferScreen> createState() => _DetailsOfferScreenState();
}

class _DetailsOfferScreenState extends State<DetailsOfferScreen> {
  
  @override
  void initState() {
    context.read<OfferScreenDetailsCubit>().fetch(orderId: widget.orderId, offerId: widget.offerId);
    super.initState();
  }

  _acceptOffer() {
    context.read<OrderScreenDetailsCubit>().acceptOffer(orderId: widget.orderId, offerId: widget.offerId).then((value) {
      context.router.navigate(
        InitialRouter(children: [
          OrderRouter(
            children: [
              DetailsOrderRoute(orderId: widget.orderId)
            ]
          )
        ])
      );
    });
  }
  
  _listenOrder(BuildContext context, OrderScreenDetailsState state) {
    if(state.status == OrderScreenDetailsStateStatus.errorMessage) {
      showErrorSnackBar(context, state.errorMessage!.messages[0]);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<OrderScreenDetailsCubit, OrderScreenDetailsState>(
        listener: _listenOrder,
        child: SafeArea(
              child: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                     SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: HeaderAppBar(isBack: true, title: "Предложение исполнителя".tr()),
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
                        BlocBuilder<OfferScreenDetailsCubit, OfferScreenDetailsState>(
                          builder: (context, state) {
                            if(state is OfferScreenDetailsSuccess) {
                              return Column(
                                children: [
                                  if(state.offer.executor != null) ExecutorTile(executor: state.offer.executor!,),
                                  const SizedBox(height: 20,),
                                  DataTile(title: "Актуален до:".tr(), data: state.offer.expiredAt,),
                                  DataTile(title: "Цена:".tr(), data: '${state.offer.price} ₸',),
                                  DataTile(title: "Сроки:".tr(), data: state.offer.date,),
                                  DataTile(title: "Местоположение:".tr(), data: 'г. ${state.offer.city?.name }',),
                                  if(state.offer.comment != null) DataTile(title: "Описание: ".tr(), data: state.offer.comment!,),
                                  const SizedBox(height: 20,),
                                  ElevatedButtonApp(text: "Назначить исполнителем".tr(), onPressed: _acceptOffer,)
                                ],
                              );
                            } else if(state is OfferScreenDetailsLoader) {
                              return const Loader();
                            } else if(state is OfferScreenDetailsError) {
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
      ),
    );
  }
}
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/screens/orders/details/order_screen_details_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/screens/forms/offer/create_offer_screen.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/list/file_download_list.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';
import 'package:megaladon/presentation/widgets/tiles/user_tile.dart';

class DetailsOrderScreen extends StatefulWidget {

  final int orderId;

  const DetailsOrderScreen({super.key, required this.orderId});
  
  @override
  State<DetailsOrderScreen> createState() => _DetailsOrderScreenState();
}

class _DetailsOrderScreenState extends State<DetailsOrderScreen> {
  _createOffer(BuildContext context) => () {
    context.router.push(CreateOfferRoute(orderId: widget.orderId));
  };

  _checkExecutors(BuildContext context) => () {
    context.router.push(ListExecutorsRoute(orderId: widget.orderId));
  };

  _accept(BuildContext context) => () {
    context.router.push(const ReviewRoute());
  };

  _decline(BuildContext context) => () {
    context.router.push(const ReviewRoute());
  };

  @override
  void initState() {
    context.read<OrderScreenDetailsCubit>().fetch(id: widget.orderId);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool isBool) {
            return [
              SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: HeaderAppBar(isBack: true),
                  )
              ),
            ];
          },
          body: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height
              ),
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return BlocBuilder<OrderScreenDetailsCubit, OrderScreenDetailsState>(
                    builder: (context, state) {
                      if(state is OrderScreenDetailsSuccess) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                children: [
                                  TitleApp('Заказ №${state.order.id}'),
                                  SizedBox(height: 20,),

                                  Text(state.order.title),
                                  Text(state.order.description),
                                  SizedBox(height: 20,),
                                  if(state.order.files!.isEmpty) ...[
                                    SubTitleApp('Нет прикреплённых файлов'),
                                    SizedBox(height: 10,),
                                  ]
                                  else ...[
                                    SubTitleApp('Прикреплённые файлы'),
                                    SizedBox(height: 10,),
                                    FileDownloadList(),
                                  ],
                                ],
                              ),
                            ),
                            Divider(thickness: 1),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Желаемый бюджет: до ${state.order.priceRecommended} ₸'),
                                  Text('Допустимый: до ${state.order.priceMax} ₸'),
                                  SizedBox(height: 20,),

                                  // UserTile(),
                                  SizedBox(height: 20,),

                                  ...[
                                    ElevatedButtonApp(
                                      text: 'Предложить услуги',
                                      onPressed: _createOffer(context),
                                    ),
                                    OutlinedButtonApp(text: 'Обсудить в чате'),
                                  ],
                                  ...[
                                    ElevatedButtonApp(
                                      text: 'Предложения (${state.order.countOffers} новых)',
                                      onPressed: _checkExecutors(context),
                                    ),
                                    OutlinedButtonApp(text: 'Обсудить в чате (5 новых)'),
                                  ],
                                  ...[
                                    ElevatedButtonApp(
                                      text: 'Принять работу',
                                      onPressed: _accept(context),
                                    ),
                                    ElevatedButtonApp(
                                      text: 'Отклонить работу',
                                      onPressed: _decline(context),

                                    ),
                                  ]
                                ],
                              ),
                            )
                          ],
                        );
                      } else if(state is OrderScreenDetailsLoader) {
                        return Loader(padding: 10,);
                      } else if(state is OrderScreenDetailsError) {
                        return ErrorMessage(error: state.error);
                      }
                      return Container();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
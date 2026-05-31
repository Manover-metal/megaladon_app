import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/executor_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/executors/favorite/add_favorite_cubit.dart';
import 'package:megaladon/logic/screens/executors/my/executor_screen_my_cubit.dart';
import 'package:megaladon/logic/screens/offers/details/offer_screen_details_cubit.dart';
import 'package:megaladon/logic/screens/orders/details/order_screen_details_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/snackbars/error_snackbar.dart';
import 'package:megaladon/presentation/widgets/snackbars/success_snackbar.dart';
import 'package:megaladon/presentation/widgets/tiles/data_tile.dart';
import 'package:megaladon/presentation/widgets/tiles/executor_tile.dart';

class DetailsOfferScreen extends StatefulWidget {
  const DetailsOfferScreen(
      {required this.orderId, required this.offerId, super.key});
  final int orderId;
  final int offerId;

  @override
  State<DetailsOfferScreen> createState() => _DetailsOfferScreenState();
}

class _DetailsOfferScreenState extends State<DetailsOfferScreen> {
  @override
  void initState() {
    context
        .read<OfferScreenDetailsCubit>()
        .fetch(orderId: widget.orderId, offerId: widget.offerId);
    super.initState();
  }

  void _acceptOffer() {
    context
        .read<OrderScreenDetailsCubit>()
        .acceptOffer(orderId: widget.orderId, offerId: widget.offerId)
        .then((value) {
      context.router.navigate(InitialRouter(children: [
        OrderRouter(children: [DetailsOrderRoute(orderId: widget.orderId)])
      ]));
    });
  }

  void _listenOrder(BuildContext context, OrderScreenDetailsState state) {
    if (state.status == OrderScreenDetailsStateStatus.errorMessage) {
      showErrorSnackBar(context, state.errorMessage!.messages[0]);
    }
  }

  void _listenFavorite(BuildContext context, AddFavoriteState state) {
    if (state is AddFavoriteSuccess) {
      context.read<ExecutorScreenMyCubit>().fetch();
      showSuccessSnackBar(
          context, AppLocalizations.of(context)!.executorAddedToFavorites);
    } else if (state is AddFavoriteError) {
      showErrorSnackBar(
          context,
          state.error.messages.isNotEmpty
              ? state.error.messages.first
              : AppLocalizations.of(context)!.unknown_error);
    }
  }

  Null Function() _addToFavorite(ExecutorModel executor) => () {
        context.read<AddFavoriteCubit>().add(
              orderId: widget.orderId,
              executorId: executor.id,
            );
      };

  @override
  Widget build(BuildContext context) =>
      BlocListener<AddFavoriteCubit, AddFavoriteState>(
        listener: _listenFavorite,
        child: Scaffold(
          body: BlocListener<OrderScreenDetailsCubit, OrderScreenDetailsState>(
            listener: _listenOrder,
            child: SafeArea(
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: HeaderAppBar(
                          isBack: true,
                          title:
                              AppLocalizations.of(context)!.artists_suggestion),
                    ),
                  )
                ],
                body: SingleChildScrollView(
                  child: Container(
                    constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        BlocBuilder<OfferScreenDetailsCubit,
                            OfferScreenDetailsState>(
                          builder: (context, state) {
                            if (state is OfferScreenDetailsSuccess) {
                              return Column(
                                children: [
                                  if (state.offer.executor != null) ...[
                                    ExecutorTile(
                                      executor: state.offer.executor!,
                                    ),
                                    if (state.offer.executor?.description !=
                                        null)
                                      DataTile(
                                        title: AppLocalizations.of(context)!
                                            .description2,
                                        data:
                                            state.offer.executor?.description ??
                                                '',
                                      ),
                                    Align(
                                      child: TextButton(
                                        onPressed: _addToFavorite(
                                            state.offer.executor!),
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .add_to_Favorite),
                                      ),
                                    ),
                                  ],
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  DataTile(
                                    title: AppLocalizations.of(context)!
                                        .executorSuggestedPrice,
                                    data: AppLocalizations.of(context)!
                                        .priceAmount(
                                            state.offer.price.toString()),
                                  ),
                                  DataTile(
                                    title: AppLocalizations.of(context)!
                                        .executionDate,
                                    data: state.offer.date,
                                  ),
                                  DataTile(
                                    title:
                                        AppLocalizations.of(context)!.location2,
                                    data: AppLocalizations.of(context)!
                                        .cityName(state.offer.city?.name ?? ''),
                                  ),
                                  if (state.offer.comment != null)
                                    DataTile(
                                      title: AppLocalizations.of(context)!
                                          .description2,
                                      data: state.offer.comment!,
                                    ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  ElevatedButtonApp(
                                    text: AppLocalizations.of(context)!
                                        .set_as_executor,
                                    onPressed: _acceptOffer,
                                  )
                                ],
                              );
                            } else if (state is OfferScreenDetailsLoader) {
                              return const Loader();
                            } else if (state is OfferScreenDetailsError) {
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
        ),
      );
}

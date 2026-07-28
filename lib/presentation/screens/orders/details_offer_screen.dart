import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/executor_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/executors/favorite/add_favorite_cubit.dart';
import 'package:megaladon/logic/screens/executors/my/executor_screen_my_cubit.dart';
import 'package:megaladon/logic/screens/offers/details/offer_screen_details_cubit.dart';
import 'package:megaladon/logic/screens/orders/details/order_screen_details_cubit.dart';
import 'package:megaladon/logic/screens/user/reviews/user_reviews_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/card/review_card.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';
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
      CustomSnackBar.error(
        Text(
          state.error?.messages.isNotEmpty == true
              ? state.error!.messages.first
              : AppLocalizations.of(context)!.unknown_error,
        ),
      ).view(context);
    }
  }

  void _listenFavorite(BuildContext context, AddFavoriteState state) {
    if (state is AddFavoriteSuccess) {
      context.read<ExecutorScreenMyCubit>().fetch();
      CustomSnackBar.success(
        Text(AppLocalizations.of(context)!.executorAddedToFavorites),
      ).view(context);
    } else if (state is AddFavoriteError) {
      CustomSnackBar.error(
        Text(
          state.error.messages.isNotEmpty
              ? state.error.messages.first
              : AppLocalizations.of(context)!.unknown_error,
        ),
      ).view(context);
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
          appBar: HeaderAppBar(
              isBack: true,
              title: AppLocalizations.of(context)!.artists_suggestion),
          body: BlocListener<OrderScreenDetailsCubit, OrderScreenDetailsState>(
            listener: _listenOrder,
            child: SingleChildScrollView(
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
                                if (!state.offer.executor!.isDeleted)
                                  Align(
                                    child: TextButton(
                                      onPressed:
                                          _addToFavorite(state.offer.executor!),
                                      child: Text(AppLocalizations.of(context)!
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
                                    .priceAmount(state.offer.price.toString()),
                              ),
                              DataTile(
                                title:
                                    AppLocalizations.of(context)!.executionDate,
                                data: state.offer.date,
                              ),
                              DataTile(
                                title: AppLocalizations.of(context)!.location2,
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
                              // Удалённый аккаунт назначить исполнителем нельзя
                              // (бэкенд такой запрос отклоняет).
                              if (state.offer.executor?.isDeleted != true)
                                ElevatedButtonApp(
                                  text: AppLocalizations.of(context)!
                                      .set_as_executor,
                                  onPressed: _acceptOffer,
                                ),
                              if (state.offer.executor != null)
                                _ReviewsSection(
                                    userId: state.offer.executor!.id),
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
      );
}

/// Отзывы автора отклика. Идёт последней секцией: так кнопка «Назначить
/// исполнителем» остаётся рядом с данными отклика, а не уезжает вниз за
/// длинным списком отзывов.
///
/// [userId] — именно id пользователя, а не исполнителя: OfferPresenter
/// отдаёт автора через UserPresenter->short(), поэтому в
/// `offer.executor.id` лежит user_id. Резолвом профиля исполнителя
/// занимается бэкенд.
class _ReviewsSection extends StatelessWidget {
  const _ReviewsSection({required this.userId});

  final int userId;

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => UserReviewsCubit(userId)..fetch(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Text(
              AppLocalizations.of(context)!.reviews,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            BlocBuilder<UserReviewsCubit, UserReviewsState>(
              builder: (context, state) {
                switch (state.status) {
                  case UserReviewsStatus.loading:
                    return const Loader(padding: 10);
                  case UserReviewsStatus.error:
                    return ErrorMessage(error: state.error!);
                  case UserReviewsStatus.success:
                    if (state.reviews.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.no_reviews_yet,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      );
                    }
                    return Column(
                      children: state.reviews
                          .map((review) => ReviewCard(review: review))
                          .toList(),
                    );
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
}

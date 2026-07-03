import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/store/reviews/store_reviews_cubit.dart';
import 'package:megaladon/presentation/widgets/card/review_card.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';

class StoreMyReviewsScreen extends StatelessWidget {
  const StoreMyReviewsScreen({required this.storeId, super.key});

  final int storeId;

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => StoreReviewsCubit(storeId)..fetch(),
        child: Builder(
          builder: (context) => Scaffold(
            appBar: HeaderAppBar(
              isBack: true,
              title: AppLocalizations.of(context)!.store_reviews,
            ),
            body: RefreshIndicator(
              onRefresh: () => context.read<StoreReviewsCubit>().fetch(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BlocBuilder<StoreReviewsCubit, StoreReviewsState>(
                    builder: (context, state) {
                      if (state.status == StoreReviewsStatus.loading) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Loader(padding: 10),
                        );
                      }
                      if (state.status == StoreReviewsStatus.error) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: ErrorMessage(error: state.error!),
                        );
                      }
                      if (state.reviews.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 40),
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
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

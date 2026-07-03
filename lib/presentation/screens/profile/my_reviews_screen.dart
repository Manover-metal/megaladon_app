import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/executor/my_reviews/executor_reviews_cubit.dart';
import 'package:megaladon/presentation/widgets/card/review_card.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';

class MyReviewsScreen extends StatelessWidget {
  const MyReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => ExecutorReviewsCubit()..fetch(),
        child: Builder(
          builder: (context) => Scaffold(
            appBar: HeaderAppBar(
              isBack: true,
              title: AppLocalizations.of(context)!.my_reviews,
            ),
            body: RefreshIndicator(
              onRefresh: () => context.read<ExecutorReviewsCubit>().fetch(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child:
                      BlocBuilder<ExecutorReviewsCubit, ExecutorReviewsState>(
                    builder: (context, state) {
                      if (state.status == ExecutorReviewsStatus.loading) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Loader(padding: 10),
                        );
                      }
                      if (state.status == ExecutorReviewsStatus.error) {
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

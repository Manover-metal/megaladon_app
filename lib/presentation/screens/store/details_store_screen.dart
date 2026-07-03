import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/core/icons/icons.dart';
import 'package:megaladon/data/models/store_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/screens/store/details/store_screen_details_cubit.dart';
import 'package:megaladon/logic/screens/store/rate/rate_store_cubit.dart';
import 'package:megaladon/logic/screens/store/reviews/store_reviews_cubit.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/card/review_card.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/form/multi_picker/media_multi_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/star_picker.dart';
import 'package:megaladon/presentation/widgets/list/file_download_list.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';
import 'package:megaladon/presentation/widgets/tiles/contact_tile.dart';
import 'package:megaladon/presentation/widgets/tiles/data_tile.dart';

class DetailsStoreScreen extends StatefulWidget {
  const DetailsStoreScreen({required this.storeId, super.key});
  final int storeId;

  @override
  State<DetailsStoreScreen> createState() => _DetailsStoreScreenState();
}

class _DetailsStoreScreenState extends State<DetailsStoreScreen> {
  late StarPickerController _starController;

  @override
  void initState() {
    _onRefresh();
    _starController = StarPickerController();
    super.initState();
  }

  Future<void> _onRefresh() async {
    await context.read<StoreScreenDetailsCubit>().fetch(id: widget.storeId);
  }

  Null Function() _rateStore(StoreModel store) => () {
        showModalBottomSheet(
            useRootNavigator: true,
            isScrollControlled: true,
            useSafeArea: true,
            context: context,
            elevation: 100,
            builder: (_) => RateStoreModal(store));
      };

  @override
  void dispose() {
    _starController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => StoreReviewsCubit(widget.storeId)..fetch(),
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child:
                BlocBuilder<StoreScreenDetailsCubit, StoreScreenDetailsState>(
              builder: (context, state) => HeaderAppBar(
                isBack: true,
                title: state is StoreScreenDetailsSuccess
                    ? state.store.name
                    : null,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              constraints:
                  BoxConstraints(minHeight: MediaQuery.of(context).size.height),
              child:
                  BlocBuilder<StoreScreenDetailsCubit, StoreScreenDetailsState>(
                builder: (context, state) {
                  if (state is StoreScreenDetailsSuccess) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).splashColor),
                          child: CachedNetworkImage(
                            imageUrl: state.store.photo ?? '',
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Icon(
                                    IconPack.market,
                                    size:
                                        MediaQuery.of(context).size.width / 5),
                            errorWidget: (context, url, error) => Icon(
                                IconPack.market,
                                size: MediaQuery.of(context).size.width / 5),
                            fit: BoxFit.cover,
                            height: MediaQuery.of(context).size.height * 0.25,
                            width: double.infinity,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.star,
                                        color: Colors.amber, size: 20),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${AppLocalizations.of(context)!.rating2}${state.store.rating ?? AppLocalizations.of(context)!.noRatings}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Кнопку «Оценить» показываем только авторизованным.
                              BlocBuilder<AuthBloc, AuthState>(
                                builder: (context, authState) => authState
                                        .isAuth
                                    ? Align(
                                        alignment: Alignment.center,
                                        child: TextButton(
                                            onPressed: _rateStore(state.store),
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .rate)),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              DataTile(
                                  title: AppLocalizations.of(context)!.address2,
                                  data: state.store.fullAddress),
                              if (state.store.city != null)
                                DataTile(
                                    title: AppLocalizations.of(context)!.city2,
                                    data: state.store.city!.name),
                              if (state.store.bin != null)
                                DataTile(
                                    title: AppLocalizations.of(context)!.bIN2,
                                    data: state.store.bin.toString()),
                              if (state.store.contacts?.isNotEmpty ??
                                  false) ...[
                                const SizedBox(height: 20),
                                SubTitleApp(
                                    AppLocalizations.of(context)!.contacts),
                                const SizedBox(height: 10),
                                for (int i = 0;
                                    i < state.store.contacts!.length;
                                    i++) ...[
                                  if (i > 0) const Divider(height: 1),
                                  ContactTile(
                                      contact: state.store.contacts![i]),
                                ],
                              ],
                              const SizedBox(
                                height: 20,
                              ),
                              if (state.store.prices.isEmpty)
                                SubTitleApp(
                                    AppLocalizations.of(context)!.no_price_list)
                              else ...[
                                SubTitleApp(
                                    AppLocalizations.of(context)!.price_list),
                                const SizedBox(
                                  height: 10,
                                ),
                                FileDownloadList(files: state.store.prices),
                              ],
                              const SizedBox(
                                height: 20,
                              ),
                              SubTitleApp(
                                  AppLocalizations.of(context)!.reviews),
                              const SizedBox(height: 10),
                              BlocBuilder<StoreReviewsCubit, StoreReviewsState>(
                                builder: (context, reviewsState) {
                                  if (reviewsState.status ==
                                      StoreReviewsStatus.loading) {
                                    return const Loader(padding: 10);
                                  }
                                  if (reviewsState.status ==
                                      StoreReviewsStatus.error) {
                                    return ErrorMessage(
                                        error: reviewsState.error!);
                                  }
                                  if (reviewsState.reviews.isEmpty) {
                                    return Text(
                                      AppLocalizations.of(context)!
                                          .no_reviews_yet,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    );
                                  }
                                  return Column(
                                    children: reviewsState.reviews
                                        .map((r) => ReviewCard(review: r))
                                        .toList(),
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else if (state is StoreScreenDetailsLoader) {
                    return const Loader(
                      padding: 10,
                    );
                  } else if (state is StoreScreenDetailsError) {
                    return ErrorMessage(error: state.error);
                  }
                  return Container();
                },
              ),
            ),
          ),
        ),
      );
}

class RateStoreModal extends StatefulWidget {
  const RateStoreModal(this.store, {super.key});
  final StoreModel store;

  @override
  State<RateStoreModal> createState() => _RateStoreModalState();
}

class _RateStoreModalState extends State<RateStoreModal> {
  late StarPickerController _starPickerController;
  late ImageMultiPickerController _imagesController;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    _starPickerController = StarPickerController();
    _imagesController = ImageMultiPickerController();
    super.initState();
  }

  @override
  void dispose() {
    _starPickerController.dispose();
    _imagesController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _rate() {
    context.read<RateStoreCubit>().rate(
          storeId: widget.store.id,
          value: _starPickerController.value,
          comment: _commentController.text,
          images: _imagesController.value,
        );
  }

  void _listener(BuildContext context, RateStoreState state) {
    if (state is RateStoreSuccess) {
      context.router.pop();
      CustomSnackBar.success(
        Text(AppLocalizations.of(context)!.storeRated),
      ).view(context);
    } else if (state is RateStoreError) {
      context.router.pop();
      CustomSnackBar.error(
        Text(state.error.messages.isNotEmpty == true
            ? state.error.messages.first
            : AppLocalizations.of(context)!.unknown_error),
      ).view(context);
    }
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<RateStoreCubit, RateStoreState>(
        listener: _listener,
        child: SingleChildScrollView(
          child: Container(
            color: Theme.of(context).colorScheme.surface,
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StarPicker(controller: _starPickerController),
                const SizedBox(height: 10),
                TextFieldApp(
                  controller: _commentController,
                  label: AppLocalizations.of(context)!.comment_optional,
                  maxLines: 4,
                ),
                const SizedBox(height: 10),
                ImageMultiPicker(controller: _imagesController, maxCount: 5),
                const SizedBox(height: 10),
                ElevatedButtonApp(
                    onPressed: _rate,
                    child: Text(AppLocalizations.of(context)!.send)),
                SizedBox(
                  height: MediaQuery.of(context).viewPadding.bottom,
                )
              ],
            ),
          ),
        ),
      );
}

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
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/review/reviews_list.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/form/multi_picker/media_multi_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/star_picker.dart';
import 'package:megaladon/presentation/widgets/list/file_download_list.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/rating/rating_stars.dart';
import 'package:megaladon/presentation/widgets/section/content_section.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';
import 'package:megaladon/presentation/widgets/tiles/contact_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsStoreScreen extends StatefulWidget {
  const DetailsStoreScreen({required this.storeId, super.key});
  final int storeId;

  @override
  State<DetailsStoreScreen> createState() => _DetailsStoreScreenState();
}

class _DetailsStoreScreenState extends State<DetailsStoreScreen> {
  static const double _sectionGap = 18;

  @override
  void initState() {
    _onRefresh();
    super.initState();
  }

  Future<void> _onRefresh() async {
    await context.read<StoreScreenDetailsCubit>().fetch(id: widget.storeId);
  }

  Null Function() _rateStore(StoreModel store) => () {
        showModalBottomSheet<void>(
            useRootNavigator: true,
            isScrollControlled: true,
            useSafeArea: true,
            context: context,
            elevation: 100,
            builder: (_) => RateStoreModal(store));
      };

  Future<void> _call(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);

    final opened = await canLaunchUrl(uri) && await launchUrl(uri);
    if (opened || !mounted) return;

    CustomSnackBar.error(
      Text(AppLocalizations.of(context)!.failed_to_open_contact),
    ).view(context);
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => StoreReviewsCubit(widget.storeId)..fetch(),
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            // Название магазина переехало в тело экрана: длинные названия
            // занимали в шапке две строки поверх кнопки «назад».
            child: HeaderAppBar(
              isBack: true,
              compactTitle: true,
              title: AppLocalizations.of(context)!.storeLabel,
            ),
          ),
          body: BlocBuilder<StoreScreenDetailsCubit, StoreScreenDetailsState>(
            builder: (context, state) {
              if (state is StoreScreenDetailsLoader) {
                return const Loader(padding: 10);
              }
              if (state is StoreScreenDetailsError) {
                return ErrorMessage(error: state.error);
              }
              if (state is StoreScreenDetailsSuccess) {
                return _StoreBody(store: state.store, gap: _sectionGap);
              }
              return const SizedBox.shrink();
            },
          ),
          bottomNavigationBar:
              BlocBuilder<StoreScreenDetailsCubit, StoreScreenDetailsState>(
            builder: (context, state) {
              if (state is! StoreScreenDetailsSuccess) {
                return const SizedBox.shrink();
              }

              return _StoreActionBar(
                store: state.store,
                onCall: _call,
                onRate: _rateStore(state.store),
              );
            },
          ),
        ),
      );
}

/// Компактная шапка вместо обложки на четверть экрана: логотип, название,
/// оценка. Контакты и прайс-листы попадают на первый экран без прокрутки.
class _StoreBody extends StatelessWidget {
  const _StoreBody({required this.store, required this.gap});
  final StoreModel store;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final contacts = store.contacts ?? const [];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(store: store),
          SizedBox(height: gap),
          _FactsCard(store: store),
          SizedBox(height: gap),
          ContentSection(
            title: l10n.contacts,
            padding: EdgeInsets.zero,
            boxed: contacts.isNotEmpty,
            child: contacts.isEmpty
                ? _Hint(l10n.no_contacts_yet)
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Column(
                      children: [
                        for (var i = 0; i < contacts.length; i++) ...[
                          if (i > 0)
                            Container(
                              height: 1,
                              color: Theme.of(context).colorScheme.onTertiary,
                            ),
                          ContactTile(contact: contacts[i]),
                        ],
                      ],
                    ),
                  ),
          ),
          SizedBox(height: gap),
          ContentSection(
            title: store.prices.isEmpty
                ? l10n.pricesLabel
                : '${l10n.pricesLabel} · ${store.prices.length}',
            child: store.prices.isEmpty
                ? _Hint(l10n.no_price_list)
                : FileDownloadList(files: store.prices),
          ),
          SizedBox(height: gap),
          ContentSection(
            title: l10n.reviews,
            boxed: false,
            child: BlocBuilder<StoreReviewsCubit, StoreReviewsState>(
              builder: (context, reviewsState) {
                if (reviewsState.status == StoreReviewsStatus.loading) {
                  return const Loader(padding: 10);
                }
                if (reviewsState.status == StoreReviewsStatus.error) {
                  return ErrorMessage(error: reviewsState.error!);
                }
                if (reviewsState.reviews.isEmpty) {
                  return _Hint(l10n.no_reviews_yet);
                }

                return ReviewsList(reviews: reviewsState.reviews);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.store});
  final StoreModel store;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final rating = store.rating;

    final caption = [
      if (store.type != null && store.type!.name.isNotEmpty) store.type!.name,
      if (store.city != null) store.city!.name,
    ].join(' · ');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Logo(photo: store.photo),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                store.name ?? '',
                style: TextStyle(
                  fontSize: 17,
                  height: 1.25,
                  fontWeight: FontWeight.w700,
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  if (rating != null) ...[
                    RatingStars(rate: rating.toDouble(), size: 14),
                    const SizedBox(width: 6),
                    Text(
                      rating.toStringAsFixed(1),
                      style: TextStyle(fontSize: 12, color: scheme.secondary),
                    ),
                  ] else
                    Text(
                      l10n.noRatings,
                      style: TextStyle(fontSize: 12, color: scheme.secondary),
                    ),
                ],
              ),
              if (caption.isNotEmpty) ...[
                const SizedBox(height: 3),
                Text(
                  caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: scheme.secondary),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({required this.photo});
  final String? photo;

  static const double _size = 64;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final placeholder = Container(
      color: scheme.secondaryContainer,
      alignment: Alignment.center,
      child: Icon(IconPack.market, size: 26, color: scheme.secondary),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: _size,
        height: _size,
        child: photo == null || photo!.isEmpty
            ? placeholder
            : CachedNetworkImage(
                imageUrl: photo!,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (_, __, ___) => placeholder,
                errorWidget: (_, __, ___) => placeholder,
              ),
      ),
    );
  }
}

/// Адрес, БИН и тип парами «ключ → значение». Прежний `DataTile` делил
/// строку на две равные половины, и длинный адрес переносился справа, пока
/// слева оставалось пусто.
class _FactsCard extends StatelessWidget {
  const _FactsCard({required this.store});
  final StoreModel store;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final rows = <List<String>>[
      if (store.fullAddress.isNotEmpty) [l10n.addressLabel, store.fullAddress],
      if (store.city != null) [l10n.city, store.city!.name],
      if (store.type != null && store.type!.name.isNotEmpty)
        [l10n.typeLabel, store.type!.name],
      if (store.bin != null && store.bin!.isNotEmpty)
        [l10n.binLabel, store.bin!],
    ];

    if (rows.isEmpty) return const SizedBox.shrink();

    return CardBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) const SizedBox(height: 9),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 92,
                  child: Text(
                    rows[i].first,
                    style: TextStyle(fontSize: 13, color: scheme.secondary),
                  ),
                ),
                Expanded(
                  child: Text(
                    rows[i].last,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: TextStyle(
            fontSize: 13, color: Theme.of(context).colorScheme.secondary),
      );
}

/// Закреплённая панель: позвонить и оценить. Раньше телефон лежал в
/// середине прокрутки, а «Оценить» было текстовой ссылкой под рейтингом.
class _StoreActionBar extends StatelessWidget {
  const _StoreActionBar({
    required this.store,
    required this.onCall,
    required this.onRate,
  });
  final StoreModel store;
  final Future<void> Function(String phone) onCall;
  final VoidCallback onRate;

  @override
  Widget build(BuildContext context) => BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          final l10n = AppLocalizations.of(context)!;
          final phone = store.primaryPhone?.value;
          // Оценивать может только авторизованный — условие сохранено.
          final canRate = authState.isAuth;

          if (phone == null && !canRate) return const SizedBox.shrink();

          final scheme = Theme.of(context).colorScheme;

          return Container(
            decoration: BoxDecoration(
              color: scheme.tertiary,
              border: Border(top: BorderSide(color: scheme.onTertiary)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Row(
                  children: [
                    if (phone != null)
                      Expanded(
                        flex: 2,
                        child: ElevatedButtonApp(
                          text: l10n.call,
                          onPressed: () => onCall(phone),
                        ),
                      ),
                    if (phone != null && canRate) const SizedBox(width: 8),
                    if (canRate)
                      Expanded(
                        child: OutlinedButtonApp(
                          text: l10n.rate,
                          onPressed: onRate,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
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

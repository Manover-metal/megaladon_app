import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/advert_model.dart';
import 'package:megaladon/data/models/dictionary/advert_type.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/advert/delete/advert_delete_cubit.dart';
import 'package:megaladon/logic/screens/advert/details/advert_screen_details_cubit.dart';
import 'package:megaladon/logic/screens/chats/chat_cubit.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/attachments_view.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/section/content_section.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/hint_text.dart';
import 'package:megaladon/presentation/widgets/tiles/user_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsAdScreen extends StatefulWidget {
  const DetailsAdScreen({required this.id, super.key});
  final int id;

  @override
  State<DetailsAdScreen> createState() => _DetailsAdScreenState();
}

class _DetailsAdScreenState extends State<DetailsAdScreen> {
  static const double _sectionGap = 18;

  @override
  void initState() {
    _refresh();
    super.initState();
  }

  Null Function() _call(String phone) => () {
        final uri = Uri(
          scheme: 'tel',
          path: phone,
        );
        launchUrl(uri);
      };

  /// Отдаём кнопке Future запроса — «Чат» держит крутилку и не принимает
  /// второе нажатие. Переписку открывает ChatOpenListener.
  Future<void> _toChat(AdvertModel advert) async {
    final companionId = advert.user?.id;
    if (companionId == null) return;
    await context.read<ChatCubit>().openChatWith(companionId);
  }

  void _refresh() {
    final cubit = context.read<AdvertScreenDetailsCubit>();
    // Уже грузится — повторное нажатие не шлёт второй запрос.
    if (cubit.state is AdvertScreenDetailsLoader) return;
    cubit.fetch(id: widget.id);
  }

  Future<void> Function() _onTrailing(AdvertModel advert) =>
      () => showModalBottomSheet<void>(
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
                      onPressed: _toUpdate(advert),
                      child: Text(AppLocalizations.of(context)!.update),
                    ),
                    const SizedBox(height: 5),
                    ElevatedButtonApp(
                      onPressed: _toDelete(advert, context),
                      child: Text(AppLocalizations.of(context)!.delete),
                    )
                  ],
                ),
              ));

  Null Function() _toUpdate(AdvertModel advert) => () {
        context.router
            .navigate(UpdateAdRoute(advert: advert, type: advert.type));
      };

  Null Function() _toDelete(AdvertModel advert, BuildContext context) => () {
        context.router.pop();
        context.read<AdvertDeleteCubit>().delete(advert.id);
      };

  void _deleteListener(BuildContext context, AdvertDeleteState state) {
    if (state is AdvertDeleteSuccess) {
      context.router.popUntil((route) => false);
      context.router.navigate(const InitialRouter(children: [
        OrderRouter(children: [ListMyOrdersRoute()])
      ]));
    } else if (state is AdvertDeleteError) {
      context.router.pop();
      CustomSnackBar.error(
        Text(
          state.error.messages.isNotEmpty
              ? state.error.messages.first
              : AppLocalizations.of(context)!.unknown_error,
        ),
      ).view(context);
    }
  }

  /// Объявление принадлежит текущему пользователю. Прежнее условие сводилось
  /// к `null == null` у гостя на объявлении без автора — и меню
  /// «Изменить/Удалить» открывалось постороннему.
  bool _isOwner(ProfileScreenState authState, AdvertModel advert) =>
      authState.user?.id != null && authState.user?.id == advert.user?.id;

  @override
  Widget build(BuildContext context) =>
      BlocListener<AdvertDeleteCubit, AdvertDeleteState>(
        listener: _deleteListener,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
              builder: (context, authState) => BlocBuilder<
                  AdvertScreenDetailsCubit, AdvertScreenDetailsState>(
                builder: (context, state) {
                  if (state is AdvertScreenDetailsSuccess) {
                    return HeaderAppBar(
                      isBack: true,
                      compactTitle: true,
                      title: state.advert.type == AdvertType.advert
                          ? AppLocalizations.of(context)!.ad
                          : AppLocalizations.of(context)!.service,
                      onTrailing: _isOwner(authState, state.advert)
                          ? _onTrailing(state.advert)
                          : null,
                    );
                  }
                  return HeaderAppBar(isBack: true, onTrailing: _refresh);
                },
              ),
            ),
          ),
          body: BlocBuilder<AdvertScreenDetailsCubit, AdvertScreenDetailsState>(
            builder: (context, state) {
              if (state is AdvertScreenDetailsLoader) {
                return const Loader(padding: 10);
              }
              if (state is AdvertScreenDetailsError) {
                return ErrorMessage(error: state.error);
              }
              if (state is AdvertScreenDetailsSuccess) {
                return _AdvertBody(advert: state.advert, gap: _sectionGap);
              }
              return const SizedBox.shrink();
            },
          ),
          bottomNavigationBar:
              BlocBuilder<AdvertScreenDetailsCubit, AdvertScreenDetailsState>(
            builder: (context, state) {
              if (state is! AdvertScreenDetailsSuccess) {
                return const SizedBox.shrink();
              }

              return _ContactBar(
                advert: state.advert,
                onCall: state.advert.additionalPhone != null
                    ? _call(state.advert.additionalPhone!)
                    : null,
                onChat: () => _toChat(state.advert),
              );
            },
          ),
        ),
      );
}

/// Прокручиваемая часть: тип и дата, заголовок, сводка, разделы. Раньше
/// заголовок с описанием стояли по центру, город с категорией не выводились
/// вовсе, а фотографии шли во всю ширину без отступов между собой.
class _AdvertBody extends StatelessWidget {
  const _AdvertBody({required this.advert, required this.gap});
  final AdvertModel advert;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final isService = advert.type == AdvertType.service;
    final media = advert.media.where((file) => file.active).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _TypeChip(isService: isService),
              const Spacer(),
              if (advert.createdAt != null)
                Text(
                  advert.createdAt!,
                  style: TextStyle(fontSize: 12, color: scheme.secondary),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            advert.title,
            style: TextStyle(
              fontSize: 19,
              height: 1.25,
              fontWeight: FontWeight.w700,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
          SizedBox(height: gap),
          _SummaryCard(advert: advert, isService: isService),
          if (advert.description.isNotEmpty) ...[
            SizedBox(height: gap),
            ContentSection(
              title: l10n.description,
              child: Text(
                advert.description,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
            ),
          ],
          SizedBox(height: gap),
          ContentSection(
            title: media.isEmpty
                ? l10n.photosLabel
                : '${l10n.photosLabel} · ${media.length}',
            boxed: media.isEmpty,
            child: media.isEmpty
                ? Text(
                    l10n.no_attached_files,
                    style: TextStyle(fontSize: 13, color: scheme.secondary),
                  )
                : AttachmentsView(images: media),
          ),
          if (advert.user != null) ...[
            SizedBox(height: gap),
            _Author(advert: advert, isService: isService),
          ],
        ],
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.isService});
  final bool isService;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        // secondaryContainer в светлой теме — плотный #CBD5E1, чип на нём
        // читается тяжелее макета. onTertiary легче и при этом различим в
        // обеих темах: #E2E8F0 и rgb(54,54,54).
        color: scheme.onTertiary,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        isService ? l10n.service : l10n.ad,
        style: TextStyle(
          fontSize: 12,
          height: 1.2,
          fontWeight: FontWeight.w600,
          color: scheme.secondary,
        ),
      ),
    );
  }
}

/// Цена крупно, под ней категория, город и дата публикации парами
/// «ключ → значение» — как в сводке заказа.
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.advert, required this.isService});
  final AdvertModel advert;
  final bool isService;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final rows = <List<String>>[
      if (advert.category != null && advert.category!.name.isNotEmpty)
        [l10n.category, advert.category!.name],
      if (advert.city != null) [l10n.city, advert.city!.name],
      if (advert.createdAt != null) [l10n.publishedLabel, advert.createdAt!],
    ];

    // «Цена: до» здесь стояла ошибочно: вилки у объявления нет, а у услуги
    // цена стартовая. Цена необязательна — без неё карточка начинается сразу
    // с характеристик, поэтому и разделитель над ними не нужен.
    final amount = advert.priceFormatted;
    final price = amount == null
        ? null
        : isService
            ? l10n.priceFromAmount(amount)
            : l10n.priceAmount(amount);

    return CardBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (price != null)
            Text(
              price,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: scheme.primary,
              ),
            ),
          if (rows.isNotEmpty) ...[
            if (price != null) ...[
              const SizedBox(height: 12),
              Container(height: 1, color: scheme.onTertiary),
              const SizedBox(height: 12),
            ],
            for (var i = 0; i < rows.length; i++) ...[
              if (i > 0) const SizedBox(height: 9),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 104,
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
        ],
      ),
    );
  }
}

class _Author extends StatelessWidget {
  const _Author({required this.advert, required this.isService});
  final AdvertModel advert;
  final bool isService;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
        builder: (context, stateUser) {
          final l10n = AppLocalizations.of(context)!;
          final author = advert.user!;
          // Удалённый аккаунт открывать нечего, а на собственном профиле
          // вкладка заказов пришла бы пустой: OrderService::index
          // подставляет exclude_user_id.
          final openable = !author.isDeleted && author.id != stateUser.user?.id;

          return ContentSection(
            title: isService ? l10n.executorLabel : l10n.sellerLabel,
            child: UserTile(
              user: author,
              onTap: openable
                  ? () => context.router.push(
                        UserProfileRoute(userId: author.id),
                      )
                  : null,
            ),
          );
        },
      );
}

/// Закреплённая панель связи. Раньше кнопки лежали под всеми фотографиями,
/// в самом низу прокрутки.
class _ContactBar extends StatelessWidget {
  const _ContactBar({
    required this.advert,
    required this.onCall,
    required this.onChat,
  });
  final AdvertModel advert;
  final VoidCallback? onCall;
  final VoidCallback onChat;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
        builder: (context, stateUser) {
          final l10n = AppLocalizations.of(context)!;
          final author = advert.user;

          // Автор удалил аккаунт — ни позвонить, ни написать ему нельзя.
          // Своё объявление тоже не требует кнопок связи.
          if (stateUser.user == null ||
              author == null ||
              author.isDeleted ||
              author.id == stateUser.user?.id) {
            return const SizedBox.shrink();
          }

          // Исполнителю без активной подписки закрыты и звонок, и чат:
          // доступ к контактам платный.
          final executor = stateUser.user?.executor;
          final blocked = executor != null && !executor.hasActiveSubscription;
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        if (onCall != null) ...[
                          Expanded(
                            flex: 2,
                            child: ElevatedButtonApp(
                              text: l10n.call,
                              onPressed: blocked ? null : onCall,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButtonApp(
                              text: l10n.chat,
                              onPressed: blocked ? null : onChat,
                            ),
                          ),
                        ] else
                          Expanded(
                            child: OutlinedButtonApp(
                              text: l10n.ask_a_question_in_the_chat,
                              onPressed: blocked ? null : onChat,
                            ),
                          ),
                      ],
                    ),
                    if (blocked) HintText(l10n.contact_requires_subscription),
                  ],
                ),
              ),
            ),
          );
        },
      );
}

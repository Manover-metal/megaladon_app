import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/executor_model.dart';
import 'package:megaladon/data/models/offer_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/chats/chat_cubit.dart';
import 'package:megaladon/logic/screens/executors/favorite/add_favorite_cubit.dart';
import 'package:megaladon/logic/screens/executors/my/executor_screen_my_cubit.dart';
import 'package:megaladon/logic/screens/offers/details/offer_screen_details_cubit.dart';
import 'package:megaladon/logic/screens/orders/details/order_screen_details_cubit.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/avatar/avatar.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/review/user_reviews_section.dart';
import 'package:megaladon/presentation/widgets/section/content_section.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';

class DetailsOfferScreen extends StatefulWidget {
  const DetailsOfferScreen(
      {required this.orderId, required this.offerId, super.key});
  final int orderId;
  final int offerId;

  @override
  State<DetailsOfferScreen> createState() => _DetailsOfferScreenState();
}

class _DetailsOfferScreenState extends State<DetailsOfferScreen> {
  static const double _sectionGap = 16;

  @override
  void initState() {
    context
        .read<OfferScreenDetailsCubit>()
        .fetch(orderId: widget.orderId, offerId: widget.offerId);
    super.initState();
  }

  /// Отдаём кнопке Future запроса — «Назначить» держит крутилку и не шлёт
  /// второй запрос. Переход к заказу делает _listenOrder по статусу
  /// offerAccepted.
  Future<void> _acceptOffer() => context
      .read<OrderScreenDetailsCubit>()
      .acceptOffer(orderId: widget.orderId, offerId: widget.offerId);

  /// Отдаём кнопке Future запроса — «Чат» держит крутилку. Переписку
  /// открывает ChatOpenListener.
  Future<void> _toChat(int userId) =>
      context.read<ChatCubit>().openChatWith(userId);

  void _listenOrder(BuildContext context, OrderScreenDetailsState state) {
    // Исполнитель назначен — уходим к заказу.
    if (state.status == OrderScreenDetailsStateStatus.offerAccepted) {
      context.router.navigate(InitialRouter(children: [
        OrderRouter(children: [DetailsOrderRoute(orderId: widget.orderId)])
      ]));
      return;
    }
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

  /// Добавили в избранное на этом экране. Отклик заново не грузим (экран
  /// мигнул бы загрузкой), поэтому отметку держим здесь.
  bool _favoriteAdded = false;

  void _listenFavorite(BuildContext context, AddFavoriteState state) {
    if (state is AddFavoriteSuccess) {
      setState(() => _favoriteAdded = true);
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

  /// Исполнитель открыл собственный отклик — с карточки заказа, кнопкой
  /// «Посмотреть предложение». Смотрит только для чтения: назначать себя,
  /// писать себе и добавлять себя в избранное незачем, а изменить отклик
  /// нельзя вовсе. В отклике автор приходит через UserPresenter::short(),
  /// так что сравниваем с id пользователя.
  bool _isOwn(OfferModel offer) {
    final me = context.read<ProfileScreenCubit>().state.user?.id;
    return me != null && offer.executor?.id == me;
  }

  /// [executorId] — id исполнителя (OfferModel.executorId), не пользователя:
  /// бэкенд проверяет его по таблице исполнителей.
  Null Function() _addToFavorite(int executorId) => () {
        context.read<AddFavoriteCubit>().add(
              orderId: widget.orderId,
              executorId: executorId,
            );
      };

  @override
  Widget build(BuildContext context) =>
      BlocListener<AddFavoriteCubit, AddFavoriteState>(
        listener: _listenFavorite,
        child: BlocListener<OrderScreenDetailsCubit, OrderScreenDetailsState>(
          listener: _listenOrder,
          child: Scaffold(
            appBar: HeaderAppBar(
              isBack: true,
              compactTitle: true,
              title: AppLocalizations.of(context)!.artists_suggestion,
            ),
            body: BlocBuilder<OfferScreenDetailsCubit, OfferScreenDetailsState>(
              builder: (context, state) {
                if (state is OfferScreenDetailsLoader) {
                  return const Loader(padding: 10);
                }
                if (state is OfferScreenDetailsError) {
                  return ErrorMessage(error: state.error);
                }
                if (state is OfferScreenDetailsSuccess) {
                  final offer = state.offer;
                  final executorId = offer.executorId;
                  final isFavorite = offer.isFavorite || _favoriteAdded;

                  return _OfferBody(
                    offer: offer,
                    gap: _sectionGap,
                    isFavorite: isFavorite,
                    onFavorite:
                        executorId != null && !_isOwn(offer) && !isFavorite
                            ? _addToFavorite(executorId)
                            : null,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            bottomNavigationBar:
                BlocBuilder<OfferScreenDetailsCubit, OfferScreenDetailsState>(
              builder: (context, state) {
                if (state is! OfferScreenDetailsSuccess ||
                    _isOwn(state.offer)) {
                  return const SizedBox.shrink();
                }

                return _DecisionBar(
                  offer: state.offer,
                  onAccept: _acceptOffer,
                  onChat: _toChat,
                );
              },
            ),
          ),
        ),
      );
}

/// Прокручиваемая часть: цена заголовком, автор, комментарий, условия и
/// отзывы. Раньше всё это было четырьмя строками, поделёнными ровно пополам,
/// где подпись «Предложенная исполнителем цена:» весила столько же, сколько
/// само число.
class _OfferBody extends StatelessWidget {
  const _OfferBody({
    required this.offer,
    required this.gap,
    required this.isFavorite,
    required this.onFavorite,
  });
  final OfferModel offer;
  final double gap;
  final bool isFavorite;
  final VoidCallback? onFavorite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final executor = offer.executor;

    final conditions = <List<String>>[
      if (offer.date.isNotEmpty) [l10n.executionDateLabel, offer.date],
      // Город раньше собирался как «г. {name}» от `city?.name ?? ''`, и без
      // города на экране оставалось «Местоположение:  г. ».
      if (offer.city != null && offer.city!.name.isNotEmpty)
        [l10n.city, offer.city!.name],
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                l10n.priceAmount(offer.priceText),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: scheme.primary,
                ),
              ),
              const SizedBox(width: 8),
              // «за шт.» меняет смысл суммы — подпись стоит вплотную к ней.
              Flexible(
                child: Text(
                  offer.priceType.localize(l10n),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: scheme.secondary),
                ),
              ),
              if (offer.isExpired) ...[
                const SizedBox(width: 9),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: scheme.onTertiary,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    l10n.offerExpired,
                    style: TextStyle(
                        fontSize: 10.5, height: 1.3, color: scheme.secondary),
                  ),
                ),
              ],
            ],
          ),
          if (executor != null) ...[
            SizedBox(height: gap),
            _AuthorCard(
              executor: executor,
              isFavorite: isFavorite,
              onFavorite: onFavorite,
            ),
          ],
          if (offer.comment != null && offer.comment!.isNotEmpty) ...[
            SizedBox(height: gap),
            ContentSection(
              title: l10n.commentLabel,
              child: Text(
                offer.comment!,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
            ),
          ],
          if (conditions.isNotEmpty) ...[
            SizedBox(height: gap),
            ContentSection(
              title: l10n.conditionsLabel,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < conditions.length; i++) ...[
                    if (i > 0) const SizedBox(height: 9),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 116,
                          child: Text(
                            conditions[i].first,
                            style: TextStyle(
                                fontSize: 13, color: scheme.secondary),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            conditions[i].last,
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
            ),
          ],
          if (executor != null) ...[
            SizedBox(height: gap),
            // id автора отклика — пользовательский: OfferPresenter отдаёт его
            // через UserPresenter::short().
            UserReviewsSection(userId: executor.id),
          ],
        ],
      ),
    );
  }
}

/// Кто предложил. «Добавить в избранное» было текстовой кнопкой по центру —
/// стало действием с иконкой прямо в карточке автора.
class _AuthorCard extends StatelessWidget {
  const _AuthorCard({
    required this.executor,
    required this.isFavorite,
    required this.onFavorite,
  });
  final ExecutorModel executor;

  /// Уже в избранном: сердечко закрашено и не нажимается.
  final bool isFavorite;

  /// null и не [isFavorite] — сердечка нет (свой отклик, нет профиля
  /// исполнителя).
  final VoidCallback? onFavorite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final orders = executor.countOrders;

    return CardBox(
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
      child: Row(
        children: [
          Avatar(name: executor.name, photoUrl: executor.photo, size: 38),
          const SizedBox(width: 10),
          Expanded(
            child: InkWell(
              onTap: executor.isDeleted
                  ? null
                  : () => context.router.push(
                        UserProfileRoute(userId: executor.id),
                      ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      executor.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        fontStyle: executor.isDeleted ? FontStyle.italic : null,
                        color: executor.isDeleted
                            ? theme.disabledColor
                            : theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                    if (orders != null)
                      Text(
                        l10n.metricOrdersCount(orders.toString()),
                        style: TextStyle(fontSize: 11, color: scheme.secondary),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (!executor.isDeleted && (onFavorite != null || isFavorite))
            IconButton(
              onPressed: isFavorite ? null : onFavorite,
              tooltip: isFavorite ? null : l10n.add_to_Favorite,
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: scheme.primary,
              ),
            ),
        ],
      ),
    );
  }
}

/// Решение закреплено внизу. Раньше «Назначить исполнителем» стояло в потоке
/// между условиями и отзывами и тонуло, стоило списку отзывов подрасти.
class _DecisionBar extends StatelessWidget {
  const _DecisionBar({
    required this.offer,
    required this.onAccept,
    required this.onChat,
  });
  final OfferModel offer;
  final VoidCallback onAccept;
  final void Function(int userId) onChat;

  @override
  Widget build(BuildContext context) {
    final executor = offer.executor;

    // Удалённый аккаунт назначить исполнителем нельзя (бэкенд такой запрос
    // отклоняет), и написать ему тоже некуда.
    if (executor == null || executor.isDeleted) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
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
          // Колонка с min — как у _ActionBar на экране заказа. Кнопки держат
          // текст в Container с alignment, а он растягивается на всю высоту,
          // которую даёт bottomNavigationBar, — без колонки обе кнопки
          // вытягивались на весь экран.
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButtonApp(
                      text: l10n.set_as_executor,
                      onPressed: onAccept,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButtonApp(
                      text: l10n.chat,
                      onPressed: () => onChat(executor.id),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

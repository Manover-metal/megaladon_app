import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/chats/chat_cubit.dart';
import 'package:megaladon/logic/screens/orders/badges/order_badges_cubit.dart';
import 'package:megaladon/logic/screens/orders/delete/order_delete_cubit.dart';
import 'package:megaladon/logic/screens/orders/details/order_screen_details_cubit.dart';
import 'package:megaladon/logic/screens/orders/main/order_screen_main_cubit.dart';
import 'package:megaladon/logic/screens/orders/my/order_screen_my_cubit.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/attachments_view.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/order/order_status_pill.dart';
import 'package:megaladon/presentation/widgets/order/order_summary_card.dart';
import 'package:megaladon/presentation/widgets/section/content_section.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/hint_text.dart';
import 'package:megaladon/presentation/widgets/tiles/executor_tile.dart';
import 'package:megaladon/presentation/widgets/tiles/user_tile.dart';

class DetailsOrderScreen extends StatefulWidget {
  const DetailsOrderScreen({required this.orderId, super.key});
  final int orderId;

  @override
  State<DetailsOrderScreen> createState() => _DetailsOrderScreenState();
}

class _DetailsOrderScreenState extends State<DetailsOrderScreen> {
  static const double _sectionGap = 18;

  /// После возврата с экрана отклика перечитываем заказ: если отклик ушёл,
  /// кнопка сразу сменится на «Посмотреть предложение».
  Future<void> _createOffer() async {
    await context.router.push(CreateOfferRoute(orderId: widget.orderId));
    if (!mounted) return;
    await context
        .read<OrderScreenDetailsCubit>()
        .refresh(id: widget.orderId);
  }

  /// Свой отклик — только для чтения: изменить его нельзя, а второй
  /// бэкенд не примет.
  void _viewOffer(int offerId) {
    context.router
        .push(DetailsOfferRoute(orderId: widget.orderId, offerId: offerId));
  }

  void _checkExecutors() {
    context.router.push(ListExecutorsRoute(orderId: widget.orderId));
  }

  /// Future до конца перехода — кнопка держит крутилку. К отзыву ведём
  /// только если заказ действительно завершён.
  /// Отдаём кнопке Future запроса — она держит крутилку и не шлёт второй
  /// запрос. К отзыву ведёт _listener по статусу completed.
  Future<void> _complete() =>
      context.read<OrderScreenDetailsCubit>().complete();

  /// Отдаём кнопке Future запроса — «Чат» держит крутилку. Переписку
  /// открывает ChatOpenListener; заготовку ChatCubit подставит, только если
  /// с этим заказчиком ещё не общались.
  Future<void> _toChat(OrderModel order) async {
    final companionId = order.user?.id;
    if (companionId == null) return;
    await context.read<ChatCubit>().openChatWith(
          companionId,
          greeting:
              AppLocalizations.of(context)!.chatOrderGreeting(order.title),
        );
  }

  late OrderBadgesCubit _badgesCubit;
  late OrderScreenMyCubit _myOrdersCubit;

  @override
  void initState() {
    context.read<OrderScreenDetailsCubit>().fetch(id: widget.orderId);
    // Ссылки берём здесь: в dispose обращаться к context уже нельзя.
    _badgesCubit = context.read<OrderBadgesCubit>();
    _myOrdersCubit = context.read<OrderScreenMyCubit>();
    super.initState();
  }

  @override
  void dispose() {
    // Открытие карточки гасит отметку на бэкенде (OrderService::info), но
    // счётчики и списки об этом не знают — перечитываем на выходе, иначе
    // бейдж провисел бы до следующего опроса.
    _badgesCubit.fetch();
    _myOrdersCubit.refresh();
    super.dispose();
  }

  void _listener(BuildContext context, OrderScreenDetailsState state) {
    // Заказ завершён — сразу к отзыву об исполнителе.
    if (state.status == OrderScreenDetailsStateStatus.completed &&
        state.order != null) {
      context.router.push(ReviewRoute(order: state.order!));
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

  void _deleteListener(BuildContext context, OrderDeleteState state) {
    if (state is OrderDeleteSuccess) {
      context.read<OrderScreenMainCubit>().fetch();
      context.read<OrderScreenMyCubit>().refresh();
      context.router.pop();
    } else if (state is OrderDeleteError) {
      CustomSnackBar.error(
        Text(
          state.error.messages.isNotEmpty
              ? state.error.messages.first
              : AppLocalizations.of(context)!.unknown_error,
        ),
      ).view(context);
    }
  }

  Future<void> Function() _onTrailing(OrderModel order) =>
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
                      onPressed: _toUpdate(order),
                      child: Text(AppLocalizations.of(context)!.update),
                    ),
                    const SizedBox(height: 5),
                    ElevatedButtonApp(
                      onPressed: _toDelete(order),
                      child: Text(AppLocalizations.of(context)!.delete),
                    )
                  ],
                ),
              ));

  Null Function() _toUpdate(OrderModel order) => () {
        context.router.navigate(UpdateOrderRoute(order: order));
      };

  Null Function() _toDelete(OrderModel order) => () {
        context.read<OrderDeleteCubit>().delete(order.id);
      };

  /// Заказ принадлежит текущему пользователю. Условие раньше требовало,
  /// чтобы свой id был `null` — из-за этого меню «Изменить/Удалить» в шапке
  /// не открывалось вообще ни у кого.
  bool _isOwner(ProfileScreenState authState, OrderModel? order) =>
      authState.user?.id != null && authState.user?.id == order?.user?.id;

  @override
  Widget build(BuildContext context) =>
      BlocListener<OrderDeleteCubit, OrderDeleteState>(
        listener: _deleteListener,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child:
                BlocBuilder<OrderScreenDetailsCubit, OrderScreenDetailsState>(
              builder: (context, state) =>
                  BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
                builder: (context, authState) {
                  final order = state.order;
                  // Редактировать и удалять можно, пока заказ не ушёл в
                  // работу — тот же порог, что стоял у кнопок в теле экрана.
                  final canManage = order != null &&
                      _isOwner(authState, order) &&
                      order.status.index <= OrderStatus.active.index;

                  return HeaderAppBar(
                    isBack: true,
                    compactTitle: true,
                    title: order != null
                        ? AppLocalizations.of(context)!
                            .orderWithId(order.id.toString())
                        : null,
                    onTrailing: canManage ? _onTrailing(order) : null,
                  );
                },
              ),
            ),
          ),
          body: BlocConsumer<OrderScreenDetailsCubit, OrderScreenDetailsState>(
            listener: _listener,
            builder: (context, state) {
              if (state.status == OrderScreenDetailsStateStatus.loading) {
                return const Loader(padding: 10);
              }

              if (state.status == OrderScreenDetailsStateStatus.error) {
                return ErrorMessage(error: state.error!);
              }

              final order = state.order;
              if (order == null) return const SizedBox.shrink();

              return _OrderBody(order: order, gap: _sectionGap);
            },
          ),
          bottomNavigationBar:
              BlocBuilder<OrderScreenDetailsCubit, OrderScreenDetailsState>(
            builder: (context, state) {
              final order = state.order;
              if (order == null) return const SizedBox.shrink();

              final myOfferId = state.myOfferId;

              return _ActionBar(
                order: order,
                myOfferId: myOfferId,
                onViewOffer:
                    myOfferId != null ? () => _viewOffer(myOfferId) : null,
                onOffer: _createOffer,
                onChat: () => _toChat(order),
                onExecutors: _checkExecutors,
                onComplete: _complete,
              );
            },
          ),
        ),
      );
}

/// Прокручиваемая часть экрана: шапка, сводка и разделы. Раньше всё это было
/// одной колонкой без заголовков, с центрированным описанием и одним
/// разделителем на весь экран.
class _OrderBody extends StatelessWidget {
  const _OrderBody({required this.order, required this.gap});
  final OrderModel order;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final hasAttachments = order.images.isNotEmpty || order.files.isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              OrderStatusPill(status: order.status),
              const Spacer(),
              Text(
                order.createdAt,
                style:
                    TextStyle(fontSize: 12, color: theme.colorScheme.secondary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            order.title,
            style: TextStyle(
              fontSize: 21,
              height: 1.25,
              fontWeight: FontWeight.w700,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
          SizedBox(height: gap),
          OrderSummaryCard(order: order),
          if (order.description.isNotEmpty) ...[
            SizedBox(height: gap),
            ContentSection(
              title: l10n.description,
              child: Text(
                order.description,
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
            title: l10n.attached_files,
            boxed: !hasAttachments,
            child: hasAttachments
                ? AttachmentsView(images: order.images, files: order.files)
                : Text(
                    l10n.no_attached_files,
                    style: TextStyle(
                        fontSize: 13, color: theme.colorScheme.secondary),
                  ),
          ),
          _Participant(order: order, gap: gap),
        ],
      ),
    );
  }
}

/// Заказчик или назначенный исполнитель — смотря кто смотрит и в каком
/// состоянии заказ. Логика показа перенесена из тела экрана без изменений.
class _Participant extends StatelessWidget {
  const _Participant({required this.order, required this.gap});
  final OrderModel order;
  final double gap;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
        builder: (context, stateUser) {
          final l10n = AppLocalizations.of(context)!;
          final user = stateUser.user;

          if (order.user != null && order.user?.id != user?.id) {
            return Padding(
              padding: EdgeInsets.only(top: gap),
              child: ContentSection(
                title: l10n.customer,
                child: UserTile(
                  user: order.user!,
                  // Условие «не я» уже обеспечено внешним if — здесь
                  // достаточно отсечь удалённых.
                  onTap: order.user!.isDeleted
                      ? null
                      : () => context.router.push(
                            UserProfileRoute(userId: order.user!.id),
                          ),
                ),
              ),
            );
          }

          if (order.executor != null &&
              order.executor?.id != user?.id &&
              order.status.index > OrderStatus.active.index) {
            return Padding(
              padding: EdgeInsets.only(top: gap),
              child: ContentSection(
                title: l10n.executorLabel,
                child: ExecutorTile(
                  executor: order.executor!,
                  // Заказчик рядом открывается, а исполнитель — нет: тут
                  // это настоящий профиль исполнителя, а не пользователя.
                  onTap: order.executor!.isDeleted
                      ? null
                      : () => context.router.push(
                            DetailsExecutorRoute(
                                executorId: order.executor!.id),
                          ),
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      );
}

/// Закреплённая панель действий. Раньше кнопки лежали в самом низу
/// прокрутки: до «Предложить услуги» приходилось листать через описание,
/// файлы и полноразмерные фотографии.
class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.order,
    required this.myOfferId,
    required this.onViewOffer,
    required this.onOffer,
    required this.onChat,
    required this.onExecutors,
    required this.onComplete,
  });
  final OrderModel order;

  /// Отклик текущего пользователя на этот заказ; null — не откликался.
  final int? myOfferId;
  final VoidCallback? onViewOffer;
  final VoidCallback onOffer;
  final VoidCallback onChat;
  final VoidCallback onExecutors;
  final VoidCallback onComplete;

  List<Widget> _children(BuildContext context, ProfileScreenState stateUser) {
    final l10n = AppLocalizations.of(context)!;
    final user = stateUser.user;

    if (user == null) {
      // Гость: сначала вход/регистрация, затем профиль исполнителя.
      if (stateUser.status == ProfileScreenStatus.notAuth &&
          order.user?.isDeleted != true &&
          order.status == OrderStatus.active) {
        return [HintText(l10n.respond_requires_auth_and_executor)];
      }
      return const [];
    }

    final isOwner = order.user?.id == user.id;

    // Уже откликался: второго отклика бэкенд не примет, а изменить отклик
    // нельзя — вместо «Предложить услуги» даём посмотреть свой. Чат — как
    // и раньше: пока заказ активен, заказчик не удалён и есть подписка.
    if (!isOwner && myOfferId != null) {
      final canChat = order.status == OrderStatus.active &&
          order.user?.isDeleted != true &&
          (user.executor?.hasActiveSubscription ?? false);

      return [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: ElevatedButtonApp(
                text: l10n.viewMyOffer,
                onPressed: onViewOffer,
              ),
            ),
            if (order.status == OrderStatus.active &&
                order.user?.isDeleted != true) ...[
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButtonApp(
                  text: l10n.chat,
                  onPressed: canChat ? onChat : null,
                ),
              ),
            ],
          ],
        ),
        HintText(l10n.alreadyResponded),
      ];
    }

    // Заказчик удалил аккаунт: ни откликнуться, ни написать ему уже нельзя.
    if (!isOwner &&
        order.user?.isDeleted != true &&
        order.status == OrderStatus.active) {
      final executor = user.executor;
      if (executor == null) {
        // Авторизован, но профиля исполнителя нет.
        return [HintText(l10n.respond_requires_executor)];
      }

      // Без активной подписки закрыт весь контакт с заказчиком: и отклик,
      // и чат.
      final canRespond = executor.hasActiveSubscription;

      return [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: ElevatedButtonApp(
                text: l10n.offer_services,
                onPressed: canRespond ? onOffer : null,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButtonApp(
                text: l10n.chat,
                onPressed: canRespond ? onChat : null,
              ),
            ),
          ],
        ),
        if (!canRespond) HintText(l10n.respond_requires_subscription),
      ];
    }

    if (isOwner) {
      if (order.status == OrderStatus.active) {
        return [
          ElevatedButtonApp(
            text: l10n.offersCount(order.countOffers.toString()),
            onPressed: onExecutors,
          ),
        ];
      }
      if (order.status == OrderStatus.hasExecutor) {
        return [
          ElevatedButtonApp(text: l10n.to_finish_work, onPressed: onComplete),
        ];
      }
    }

    return const [];
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
        builder: (context, stateUser) {
          final children = _children(context, stateUser);
          if (children.isEmpty) return const SizedBox.shrink();

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
                  children: children,
                ),
              ),
            ),
          );
        },
      );
}

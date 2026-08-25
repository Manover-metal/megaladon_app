import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/dictionary/subscribe_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/dictionary/dictionary_cubit.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';
import 'package:megaladon/logic/subscribe/subscribe_cubit.dart';
import 'package:megaladon/presentation/screens/subscribe/widgets/subscription_benefits.dart';
import 'package:megaladon/presentation/screens/subscribe/widgets/subscription_status_banner.dart';
import 'package:megaladon/presentation/widgets/card/subscribe_card.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/hint_text.dart';

class SubscribeScreen extends StatelessWidget {
  const SubscribeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Слушатель поднят на уровень экрана: в карточке он дублировался бы по
    // числу тарифов и после одной покупки показал бы несколько снекбаров.
    return BlocListener<SubscribeCubit, SubscribeState>(
      listener: (context, state) {
        if (state is SubscribeSuccess) {
          CustomSnackBar.success(
            Text(l10n.subscribed_for_months(state.subscribe.duration)),
          ).view(context);
          // Баннер статуса берёт дату окончания из профиля — перечитываем его,
          // иначе он останется с прежним «не активна».
          context.read<ProfileScreenCubit>().updateData();
        } else if (state is SubscribeError) {
          CustomSnackBar.error(
            Text(state.error.messages.isNotEmpty
                ? state.error.messages.first
                : l10n.unknown_error),
          ).view(context);
        }
      },
      child: Scaffold(
        appBar: HeaderAppBar(isMenu: true, title: l10n.subscriptions),
        body: BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
          builder: (context, profile) {
            // Роли берём из профиля, а не фиксируем в initState: экран может
            // открыться раньше, чем придёт /profile.
            final faces = [
              if (profile.user?.executor != null) SubscribeType.executor,
              if (profile.user?.store != null) SubscribeType.store,
            ];

            if (faces.isEmpty) {
              // Профиль ещё не пришёл — ролей не видно, но и сказать «заведите
              // исполнителя» пока не за что.
              if (profile.status == ProfileScreenStatus.initial ||
                  profile.status == ProfileScreenStatus.loading) {
                return const Loader(padding: 10);
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(child: HintText(l10n.subscriptionNoFaces)),
              );
            }

            if (faces.length == 1) {
              return _SubscribeFaceView(type: faces.first);
            }

            // DefaultTabController сам пересоздаёт контроллер при смене длины —
            // своего TabController с ручным dispose здесь не нужно.
            return DefaultTabController(
              length: faces.length,
              child: _FacesTabs(faces: faces),
            );
          },
        ),
      ),
    );
  }
}

class _FacesTabs extends StatelessWidget {
  const _FacesTabs({required this.faces});

  final List<SubscribeType> faces;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      children: [
        TabBar(
          labelColor: theme.colorScheme.primary,
          labelStyle:
              theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          unselectedLabelStyle:
              theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          unselectedLabelColor: Colors.grey,
          indicatorColor: theme.colorScheme.primary,
          tabs: [
            for (final face in faces)
              Tab(
                text: face == SubscribeType.executor
                    ? l10n.as_a_executor
                    : l10n.asAStore,
              ),
          ],
        ),
        Expanded(
          child: TabBarView(
            children: [
              for (final face in faces) _SubscribeFaceView(type: face),
            ],
          ),
        ),
      ],
    );
  }
}

/// Содержимое одной вкладки: статус подписки, описание выгод и список тарифов.
class _SubscribeFaceView extends StatelessWidget {
  const _SubscribeFaceView({required this.type});

  final SubscribeType type;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isBusy = context.watch<SubscribeCubit>().state is SubscribeLoading;

    return BlocBuilder<DictionaryCubit, DictionaryState>(
      builder: (context, state) {
        final plans = [
          ...type == SubscribeType.executor
              ? state.subscribesExecutor
              : state.subscribesStore
        ]..sort((a, b) => a.duration.compareTo(b.duration));
        final bestId = _bestPlanId(plans);
        final discount = _discountPercent(plans);

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            // Дату окончания отдаёт только ExecutorPresenter, у магазина
            // такого поля в ответе нет — статус показываем исполнителю.
            if (type == SubscribeType.executor) ...[
              BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
                builder: (context, profile) => SubscriptionStatusBanner(
                  expiredAt: profile.user?.executor?.subscriptionExpiredAt,
                ),
              ),
              const SizedBox(height: 24),
            ],
            SubscriptionBenefits(type: type),
            const SizedBox(height: 8),
            Text(
              l10n.subscriptionChoosePeriod,
              style: theme.textTheme.bodyLarge?.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 14),
            if (plans.isEmpty)
              HintText(l10n.subscriptionPlansEmpty)
            else
              for (final plan in plans)
                SubscribeCard(
                  subscribe: plan,
                  isBest: plan.id == bestId,
                  discountPercent: plan.id == bestId ? discount : null,
                  isBusy: isBusy,
                ),
            const SizedBox(height: 6),
            Text(
              l10n.subscriptionFootnote,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 13,
                height: 1.35,
                color: theme.hintColor,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Платные тарифы, по которым осмысленно считать цену за месяц.
Iterable<SubscribeModel> _paidPlans(List<SubscribeModel> plans) =>
    plans.where((plan) => plan.price > 0 && plan.duration > 0);

/// Тариф с лучшей ценой за месяц — его карточку подсвечиваем. Если платных
/// тарифов нет, подсвечиваем единственный бесплатный, чтобы кнопка не осталась
/// без акцента.
int? _bestPlanId(List<SubscribeModel> plans) {
  final paid = _paidPlans(plans).toList()
    ..sort((a, b) => (a.price / a.duration).compareTo(b.price / b.duration));
  if (paid.isNotEmpty) {
    return paid.first.id;
  }
  return plans.length == 1 ? plans.first.id : null;
}

/// Насколько лучший тариф выгоднее самого дорогого в пересчёте на месяц.
/// null — сравнивать не с чем или разница меньше процента.
int? _discountPercent(List<SubscribeModel> plans) {
  final rates = _paidPlans(plans)
      .map((plan) => plan.price / plan.duration)
      .toList()
    ..sort();
  if (rates.length < 2) {
    return null;
  }
  final percent = ((1 - rates.first / rates.last) * 100).round();
  return percent >= 1 ? percent : null;
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:megaladon/data/models/dictionary/subscribe_model.dart';
import 'package:megaladon/data/models/executor_model.dart';
import 'package:megaladon/data/models/store_model.dart';
import 'package:megaladon/data/models/user_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/form/price/price_form_cubit.dart';
import 'package:megaladon/logic/screens/profile/change_photo/change_photo_cubit.dart';
import 'package:megaladon/logic/screens/profile/delete_account/delete_account_cubit.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/avatar/avatar.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/dialogs/delete_account_dialog.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/message/auth_message.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/notifications/push_disabled_banner.dart';
import 'package:megaladon/presentation/widgets/rating/rating_stars.dart';
import 'package:megaladon/presentation/widgets/section/content_section.dart';
import 'package:megaladon/presentation/widgets/settings/settings_row.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';
import 'package:megaladon/presentation/widgets/tiles/contact_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const double _gap = 16;

  /// Выбранная вкладка среди доступных ролей. Индекс считается по списку,
  /// который собирается в [_tabsFor]: у человека без второй роли вкладок нет
  /// вовсе и переключатель не показывается.
  int _tab = 0;

  Future<void> _onDeleteAccount(BuildContext context) async {
    final password = await showDialog<String>(
      context: context,
      builder: (_) => const DeleteAccountDialog(),
    );
    if (password != null && context.mounted) {
      context.read<DeleteAccountCubit>().deleteAccount(password);
    }
  }

  void _deleteAccountListener(BuildContext context, DeleteAccountState state) {
    if (state.status == DeleteAccountStatus.success) {
      CustomSnackBar.success(
        Text(AppLocalizations.of(context)!.account_deleted_successfully),
      ).view(context);
      // Аккаунт вместе с токенами уже удалён — звать DELETE /auth/logout
      // нечем, он вернёт 401.
      context.read<AuthBloc>().add(const AuthLogoutEvent(notifyServer: false));
    } else if (state.status == DeleteAccountStatus.error) {
      CustomSnackBar.error(
        Text(state.error?.messages.isNotEmpty == true
            ? state.error!.messages.first
            : AppLocalizations.of(context)!.unknown_error),
      ).view(context);
    }
  }

  Future _fetch() async {
    // Гость сюда попадает штатно: ProfileScreenCubit при отсутствии токена
    // выставляет notAuth (показывается AuthMessage). Дёргать /user/profile за
    // гостя всё равно нет смысла — придёт 401.
    final state = context.read<AuthBloc>().state;
    if (state is AuthLoginState) {
      return context.read<ProfileScreenCubit>().fetch();
    }
  }

  @override
  void initState() {
    _fetch();
    super.initState();
  }

  void _changePhoto() {
    context.read<ChangePhotoCubit>().changePhoto();
  }

  void _photoListener(BuildContext context, ChangePhotoState state) {
    if (state.status == PhotoStatus.error) {
      CustomSnackBar.error(
        Text(
          state.error?.messages.isNotEmpty == true
              ? state.error!.messages.first
              : AppLocalizations.of(context)!.unknown_error,
        ),
      ).view(context);
    }
  }

  /// Какие вкладки показывать. «Аккаунт» есть всегда, роли — по наличию.
  List<String> _tabsFor(UserModel user, AppLocalizations l10n) => [
        l10n.accountTab,
        if (user.executor != null) l10n.executorLabel,
        if (user.store != null) l10n.storeLabel,
      ];

  @override
  Widget build(BuildContext context) =>
      BlocListener<DeleteAccountCubit, DeleteAccountState>(
        listener: _deleteAccountListener,
        child: Scaffold(
          appBar: HeaderAppBar(
            isMenu: true,
            compactTitle: true,
            title: AppLocalizations.of(context)!.profile,
          ),
          // CustomScrollView, а не SingleChildScrollView: состояния без
          // содержимого отдаются через SliverFillRemaining и занимают ровно
          // вьюпорт, а не выдуманную высоту экрана. Сам список слайверов
          // существует всегда — RefreshIndicator требует прокручиваемого
          // потомка в любом состоянии.
          body: RefreshIndicator(
            onRefresh: _fetch,
            child: BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
              builder: (context, state) => CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                    sliver: _sliver(context, state),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _sliver(BuildContext context, ProfileScreenState state) {
    if (state.status == ProfileScreenStatus.loading) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: Loader()),
      );
    }
    if (state.status == ProfileScreenStatus.notAuth) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: AuthMessage()),
      );
    }
    // Раньше эта ветка проверяла notAuth второй раз и потому была
    // недостижима: любой сбой запроса профиля оборачивался пустым экраном.
    if (state.status == ProfileScreenStatus.error) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: ErrorMessage(error: state.error!)),
      );
    }
    if (state.status != ProfileScreenStatus.success || state.user == null) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(child: _body(context, state.user!));
  }

  Widget _body(BuildContext context, UserModel user) {
    final l10n = AppLocalizations.of(context)!;
    final tabs = _tabsFor(user, l10n);
    final index = _tab.clamp(0, tabs.length - 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(
            user: user,
            onChangePhoto: _changePhoto,
            onPhotoError: _photoListener),
        // Пуши запрещены в системе или выключены в приложении — без них не
        // узнать об откликах и смене статуса. Когда всё включено, плашки нет.
        const PushDisabledBanner(),
        // Одна роль — переключать нечего.
        if (tabs.length > 1) ...[
          const SizedBox(height: _gap),
          _Tabs(
            tabs: tabs,
            current: index,
            onChanged: (value) => setState(() => _tab = value),
          ),
        ],
        const SizedBox(height: _gap),
        _tabContent(context, user, tabs[index], l10n),
      ],
    );
  }

  Widget _tabContent(
      BuildContext context, UserModel user, String tab, AppLocalizations l10n) {
    if (tab == l10n.executorLabel && user.executor != null) {
      return _ExecutorTab(executor: user.executor!, gap: _gap);
    }
    if (tab == l10n.storeLabel && user.store != null) {
      return _StoreTab(store: user.store!, gap: _gap);
    }

    return _AccountTab(
      user: user,
      gap: _gap,
      onDelete: () => _onDeleteAccount(context),
    );
  }
}

/// Шапка: аватар, имя, телефон и город. Аватар был размером в треть ширины
/// экрана, а поверх нижней трети круга лежала полупрозрачная «шторка» с
/// карандашом во всю ширину.
class _Header extends StatelessWidget {
  const _Header({
    required this.user,
    required this.onChangePhoto,
    required this.onPhotoError,
  });
  final UserModel user;
  final VoidCallback onChangePhoto;
  final void Function(BuildContext, ChangePhotoState) onPhotoError;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final caption = [
      if (user.phone != null) user.phone!,
      if (user.city != null) user.city!.name,
    ].join(' · ');

    return Row(
      children: [
        BlocConsumer<ChangePhotoCubit, ChangePhotoState>(
          listener: onPhotoError,
          builder: (context, state) => Avatar(
            name: user.name,
            photoUrl: state.url,
            bytes: state.status == PhotoStatus.bytes ? state.imageData : null,
            size: 56,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15.5,
                  height: 1.25,
                  fontWeight: FontWeight.w700,
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
              if (caption.isNotEmpty)
                Text(
                  caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11.5, color: scheme.secondary),
                ),
            ],
          ),
        ),
        IconButton(
          onPressed: onChangePhoto,
          tooltip: l10n.changePhotoLabel,
          icon: Icon(Icons.photo_camera_outlined, color: scheme.primary),
        ),
      ],
    );
  }
}

/// Переключатель ролей. Показывается только тем, у кого их больше одной.
class _Tabs extends StatelessWidget {
  const _Tabs({
    required this.tabs,
    required this.current,
    required this.onChanged,
  });
  final List<String> tabs;
  final int current;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: scheme.onTertiary,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        children: [
          for (var i = 0; i < tabs.length; i++)
            Expanded(
              child: InkWell(
                onTap: () => onChanged(i),
                borderRadius: BorderRadius.circular(7),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  decoration: BoxDecoration(
                    color: i == current ? scheme.tertiary : Colors.transparent,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    tabs[i],
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight:
                          i == current ? FontWeight.w600 : FontWeight.w400,
                      color: i == current
                          ? theme.textTheme.bodyMedium?.color
                          : scheme.secondary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AccountTab extends StatelessWidget {
  const _AccountTab({
    required this.user,
    required this.gap,
    required this.onDelete,
  });
  final UserModel user;
  final double gap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FactsCard(rows: [
          [l10n.name, user.name],
          if (user.phone != null) [l10n.telephone, user.phone!],
          if (user.city != null) [l10n.location, user.city!.name],
        ]),
        SizedBox(height: gap),
        ContentSection(
          title: l10n.securityLabel,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              SettingsRow(
                icon: Icons.phone_iphone,
                title: l10n.change_phone_number,
                trailing: const SettingsChevron(),
                onTap: () => context.router.navigate(
                  const ChangePhoneStartRoute(),
                ),
              ),
              const SettingsRowDivider(),
              SettingsRow(
                icon: Icons.lock_outline,
                title: l10n.change_password,
                trailing: const SettingsChevron(),
                onTap: () => context.router.navigate(
                  const ChangePasswordRoute(),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: gap + 8),
        // Удаление аккаунта — не рядовой пункт настроек: отделено и набрано
        // цветом ошибки, а не как «Сменить пароль».
        Center(
          child: TextButton(
            onPressed: onDelete,
            child: Text(
              l10n.delete_account,
              style: TextStyle(fontSize: 13, color: scheme.error),
            ),
          ),
        ),
      ],
    );
  }
}

class _ExecutorTab extends StatelessWidget {
  const _ExecutorTab({required this.executor, required this.gap});
  final ExecutorModel executor;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final rating = executor.rating;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CardBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      executor.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _SubscriptionChip(expiredAt: executor.subscriptionExpiredAt),
                ],
              ),
              const SizedBox(height: 7),
              Row(
                children: [
                  if (rating != null) ...[
                    RatingStars(rate: rating, size: 13),
                    const SizedBox(width: 6),
                    Text(
                      rating.toStringAsFixed(1),
                      style: TextStyle(fontSize: 11.5, color: scheme.secondary),
                    ),
                  ] else
                    Text(
                      l10n.noRatings,
                      style: TextStyle(fontSize: 11.5, color: scheme.secondary),
                    ),
                  if (executor.countOrders != null) ...[
                    const SizedBox(width: 6),
                    Text(
                      l10n.metricOrdersCountDot(
                        executor.countOrders.toString(),
                      ),
                      style: TextStyle(fontSize: 11.5, color: scheme.secondary),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 11),
              Container(height: 1, color: scheme.onTertiary),
              const SizedBox(height: 11),
              // bin объявлен String? и у части исполнителей не заполнен —
              // раньше здесь стоял `executor.bin!`, и экран падал.
              _Facts(rows: [
                if (executor.bin != null && executor.bin!.isNotEmpty)
                  [l10n.bIN, executor.bin!],
                if (executor.fullAddress != null &&
                    executor.fullAddress!.isNotEmpty)
                  [l10n.address, executor.fullAddress!],
                if (executor.services.isNotEmpty)
                  [
                    l10n.services,
                    executor.services.map((s) => s.name).join(', '),
                  ],
              ]),
            ],
          ),
        ),
        SizedBox(height: gap),
        CardBox(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              SettingsRow(
                icon: Icons.edit_outlined,
                title: l10n.change_executor,
                trailing: const SettingsChevron(),
                onTap: () =>
                    context.router.navigate(const InitialRouter(children: [
                  ProfileRouter(children: [ChangeExecutorRoute()])
                ])),
              ),
              const SettingsRowDivider(),
              SettingsRow(
                icon: Icons.star_border,
                title: l10n.my_reviews,
                trailing: const SettingsChevron(),
                onTap: () =>
                    context.router.navigate(const InitialRouter(children: [
                  ProfileRouter(children: [MyReviewsRoute()])
                ])),
              ),
              const SettingsRowDivider(),
              SettingsRow(
                icon: Icons.workspace_premium_outlined,
                title: l10n.subscriptions,
                trailing: const SettingsChevron(),
                onTap: () => context.router.navigate(InitialRouter(children: [
                  OrderRouter(children: [
                    SubscribeRoute(initialType: SubscribeType.executor)
                  ])
                ])),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Статус подписки. У исполнителя она решает, может ли он откликаться и
/// писать в чат, у магазина — виден ли он в каталоге. На профиле её статус
/// раньше не показывался вовсе.
class _SubscriptionChip extends StatelessWidget {
  const _SubscriptionChip({required this.expiredAt});
  final DateTime? expiredAt;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final until = expiredAt;
    final active = until?.isAfter(DateTime.now()) ?? false;

    final text = active && until != null
        ? l10n.subscriptionUntil(DateFormat('dd.MM.yyyy').format(until))
        : l10n.subscriptionNone;
    final color = active ? scheme.primary : scheme.secondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: active ? color.withValues(alpha: 0.14) : scheme.onTertiary,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.5,
          height: 1.3,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _StoreTab extends StatelessWidget {
  const _StoreTab({required this.store, required this.gap});
  final StoreModel store;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final rating = store.rating;
    final contacts = store.contacts ?? const [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CardBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (rating != null) ...[
                    RatingStars(rate: rating.toDouble(), size: 13),
                    const SizedBox(width: 6),
                    Text(
                      rating.toStringAsFixed(1),
                      style: TextStyle(fontSize: 11.5, color: scheme.secondary),
                    ),
                  ] else
                    Text(
                      l10n.noRatings,
                      style: TextStyle(fontSize: 11.5, color: scheme.secondary),
                    ),
                  const Spacer(),
                  const SizedBox(width: 8),
                  _SubscriptionChip(expiredAt: store.subscriptionExpiredAt),
                ],
              ),
              const SizedBox(height: 11),
              Container(height: 1, color: scheme.onTertiary),
              const SizedBox(height: 11),
              _Facts(rows: [
                if (store.fullAddress.isNotEmpty)
                  [l10n.address, store.fullAddress],
                if (store.city != null) [l10n.city, store.city!.name],
                if (store.bin != null && store.bin!.isNotEmpty)
                  [l10n.bIN, store.bin!],
                if (store.type != null && store.type!.name.isNotEmpty)
                  [l10n.typeLabel, store.type!.name],
              ]),
            ],
          ),
        ),
        if (contacts.isNotEmpty) ...[
          SizedBox(height: gap),
          ContentSection(
            title: l10n.contacts,
            child: Column(
              children: [
                for (var i = 0; i < contacts.length; i++) ...[
                  if (i > 0) Container(height: 1, color: scheme.onTertiary),
                  ContactTile(contact: contacts[i]),
                ],
              ],
            ),
          ),
        ],
        SizedBox(height: gap),
        const _PriceLists(),
        SizedBox(height: gap),
        CardBox(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              SettingsRow(
                icon: Icons.edit_outlined,
                title: l10n.change_store,
                trailing: const SettingsChevron(),
                onTap: () =>
                    context.router.navigate(const InitialRouter(children: [
                  ProfileRouter(children: [ChangeStoreRoute()])
                ])),
              ),
              const SettingsRowDivider(),
              SettingsRow(
                icon: Icons.star_border,
                title: l10n.store_reviews,
                trailing: const SettingsChevron(),
                onTap: () => context.router.navigate(InitialRouter(children: [
                  ProfileRouter(
                      children: [StoreMyReviewsRoute(storeId: store.id)])
                ])),
              ),
              const SettingsRowDivider(),
              SettingsRow(
                icon: Icons.workspace_premium_outlined,
                title: l10n.subscriptions,
                trailing: const SettingsChevron(),
                onTap: () => context.router.navigate(InitialRouter(children: [
                  OrderRouter(children: [
                    SubscribeRoute(initialType: SubscribeType.store)
                  ])
                ])),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Прайс-листы магазина. Раньше лежали посреди личных данных, а состояние
/// файла показывалось красной и зелёной иконкой без единой подписи.
class _PriceLists extends StatelessWidget {
  const _PriceLists();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return BlocConsumer<PriceFormCubit, PriceFormState>(
      listener: (context, state) {
        if (state.error != null) {
          CustomSnackBar.error(
            Text(state.error?.messages.isNotEmpty == true
                ? state.error!.messages.first
                : l10n.unknown_error),
          ).view(context);
        }
      },
      builder: (context, state) {
        final cubit = context.read<PriceFormCubit>();

        return ContentSection(
          title: l10n.price_lists,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var i = 0; i < state.prices.length; i++) ...[
                if (i > 0) const SettingsRowDivider(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(13, 6, 6, 6),
                  child: Row(
                    children: [
                      Icon(Icons.description_outlined,
                          size: 19, color: scheme.secondary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          state.prices[i].name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13.5),
                        ),
                      ),
                      Switch.adaptive(
                        value: state.prices[i].active,
                        onChanged: (value) => value
                            ? cubit.activate(state.prices[i].id)
                            : cubit.deactivate(state.prices[i].id),
                      ),
                      IconButton(
                        onPressed: () => cubit.delete(state.prices[i].id),
                        tooltip: l10n.delete,
                        icon: Icon(Icons.delete_outline, color: scheme.error),
                      ),
                    ],
                  ),
                ),
              ],
              if (state.prices.isNotEmpty) const SettingsRowDivider(),
              Padding(
                padding: const EdgeInsets.all(12),
                child: ElevatedButtonApp(
                  text: l10n.add_price,
                  onPressed: cubit.addPrice,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Данные парами «ключ → значение» вместо заблокированных полей ввода.
class _FactsCard extends StatelessWidget {
  const _FactsCard({required this.rows});
  final List<List<String>> rows;

  @override
  Widget build(BuildContext context) => CardBox(child: _Facts(rows: rows));
}

class _Facts extends StatelessWidget {
  const _Facts({required this.rows});
  final List<List<String>> rows;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
    );
  }
}

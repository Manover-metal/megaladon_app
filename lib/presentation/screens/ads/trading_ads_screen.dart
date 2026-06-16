import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/advert/main/advert_screen_main_cubit.dart';
import 'package:megaladon/logic/screens/service/main/service_screen_main_cubit.dart';
import 'package:megaladon/presentation/screens/orders/list_my_orders_screen.dart';
import 'package:megaladon/presentation/widgets/bottom_sheet/filters/filter_ad_bottom_sheet.dart';
import 'package:megaladon/presentation/widgets/card/ad_card.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/message/stock_message.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';

class TradingAdsScreen extends StatefulWidget {
  const TradingAdsScreen({super.key});

  @override
  State<TradingAdsScreen> createState() => _TradingAdsScreenState();
}

class _TradingAdsScreenState extends State<TradingAdsScreen>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollAdvertController;
  late ScrollController _scrollServiceController;

  late TabController _tabController;

  Future _onRefresh() async {
    await context.read<AdvertScreenMainCubit>().fetch();
    await context.read<ServiceScreenMainCubit>().fetch();
  }

  Future<void> _showFilter() async {
    var result = await showModalBottomSheet(
        isScrollControlled: true,
        useSafeArea: true,
        useRootNavigator: true,
        context: context,
        elevation: 100,
        builder: (_) => const FilterAdBottomSheet());
    if (result != null) {
      context.read<AdvertScreenMainCubit>().fetch();
      context.read<ServiceScreenMainCubit>().fetch();
    }
  }

  void _listenerAdvertScroll() {
    if (_scrollAdvertController.position.maxScrollExtent <
        _scrollAdvertController.position.pixels) {
      final cubit = context.read<AdvertScreenMainCubit>();
      if (cubit.state.status != AdverScreenMainStatus.loading) {
        var params = cubit.state.params;
        cubit.fetch(
            params: params.copyWith(
                startRow: params.startRow + params.rowsPerPage));
      }
    }
  }

  void _listenerServiceScroll() {
    if (_scrollServiceController.position.maxScrollExtent <
        _scrollServiceController.position.pixels) {
      final cubit = context.read<ServiceScreenMainCubit>();
      if (cubit.state.status != ServiceScreenMainStatus.loading) {
        var params = cubit.state.params;
        cubit.fetch(
            params: params.copyWith(
                startRow: params.startRow + params.rowsPerPage));
      }
    }
  }

  @override
  void initState() {
    _scrollAdvertController = ScrollController()
      ..addListener(_listenerAdvertScroll);
    _scrollServiceController = ScrollController()
      ..addListener(_listenerServiceScroll);

    _tabController = TabController(length: 2, vsync: this);

    _onRefresh();
    super.initState();
  }

  @override
  void dispose() {
    _scrollAdvertController.removeListener(_listenerAdvertScroll);
    _scrollServiceController.removeListener(_listenerServiceScroll);

    _scrollAdvertController.dispose();
    _scrollServiceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: BlocBuilder<AdvertScreenMainCubit, AdvertScreenMainState>(
              builder: (context, state) => HeaderAppBar(
                isMenu: true,
                title: AppLocalizations.of(context)!.marketplace,
                onTrailing: _onRefresh,
                trailing: state.status != AdverScreenMainStatus.loading
                    ? const Icon(Icons.refresh, size: 30)
                    : const CupertinoActivityIndicator(),
              ),
            ),
          ),
          body: NestedScrollView(
            headerSliverBuilder: (context, isBool) => [
              SliverToBoxAdapter(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: _showFilter,
                        child: const Icon(Icons.filter_alt, size: 30),
                      ),
                    ),
                  ),
                ],
              )),
              SliverPersistentHeader(
                  delegate: TabBarDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: Theme.of(context).colorScheme.primary,
                  labelStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                  unselectedLabelStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Theme.of(context).colorScheme.primary,
                  tabs: [
                    Tab(text: AppLocalizations.of(context)!.services),
                    Tab(text: AppLocalizations.of(context)!.ads),
                  ],
                ),
              ))
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                RefreshIndicator(
                  color: Colors.white,
                  onRefresh: _onRefresh,
                  child: CupertinoScrollbar(
                    controller: _scrollServiceController,
                    child: SingleChildScrollView(
                      controller: _scrollServiceController,
                      child: Container(
                        constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: BlocBuilder<ServiceScreenMainCubit,
                            ServiceScreenMainState>(
                          builder: (context, state) => Column(
                            children: [
                              ...state.services
                                  .map((advert) => AdCard(advert: advert))
                                  .toList(),
                              if (state.status ==
                                  ServiceScreenMainStatus.loading)
                                const Loader(padding: 10)
                              else if (state.status ==
                                  ServiceScreenMainStatus.error)
                                ErrorMessage(error: state.error!)
                              else if (state.stock)
                                StockMessage(
                                    name:
                                        AppLocalizations.of(context)!.services)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                RefreshIndicator(
                  color: Colors.white,
                  onRefresh: _onRefresh,
                  child: CupertinoScrollbar(
                    controller: _scrollAdvertController,
                    child: SingleChildScrollView(
                      controller: _scrollAdvertController,
                      child: Container(
                        constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: BlocBuilder<AdvertScreenMainCubit,
                            AdvertScreenMainState>(
                          builder: (context, state) => Column(
                            children: [
                              ...state.adverts
                                  .map((advert) => AdCard(advert: advert))
                                  .toList(),
                              if (state.status == AdverScreenMainStatus.loading)
                                const Loader(padding: 10)
                              else if (state.status ==
                                  AdverScreenMainStatus.error)
                                ErrorMessage(error: state.error!)
                              else if (state.stock)
                                StockMessage(
                                    name: AppLocalizations.of(context)!.ads)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

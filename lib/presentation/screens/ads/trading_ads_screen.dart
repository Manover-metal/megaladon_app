import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/request/params/index/advert_index_request_params.dart';
import 'package:megaladon/logic/screens/advert/main/advert_screen_main_cubit.dart';
import 'package:megaladon/presentation/screens/orders/list_my_orders_screen.dart';
import 'package:megaladon/presentation/widgets/bottom_sheet/filters/filter_ad_bottom_sheet.dart';
import 'package:megaladon/presentation/widgets/card/ad_card.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/message/stock_message.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';

class TradingAdsScreen extends StatefulWidget {
  const TradingAdsScreen({super.key});

  @override
  State<TradingAdsScreen> createState() => _TradingAdsScreenState();
}

class _TradingAdsScreenState extends State<TradingAdsScreen> with SingleTickerProviderStateMixin {
  late ScrollController _scrollAdvertController;
  late ScrollController _scrollServiceController;

  late TabController _tabController;


  Future _onRefresh() async {
    await context.read<AdvertScreenMainCubit>().fetchAdvert();
    await context.read<AdvertScreenMainCubit>().fetchService();

  }

  _showFilter() async {
    bool? result = await showModalBottomSheet(
        isScrollControlled: true,
        useSafeArea: true,
        useRootNavigator: true,
        context: context,
        elevation: 100,
        builder: (_) => FilterAdBottomSheet()
    );
    if(result != null) {
      context.read<AdvertScreenMainCubit>().fetchAdvert();
      context.read<AdvertScreenMainCubit>().fetchService();

    }
  }

  _listenerAdvertScroll() {
    if (_scrollAdvertController.position.maxScrollExtent < _scrollAdvertController.position.pixels) {
      final cubit = context.read<AdvertScreenMainCubit>();
      if(cubit.state.status != AdverScreenMainStatus.loading) {
        AdvertIndexRequestParams params = cubit.state.params;
        cubit.fetchAdvert(params: params.copyWith(startRow: params.startRow + params.rowsPerPage));
      }
    }
  }

  _listenerServiceScroll() {
    if (_scrollServiceController.position.maxScrollExtent < _scrollServiceController.position.pixels) {
      final cubit = context.read<AdvertScreenMainCubit>();
      if(cubit.state.status != AdverScreenMainStatus.loading) {
        AdvertIndexRequestParams params = cubit.state.params;
        cubit.fetchService(params: params.copyWith(startRow: params.startRow + params.rowsPerPage));
      }
    }
  }


  @override
  void initState() {
    _scrollAdvertController = ScrollController()..addListener(_listenerAdvertScroll);
    _scrollServiceController = ScrollController()..addListener(_listenerServiceScroll);

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
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool isBool) {
                return [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: BlocBuilder<AdvertScreenMainCubit, AdvertScreenMainState>(
                            builder: (context, state) {
                              return HeaderAppBar(
                                  isMenu: true,
                                  title: "Marketplace".tr(),
                                  onTrailing: _onRefresh,
                                  trailing: state.status != AdverScreenMainStatus.loading ? const Icon(
                                    Icons.refresh,
                                    size: 30,
                                  ) : CupertinoActivityIndicator(),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: _showFilter,
                              child: const Icon(Icons.filter_alt,  size: 30),
                            ),
                          ),
                        ),
                      ],
                    )
                  ),
                  SliverPersistentHeader(
                      delegate: TabBarDelegate(
                        TabBar(
                          controller: _tabController,
                          labelColor: Theme.of(context).colorScheme.primary,
                          labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                          unselectedLabelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: Theme.of(context).colorScheme.primary,
                          tabs: [
                            Tab(text: "Services".tr()),
                            Tab(text:"Ads".tr()),
                          ],
                        ),
                      )
                  )
                ];
              },
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
                              minHeight: MediaQuery.of(context).size.height
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: BlocBuilder<AdvertScreenMainCubit, AdvertScreenMainState>(
                            builder: (context, state) {
                               return Column(
                                children: [
                                  ...state.services.map((advert) {
                                    return AdCard(advert: advert);
                                  }).toList(),
                                  if(state.status == AdverScreenMainStatus.loading) const Loader(padding: 10)
                                  else if(state.status == AdverScreenMainStatus.error)  ErrorMessage(error: state.error!)
                                  else if(state.stock)  StockMessage(name: 'Services'.tr())
                                ],
                              );
                            },
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
                              minHeight: MediaQuery.of(context).size.height
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: BlocBuilder<AdvertScreenMainCubit, AdvertScreenMainState>(
                            builder: (context, state) {
                              return Column(
                                children: [
                                  ...state.adverts.map((advert) {
                                    return AdCard(advert: advert);
                                  }).toList(),
                                  if(state.status == AdverScreenMainStatus.loading) const Loader(padding: 10)
                                  else if(state.status == AdverScreenMainStatus.error)  ErrorMessage(error: state.error!)
                                  else if(state.stock)  StockMessage(name: 'Ads'.tr())
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ),
        ),
      ),
    );
  }
}
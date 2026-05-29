import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/store/main/store_screen_main_cubit.dart';
import 'package:megaladon/presentation/widgets/bottom_sheet/filters/filter_store_bottom_sheet.dart';
import 'package:megaladon/presentation/widgets/card/store_card.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/message/stock_message.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';

class ListStoresScreen extends StatefulWidget {
  const ListStoresScreen({super.key});

  @override
  State<ListStoresScreen> createState() => _ListStoresScreenState();
}

class _ListStoresScreenState extends State<ListStoresScreen> {
  late ScrollController _scrollController;

  Future _onRefresh() async {
    await context.read<StoreScreenMainCubit>().fetch();
  }

  Future<void> _showFilter() async {
    var result = await showModalBottomSheet(
        isScrollControlled: true,
        useSafeArea: true,
        useRootNavigator: true,
        context: context,
        elevation: 100,
        builder: (_) => const FilterStoreBottomSheet());
    if (result != null) {
      context.read<StoreScreenMainCubit>().fetch();
    }
  }

  void _listenerScroll() {
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.position.pixels) {
      final cubit = context.read<StoreScreenMainCubit>();
      if (cubit.state.status != StoreScreenMainStatus.loading) {
        var params = cubit.state.params;
        cubit.fetch(
            params: params.copyWith(
                startRow: params.startRow + params.rowsPerPage));
      }
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_listenerScroll);
    _onRefresh();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_listenerScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, isBool) => [
              SliverToBoxAdapter(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    //
                    child:
                        BlocBuilder<StoreScreenMainCubit, StoreScreenMainState>(
                      builder: (context, state) => HeaderAppBar(
                        isMenu: true,
                        title: AppLocalizations.of(context)!.theshops,
                        onTrailing: _onRefresh,
                        trailing: state.status != StoreScreenMainStatus.loading
                            ? const Icon(
                                Icons.refresh,
                                size: 30,
                              )
                            : const CupertinoActivityIndicator(),
                      ),
                    ),
                  ),
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
            ],
            body: RefreshIndicator(
              onRefresh: _onRefresh,
              child: CupertinoScrollbar(
                controller: _scrollController,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Container(
                    constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        BlocBuilder<StoreScreenMainCubit, StoreScreenMainState>(
                          builder: (context, state) => Column(
                            children: [
                              ...state.stores
                                  .map((store) => StoreCard(store: store))
                                  .toList(),
                              if (state.status == StoreScreenMainStatus.loading)
                                const Loader(
                                  padding: 10,
                                )
                              else if (state.status ==
                                  StoreScreenMainStatus.error)
                                ErrorMessage(error: state.error!)
                              else if (state.stock)
                                StockMessage(
                                    name:
                                        AppLocalizations.of(context)!.theshops)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/request/params/index/store_index_request_params.dart';
import 'package:megaladon/generated/locale_keys.g.dart';
import 'package:megaladon/logic/screens/store/main/store_screen_main_cubit.dart';
import 'package:megaladon/presentation/widgets/bottom_sheet/filters/filter_store_bottom_sheet.dart';
import 'package:megaladon/presentation/widgets/card/store_card.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
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

  _showFilter() async {
    bool? result = await showModalBottomSheet(
        isScrollControlled: true,
        useSafeArea: true,
        useRootNavigator: true,
        context: context,
        elevation: 100,
        builder: (_) => const FilterStoreBottomSheet()
    );
    if(result != null) {
      context.read<StoreScreenMainCubit>().fetch();
    }
  }
  _listenerScroll() {
    if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels ) {
      final cubit = context.read<StoreScreenMainCubit>();
      if(cubit.state.status != StoreScreenMainStatus.loading) {
        StoreIndexRequestParams params = cubit.state.params;
        cubit.fetch(params: params.copyWith(startRow: params.startRow + params.rowsPerPage));
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool isBool) {
            return [
              SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        //
                        child: HeaderAppBar(isMenu: true, title: "Theshops".tr()),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: _showFilter,
                            child: const Icon(Icons.filter_alt, size: 30),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            ];
          },
          body: RefreshIndicator(
            onRefresh: _onRefresh,
            child: CupertinoScrollbar(
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Container(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      BlocBuilder<StoreScreenMainCubit, StoreScreenMainState>(
                        builder: (context, state) {
                         return Column(
                            children: [
                              ...state.stores.map((store) {
                               return StoreCard(store: store);
                              }).toList(),
                              if(state.status == StoreScreenMainStatus.loading) const Loader(padding: 10,)
                              else if(state.status == StoreScreenMainStatus.error)  ErrorMessage(error: state.error!)
                              else if(state.stock)  StockMessage(name: 'Theshops'.tr())

                          ],
                          );
                        },
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
}
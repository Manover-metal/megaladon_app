import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/logic/screens/advert/main/advert_screen_main_cubit.dart';
import 'package:megaladon/presentation/widgets/bottom_sheet/filters/filter_ad_bottom_sheet.dart';
import 'package:megaladon/presentation/widgets/card/ad_card.dart';
import 'package:megaladon/presentation/widgets/error/error_message.dart';
import 'package:megaladon/presentation/widgets/list/status_order_list.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

import '../../../data/models/request/params/advert_index_request_params.dart';

class TradingAdsScreen extends StatefulWidget {
  @override
  State<TradingAdsScreen> createState() => _TradingAdsScreenState();
}

class _TradingAdsScreenState extends State<TradingAdsScreen> {
late ScrollController _scrollController;


  Future _onRefresh() async {
    await context.read<AdvertScreenMainCubit>().fetch();
  }

  _showFilter() async {
    bool? result = await showModalBottomSheet(
        useRootNavigator: true,
        context: context,
        elevation: 100,
        builder: (_) => FilterAdBottomSheet()
    );
    if(result != null) {
      context.read<AdvertScreenMainCubit>().fetch();
    }
  }
  // _showSort() async {
  //   bool? result = await showModalBottomSheet(
  //       useRootNavigator: true,
  //       context: context,
  //       elevation: 100,
  //       builder: (_) => SortOrderBottomSheet()
  //   );
  //   if(result != null) {
  //     context.read<OrderScreenMainCubit>().fetch();
  //   }
  // }

  _listenerScroll() {
    if (_scrollController.position.maxScrollExtent < _scrollController.position.pixels + 500) {
      final cubit = context.read<AdvertScreenMainCubit>();
      if(cubit.state.status != AdverScreenMainStatus.loading) {
        AdvertIndexRequestParams params = cubit.state.params;
        cubit.fetch(params: params.copyWith(startRow: params.startRow + 1));
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
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            HeaderAppBar(isMenu: true,),
                            TitleApp('Торговая площадка'),
                            SizedBox(height: 20,),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            child: Icon(Icons.filter_alt,  size: 30),
                            onTap: _showFilter,
                          ),
                        ),
                      ),
                    ],
                  )
                ),
              ];
            },
            body: RefreshIndicator(
              color: Colors.white,
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      BlocBuilder<AdvertScreenMainCubit, AdvertScreenMainState>(
                        builder: (context, state) {
                           return Column(
                          children: [
                            ...state.advers.map((adver) {
                              return AdCard(advert: adver);
                            }).toList(),
                            if(state.status == AdverScreenMainStatus.loading) const Loader(padding: 10,),
                            if(state.status == AdverScreenMainStatus.error)  ErrorMessage(error: state.error!)
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
    );
  }
}
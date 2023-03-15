import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/request/params/index/advert_index_request_params.dart';
import 'package:megaladon/logic/screens/advert/main/advert_screen_main_cubit.dart';
import 'package:megaladon/logic/screens/advert/my/advert_screen_my_cubit.dart';
import 'package:megaladon/presentation/widgets/bottom_sheet/filters/filter_ad_my_bottom_sheet.dart';
import 'package:megaladon/presentation/widgets/card/ad_card.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/message/stock_message.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class MyAdsScreen extends StatefulWidget {
  @override
  State<MyAdsScreen> createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen> {
late ScrollController _scrollController;


  Future _onRefresh() async {
    context.read<AdvertScreenMyCubit>().fetch();
  }

  _showFilter() async {
    bool? result = await showModalBottomSheet(
        useRootNavigator: true,
        context: context,
        elevation: 100,
        builder: (_) => FilterMyAdBottomSheet()
    );
    if(result != null) {
      context.read<AdvertScreenMyCubit>().fetch();
    }
  }
_listenerScroll() {
    if (_scrollController.position.maxScrollExtent < _scrollController.position.pixels) {
      final cubit = context.read<AdvertScreenMyCubit>();
      if(cubit.state.status != AdverScreenMainStatus.loading) {
        AdvertIndexRequestParams params = cubit.state.params;
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
          headerSliverBuilder: (context, isBool) {
            return [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          HeaderAppBar(isMenu: true, ),
                          TitleApp('Мои объявления'),
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
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height
                ),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    BlocBuilder<AdvertScreenMyCubit, AdvertScreenMyState>(
                      builder: (context, state) {
                           return Column(
                          children: [
                            ...state.advers.map((adver) {
                              return AdCard(advert: adver);
                            }).toList(),
                            if(state.status == AdverScreenMyMainStatus.loading) const Loader(padding: 10)
                            else if(state.status == AdverScreenMyMainStatus.error) ErrorMessage(error: state.error!)
                            else if(state.stock) StockMessage(name: 'Объявления')

                          ],
                        );
                      },
                    )
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
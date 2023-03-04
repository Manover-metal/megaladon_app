import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/logic/screens/store/main/store_screen_main_cubit.dart';
import 'package:megaladon/presentation/widgets/bottom_sheet/filters/filter_store_bottom_sheet.dart';
import 'package:megaladon/presentation/widgets/card/store_card.dart';
import 'package:megaladon/presentation/widgets/list/status_order_list.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class ListStoresScreen extends StatefulWidget {

  @override
  State<ListStoresScreen> createState() => _ListStoresScreenState();
}

class _ListStoresScreenState extends State<ListStoresScreen> {
  @override
  void initState() {
    _onRefresh();
    super.initState();
  }

  Future _onRefresh() async {
    await context.read<StoreScreenMainCubit>().fetch();
  }

  _showFilter() async {
    bool? result = await showModalBottomSheet(
        useRootNavigator: true,
        context: context,
        elevation: 100,
        builder: (_) => FilterStoreBottomSheet()
    );
    if(result != null) {
      context.read<StoreScreenMainCubit>().fetch();
    }
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
                            TitleApp('Магазины'),
                            SizedBox(height: 20,),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            child: Icon(Icons.filter_alt, size: 30),
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
                    BlocBuilder<StoreScreenMainCubit, StoreScreenMainState>(
                      builder: (context, state) {
                        if(state is StoreScreenMainSuccess) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: state.stores.map((store) {
                                  return StoreCard(store: store);
                                }
                              ).toList(),
                            ),
                          );
                        }
                        else if(state is StoreScreenMainLoader) {
                          return const Loader(padding: 10,);
                        } else if(state is StoreScreenMainError) {
                          return Text('error');
                        }
                        return Container();
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
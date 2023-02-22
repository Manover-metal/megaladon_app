import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/logic/screens/store/main/store_screen_main_cubit.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
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
                BlocBuilder<StoreScreenMainCubit, StoreScreenMainState>(
                  builder: (context, state) {
                    if(state is StoreScreenMainSuccess) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: state.stores.map((index) {
                              return StoreCard();
                            }
                          ).toList(),
                        ),
                      );
                    }
                    else if(state is StoreScreenMainLoader) {
                      return const Loader();
                    } else if(state is StoreScreenMainError) {
                      return Text('error');
                    }
                    return Container();
                    
                    
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
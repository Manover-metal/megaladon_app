import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/logic/screens/advert/main/advert_screen_main_cubit.dart';
import 'package:megaladon/presentation/widgets/card/ad_card.dart';
import 'package:megaladon/presentation/widgets/list/status_order_list.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class TradingAdsScreen extends StatefulWidget {
  @override
  State<TradingAdsScreen> createState() => _TradingAdsScreenState();
}

class _TradingAdsScreenState extends State<TradingAdsScreen> {

  @override
  void initState() {
    context.read<AdvertScreenMainCubit>().fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
              StatusList(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: BlocBuilder<AdvertScreenMainCubit, AdvertScreenMainState>(
                  builder: (context, state) {
                    if(state is AdvertScreenMainSuccess) {
                      return Column(
                        children: state.adverts.map((advert) {
                          return AdCard();
                        }).toList(),
                      );
                    }
                    else if(state is AdvertScreenMainLoader) {
                      return const Loader();
                    }
                    return Container();

                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
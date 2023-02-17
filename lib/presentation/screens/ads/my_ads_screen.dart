import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/logic/screens/advert/my/advert_screen_my_cubit.dart';
import 'package:megaladon/presentation/widgets/card/ad_card.dart';
import 'package:megaladon/presentation/widgets/card/store_card.dart';
import 'package:megaladon/presentation/widgets/list/status_order_list.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class MyAdsScreen extends StatelessWidget {
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
                    HeaderAppBar(isMenu: true, ),
                    TitleApp('Мои объявления'),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
              StatusList(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: BlocBuilder<AdvertScreenMyCubit, AdvertScreenMyState>(
                  builder: (context, state) {
                    if(state is AdvertScreenMySuccess) {
                      return Column(
                        children: state.adverts.map((advert) {
                          return AdCard();
                        }).toList(),
                      );
                    }
                    else if(state is AdvertScreenMyLoader) {
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
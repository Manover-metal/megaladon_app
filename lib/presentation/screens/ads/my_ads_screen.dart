import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/repositories/advert_repository.dart';
import 'package:megaladon/logic/screens/advert/my/advert_screen_my_cubit.dart';
import 'package:megaladon/presentation/widgets/card/ad_card.dart';
import 'package:megaladon/presentation/widgets/card/store_card.dart';
import 'package:megaladon/presentation/widgets/list/status_order_list.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class MyAdsScreen extends StatefulWidget {
  @override
  State<MyAdsScreen> createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen> {

  @override
  void initState() {
    _onRefresh();
    super.initState();
  }

  Future _onRefresh() async {
    context.read<AdvertScreenMyCubit>().fetch();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height
              ),
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
                              return AdCard(advert: advert,);
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
        ),
      ),
    );
  }
}
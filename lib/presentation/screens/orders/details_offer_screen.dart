import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/logic/screens/offers/details/offer_screen_details_cubit.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/error/error_message.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';
import 'package:megaladon/presentation/widgets/tiles/data_tile.dart';
import 'package:megaladon/presentation/widgets/tiles/executor_tile.dart';

class DetailsOfferScreen extends StatefulWidget {
  
  final int orderId;
  final int offerId;

  const DetailsOfferScreen({super.key, required this.orderId, required this.offerId});
  
  @override
  State<DetailsOfferScreen> createState() => _DetailsOfferScreenState();
}

class _DetailsOfferScreenState extends State<DetailsOfferScreen> {
  
  @override
  void initState() {
    context.read<OfferScreenDetailsCubit>().fetch(orderId: widget.orderId, offerId: widget.offerId);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      HeaderAppBar(isBack: true, ),
                      TitleApp('Предложение исполнителя'),
                      SizedBox(height: 20,),
                    ],
                  ),
                ),
              )
            ];
          },
          body: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height
              ),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  BlocBuilder<OfferScreenDetailsCubit, OfferScreenDetailsState>(
                    builder: (context, state) {
                      if(state is OfferScreenDetailsSuccess) {
                        return Column(
                          children: [
                            ExecutorTile(),
                            SizedBox(height: 20,),
                            DataTile(title: 'Актуален до: ', data: '31-10-2022',),
                            DataTile(title: 'Цена: ', data: '25 000 ₸',),
                            DataTile(title: 'Сроки: ', data: '2 недели',),
                            DataTile(title: 'Местоположение: ', data: 'г. Караганда',),
                            DataTile(title: 'Описание:  ', data: 'Как принято считать, непосредственные участники технического прогресса объединены в целые кластеры',),
                            SizedBox(height: 20,),
                            ElevatedButtonApp(text: 'Назначить исполнителем')
                          ],
                        );
                      } else if(state is OfferScreenDetailsLoader) {
                        return Loader();
                      } else if(state is OfferScreenDetailsError) {
                        return ErrorMessage(error: state.error);
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
    );
  }
}
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/logic/screens/advert/details/advert_screen_details_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/screens/forms/offer/create_offer_screen.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/list/file_download_list.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';
import 'package:megaladon/presentation/widgets/tiles/user_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsAdScreen extends StatefulWidget {

  final int id;

  const DetailsAdScreen({super.key, required this.id});

  @override
  State<DetailsAdScreen> createState() => _DetailsAdScreenState();
}

class _DetailsAdScreenState extends State<DetailsAdScreen> {

  @override
  void initState() {
    context.read<AdvertScreenDetailsCubit>().fetch(id: widget.id);
    super.initState();
  }

  _call(String phone) => ()  {
    final Uri uri = Uri(
      scheme: 'tel',
      path: phone,
    );
    launchUrl(uri);
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        HeaderAppBar(isBack: true,),
                        TitleApp('Объявление'),
                        SizedBox(height: 20,),
                      ],
                    ),
                  ),
                  BlocBuilder<AdvertScreenDetailsCubit, AdvertScreenDetailsState>(
                    builder: (context, state) {
                      if(state is AdvertScreenDetailsSuccess) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0),
                              child: Column(
                                children: [
                                  Text(state.advert.title),
                                  Text(state.advert.description),
                                  SizedBox(height: 20,),
                                  if(state.advert.media.isEmpty) SubTitleApp('Нет прикреплённых файлов')
                                  else ...[
                                    SubTitleApp('Прикреплённые файлы'),
                                    SizedBox(height: 10,),
                                    FileDownloadList(),
                                  ],

                                ],
                              ),
                            ),
                            Divider(thickness: 1),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Цена: до ${state.advert.price} ₸'),
                                  SizedBox(height: 10,),
                                  UserTile(user: state.advert.user!),
                                  SizedBox(height: 20),
                                  ...[
                                    ElevatedButtonApp(
                                      text: 'Позвонить',
                                      onPressed: _call(state.advert.additionalPhone!),
                                    ),
                                    OutlinedButtonApp(
                                        text: 'Задать вопрос в чате'),
                                  ],
                                  ...[
                                    ElevatedButtonApp(
                                      text: 'Изменить',
                                    ),
                                  ]
                                ],
                              ),
                            )
                          ],
                        );
                      } else if(state is AdvertScreenDetailsLoader) {
                        return Loader();
                      } else if(state is AdvertScreenDetailsError) {
                        return Text('error');
                      }
                      return Container();
                    },
                  )
                ],
              )
          ),
        ),
      ),
    );
  }
}

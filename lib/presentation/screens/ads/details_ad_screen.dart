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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: BlocBuilder<AdvertScreenDetailsCubit, AdvertScreenDetailsState>(
              builder: (context, state) {
                if(state is AdvertScreenDetailsSuccess) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            HeaderAppBar(isBack: true,),
                            TitleApp('Объявление'),
                            SizedBox(height: 20,),
                            Text(
                                'Изготовить скользящие опоры DN-5000 под стойки опорных башней очень большой заголовок задания'),
                            Text(
                                'Учитывая ключевые сценарии поведения, синтетическое тестирование требует от нас анализа системы массового участия. Есть над чем задуматься: предприниматели в сети интернет освещают чрезвычайно интересные особенности картины в целом, однако.'),
                            SizedBox(height: 20,),
                            SubTitleApp('Прикреплённые файлы'),
                            SizedBox(height: 10,),
                            FileDownloadList(),
                          ],
                        ),
                      ),
                      Divider(thickness: 1),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Цена: до 25 000 ₸'),
                            SizedBox(height: 10,),
                            UserTile(),
                            SizedBox(height: 20),

                            ...[
                              ElevatedButtonApp(
                                text: 'Позвонить',
                              ),
                              OutlinedButtonApp(text: 'Задать вопрос в чате'),
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
                }else if(state is AdvertScreenDetailsLoader) {
                  return Loader();
                } else if(state is AdvertScreenDetailsError) {
                  return Text('error');
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}
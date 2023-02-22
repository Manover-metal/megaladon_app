import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/logic/screens/store/details/store_screen_details_cubit.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/list/file_download_list.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';
import 'package:megaladon/presentation/widgets/tiles/data_tile.dart';

class DetailsStoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                HeaderAppBar(isBack: true),
                BlocBuilder<StoreScreenDetailsCubit, StoreScreenDetailsState>(
                  builder: (context, state) {
                    if(state is StoreScreenDetailsSuccess) {
                      return Column(
                        children: [
                          TitleApp('TOO "Стальной Алхимик"'),
                          SizedBox(height: 20,),

                          CircleAvatar(
                            radius: MediaQuery.of(context).size.width / 6,
                            backgroundColor:  Colors.grey.shade300,
                          ),
                          DataTile(title: 'Адрес:', data: 'Республика Казахстан, г. Караганда, ул. Заводская 17/2'),
                          DataTile(title: 'Email:', data: 'mailto@mail.ru'),
                          DataTile(title: 'Телефон:', data: '+7 (123) 456-78-91'),
                          DataTile(title: 'Сайт:', data: 'steel-astana.kz'),
                          DataTile(title: 'Описание:', data: 'Как принято считать, непосредственные участники технического прогресса объединены в целые кластеры'),
                          SizedBox(height: 20,),

                          SubTitleApp('Прайс Лист'),
                          SizedBox(height: 10,),

                          FileDownloadList(),
                          ElevatedButtonApp(text: 'Позвонить'),
                          OutlinedButtonApp(text: 'Написать'),
                        ],
                      );
                    }
                    else if(state is StoreScreenDetailsLoader) {
                      return Loader();
                    } else if(state is StoreScreenDetailsError) {
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
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/core/icons/icons.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/screens/advert/details/advert_screen_details_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
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

  _toChat() {
    context.router.navigate(DetailsChatRouter());
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
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: HeaderAppBar(isBack: true, title: 'Объявление'),
                      ),
                    ],
                  )
              ),
            ];
          },
          body: SingleChildScrollView(
            child: Container(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height
                ),
                child: BlocBuilder<AdvertScreenDetailsCubit, AdvertScreenDetailsState>(
                  builder: (context, state) {
                    if(state is AdvertScreenDetailsSuccess) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              children: [
                                Text(state.advert.title),
                                Text(state.advert.description),
                                SizedBox(height: 20,),
                                if(state.advert.media.isEmpty) SubTitleApp('Нет прикреплённых файлов')
                                else ...[
                                  SubTitleApp('Прикреплённые файлы'),
                                  SizedBox(height: 10,),
                                  ...state.advert.media.map((e) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        width: double.infinity,
                                        constraints: BoxConstraints(
                                            minHeight: 100
                                        ),
                                        color: Theme.of(context).colorScheme.secondary,
                                        child: CachedNetworkImage(
                                          imageUrl: e.url,
                                          progressIndicatorBuilder: (context, url, downloadProgress) => Icon(IconPack.chat, size: MediaQuery.of(context).size.width / 10),
                                          errorWidget:  (context, url, error) => Icon(IconPack.chat, size: MediaQuery.of(context).size.width / 10),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  }).toList()
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
                                BlocBuilder<AuthBloc, AuthState>(
                                  builder: (context, stateUser) {
                                    if(stateUser is AuthLoginState) {
                                      return Column(
                                        children: [
                                          if(state.advert.user!.id == stateUser.auth.user.value!.id)...[
                                            ElevatedButtonApp(
                                              text: 'Изменить',
                                            ),
                                          ] else ...[
                                            ElevatedButtonApp(
                                              text: 'Позвонить',
                                              onPressed: _call(state.advert.additionalPhone!),
                                            ),
                                            OutlinedButtonApp(
                                                onPressed: _toChat,
                                                text: 'Задать вопрос в чате'
                                            ),
                                          ]
                                        ],
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    } else if(state is AdvertScreenDetailsLoader) {
                      return Loader(padding: 10,);
                    } else if(state is AdvertScreenDetailsError) {
                      return ErrorMessage(error: state.error);
                    }
                    return Container();
                  },
                )
            ),
          ),
        ),
      ),
    );
  }
}

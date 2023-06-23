import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/core/icons/icons.dart';
import 'package:megaladon/data/models/advert_model.dart';
import 'package:megaladon/data/models/dictionary/advert_type.dart';
import 'package:megaladon/data/repositories/advert_repository.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/screens/advert/details/advert_screen_details_cubit.dart';
import 'package:megaladon/logic/screens/chats/chat_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/snackbars/error_snackbar.dart';
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
    context.read<ChatCubit>().createChatAdvert(widget.id).then((value) {
      context.router.navigate(const ListChatsRoute());
    });
  }

  _edit(AdvertModel advert) => () {
    context.router.navigate(UpdateAdRoute(advert: advert, type: advert.type));
  };


  _onTrailing(AdvertModel advert) => () {
    showModalBottomSheet(
        useRootNavigator: true,
        useSafeArea: true,
        context: context,
        builder: (context) {
          return Container(
            color: Theme.of(context).colorScheme.background,
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButtonApp(
                  onPressed: _toUpdate(advert),
                  child: Text('Изменить'),
                ),
                SizedBox(height: 5),
                ElevatedButtonApp(
                  onPressed: _toDelete(advert),
                  child: Text('Удалить'),

                )
              ],
            ),
          );
        }
    );
  };

  _toUpdate(AdvertModel advert) => () {
    context.router.navigate(
        UpdateAdRoute(advert: advert, type: advert.type)
    );
  };

  _toDelete(AdvertModel advert) => () {
    AdvertRepository().delete(advert.id).then((value) {
      context.router.pop();
      context.router.popUntil((route) => false);
      context.router.navigate(const InitialRouter(
          children: [
            OrderRouter(
                children: [
                  ListMyOrdersRoute()
                ]
            )
          ]
      ));
    }).catchError((error) {
      context.router.pop();
      if(error is DioError) {
        showErrorSnackBar(context, error.response?.data['message'] ?? 'Неизвестная ошибка');
      } else {
        showErrorSnackBar(context, 'Неизвестная ошибка');
      }
    });
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, isBool) {
            return [
              SliverToBoxAdapter(
                  child: Column(
                    children:  [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, authState) {
                            return BlocBuilder<AdvertScreenDetailsCubit, AdvertScreenDetailsState>(
                              builder: (context, state) {
                                if(state is AdvertScreenDetailsSuccess) {
                                  return HeaderAppBar(
                                    isBack: true,
                                    title: state.advert.type == AdvertType.advert ? "Ad".tr(): "Service".tr(),
                                    onTrailing: (authState is AuthLoginState) && authState.auth.user.value?.id == state.advert.user?.id ? _onTrailing(state.advert) : null,
                                  );
                                }
                                return const HeaderAppBar(
                                  isBack: true,
                                  title: '',
                                );
                              },
                            );
                          },
                        ),
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
                                const SizedBox(height: 20,),
                                if(state.advert.media.isEmpty) SubTitleApp("No_attached_files".tr())
                                else ...[
                                  SubTitleApp("Attached_files".tr()),
                                  const SizedBox(height: 10,),
                                  ...state.advert.media.map((e) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        width: double.infinity,
                                        constraints: const BoxConstraints(
                                            minHeight: 100
                                        ),
                                        color: Theme.of(context).colorScheme.secondary,
                                        child: CachedNetworkImage(
                                          imageUrl: e.url,
                                          progressIndicatorBuilder: (context, url, downloadProgress) => Icon(Icons.image_outlined, size: MediaQuery.of(context).size.width / 10),
                                          errorWidget:  (context, url, error) => Icon(Icons.error_outline, size: MediaQuery.of(context).size.width / 10),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  }).toList()
                                ],
                              ],
                            ),
                          ),
                          const Divider(thickness: 1),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text( '${"Price_up_to".tr()}${state.advert.price} ₸'),
                                const SizedBox(height: 10,),
                                UserTile(user: state.advert.user!),
                                const SizedBox(height: 20),
                                BlocBuilder<AuthBloc, AuthState>(
                                  builder: (context, stateUser) {
                                    if(stateUser is AuthLoginState) {
                                      return Column(
                                        children: [
                                          if(state.advert.user!.id != stateUser.auth.user.value!.id)...[
                                            ElevatedButtonApp(
                                              text: "Call".tr(),
                                              onPressed: _call(state.advert.additionalPhone!),
                                            ),
                                            OutlinedButtonApp(
                                                onPressed: _toChat,
                                                text: "Ask_a_question_in_the_chat".tr()
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
                      return const Loader(padding: 10,);
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

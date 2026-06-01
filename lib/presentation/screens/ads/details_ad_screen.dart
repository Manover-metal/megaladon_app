import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/advert_model.dart';
import 'package:megaladon/data/models/dictionary/advert_type.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/screens/advert/delete/advert_delete_cubit.dart';
import 'package:megaladon/logic/screens/advert/details/advert_screen_details_cubit.dart';
import 'package:megaladon/logic/screens/chats/chat_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';
import 'package:megaladon/presentation/widgets/tiles/user_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsAdScreen extends StatefulWidget {
  const DetailsAdScreen({required this.id, super.key});
  final int id;

  @override
  State<DetailsAdScreen> createState() => _DetailsAdScreenState();
}

class _DetailsAdScreenState extends State<DetailsAdScreen> {
  @override
  void initState() {
    _refresh();
    super.initState();
  }

  Null Function() _call(String phone) => () {
        final uri = Uri(
          scheme: 'tel',
          path: phone,
        );
        launchUrl(uri);
      };

  void _toChat() {
    context.read<ChatCubit>().createChatAdvert(widget.id).then((value) {
      context.router.navigate(const ListChatsRoute());
    });
  }

  void _refresh() {
    context.read<AdvertScreenDetailsCubit>().fetch(id: widget.id);
  }

  Future<void> Function() _onTrailing(AdvertModel advert) =>
      () => showModalBottomSheet<void>(
          useRootNavigator: true,
          useSafeArea: true,
          context: context,
          builder: (context) => Container(
                color: Theme.of(context).colorScheme.surface,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlinedButtonApp(
                      onPressed: _toUpdate(advert),
                      child: Text(AppLocalizations.of(context)!.update),
                    ),
                    const SizedBox(height: 5),
                    ElevatedButtonApp(
                      onPressed: _toDelete(advert),
                      child: Text(AppLocalizations.of(context)!.delete),
                    )
                  ],
                ),
              ));

  Null Function() _toUpdate(AdvertModel advert) => () {
        context.router
            .navigate(UpdateAdRoute(advert: advert, type: advert.type));
      };

  Null Function() _toDelete(AdvertModel advert) => () {
        context.read<AdvertDeleteCubit>().delete(advert.id);
      };

  void _deleteListener(BuildContext context, AdvertDeleteState state) {
    if (state is AdvertDeleteSuccess) {
      context.router.popUntil((route) => false);
      context.router.navigate(const InitialRouter(children: [
        OrderRouter(children: [ListMyOrdersRoute()])
      ]));
    } else if (state is AdvertDeleteError) {
      context.router.pop();
      CustomSnackBar.error(
        Text(
          state.error.messages.isNotEmpty
              ? state.error.messages.first
              : AppLocalizations.of(context)!.unknown_error,
        ),
      ).view(context);
    }
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<AdvertDeleteCubit, AdvertDeleteState>(
        listener: _deleteListener,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) => BlocBuilder<
                  AdvertScreenDetailsCubit, AdvertScreenDetailsState>(
                builder: (context, state) {
                  if (state is AdvertScreenDetailsSuccess) {
                    return HeaderAppBar(
                      isBack: true,
                      title: state.advert.type == AdvertType.advert
                          ? AppLocalizations.of(context)!.ad
                          : AppLocalizations.of(context)!.service,
                      onTrailing: (authState is AuthLoginState) &&
                              authState.auth.user.value?.id ==
                                  state.advert.user?.id
                          ? _onTrailing(state.advert)
                          : null,
                    );
                  }
                  return HeaderAppBar(isBack: true, onTrailing: _refresh);
                },
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height),
                child: BlocBuilder<AdvertScreenDetailsCubit,
                    AdvertScreenDetailsState>(
                  builder: (context, state) {
                    if (state is AdvertScreenDetailsSuccess) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                Text(state.advert.title),
                                Text(state.advert.description),
                                const SizedBox(
                                  height: 20,
                                ),
                                if (state.advert.media.isEmpty)
                                  SubTitleApp(AppLocalizations.of(context)!
                                      .no_attached_files)
                                else ...[
                                  SubTitleApp(AppLocalizations.of(context)!
                                      .attached_files),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ...state.advert.media
                                      .map((e) => ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Container(
                                              width: double.infinity,
                                              constraints: const BoxConstraints(
                                                  minHeight: 100),
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              child: CachedNetworkImage(
                                                imageUrl: e.url,
                                                progressIndicatorBuilder:
                                                    (context, url,
                                                            downloadProgress) =>
                                                        Icon(
                                                            Icons
                                                                .image_outlined,
                                                            size: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                10),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    Icon(Icons.error_outline,
                                                        size: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            10),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ))
                                      .toList()
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
                                Text(AppLocalizations.of(context)!
                                    .priceUpToAmount(
                                        state.advert.price.toString())),
                                const SizedBox(
                                  height: 10,
                                ),
                                UserTile(user: state.advert.user!),
                                const SizedBox(height: 20),
                                BlocBuilder<AuthBloc, AuthState>(
                                  builder: (context, stateUser) {
                                    if (stateUser is AuthLoginState) {
                                      return Column(
                                        children: [
                                          if (state.advert.user!.id !=
                                              stateUser
                                                  .auth.user.value!.id) ...[
                                            ElevatedButtonApp(
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .call,
                                              onPressed: _call(state
                                                  .advert.additionalPhone!),
                                            ),
                                            OutlinedButtonApp(
                                                onPressed: _toChat,
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .ask_a_question_in_the_chat),
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
                    } else if (state is AdvertScreenDetailsLoader) {
                      return const Loader(
                        padding: 10,
                      );
                    } else if (state is AdvertScreenDetailsError) {
                      return ErrorMessage(error: state.error);
                    }
                    return Container();
                  },
                )),
          ),
        ),
      );
}

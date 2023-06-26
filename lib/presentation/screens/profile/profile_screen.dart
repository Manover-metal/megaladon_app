import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:megaladon/data/models/executor_model.dart';
import 'package:megaladon/data/models/store_model.dart';
import 'package:megaladon/data/models/user_model.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/form/price/price_form_cubit.dart';
import 'package:megaladon/logic/screens/profile/change_photo/change_photo_cubit.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/drawer/drawer_profile.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/message/auth_message.dart';
import 'package:megaladon/presentation/widgets/message/error_message.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/snackbars/error_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';
import 'package:megaladon/presentation/widgets/tiles/contact_tile.dart';
import 'package:megaladon/presentation/widgets/tiles/data_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future _fetch() async {
    final state = context.read<AuthBloc>().state;
    if (state is AuthLoginState) {
      return await context
          .read<ProfileScreenCubit>()
          .fetch(id: state.auth.user.value!.id);
    } else {
      return await context.read<ProfileScreenCubit>().fetch(id: 0);
    }
  }

  @override
  void initState() {
    _fetch();
    super.initState();
  }

  _context(context) => () {
    Scaffold.of(context).openEndDrawer();
  };

  _changePhoto() {
    context.read<ChangePhotoCubit>().changePhoto();
  }

  _photoListener(BuildContext context, ChangePhotoState state) {
    if (state.status == PhotoStatus.error) {
      showErrorSnackBar(context, state.error!.messages[0]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: DrawerProfile(),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
                builder: (context, state) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: HeaderAppBar(
                          isMenu: true,
                          title: "Profile".tr(),
                          onTrailing:
                              (state.status == ProfileScreenStatus.success)
                                  ? _context(context)
                                  : null),
                    ),
                  );
                },
              )
            ];
          },
          body: RefreshIndicator(
            onRefresh: _fetch,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
                      builder: (context, state) {
                        if (state.status == ProfileScreenStatus.success) {
                          UserModel user = state.user!;
                          ExecutorModel? executor = state.executor;
                          StoreModel? store = state.store;
                          return Column(
                            children: [
                              BlocConsumer<ChangePhotoCubit, ChangePhotoState>(
                                listener: _photoListener,
                                builder: (context, state) {
                                  return SizedBox(
                                    width: MediaQuery.of(context).size.width / 3,
                                    height: MediaQuery.of(context).size.width / 3,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      clipBehavior: Clip.hardEdge,
                                      child: Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            height: MediaQuery.of(context).size.width /  3,
                                            color: Theme.of(context).colorScheme.secondary,
                                            child: state.status == PhotoStatus.bytes
                                                ? Image.memory(
                                                    state.imageData!,
                                                    fit: BoxFit.cover,
                                                  )
                                                : CachedNetworkImage(
                                                    imageUrl: state.url ?? '',
                                                    fadeInDuration: Duration.zero,
                                                    progressIndicatorBuilder: (context, url, downloadProgress) => Icon(Icons.person, size: MediaQuery.of(context).size.width / 4),
                                                    errorWidget: (context, url, error) => Icon(Icons.person, size: MediaQuery.of(context).size.width / 4),
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                          Align(
                                              alignment: Alignment.bottomCenter,
                                              child: GestureDetector(
                                                onTap: _changePhoto,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius
                                                                .vertical(
                                                            bottom:
                                                                Radius.circular(
                                                                    1000)),
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .background
                                                        .withOpacity(0.5),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 3),
                                                  width: double.infinity,
                                                  child: const Icon(Icons.edit),
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              DataTile(
                                  title: "Name".tr(), data: user.name),
                              if (user.phone != null)
                                DataTile(
                                    title: "Telephone".tr(), data: user.phone!),
                              if (user.city != null)
                                DataTile(
                                    title: "Location".tr(),
                                    data: 'г.${user.city?.name ?? ''}'),
                              const Divider(thickness: 1),
                              if (executor != null) ...[
                                TitleApp("Artist_data".tr()),
                                const SizedBox(
                                  height: 20,
                                ),
                                DataTile(
                                    title:"Organization".tr(),
                                    data: executor.name),
                                DataTile(title: "BIN".tr(), data: executor.bin!),
                                DataTile(
                                    title: "Rating".tr(),
                                    data: executor.rating ?? '0'),
                                if (executor.city != null)
                                  DataTile(
                                      title: "City".tr(),
                                      data: executor.city!.name),
                                if (executor.fullAddress != null)
                                  DataTile(
                                      title: "Address".tr(),
                                      data: executor.fullAddress!),
                                if (executor.countOrders != null)
                                  DataTile(
                                      title: 'The_number_of_orders'.tr(),
                                      data: executor.countOrders.toString()),
                                if (executor.description != null)
                                  DataTile(
                                      title: 'Description'.tr(),
                                      data: executor.description ?? ''),
                                const Divider(thickness: 1),
                              ],
                              if (store != null) ...[
                                TitleApp("Store_data".tr()),
                                const SizedBox(
                                  height: 20,
                                ),
                                DataTile(
                                    title:"Address".tr(),
                                    data: store.fullAddress),
                                DataTile(
                                    title: "Rating".tr(),
                                    data: store.rating ?? '0'),
                                if (store.bin != null)
                                  DataTile(
                                      title: "BIN".tr(), data: store.bin.toString()),
                                if (store.city != null)
                                  DataTile(
                                      title: "City".tr(), data: store.city!.name),
                                if (store.contacts != null)
                                  ...store.contacts!.map((e) {
                                    return ContactTile(contact: e);
                                  }).toList(),
                                const SizedBox(
                                  height: 20,
                                ),
                                TitleApp("Price_lists".tr()),

                                BlocConsumer<PriceFormCubit, PriceFormState>(
                                  builder: (context, state) {
                                    return Column(
                                    children: [
                                      Column(
                                        children: state.prices.map((file) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                file.name,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              )),
                                              IconButton(
                                                  onPressed: () => context.read<PriceFormCubit>().delete(file.id),
                                                  icon: const Icon(Icons.delete, color: Colors.red)
                                              ),
                                              if (file.active)
                                                IconButton(
                                                    onPressed: () => context.read<PriceFormCubit>().deactivate(file.id),
                                                    icon: const Icon(Icons.check_circle_rounded, color: Colors.green)
                                                )
                                              else IconButton(
                                                  onPressed: () => context.read<PriceFormCubit>().activate(file.id),
                                                  icon: const Icon(Icons.remove_circle_outline, color: Colors.red)
                                                )
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                      ElevatedButtonApp(
                                        text: "Add_price".tr(),
                                        onPressed: context
                                            .read<PriceFormCubit>()
                                            .addPrice,
                                      ),
                                    ],
                                  );
                                  },
                                  listener: (context, state) {
                                    if (state.error != null) {
                                      showErrorSnackBar(
                                          context, state.error!.messages[0]);
                                    }
                                  }
                                ),

                                const SizedBox(
                                  height: 20,
                                ),
                                const Divider(thickness: 1),
                              ]
                            ],
                          );
                        }
                        else if (state.status == ProfileScreenStatus.notAuth) {
                          return const AuthMessage();
                        } else if (state.status == ProfileScreenStatus.loading) {
                          return const Loader();
                        } else if (state.status == ProfileScreenStatus.notAuth) {
                          return ErrorMessage(error: state.error!);
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

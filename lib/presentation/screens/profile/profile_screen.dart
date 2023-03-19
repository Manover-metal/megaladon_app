import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:megaladon/data/models/executor_model.dart';
import 'package:megaladon/data/models/store_model.dart';
import 'package:megaladon/data/models/user_model.dart';
import 'package:megaladon/generated/locale_keys.g.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/form/price/price_form_cubit.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
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
  // late PriceMultiPickerController _priceController;

  Future _fetch() async {
    final state = context.read<AuthBloc>().state;
    if(state is AuthLoginState) {
      return await context.read<ProfileScreenCubit>().fetch(id: state.auth.user.value!.id);
    } else  {
      return await context.read<ProfileScreenCubit>().fetch(id: 0);
    }
  }

  // _addFile(PlatformFile file) async {
  //   await context.read<ProfileScreenCubit>().addPrice(file);
  // }
  //
  // _deleteFile(int indexFile) async {
  //   await context.read<ProfileScreenCubit>().deleteByIndex(indexFile);
  // }

  @override
  void initState() {
    _fetch();
    // _priceController = PriceMultiPickerController(
    //     _addFile,
    //     _deleteFile
    // );
    super.initState();
  }

  @override
  void dispose() {
    // _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: HeaderAppBar(isMenu: true, title: 'Профиль'),
                ),
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
                        if(state.status == ProfileScreenStatus.success) {
                          UserModel user = state.user!;
                          ExecutorModel? executor = state.executor;
                          StoreModel? store = state.store;
                          return Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                  width: MediaQuery.of(context).size.width/3,
                                  height: MediaQuery.of(context).size.width/3,
                                  color: Theme.of(context).colorScheme.secondary,
                                  child: CachedNetworkImage(
                                    imageUrl: user.photo ?? '',
                                    progressIndicatorBuilder: (context, url, downloadProgress) => Icon(Icons.person, size: MediaQuery.of(context).size.width / 4),
                                    errorWidget:  (context, url, error) => Icon(Icons.person, size: MediaQuery.of(context).size.width / 4),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20,),
                              DataTile(title: LocaleKeys.Name.tr(), data: user.name),
                              if(user.phone != null) DataTile(title: LocaleKeys.Telephone.tr() , data: user.phone!),
                              if(user.city != null) DataTile(title: LocaleKeys.Location.tr(), data: 'г.${user.city?.name ?? ''}'),
                              const Divider(thickness: 1),
                              if(executor != null) ...[
                                TitleApp(LocaleKeys.Artist_data.tr()),
                                const SizedBox(height: 20,),
                                DataTile(title: LocaleKeys.Organization.tr(), data: executor.name),
                                DataTile(title: 'БИН', data: executor.bin!),
                                DataTile(title: 'Рейтинг', data: executor.rating ?? '0'),
                                if(executor.fullAddress != null) DataTile(title: LocaleKeys.Address, data: executor.fullAddress!),
                                if(executor.countOrders != null) DataTile(title: 'Количество заказов', data: executor.countOrders.toString()),
                                const Divider(thickness: 1),
                              ],
                              if(store != null) ...[
                                TitleApp(LocaleKeys.Store_data.tr()),
                                const SizedBox(height: 20,),
                                if(store.name != null) DataTile(title: LocaleKeys.Organization.tr(), data: '${store.type?.name ?? ''} "${store.name!}"'),
                                DataTile(title: LocaleKeys.Address, data: store.fullAddress),
                                DataTile(title: 'Рейтинг', data: store.rating ?? '0'),
                                if(store.bin != null) DataTile(title: 'БИН', data: store.bin.toString()),
                                if(store.city != null) DataTile(title: 'Город', data: store.city!.name),
                                if(store.contacts != null) ...store.contacts!.map((e) {
                                  return ContactTile(contact: e);
                                }).toList(),
                                const SizedBox(height: 20,),
                                TitleApp('Прайс-лист'),

                                BlocConsumer<PriceFormCubit, PriceFormState>(
                                    builder: (context, state) {
                                      return Column(
                                        children: [
                                          Column(
                                            children: state.prices.map((file) {
                                              return Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                      child: Text(
                                                        file.name,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      )
                                                  ),
                                                  if(file.active) IconButton(
                                                      onPressed: () => context.read<PriceFormCubit>().deactivate(file.id),
                                                      icon: const Icon(Icons.check_circle_rounded, color: Colors.green)
                                                  )else IconButton(
                                                      onPressed:  () => context.read<PriceFormCubit>().activate(file.id),
                                                      icon: const Icon(Icons.remove_circle_outline, color: Colors.red)
                                                  )

                                                ],
                                              );
                                            }).toList(),
                                          ),
                                          ElevatedButtonApp(
                                            text: 'Добавить прайс',
                                            onPressed: context.read<PriceFormCubit>().addPrice,
                                          ),
                                        ],
                                      );
                                    },
                                    listener: (context, state) {
                                      if(state.error != null) {
                                        showErrorSnackBar(context, state.error!.messages[0]);
                                      }
                                    }
                                ),
                                // SubTitleApp(LocaleKeys.Price_lists.tr(), textAlign: TextAlign.start,),
                                // SizedBox(height: 10,),
                                // if(state.isUpdatePrice) ...[
                                //   PriceMultiPicker(controller: _priceController, files: store.prices!,),
                                //   ElevatedButtonApp(
                                //     text: 'Сохранить',
                                //     onPressed: context.read<ProfileScreenCubit>().hoverChangePrice,
                                //   ),
                                // ] else ...[
                                //   if(store.prices!.isNotEmpty) FileDownloadList(files: store.prices!)
                                //   else Text('Прайс-лист пустой'),
                                //   ElevatedButtonApp(
                                //     text: 'Изменить',
                                //     onPressed: context.read<ProfileScreenCubit>().hoverChangePrice,
                                //   ),
                                // ],

                                const SizedBox(height: 20,),
                                const Divider(thickness: 1),
                              ]
                            ],
                          );
                        } else if(state.status == ProfileScreenStatus.notAuth) {
                          return const AuthMessage();
                        } else if(state.status == ProfileScreenStatus.loading) {
                          return const Loader();
                        } else if(state.status == ProfileScreenStatus.notAuth) {
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
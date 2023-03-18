import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:megaladon/data/models/executor_model.dart';
import 'package:megaladon/data/models/store_model.dart';
import 'package:megaladon/data/models/user_model.dart';
import 'package:megaladon/generated/locale_keys.g.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';
import 'package:megaladon/presentation/widgets/list/file_download_list.dart';
import 'package:megaladon/presentation/widgets/message/auth_message.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';
import 'package:megaladon/presentation/widgets/tiles/contact_tile.dart';
import 'package:megaladon/presentation/widgets/tiles/data_tile.dart';

class ProfileScreen extends StatefulWidget {

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future _fetch() async {
    final state = context.read<AuthBloc>().state;
    if(state is AuthLoginState) {
      return await context.read<ProfileScreenCubit>().fetch(id: state.auth.user.value!.id);
    } else  {
      return await context.read<ProfileScreenCubit>().fetch(id: 0);
    }
  }

  @override
  void initState() {
    _fetch();
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
                  child: HeaderAppBar(isMenu: true, title: 'Профиль'),
                ),
              )
            ];
          },
          body: RefreshIndicator(
            onRefresh: _fetch,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
                      builder: (context, state) {
                        if(state is ProfileScreenSuccess) {
                          UserModel user = state.user;
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

                              SizedBox(height: 20,),
                              DataTile(title: LocaleKeys.Name.tr(), data: user.name),
                              if(user.phone != null) DataTile(title: LocaleKeys.Telephone.tr() , data: user.phone!),
                              if(user.city != null) DataTile(title: LocaleKeys.Location.tr(), data: 'г.${user.city?.name ?? ''}'),
                              Divider(thickness: 1),
                              if(executor != null) ...[
                                TitleApp(LocaleKeys.Artist_data.tr()),
                                SizedBox(height: 20,),
                                DataTile(title: LocaleKeys.Organization.tr(), data: executor.name),
                                DataTile(title: 'БИН', data: executor.bin!),
                                DataTile(title: 'Рейтинг', data: executor.rating ?? '0'),
                                if(executor.fullAddress != null) DataTile(title: LocaleKeys.Address, data: executor.fullAddress!),
                                if(executor.countOrders != null) DataTile(title: 'Количество заказов', data: executor.countOrders.toString()),
                                Divider(thickness: 1),
                              ],
                              if(store != null) ...[
                                TitleApp(LocaleKeys.Store_data.tr()),
                                SizedBox(height: 20,),
                                if(store.name != null) DataTile(title: LocaleKeys.Organization.tr(), data: '${store.type?.name ?? ''} "${store.name!}"'),
                                DataTile(title: LocaleKeys.Address, data: store.fullAddress),
                                DataTile(title: 'Рейтинг', data: store.rating ?? '0'),
                                if(store.bin != null) DataTile(title: 'БИН', data: store.bin.toString()),
                                if(store.city != null) DataTile(title: 'Город', data: store.city!.name),
                                if(store.contacts != null) ...store.contacts!.map((e) {
                                  return ContactTile(contact: e);
                                }).toList(),
                                SizedBox(height: 20,),
                                SubTitleApp(LocaleKeys.Price_lists.tr(), textAlign: TextAlign.start,),
                                SizedBox(height: 10,),
                                FileDownloadList(),
                                SizedBox(height: 20,),
                                Divider(thickness: 1),
                              ]
                            ],
                          );
                        } else if(state is ProfileScreenUnauthorization) {
                          return const AuthMessage();
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
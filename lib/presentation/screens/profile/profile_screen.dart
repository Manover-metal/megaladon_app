import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/executor_model.dart';
import 'package:megaladon/data/models/store_model.dart';
import 'package:megaladon/data/models/user_model.dart';
import 'package:megaladon/generated/locale_keys.g.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/presentation/widgets/list/file_download_list.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';
import 'package:megaladon/presentation/widgets/tiles/data_tile.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                HeaderAppBar(isMenu: true),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if(state is AuthLoginState) {
                      UserModel user = state.auth.user.value!;
                      ExecutorModel? executor = state.auth.executor.value;
                      StoreModel? store = state.auth.store.value;

                      return Column(
                        children: [
                          CircleAvatar(
                            radius: MediaQuery.of(context).size.width / 6,
                            backgroundColor: Colors.grey.shade300,
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
                            if(executor.fullAddress != null) DataTile(title: LocaleKeys.Address, data: executor.fullAddress!),
                            Divider(thickness: 1),
                          ],
                          if(store != null) ...[
                            TitleApp(LocaleKeys.Store_data.tr()),
                            SizedBox(height: 20,),
                            if(store.name != null) DataTile(title: LocaleKeys.Organization.tr(), data: store.name!),
                            DataTile(title: LocaleKeys.Address, data: store.fullAddress),
                            if(store.city != null) DataTile(title: 'Город', data: store.city!.name),

                            Divider(thickness: 1),
                          ]
                        ],
                      );
                    }else {
                      return Container();
                    }
                  },
                ),

                // DataTile(title: LocaleKeys.Email.tr(), data: 'mailto@mail.ru'),
                // DataTile(title: LocaleKeys.Telephone.tr(), data: '+7 (123) 456-78-91'),
                // DataTile(title: LocaleKeys.Website.tr(), data: 'steel-astana.kz'),
                SizedBox(height: 20,),
                SubTitleApp(LocaleKeys.Price_lists.tr(), textAlign: TextAlign.start,),
                SizedBox(height: 10,),
                FileDownloadList(),
                SizedBox(height: 20,),

              ],
            ),
          ),
        ),
      ),
    );
  }

}
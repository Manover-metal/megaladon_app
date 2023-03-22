import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/tiles/drawer_route_tile.dart';
import 'package:megaladon/presentation/widgets/tiles/drawer_tile.dart';

class DrawerProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
          builder: (context, state) {
            return Column(
              children: [
                const SizedBox(height: 20,),
                if(state.user != null) ...[
                   DrawerRouteTile(text: 'Change_phone_number'.tr(), page: ChangePhoneStartRoute()),

                   DrawerRouteTile(text: 'Change_password'.tr(), page: ChangePasswordRoute()),
                ],
                if(state.executor != null) ...[
                  const DrawerRouteTile(text: 'change_executor', page: InitialRouter(
                      children: [
                        ProfileRouter(
                          children: [
                            ChangeExecutorRoute()
                          ]
                        )
                      ]
                    )
                  ),
                ],
                if(state.store != null) ...[
                  const DrawerRouteTile(text: 'change_store', page: InitialRouter(
                      children: [
                        ProfileRouter(
                            children: [
                              ChangeStoreRoute()
                            ]
                        )
                      ]
                  )
                  ),
                ]
              ],
            );
          },
        ),
      ),
    );
  }

}
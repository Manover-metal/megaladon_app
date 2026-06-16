import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/tiles/drawer_route_tile.dart';

class DrawerProfile extends StatelessWidget {
  const DrawerProfile({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
        child: SafeArea(
          child: BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
            builder: (context, state) => Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                if (state.user != null) ...[
                  DrawerRouteTile(
                      text: AppLocalizations.of(context)!.change_phone_number,
                      page: const ChangePhoneStartRoute()),
                  DrawerRouteTile(
                      text: AppLocalizations.of(context)!.change_password,
                      page: const ChangePasswordRoute()),
                ],
                if (state.user?.executor != null) ...[
                  DrawerRouteTile(
                      text: AppLocalizations.of(context)!.change_executor,
                      page: const InitialRouter(children: [
                        ProfileRouter(children: [ChangeExecutorRoute()])
                      ])),
                ],
                if (state.user?.store != null) ...[
                  DrawerRouteTile(
                      text: AppLocalizations.of(context)!.change_store,
                      page: const InitialRouter(children: [
                        ProfileRouter(children: [ChangeStoreRoute()])
                      ])),
                ]
              ],
            ),
          ),
        ),
      );
}

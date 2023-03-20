import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';
import 'package:megaladon/presentation/widgets/tiles/drawer_tile.dart';

class DrawerProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
            builder: (context, state) {
              return Column(
                children: [
                  if(state.user != null) ...[
                    DrawerTile(text: 'Изменить номер телефона', callback: () {}),
                    DrawerTile(text: 'Изменить пароль', callback: () {}),
                  ],
                  if(state.executor != null) ...[
                    DrawerTile(text: 'Изменить исполнителя', callback: () {}),
                  ],
                  if(state.store != null) ...[
                    DrawerTile(text: 'Изменить магазин', callback: () {}),
                  ]
                ],
              );
            },
          ),
        ),
      ),
    );
  }

}
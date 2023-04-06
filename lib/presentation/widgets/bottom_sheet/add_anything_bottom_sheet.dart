import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/dictionary/advert_type.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/message/auth_message.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class AddAnythingBottomSheet extends StatelessWidget {
  const AddAnythingBottomSheet({super.key});


  _createAdvert(BuildContext context, AdvertType type) => () {
    context.router.navigate(CreateAdRoute(type: type));
  };

  _createOrder(BuildContext context) => () {
    context.router.navigate(const CreateOrderRoute());
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if(state is AuthLoginState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                 TitleApp('create'.tr()),
                const Divider(thickness: 1,height: 20,),
                BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return Visibility(
                        visible: state is AuthLoginState && state.auth.executor.value != null,
                        child: Column(
                          children: [
                            ElevatedButtonApp(
                              text: 'Ad'.tr(),
                              onPressed: _createAdvert(context, AdvertType.advert),
                            ),
                            ElevatedButtonApp(
                              text: 'Service'.tr(),
                              onPressed: _createAdvert(context, AdvertType.service),
                            ),
                          ]
                        ),
                      );
                      return Container();
                    }
                ),
                ElevatedButtonApp(
                  text: 'Order2'.tr(),
                  onPressed: _createOrder(context),
                ),
                const SizedBox(height: 30,),
              ],
            );
          } else {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AuthMessage(continueText: 'to_create_an_ad_or_order'.tr(),),
              ],
            );
          }
        },
      ),
    );
  }

}
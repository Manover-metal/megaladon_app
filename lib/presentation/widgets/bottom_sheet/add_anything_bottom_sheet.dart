import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/dictionary/advert_type.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/message/auth_message.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class AddAnythingBottomSheet extends StatelessWidget {
  const AddAnythingBottomSheet({super.key});

  Null Function() _createAdvert(BuildContext context, AdvertType type) => () {
        context.router.navigate(CreateAdRoute(type: type));
      };

  Null Function() _createOrder(BuildContext context) => () {
        context.router.navigate(const CreateOrderRoute());
      };

  @override
  Widget build(BuildContext context) => Container(
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoginState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TitleApp(AppLocalizations.of(context)!.create),
                  const Divider(
                    thickness: 1,
                    height: 20,
                  ),
                  BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                    return Visibility(
                      visible: state is AuthLoginState &&
                          state.auth.executor.value != null,
                      child: ElevatedButtonApp(
                        text: AppLocalizations.of(context)!.service,
                        onPressed: _createAdvert(context, AdvertType.service),
                      ),
                    );
                    return Container();
                  }),
                  ElevatedButtonApp(
                    text: AppLocalizations.of(context)!.ad,
                    onPressed: _createAdvert(context, AdvertType.advert),
                  ),
                  ElevatedButtonApp(
                    text: AppLocalizations.of(context)!.order2,
                    onPressed: _createOrder(context),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              );
            } else {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AuthMessage(
                    continueText:
                        AppLocalizations.of(context)!.to_create_an_ad_or_order,
                  ),
                ],
              );
            }
          },
        ),
      );
}

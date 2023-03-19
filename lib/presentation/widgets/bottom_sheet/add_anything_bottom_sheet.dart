import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/message/auth_message.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class AddAnythingBottomSheet extends StatelessWidget {
  const AddAnythingBottomSheet({super.key});


  _createAdvert(BuildContext context) => () {
    context.router.navigate(const CreateAdRoute());
  };

  _createOrder(BuildContext context) => () {
    context.router.navigate(const CreateOrderRoute());
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Theme.of(context).colorScheme.background,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if(state is AuthLoginState) {
              return Column(
                children: [
                  TitleApp('Создать'),
                  const Divider(thickness: 1,height: 20,),
                  ElevatedButtonApp(
                    text: 'Объявление',
                    onPressed: _createAdvert(context),
                  ),
                  ElevatedButtonApp(
                    text: 'Заказ',
                    onPressed: _createOrder(context),
                  ),
                  const SizedBox(height: 30,),
                ],
              );
            } else {
              return const AuthMessage(continueText: ', чтобы создать объявление или заказ',);
            }
          },
        ),
      ),
    );
  }

}
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class AddAnythingBottomSheet extends StatelessWidget {

  _createAdvert(BuildContext context) => () {
    context.router.navigate(const CreateAdRoute());
  };

  _createOrder(BuildContext context) => () {
    context.router.navigate(const CreateOrderRoute());
  };

  _login(BuildContext context) => () {
    context.router.navigate(const LoginRoute());
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Theme.of(context).colorScheme.background,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if(state is AuthLoginState) {
              return Column(
                children: [
                  TitleApp('Создать'),
                  Divider(thickness: 1,height: 20,),
                  ElevatedButtonApp(
                    text: 'Объявление',
                    onPressed: _createAdvert(context),
                  ),
                  ElevatedButtonApp(
                    text: 'Заказ',
                    onPressed: _createOrder(context),
                  ),
                  SizedBox(height: 30,),
                ],
              );
            } else {
              return Column(
                children: [
                  Text('Авторизация',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white
                      )
                  ),
                  Text('Вам нужно авторизоваться в приложение, чтобы создать объявление или заказ',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10,),
                  ElevatedButtonApp(
                    onPressed: _login(context),
                    text: 'Продолжить',
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }

}
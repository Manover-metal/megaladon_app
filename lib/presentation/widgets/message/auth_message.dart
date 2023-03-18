import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';

class AuthMessage extends StatelessWidget {

  final String? continueText;

  const AuthMessage({super.key, this.continueText});

  _login(BuildContext context) => () {
    context.router.navigate(const LoginRoute());
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Авторизация',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white
            )
        ),
        Text('Вам нужно авторизоваться в приложение${continueText ?? ''}',
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

}
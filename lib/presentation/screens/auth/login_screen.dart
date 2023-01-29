import 'package:flutter/material.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/text_field.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Авторизация',
                  textAlign: TextAlign.center,
                ),
                TextFieldApp(),
                TextFieldApp(),
                Text('забыли пароль'),
                ElevatedButtonApp(text: 'Войти'),
                OutlinedButtonApp(text: 'Регистрация')
              ],
            ),
          ),
        ),
      ),
    );
  }

}
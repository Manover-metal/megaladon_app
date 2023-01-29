import 'package:flutter/material.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/text_field.dart';

class RegisterUserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text('Регистрация',),
                TextFieldApp(),
                TextFieldApp(),
                ElevatedButtonApp(text: 'Продолжить'),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'Нажимая на кнопку “Продолжить”, вы принимаете '),
                      TextSpan(text: 'Условия пользовательского соглашения',
                        style: TextStyle(

                        )
                      )
                    ]
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}
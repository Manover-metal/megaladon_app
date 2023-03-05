// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class RegisterExecutorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
            
                TitleApp('Регистрация исполнителя'),
                SizedBox(height: 20,),
                TextFieldApp(),
                TextFieldApp(),
                TextFieldApp(),
                TextFieldApp(),
                ElevatedButtonApp(text: 'Продолжить'),
                Text.rich(
                    TextSpan(
                        // ignore: prefer_const_literals_to_create_immutables
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
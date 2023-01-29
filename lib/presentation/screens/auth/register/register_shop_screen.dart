import 'package:flutter/material.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/form/text_field.dart';

class RegisterShopScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text('Регистрация исполнителя',),
                TextFieldApp(),
                TextFieldApp(),
                TextFieldApp(),
                TextFieldApp(),

                Text('Контактная информация',),
                TextFieldApp(),
                TextFieldApp(),
                TextFieldApp(),
                TextFieldApp(),
                TextFieldApp(),
                TextFieldApp(),

                Divider(),
                TextFieldApp(),
                TextFieldApp(),
                TextFieldApp(),
                OutlinedButtonApp(text: 'Добавить контактное лицо'),

                Text('Прайс листы',),
                Row(
                  children: [
                    Expanded(
                      child: Text('Прайс-лист на изделия....xls (5,2 Мб)'),
                    ),
                    Icon(Icons.delete_outline)
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text('Прайс-лист на изделия....xls (5,2 Мб)'),
                    ),
                    Icon(Icons.delete_outline)
                  ],
                ),
                OutlinedButtonApp(text: 'Добавить прайс-лист'),



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
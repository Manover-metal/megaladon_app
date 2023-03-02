import 'package:flutter/material.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/list/file_delete_list.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class RegisterStoreScreen extends StatelessWidget {
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

                TitleApp('Контактная информация'),
                SizedBox(height: 20,),
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

                TitleApp('Прайс листы'),
                SizedBox(height: 20,),
                FileDeleteList(),
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
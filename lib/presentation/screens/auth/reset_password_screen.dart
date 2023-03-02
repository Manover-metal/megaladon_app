import 'package:flutter/material.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class ResetPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                TitleApp('Изменить пароль'),
                SizedBox(height: 20,),
                TextFieldApp(),
                ElevatedButtonApp(text: 'Изменить'),
                OutlinedButtonApp(text: 'Отмена')
              ],
            ),
          ),
        ),
      ),
    );
  }

}
import 'package:flutter/material.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class VerifyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                TitleApp('Регистрация'),
                SizedBox(height: 20,),
                Text('Введите 6-ти значный код из смс'),
                ElevatedButtonApp(text: 'Подтвердить'),
                OutlinedButtonApp(text: 'Выслать код повторно')
              ],
            ),
          ),
        ),
      ),
    );
  }

}
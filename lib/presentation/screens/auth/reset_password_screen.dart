import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TitleApp("Change_password".tr()),
                const SizedBox(height: 20,),
                const TextFieldApp(),
                ElevatedButtonApp(text: "Изменить".tr()),
                OutlinedButtonApp(text: "Cancel".tr())
              ],
            ),
          ),
        ),
      ),
    );
  }

}
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // aad tr()
                TitleApp("Password_recovery".tr()),
                const SizedBox(height: 20,),
                const TextFieldApp(),
                ElevatedButtonApp(text: "Send_password".tr()),
                OutlinedButtonApp(text: "Cancel".tr())
              ],
            ),
          ),
        ),
      ),
    );
  }

}
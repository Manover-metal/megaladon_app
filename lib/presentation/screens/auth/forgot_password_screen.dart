import 'package:flutter/material.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // aad tr()
                  TitleApp(AppLocalizations.of(context)!.password_recovery),
                  const SizedBox(
                    height: 20,
                  ),
                  const TextFieldApp(),
                  ElevatedButtonApp(
                      text: AppLocalizations.of(context)!.send_password),
                  OutlinedButtonApp(text: AppLocalizations.of(context)!.cancel)
                ],
              ),
            ),
          ),
        ),
      );
}

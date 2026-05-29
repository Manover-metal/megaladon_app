import 'package:flutter/material.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TitleApp(AppLocalizations.of(context)!.change_password),
                  const SizedBox(
                    height: 20,
                  ),
                  const TextFieldApp(),
                  ElevatedButtonApp(text: AppLocalizations.of(context)!.edit),
                  OutlinedButtonApp(text: AppLocalizations.of(context)!.cancel)
                ],
              ),
            ),
          ),
        ),
      );
}

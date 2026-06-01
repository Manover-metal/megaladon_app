import 'package:flutter/material.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: HeaderAppBar(
            isBack: true,
            title: AppLocalizations.of(context)!.about_the_application),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Text(AppLocalizations.of(context)!.aboutText),
          ),
        ),
      );
}

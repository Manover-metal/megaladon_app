import 'package:flutter/material.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: NestedScrollView(
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Text(AppLocalizations.of(context)!.aboutText),
              ),
            ),
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: HeaderAppBar(
                    isBack: true,
                    title: AppLocalizations.of(context)!.about_the_application),
              ))
            ],
          ),
        ),
      );
}

import 'package:flutter/material.dart';

class TitleApp extends StatelessWidget {
  const TitleApp(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge,
        textAlign: TextAlign.center,
      );
}

class SubTitleApp extends StatelessWidget {
  const SubTitleApp(this.text, {super.key, this.textAlign = TextAlign.center});
  final String text;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 20,
            ),
        textAlign: textAlign,
      );
}

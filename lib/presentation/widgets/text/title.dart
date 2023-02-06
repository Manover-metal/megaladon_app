import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TitleApp extends StatelessWidget {
  final String text;

  TitleApp(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: Theme.of(context).textTheme.bodyLarge,
      textAlign: TextAlign.center,

    );
  }
}

class SubTitleApp extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  SubTitleApp(this.text, {super.key, this.textAlign = TextAlign.center});

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 20,
      ),
      textAlign: textAlign,
    );
  }
}
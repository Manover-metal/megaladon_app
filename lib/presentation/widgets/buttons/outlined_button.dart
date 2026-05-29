import 'package:flutter/material.dart';

class OutlinedButtonApp extends StatelessWidget {
  const OutlinedButtonApp({super.key, this.onPressed, this.child, this.text});
  final VoidCallback? onPressed;
  final Widget? child;
  final String? text;

  Widget? _getText() {
    if (text != null) {
      return Text(text!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => OutlinedButton(
      onPressed: onPressed,
      child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          child: (child != null) ? child : _getText()));
}

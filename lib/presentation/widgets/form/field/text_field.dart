import 'package:flutter/material.dart';

class TextFieldApp extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final Widget? icon;

  const TextFieldApp({super.key, this.controller, this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          icon: icon,
          labelText: label,
          labelStyle: const TextStyle(
              fontSize: 18
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10)
        ),
      ),
    );
  }

}
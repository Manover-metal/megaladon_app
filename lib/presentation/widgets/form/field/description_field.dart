import 'package:flutter/material.dart';

class DescriptionFieldApp extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final Widget? icon;

  const DescriptionFieldApp({super.key, this.controller, this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        maxLines: 5,
        controller: controller,
        decoration: InputDecoration(
            icon: icon,
            labelText: label,
            labelStyle: const TextStyle(
                fontSize: 18
            ),
            alignLabelWithHint: true,

            contentPadding: const EdgeInsets.symmetric(horizontal: 10)
        ),
      ),
    );
  }

}
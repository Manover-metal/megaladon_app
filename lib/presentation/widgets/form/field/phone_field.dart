import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PhoneField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final Widget? icon;

  final maskFormatter = MaskTextInputFormatter(
      mask: '+7##########',
      filter: { "#": RegExp(r'[0-9]') },
      type: MaskAutoCompletionType.lazy
  );

  PhoneField({super.key, this.controller, this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),

      child: TextField(
        controller: controller,
        inputFormatters: [maskFormatter],
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
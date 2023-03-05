import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ExpiredAtFieldApp extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final Widget? icon;

  MaskTextInputFormatter maskFormatter = MaskTextInputFormatter(mask: '####-##-##', filter: { "#": RegExp(r'[0-9]') });

  ExpiredAtFieldApp({super.key, this.controller, this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: controller,
        inputFormatters: [
          maskFormatter
        ],
        decoration: InputDecoration(
            icon: icon,
            labelText: label,

            hintText: '2022-12-31',
            labelStyle: TextStyle(
                fontSize: 18
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 10)
        ),
      ),
    );
  }

}
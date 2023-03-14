import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DoubleFieldApp extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final Widget? icon;

  const DoubleFieldApp({super.key, this.controller, this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: TextField(
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'(\d|\.)'))
        ],
        keyboardType: TextInputType.number,
        controller: controller,
        decoration: InputDecoration(
            icon: icon,
            labelText: label,
            contentPadding: EdgeInsets.symmetric(horizontal: 10)
        ),
      ),
    );
  }

}
import 'package:flutter/material.dart';

class PasswordFieldApp extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final Widget? icon;

  const PasswordFieldApp({super.key, this.controller, this.label, this.icon});

  @override
  State<PasswordFieldApp> createState() => _PasswordFieldAppState();
}

class _PasswordFieldAppState extends State<PasswordFieldApp> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextField(
        controller: widget.controller,
        obscureText: _obscure,
        decoration: InputDecoration(
          icon: widget.icon,
          labelText: widget.label,
          labelStyle: const TextStyle(fontSize: 18),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          suffixIcon: IconButton(
            icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _obscure = !_obscure),
          ),
        ),
      ),
    );
  }
}

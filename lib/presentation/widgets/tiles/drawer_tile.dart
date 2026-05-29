import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile({required this.text, required this.callback, super.key});
  final String text;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: callback,
        child: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Text(text),
        ),
      );
}

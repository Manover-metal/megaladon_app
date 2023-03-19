import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  const DrawerTile({super.key, required this.text, required this.callback});


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(text),
      ),
    );
  }

}
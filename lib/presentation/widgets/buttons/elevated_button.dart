import 'package:flutter/material.dart';

class ElevatedButtonApp extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  final String? text;

  ElevatedButtonApp({this.onPressed, this.child, this.text});

  Widget? _getText() {
    if(text != null) {
      return Text(text!, textAlign: TextAlign.center,
        // style: TextStyle(
        //   fontSize: 25
        // ),
      );
    }
    return null;
  }


  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            child: (child != null) ? child
                : _getText()
        )
    );
  }
}
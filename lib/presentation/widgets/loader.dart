import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final double padding;
  final Color? color;
  const Loader({super.key, this.padding = 0, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      child: Center(
        child: CupertinoActivityIndicator(
          radius: 15,
          color: color ?? Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }

}
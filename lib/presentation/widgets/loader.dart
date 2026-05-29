import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key, this.padding = 0, this.color});
  final double padding;
  final Color? color;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(padding),
        child: Center(
          child: CupertinoActivityIndicator(
            radius: 15,
            color: color ?? Theme.of(context).colorScheme.secondary,
          ),
        ),
      );
}

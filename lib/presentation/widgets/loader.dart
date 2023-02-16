import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final double padding;

  const Loader({super.key, this.padding = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 4,
          color: Theme.of(context).colorScheme.background,
        ),
      ),
    );
  }

}
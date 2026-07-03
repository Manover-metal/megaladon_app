import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({required this.rate, this.size = 18, super.key});

  final double rate;
  final double size;

  @override
  Widget build(BuildContext context) {
    final rounded = rate.round();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (i) => Icon(
          i < rounded ? Icons.star : Icons.star_border,
          size: size,
          color: Colors.amber,
        ),
      ),
    );
  }
}

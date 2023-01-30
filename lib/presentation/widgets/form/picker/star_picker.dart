import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StarPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Рейтинг: '),
        Row(
          children: List.generate(5, (index) {
              return Icon(Icons.star_rate_rounded);
            }
          ),
        )
      ],
    );
  }

}
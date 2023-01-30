import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FileDeleteList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(2, (index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Прайс-лист на изделия....xls (5,2 Мб)'),
            Icon(Icons.delete_outline,
              color: Colors.red,
            )
          ],
        );
      }),
    );
  }

}
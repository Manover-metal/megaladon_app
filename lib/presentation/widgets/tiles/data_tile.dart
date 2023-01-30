import 'package:flutter/cupertino.dart';

class DataTile extends StatelessWidget {
  final String title;
  final String data;

  const DataTile({super.key, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(title),
        Expanded(
          child: Text(data),
        )
      ],
    );
  }

}
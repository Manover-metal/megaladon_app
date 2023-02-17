import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DataTile extends StatelessWidget {
  final String title;
  final String data;

  const DataTile({super.key, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 18
              ),
            ),
          ),
          Expanded(
            child: Text(data,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 18
              ),
            ),

          )
        ],
      ),
    );
  }

}
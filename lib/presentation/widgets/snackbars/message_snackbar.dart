import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showMessageSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      margin: EdgeInsets.all(20),
      behavior: SnackBarBehavior.floating,
      elevation: 40,
      backgroundColor: Theme.of(context).colorScheme.background,
      duration: Duration(seconds: 5),
      content: Row(
        children: [
          Icon(
            Icons.message,
          ),
          SizedBox(width: 15,),
          Expanded(
            child: Text(message,
              style: Theme.of(context).textTheme.titleSmall
            ),
          ),
        ],
      )
  )
  );
}
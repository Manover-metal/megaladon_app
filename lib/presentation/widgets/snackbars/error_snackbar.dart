import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showErrorSnackBar(BuildContext context, String error) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      margin: EdgeInsets.all(20),
      behavior: SnackBarBehavior.floating,
      elevation: 40,
      backgroundColor: Theme.of(context).colorScheme.background,
      duration: Duration(seconds: 20),
      content: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.error,
          ),
          SizedBox(width: 15,),
          Expanded(
            child: Text(error,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.error
              ),
            ),
          ),
        ],
      )
    )
  );
}
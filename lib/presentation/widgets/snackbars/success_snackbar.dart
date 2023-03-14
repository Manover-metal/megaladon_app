import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/core/themes/dark.dart';

showSuccessSnackBar(BuildContext context, String success) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      margin: EdgeInsets.all(20),
      behavior: SnackBarBehavior.floating,
      elevation: 40,
      backgroundColor: Theme.of(context).colorScheme.background,
      duration: Duration(seconds: 5),
      content: Row(
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: ColorSchemeApp.success.color
          ),
          SizedBox(width: 15,),
          Expanded(
            child: Text(success,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: ColorSchemeApp.success.color
              ),
            ),
          ),
        ],
      )
  )
  );
}
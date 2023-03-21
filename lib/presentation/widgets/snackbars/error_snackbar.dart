import 'package:flutter/material.dart';

showErrorSnackBar(BuildContext context, String error) {
  ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(
      margin: const EdgeInsets.all(20),
      behavior: SnackBarBehavior.floating,
      elevation: 40,
      backgroundColor: Theme.of(context).colorScheme.background,
      duration: const Duration(seconds: 20),
      content: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: 15,),
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
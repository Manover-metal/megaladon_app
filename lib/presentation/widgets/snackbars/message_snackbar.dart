import 'package:flutter/material.dart';

void showMessageSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
        margin: const EdgeInsets.all(20),
        behavior: SnackBarBehavior.floating,
        elevation: 40,
        backgroundColor: Theme.of(context).colorScheme.surface,
        duration: const Duration(seconds: 5),
        content: Row(
          children: [
            const Icon(
              Icons.message,
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child:
                  Text(message, style: Theme.of(context).textTheme.titleSmall),
            ),
          ],
        )));
}

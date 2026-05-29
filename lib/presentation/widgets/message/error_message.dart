import 'package:flutter/cupertino.dart';
import 'package:megaladon/data/models/error_model.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({required this.error, super.key});
  final ErrorModel error;

  @override
  Widget build(BuildContext context) => Column(
        children: error.messages
            .map((e) => Text(
                  e,
                  textAlign: TextAlign.center,
                ))
            .toList(),
      );
}

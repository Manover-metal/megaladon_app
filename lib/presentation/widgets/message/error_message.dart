import 'package:flutter/cupertino.dart';
import 'package:megaladon/data/models/error_model.dart';

class ErrorMessage extends StatelessWidget {
  final ErrorModel error;

  const ErrorMessage({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: error.messages.map((e) {
        return Text(e, textAlign: TextAlign.center,);
      }).toList(),
    );
  }

}
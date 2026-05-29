import 'package:flutter/material.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

class StarPickerController extends ValueNotifier<int> {
  StarPickerController({int value = 3}) : super(value);

  void _change(int index) {
    value = index;
    notifyListeners();
  }
}

class StarPicker extends StatelessWidget {
  const StarPicker({required this.controller, super.key});
  final StarPickerController controller;

  Null Function() _change(int index) => () {
        controller._change(index);
      };

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Text(AppLocalizations.of(context)!.rating2),
          ValueListenableBuilder(
            builder: (context, value, child) => Row(
              children: List.generate(
                  5,
                  (index) => GestureDetector(
                        onTap: _change(index + 1),
                        child: Icon(
                          Icons.star_rate_rounded,
                          color: (value >= index + 1)
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.secondary,
                          size: MediaQuery.of(context).size.width / 10,
                        ),
                      )),
            ),
            valueListenable: controller,
          )
        ],
      );
}

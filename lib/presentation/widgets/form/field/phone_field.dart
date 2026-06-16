import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PhoneField extends StatelessWidget {
  PhoneField(
      {super.key, this.controller, this.label, this.icon, this.errorText});
  final TextEditingController? controller;
  final String? label;
  final Widget? icon;
  final String? errorText;

  late final phoneMaskFormatter = MaskTextInputFormatter(
    mask: '+7 (###) ###-##-##',
    filter: {'#': RegExp('[0-9]')},
    type: MaskAutoCompletionType.lazy,
    initialText: controller?.value.text,
  );

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label != null)
              Text(label!,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary)),
            if (label != null) const SizedBox(height: 5),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                border: Border.all(
                    color: errorText != null
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.primary,
                    width: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: controller,
                inputFormatters: [phoneMaskFormatter],
                keyboardType: TextInputType.phone,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            if (errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
                child: Text(
                  errorText!,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.error, fontSize: 12),
                ),
              ),
          ],
        ),
      );
}

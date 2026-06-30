import 'package:flutter/material.dart';

class TextFieldApp extends StatelessWidget {
  const TextFieldApp(
      {super.key,
      this.controller,
      this.label,
      this.icon,
      this.errorText,
      this.value,
      this.readOnly = false,
      this.hintText,
      this.onChanged});
  final TextEditingController? controller;
  final String? label;
  final Widget? icon;
  final String? errorText;
  final String? value;
  final bool readOnly;
  final String? hintText;
  final ValueChanged<String>? onChanged;

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
                // Рисуем меню выделения средствами Flutter, а не системное
                // SystemContextMenu (iOS) — оно роняет ассерт
                // "_currentConnection != null" при пересборке, когда input-
                // соединение уже закрыто.
                contextMenuBuilder: (context, editableTextState) =>
                    AdaptiveTextSelectionToolbar.editableText(
                  editableTextState: editableTextState,
                ),
                onTapOutside: (_) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                controller: controller ??
                    (value != null ? TextEditingController(text: value) : null),
                readOnly: readOnly,
                onChanged: onChanged,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  hintText: hintText,
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

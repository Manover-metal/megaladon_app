import 'package:flutter/material.dart';

class DescriptionFieldApp extends StatelessWidget {
  const DescriptionFieldApp(
      {super.key, this.controller, this.label, this.icon, this.errorText});
  final TextEditingController? controller;
  final String? label;
  final Widget? icon;
  final String? errorText;

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
                contextMenuBuilder: (context, editableTextState) =>
                    AdaptiveTextSelectionToolbar.editableText(
                  editableTextState: editableTextState,
                ),
                onTapOutside: (_) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                maxLines: 5,
                controller: controller,
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

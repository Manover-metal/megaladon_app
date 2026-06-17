import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DoubleFieldApp extends StatelessWidget {
  const DoubleFieldApp({super.key, this.controller, this.label, this.icon});
  final TextEditingController? controller;
  final String? label;
  final Widget? icon;

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
                    color: Theme.of(context).colorScheme.primary, width: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                onTapOutside: (_) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'(\d|\.)'))
                ],
                keyboardType: TextInputType.number,
                controller: controller,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
      );
}

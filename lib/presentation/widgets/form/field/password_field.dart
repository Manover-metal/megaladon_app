import 'package:flutter/material.dart';

class PasswordFieldApp extends StatefulWidget {
  const PasswordFieldApp(
      {super.key, this.controller, this.label, this.icon, this.errorText});
  final TextEditingController? controller;
  final String? label;
  final Widget? icon;
  final String? errorText;

  @override
  State<PasswordFieldApp> createState() => _PasswordFieldAppState();
}

class _PasswordFieldAppState extends State<PasswordFieldApp> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.label != null)
              Text(widget.label!,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary)),
            if (widget.label != null) const SizedBox(height: 5),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                border: Border.all(
                    color: widget.errorText != null
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.primary,
                    width: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onTapOutside: (_) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      controller: widget.controller,
                      obscureText: _obscure,
                      style: Theme.of(context).textTheme.bodyMedium,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                        color: Theme.of(context).colorScheme.secondary),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ],
              ),
            ),
            if (widget.errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
                child: Text(
                  widget.errorText!,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.error, fontSize: 12),
                ),
              ),
          ],
        ),
      );
}

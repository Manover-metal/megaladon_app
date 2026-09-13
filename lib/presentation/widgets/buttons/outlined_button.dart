import 'dart:async';

import 'package:flutter/material.dart';
import 'package:megaladon/presentation/widgets/loader.dart';

/// Второстепенная кнопка. Как и ElevatedButtonApp: если [onPressed]
/// возвращает Future, кнопка показывает крутилку и не принимает нажатий,
/// пока он не завершится, — без второго запроса и двойного перехода.
class OutlinedButtonApp extends StatefulWidget {
  const OutlinedButtonApp({super.key, this.onPressed, this.child, this.text});
  final FutureOr<void> Function()? onPressed;
  final Widget? child;
  final String? text;

  @override
  State<OutlinedButtonApp> createState() => _OutlinedButtonAppState();
}

class _OutlinedButtonAppState extends State<OutlinedButtonApp> {
  bool _busy = false;

  Future<void> _handle() async {
    if (_busy) return;
    final result = widget.onPressed?.call();
    if (result is! Future) return;

    setState(() => _busy = true);
    try {
      await result;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Widget? _content(BuildContext context) {
    if (_busy) {
      return Loader(color: Theme.of(context).colorScheme.primary);
    }
    if (widget.child != null) return widget.child;
    if (widget.text != null) {
      return Text(widget.text!, textAlign: TextAlign.center);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => OutlinedButton(
      onPressed: widget.onPressed == null ? null : (_busy ? () {} : _handle),
      child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          child: _content(context)));
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:megaladon/presentation/widgets/loader.dart';

/// Основная кнопка.
///
/// Если [onPressed] возвращает Future (запрос, переход после запроса), кнопка
/// сама показывает крутилку и не реагирует на нажатия, пока он не завершится:
/// второе нажатие не уходит вторым запросом и не открывает экран дважды.
/// Синхронный обработчик работает как раньше.
class ElevatedButtonApp extends StatefulWidget {
  const ElevatedButtonApp({super.key, this.onPressed, this.child, this.text});
  final FutureOr<void> Function()? onPressed;
  final Widget? child;
  final String? text;

  @override
  State<ElevatedButtonApp> createState() => _ElevatedButtonAppState();
}

class _ElevatedButtonAppState extends State<ElevatedButtonApp> {
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
      return Loader(color: Theme.of(context).colorScheme.surface);
    }
    if (widget.child != null) return widget.child;
    if (widget.text != null) {
      return Text(widget.text!, textAlign: TextAlign.center);
    }
    return null;
  }

  // Пока идёт запрос, кнопка остаётся «живой» на вид (как на экранах форм,
  // где вместо неё рисуют кнопку с Loader), но нажатия ничего не делают.
  @override
  Widget build(BuildContext context) => ElevatedButton(
      onPressed: widget.onPressed == null ? null : (_busy ? () {} : _handle),
      child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          child: _content(context)));
}

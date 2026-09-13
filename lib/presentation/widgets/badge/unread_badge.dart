import 'package:flutter/material.dart';

/// Счётчик непрочитанных сообщений. Пустеет сам: при [count] <= 0 схлопывается
/// в ноль ширины, поэтому вызывающему коду не нужен свой `if`.
class UnreadBadge extends StatelessWidget {
  const UnreadBadge({required this.count, super.key}) : _asDot = false;

  /// Точка без числа: когда «что-то изменилось» известно, а сколько — нет.
  /// [visible] == false схлопывает виджет так же, как нулевой счётчик.
  const UnreadBadge.dot({required bool visible, super.key})
      : count = visible ? 1 : 0,
        _asDot = true;

  final int count;

  final bool _asDot;

  /// Больше этого числа показываем «99+»: иначе бейдж расползается и ломает
  /// строку с именем собеседника.
  static const int _maxShown = 99;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    if (_asDot) {
      return Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          shape: BoxShape.circle,
        ),
      );
    }

    final label = count > _maxShown ? '$_maxShown+' : '$count';

    return Container(
      constraints: const BoxConstraints(minWidth: 22),
      height: 22,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          height: 1,
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onPrimary,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:megaladon/data/models/offer_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/widgets/form/field_style.dart';

/// Выбор «за всю работу» / «за шт.» под ценой отклика. Сегментный
/// переключатель в рамке поля ввода — внутри [FieldStyle] выглядит так же,
/// как соседние поля карточки.
class OfferPriceTypePicker extends StatelessWidget {
  const OfferPriceTypePicker({
    required this.value,
    required this.onChanged,
    this.label,
    super.key,
  });
  final OfferPriceType value;
  final ValueChanged<OfferPriceType> onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) ...[
            Text(
              label!,
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            const SizedBox(height: 5),
          ],
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: FieldStyle.fillOf(context),
              border: FieldStyle.borderOf(context, hasError: false),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                for (final type in OfferPriceType.values)
                  Expanded(
                    child: _Segment(
                      text: type.localize(l10n),
                      selected: type == value,
                      onTap: () => onChanged(type),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.text,
    required this.selected,
    required this.onTap,
  });
  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? scheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected
                  ? scheme.surface
                  : theme.textTheme.bodyMedium?.color,
            ),
          ),
        ),
      ),
    );
  }
}

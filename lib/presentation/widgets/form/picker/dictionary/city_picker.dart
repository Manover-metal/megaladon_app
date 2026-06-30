import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/dictionary/dictionary_cubit.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/city_selection_screen.dart';

class CityPickerController extends ValueNotifier<CityModel?> {
  CityPickerController({CityModel? city}) : super(city);

  void _changeCity(CityModel? city) {
    value = city;
    notifyListeners();
  }
}

class CityPicker extends StatefulWidget {
  const CityPicker(
      {required this.label,
      required this.controller,
      super.key,
      this.icon,
      this.errorText,
      this.withNull = false});
  final String label;
  final CityPickerController controller;
  final Widget? icon;
  final String? errorText;

  /// When true, the selection screen lets the user clear the city ("all").
  final bool withNull;

  @override
  State<CityPicker> createState() => _CityPickerState();
}

class _CityPickerState extends State<CityPicker> {
  // Защита от множественных нажатий: не открываем экран выбора повторно,
  // пока предыдущий ещё открыт. Иначе rapid-тапы пушат несколько экранов с
  // текстовым полем и ловим ассерт системного контекстного меню.
  bool _isOpening = false;

  Future<void> _handleClick() async {
    if (_isOpening) return;

    final cities = context.read<DictionaryCubit>().state.cities;
    if (cities.isEmpty) return;

    _isOpening = true;
    try {
      final result = await Navigator.of(context).push<CitySelectionResult>(
        MaterialPageRoute(
          builder: (_) => CitySelectionScreen(
            cities: cities,
            selected: widget.controller.value,
            withNull: widget.withNull,
          ),
        ),
      );

      if (result != null) {
        widget.controller._changeCity(result.city);
      }
    } finally {
      if (mounted) _isOpening = false;
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: ValueListenableBuilder(
          builder: (context, city, child) => GestureDetector(
            onTap: _handleClick,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                const SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    border: Border.all(
                      color: widget.errorText != null
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.primary,
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(city?.name ??
                              (widget.withNull
                                  ? AppLocalizations.of(context)!.all
                                  : ''))),
                      const Icon(Icons.keyboard_arrow_down_outlined),
                    ],
                  ),
                ),
                if (widget.errorText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 4),
                    child: Text(
                      widget.errorText!,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
          valueListenable: widget.controller,
        ),
      );
}

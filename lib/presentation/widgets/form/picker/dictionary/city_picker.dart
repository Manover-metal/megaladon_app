import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/logic/dictionary/dictionary_cubit.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/city_selection_screen.dart';

class CityPickerController extends ValueNotifier<CityModel?> {
  CityPickerController({CityModel? city}) : super(city);

  void _changeCity(CityModel city) {
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
      this.errorText});
  final String label;
  final CityPickerController controller;
  final Widget? icon;
  final String? errorText;

  @override
  State<CityPicker> createState() => _CityPickerState();
}

class _CityPickerState extends State<CityPicker> {
  Future<void> _handleClick() async {
    final cities = context.read<DictionaryCubit>().state.cities;

    if (cities.isEmpty) return;

    final result = await Navigator.of(context).push<CityModel>(
      MaterialPageRoute(
        builder: (_) => CitySelectionScreen(
          cities: cities,
          selected: widget.controller.value,
        ),
      ),
    );

    if (result != null) {
      widget.controller._changeCity(result);
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
                      Expanded(child: Text(city?.name ?? '')),
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

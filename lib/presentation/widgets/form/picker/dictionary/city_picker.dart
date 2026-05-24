import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/logic/dictionary/dictionary_cubit.dart';

class CityPickerController extends ValueNotifier<CityModel> {
  CityPickerController({CityModel? city}) : super(city ?? CityModel.nothing);

  void _changeCity(CityModel city) {
    print(city.id);
    print(city.name);
    value = city;
    notifyListeners();
  }
}

class CityPicker extends StatefulWidget {
  final String label;
  final CityPickerController controller;
  final Widget? icon;

  const CityPicker({super.key, required this.label, required this.controller, this.icon});

  @override
  State<CityPicker> createState() => _CityPickerState();
}

class _CityPickerState extends State<CityPicker> {
  _handleClick() async {
    final List<CityModel> cities =
        context.read<DictionaryCubit>().state.cities;

    if (cities.isEmpty) return;

    cities.forEach((c) => print(c.name));

    int initialIndex = cities.indexWhere((c) => c.id == widget.controller.value.id);
    if (initialIndex < 0) initialIndex = 0;

    int selectedIndex = initialIndex;

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height / 3.5 + 44,
        color: Colors.black,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: Text('Cancel'.tr()),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
                CupertinoButton(
                  child: Text('select'.tr()),
                  onPressed: () {
                    widget.controller._changeCity(cities[selectedIndex]);
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            ),
            Expanded(
              child: CupertinoPicker(
                scrollController:
                    FixedExtentScrollController(initialItem: initialIndex),
                itemExtent: 50,
                looping: true,
                onSelectedItemChanged: (index) => selectedIndex = index,
                children: cities.map((c) => Center(child: Text(c.name, style: const TextStyle(color: Colors.white)))).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ValueListenableBuilder(
        builder: (BuildContext context, CityModel city, Widget? child) {
          return GestureDetector(
            onTap: _handleClick,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                const SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text(city.name)),
                      const Icon(Icons.keyboard_arrow_down_outlined),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        valueListenable: widget.controller,
      ),
    );
  }
}

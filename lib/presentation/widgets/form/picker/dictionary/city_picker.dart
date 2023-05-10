
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/logic/dictionary/dictionary_cubit.dart';

Future<CityModel?> showCityPicker(BuildContext context) async {
  List<CityModel> cities = context.read<DictionaryCubit>().state.cities;

  final result = await Picker(
    itemExtent: 30,
    height: MediaQuery.of(context).size.height / 3.5,
    backgroundColor: Theme.of(context).colorScheme.background,
    adapter: PickerDataAdapter<CityModel>(
        data: [
          PickerItem<CityModel>(
              text: Text(CityModel.nothing.name),
              value: CityModel.nothing
          ),
          ...cities.map((city) {
            return PickerItem<CityModel>(
                text: Text(city.name),
                value: city
            );
          }).toList()
        ]
    ),
    changeToFirst: false,
    hideHeader: false,
    cancelText: 'Cancel'.tr(),
    confirmText: 'select'.tr(),
  ).showModal(context);

  if(result == null) return null;
  if(result[0] == 0) return CityModel.nothing;
  return cities[result[0] - 1];
}


class CityPickerController extends ValueNotifier<CityModel> {


  CityPickerController({CityModel? city}) : super(city ?? CityModel.nothing);



  void _changeCity(CityModel city) {
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
    CityModel? city = await showCityPicker(context);
    if (city != null) {
      widget.controller._changeCity(city);
    }
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
                Text(widget.label,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 0.5
                    ),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text(city.name)),
                      const Icon(Icons.keyboard_arrow_down_outlined)
                    ],
                  ),
                )
              ],
            ),
          );
        },
        valueListenable: widget.controller,
      ),
    );
  }
}
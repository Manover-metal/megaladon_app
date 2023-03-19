
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/logic/dictionary/dictionary_cubit.dart';

Future<List<int>?> showCityPicker(BuildContext context, List<CityModel> cities) async {
  return await Picker(
    itemExtent: 30,
    height: MediaQuery.of(context).size.height / 3.5,
    backgroundColor: Theme.of(context).colorScheme.background,
    adapter: PickerDataAdapter<CityModel>(
        data: cities.map((city) {
          return PickerItem<CityModel>(
              text: Text(city.name),
              value: city
          );
        }).toList()
    ),
    changeToFirst: false,
    hideHeader: false,
    cancelText: 'Отмена',
    confirmText: 'Выбрать',
  ).showModal(context);
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
  late TextEditingController _textController;

  _handleClick(BuildContext context) => () async {
    List<CityModel> cities = context.read<DictionaryCubit>().state.cities;

    List<int>? result = await showCityPicker(context, cities);
    try {
      if (result != null) {
        CityModel city = cities[result[0]];
        widget.controller._changeCity(city);
        _textController.value = TextEditingValue(text: city.name);
      }
    }catch(e) {}

    FocusManager.instance.primaryFocus?.unfocus();
  };

  @override
  void initState() {
    _textController = TextEditingController(text: widget.controller.value.name);
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ValueListenableBuilder(
        builder: (BuildContext context, CityModel city, Widget? child) {
          return TextField(
            controller: _textController,
            onTap: _handleClick(context),
            decoration: InputDecoration(
                icon: widget.icon,
                labelText: widget.label,
                labelStyle: const TextStyle(
                    fontSize: 18
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10)

            ),
          );
        },
        valueListenable: widget.controller,
      ),
    );
  }
}
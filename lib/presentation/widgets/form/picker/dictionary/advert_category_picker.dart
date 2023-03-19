import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:megaladon/data/models/dictionary/advert_category_model.dart';
import 'package:megaladon/logic/dictionary/dictionary_cubit.dart';

Future<List<int>?> showAdvertCategoryPicker(BuildContext context, List<AdvertCategoryModel> cities) async {
  return await Picker(
    itemExtent: 30,
    height: MediaQuery.of(context).size.height / 3.5,
    backgroundColor: Theme.of(context).colorScheme.background,
    adapter: PickerDataAdapter<AdvertCategoryModel>(
        data: cities.map((advertCategory) {
          return PickerItem<AdvertCategoryModel>(
              text: Text(advertCategory.name),
              value: advertCategory
          );
        }).toList()
    ),
    changeToFirst: false,
    hideHeader: false,
    cancelText: 'Отмена',
    confirmText: 'Выбрать',
  ).showModal(context);
}


class AdvertCategoryPickerController extends ValueNotifier<AdvertCategoryModel> {


  AdvertCategoryPickerController({ AdvertCategoryModel? category}) : super(category ?? AdvertCategoryModel.nothing);



  void _changeAdvertCategory(AdvertCategoryModel category) {
    value = category;
    notifyListeners();
  }
}

class AdvertCategoryPicker extends StatefulWidget {
  final String label;
  final AdvertCategoryPickerController controller;

  const AdvertCategoryPicker({super.key, required this.label, required this.controller});

  @override
  State<AdvertCategoryPicker> createState() => _AdvertCategoryPickerState();
}

class _AdvertCategoryPickerState extends State<AdvertCategoryPicker> {
  late TextEditingController _textController;

  _handleClick(BuildContext context) => () async {
    List<AdvertCategoryModel> advertCategories = context.read<DictionaryCubit>().state.advertCategories;

    List<int>? result = await showAdvertCategoryPicker(context, advertCategories);
    try{
      if (result != null) {
        AdvertCategoryModel advertCategory = advertCategories[result[0]];
        widget.controller._changeAdvertCategory(advertCategory);
        _textController.value = TextEditingValue(text: advertCategory.name);
      }
    }catch (e) {}
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
      margin: const EdgeInsets.symmetric(vertical: 5),
      height: 60,
      child: ValueListenableBuilder(
        builder: (BuildContext context, AdvertCategoryModel advertCategory, Widget? child) {
          return TextField(
            controller: _textController,
            onTap: _handleClick(context),
            decoration: InputDecoration(
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
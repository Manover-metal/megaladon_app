import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:megaladon/data/models/dictionary/advert_category_model.dart';
import 'package:megaladon/logic/dictionary/dictionary_cubit.dart';

Future<AdvertCategoryModel?> showAdvertCategoryPicker(BuildContext context) async {
  List<AdvertCategoryModel> advertCategories = context.read<DictionaryCubit>().state.advertCategories;

  final result = await Picker(
    itemExtent: 30,
    height: MediaQuery.of(context).size.height / 3.5,
    backgroundColor: Theme.of(context).colorScheme.background,
    adapter: PickerDataAdapter<AdvertCategoryModel>(
        data: advertCategories.map((advertCategory) {
          return PickerItem<AdvertCategoryModel>(
              text: Text(advertCategory.name),
              value: advertCategory
          );
        }).toList()
    ),
    changeToFirst: false,
    hideHeader: false,
    cancelText: 'Cancel',
    confirmText: 'select'.tr(),
  ).showModal(context);

  if(result == null) return null;
  return advertCategories[result[0]];
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

  _handleClick () async {

    AdvertCategoryModel? advertCategory = await showAdvertCategoryPicker(context);
    if (advertCategory != null) {
      widget.controller._changeAdvertCategory(advertCategory);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ValueListenableBuilder(
        builder: (BuildContext context, AdvertCategoryModel advertCategory, Widget? child) {
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
                  padding: EdgeInsets.all(13),
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
                      Expanded(child: Text(advertCategory.name)),
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

import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:megaladon/data/models/request/index_period_enum.dart';

Future<IndexPeriod?> showIndexPeriodPicker(BuildContext context) async {
  final result =  await Picker(
    itemExtent: 30,
    height: MediaQuery.of(context).size.height / 3.5,
    backgroundColor: Theme.of(context).colorScheme.background,
    adapter: PickerDataAdapter<IndexPeriod>(
        data: IndexPeriod.values.map((e) {
          return PickerItem<IndexPeriod>(
              text: Text(e.toString()),
              value: e
          );
        }).toList()
    ),
    changeToFirst: false,
    hideHeader: false,
    cancelText: 'Отмена',
    confirmText: 'Выбрать',
  ).showModal(context);

  if(result == null) return null;
  return IndexPeriod.values[result[0]];
}


class IndexPeriodPickerController extends ValueNotifier<IndexPeriod> {


  IndexPeriodPickerController(IndexPeriod period) : super(period);



  void _changeIndexPeriod(IndexPeriod period) {
    value = period;
    notifyListeners();
  }
}

class IndexPeriodPicker extends StatefulWidget {
  final String label;
  final IndexPeriodPickerController controller;

  const IndexPeriodPicker({super.key, required this.label, required this.controller});

  @override
  State<IndexPeriodPicker> createState() => _IndexPeriodPickerState();
}

class _IndexPeriodPickerState extends State<IndexPeriodPicker> {

  _handleClick() async {
    IndexPeriod? period = await showIndexPeriodPicker(context);

    if(period != null) {
      widget.controller._changeIndexPeriod(period);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: ValueListenableBuilder(
        builder: (BuildContext context, IndexPeriod period, Widget? child) {
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
                      color: Theme.of(context).colorScheme.onBackground,
                      border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 0.5
                      ),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text(period.toString())),
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
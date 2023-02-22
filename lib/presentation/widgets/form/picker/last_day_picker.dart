
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:megaladon/data/repositories/advert_repository.dart';

Future<List<int>?> showIndexPeriodPicker(BuildContext context) async {
  return await Picker(
    backgroundColor: Theme.of(context).colorScheme.background,
    adapter: PickerDataAdapter<AdvertIndexPeriod>(
        data: AdvertIndexPeriod.values.map((e) {
          return PickerItem<AdvertIndexPeriod>(
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
}


class IndexPeriodPickerController extends ValueNotifier<AdvertIndexPeriod> {


  IndexPeriodPickerController(AdvertIndexPeriod period) : super(period);



  void _changeIndexPeriod(AdvertIndexPeriod period) {
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
  late TextEditingController _textController;

  _handleClick(BuildContext context) => () async {
    List<int>? result = await showIndexPeriodPicker(context);

    if(result != null) {
      AdvertIndexPeriod period = AdvertIndexPeriod.values[result[0]];
      widget.controller._changeIndexPeriod(period);
      _textController.value = TextEditingValue(text: period.toString());
    }

    FocusManager.instance.primaryFocus?.unfocus();
  };

  @override
  void initState() {
    _textController = TextEditingController(text: widget.controller.value.toString());
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
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ValueListenableBuilder(
        builder: (BuildContext context, AdvertIndexPeriod period, Widget? child) {
          return TextField(
            controller: _textController,
            onTap: _handleClick(context),
            decoration: InputDecoration(
                labelText: widget.label,
                labelStyle: TextStyle(
                    fontSize: 18
                )
            ),
          );
        },
        valueListenable: widget.controller,
      ),
    );
  }
}
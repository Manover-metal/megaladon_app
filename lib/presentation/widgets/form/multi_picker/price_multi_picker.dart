import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/data/models/dictionary/file_model.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/snackbars/error_snackbar.dart';

class FileModelPicker {
  final FileModel? file;
  final PlatformFile? platform;

  FileModelPicker(this.file, this.platform);
}


class PriceMultiPickerController extends ValueNotifier<List<FileModelPicker>> {
  final Function(PlatformFile) onAddFile;
  final Function(int) onDeleteFile;


  PriceMultiPickerController(
    this.onAddFile,
    this.onDeleteFile
  ) : super([]);

  _listener() {
    notifyListeners();
  }

  void _initial(List<FileModel> files) {
    value = files.map((e) {
      return FileModelPicker(e, null);
    }).toList();
  }

  void _addPrice(PlatformFile file) {
    value = [...value, FileModelPicker(null, file)];
    onAddFile(file);
    _listener();
  }

  void _deactivate(index) {
    if(value[index].platform != null) {
      onDeleteFile(index);
      _listener();
    }
  }

  void _removeByIndex(int index) {
    value = List.from(value)..removeAt(index);
    _listener();
  }
}

class PriceMultiPicker extends StatefulWidget {
  final PriceMultiPickerController controller;
  final List<FileModel> files;

  const PriceMultiPicker({super.key, required this.controller, required this.files});

  @override
  State<PriceMultiPicker> createState() => _PriceMultiPickerState();
}

class _PriceMultiPickerState extends State<PriceMultiPicker> {
  _addPrice() async {
    if(widget.controller.value.length < 2) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf']
      );
      if (result != null) {
        final PlatformFile file = result.files[0];
        widget.controller._addPrice(file);
      }
    } else {
      showErrorSnackBar(context, 'Вы не можете загрузить больше 2х прайс-листов');
    }
  }

  _removeByIndex(int index) => () {
    widget.controller._removeByIndex(index);
  };

  @override
  void didChangeDependencies() {
    widget.controller._initial(widget.files);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder(
          valueListenable: widget.controller,
          builder: (context, List<FileModelPicker> files, Widget? child) {
            return ListView.builder(
                itemCount: files.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, item) {
                  return Row(
                    children: [
                      Expanded(
                        child: Text(files[item].file?.name ?? files[item].platform!.name)
                      ),
                      if(files[item].platform != null) IconButton(
                        onPressed: _removeByIndex(item),
                        icon: Icon(Icons.remove_circle_outline_rounded,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      )
                    ],
                  );
                }
            );
          },
        ),
        OutlinedButtonApp(text: 'Добавить прайс', onPressed: _addPrice,)
      ],
    );
  }
}
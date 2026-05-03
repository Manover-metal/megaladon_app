import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';

class FileMultiPickerController extends ValueNotifier<List<PlatformFile>> {
  FileMultiPickerController() : super([]);

  _listener() {
    notifyListeners();
  }

  void _addFiles(List<PlatformFile> files) {
    value = [...value, ...files];
    _listener();
  }

  void _removeByIndex(int index) {
    value = List.from(value)..removeAt(index);
    _listener();
  }

}

class FileMultiPicker extends StatefulWidget {
  final FileMultiPickerController controller;

  const FileMultiPicker({super.key, required this.controller});

  @override
  State<FileMultiPicker> createState() => _FileMultiPickerState();
}

class _FileMultiPickerState extends State<FileMultiPicker> {
  _addFile() async {
    FilePickerResult? result = await FilePicker.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg' ,'pdf', 'doc', 'docx'],
    );

    if (result != null) {
      final List<PlatformFile> files = result.files;
      widget.controller._addFiles(files);
    }
  }

  _removeByIndex(int index) => () {
    widget.controller._removeByIndex(index);
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder(
          valueListenable: widget.controller,
          builder: (context, List<PlatformFile> files, Widget? child) {
            return ListView.builder(
                itemCount: files.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, item) {
                  return Row(
                    children: [
                      Expanded(
                        child: Text(files[item].name)
                      ),
                      IconButton(
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
        OutlinedButtonApp(text: 'Add_file'.tr(), onPressed: _addFile,)
      ],
    );
  }
}
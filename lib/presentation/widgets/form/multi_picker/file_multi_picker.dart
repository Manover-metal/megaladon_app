import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';

class FileMultiPickerController extends ValueNotifier<List<PlatformFile>> {
  FileMultiPickerController() : super([]);

  void _listener() {
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
  const FileMultiPicker({required this.controller, super.key});
  final FileMultiPickerController controller;

  @override
  State<FileMultiPicker> createState() => _FileMultiPickerState();
}

class _FileMultiPickerState extends State<FileMultiPicker> {
  Future<void> _addFile() async {
    var result = await FilePicker.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf', 'doc', 'docx'],
    );

    if (result != null) {
      final files = result.files;
      widget.controller._addFiles(files);
    }
  }

  Null Function() _removeByIndex(int index) => () {
        widget.controller._removeByIndex(index);
      };

  @override
  Widget build(BuildContext context) => Column(
        children: [
          ValueListenableBuilder(
            valueListenable: widget.controller,
            builder: (context, files, child) => ListView.builder(
                itemCount: files.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, item) => Row(
                      children: [
                        Expanded(child: Text(files[item].name)),
                        IconButton(
                          onPressed: _removeByIndex(item),
                          icon: Icon(
                            Icons.remove_circle_outline_rounded,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        )
                      ],
                    )),
          ),
          OutlinedButtonApp(
            text: AppLocalizations.of(context)!.add_file,
            onPressed: _addFile,
          )
        ],
      );
}

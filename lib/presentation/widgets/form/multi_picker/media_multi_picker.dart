import 'package:carousel_slider/carousel_slider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageMultiPickerController extends ValueNotifier<List<PlatformFile>> {
  ImageMultiPickerController() : super([]);

  _listener() {
    notifyListeners();
  }

  void _addFiles(List<PlatformFile> files) {
    value = [...value, ...files];
    _listener();
  }

  void _removeByIndex(PlatformFile file) {
    value = List.from(value)..remove(file);
    _listener();
  }

  Future<bool> _requestPermission() async {
    await Permission.photos.request();
    return await Permission.photos.request().isGranted;
  }
}

class ImageMultiPicker extends StatefulWidget {
  final ImageMultiPickerController controller;

  const ImageMultiPicker({super.key, required this.controller});

  @override
  State<ImageMultiPicker> createState() => _ImageMultiPickerState();
}

class _ImageMultiPickerState extends State<ImageMultiPicker> {
  _addImage() async {
    if(await widget.controller._requestPermission()) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          withData: true,
          type: FileType.image
      );
      if (result != null) {
        final List<PlatformFile> files = result.files;
        widget.controller._addFiles(files);
      }
    }

  }

  _removeByIndex(PlatformFile file) => () {
    widget.controller._removeByIndex(file);
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder(
          valueListenable: widget.controller,
          builder: (context, List<PlatformFile> images, Widget? child) {
            if(images.isNotEmpty) {
              return CarouselSlider(
                items: images.map((image) {
                  return Stack(
                    children: [
                      Container(
                        // width: double.infinity,
                        // height: MediaQuery.of(context).size.height / 3,
                        child: (image.bytes != null)? Image.memory(
                          image.bytes!,
                          fit: BoxFit.cover,
                        ): null,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: IconButton(
                            icon: Icon(
                              Icons.cancel_outlined,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            onPressed: _removeByIndex(image),
                          ),
                        ),
                      )
                    ],
                  );
                }).toList(),
                options: CarouselOptions(
                    viewportFraction: 1,
                    aspectRatio: 16/9
                ),
              );
            } return Container();
          },
        ),
        OutlinedButtonApp(text: 'Добавить изображение', onPressed: _addImage,)
      ],
    );
  }
}
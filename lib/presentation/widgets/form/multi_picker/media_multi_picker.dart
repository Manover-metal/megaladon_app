import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/core/image/image_service.dart';
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
}

class ImageMultiPicker extends StatefulWidget {
  final ImageMultiPickerController controller;

  const ImageMultiPicker({super.key, required this.controller});

  @override
  State<ImageMultiPicker> createState() => _ImageMultiPickerState();
}

class _ImageMultiPickerState extends State<ImageMultiPicker> {
  late CarouselController _carouselController;

  _addImage() async {
    final result = await ImageService.getImages();

    if (result != null) {
      final List<PlatformFile> files = result.files;
      widget.controller._addFiles(files);
    }
  }

  _removeByIndex(PlatformFile file) => () {
    widget.controller._removeByIndex(file);
  };

  @override
  void initState() {
    _carouselController = CarouselController();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder(
          valueListenable: widget.controller,
          builder: (context, List<PlatformFile> images, Widget? child) {
            if(images.isNotEmpty) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  CarouselSlider(
                    carouselController: _carouselController,
                    items: images.map((image) {
                      return Stack(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Image.memory(
                              image.bytes!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: IconButton(
                                icon: Icon(
                                  Icons.cancel,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                onPressed: _removeByIndex(image),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                    options: CarouselOptions(
                        enableInfiniteScroll: false,
                        viewportFraction: 1,
                        aspectRatio: 1.6
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_rounded),
                      onPressed: _carouselController.previousPage,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios_rounded),
                      onPressed: _carouselController.nextPage,
                    ),
                  )
                ],
              );
            } return Container();
          },
        ),
        const SizedBox(height: 10),
        OutlinedButtonApp(text: 'add_image'.tr(), onPressed: _addImage,)
      ],
    );
  }
}
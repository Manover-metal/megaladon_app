// import 'dart:async';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_picker/Picker.dart';
// import 'package:megaladon/data/models/element.dart';
//
// Future<List<int>?> showTypeElementPicker(BuildContext context) async {
//   return await Picker(
//       adapter: PickerDataAdapter<TypeElementModel>(
//           data: TypeElementModel.values.where((element) => element != TypeElementModel.project).map((e) {
//             return PickerItem<TypeElementModel>(
//               text: Text(e.toString()),
//               value: e
//             );
//           }).toList()
//       ),
//       changeToFirst: false,
//       hideHeader: false,
//       cancelText: 'Отмена',
//       confirmText: 'Выбрать',
//   ).showModal(context);
// }
//
//
// class TypeElementPickerController extends ValueNotifier<TypeElementModel> {
//
//
//   TypeElementPickerController(TypeElementModel typeModel) : super(typeModel);
//
//
//
//   void _changeTypeElement(TypeElementModel typeElement) {
//     value = typeElement;
//     notifyListeners();
//   }
// }
//
// class TypeElementPicker extends StatefulWidget {
//   final String label;
//   final TypeElementPickerController typeController;
//
//   const TypeElementPicker({super.key, required this.label, required this.typeController});
//
//   @override
//   State<TypeElementPicker> createState() => _TypeElementPickerState();
// }
//
// class _TypeElementPickerState extends State<TypeElementPicker> {
//   late TextEditingController controller;
//
//   _handleClick(BuildContext context) => () async {
//     List<int>? result = await showTypeElementPicker(context);
//
//     if(result != null) {
//       TypeElementModel typeElement = TypeElementModel.values.where((element) => element != TypeElementModel.project).toList()[result[0]];
//       widget.typeController._changeTypeElement(typeElement);
//       controller.value = TextEditingValue(text: typeElement.toString());
//     }
//
//     FocusManager.instance.primaryFocus?.unfocus();
//   };
//
//   @override
//   void initState() {
//     controller = TextEditingController(text: widget.typeController.value.toString());
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       child: ValueListenableBuilder(
//         builder: (BuildContext context, TypeElementModel typeElement, Widget? child) {
//           return TextField(
//             controller: controller,
//             onTap: _handleClick(context),
//             decoration: const InputDecoration(
//                 labelText: 'Тип',
//                 labelStyle: TextStyle(
//                     fontSize: 18
//                 )
//             ),
//           );
//         },
//         valueListenable: widget.typeController,
//       ),
//     );
//   }
// }
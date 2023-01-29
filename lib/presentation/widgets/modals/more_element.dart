//
// import 'package:auto_route/auto_route.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:megaladon/data/models/element.dart';
// import 'package:megaladon/logic/element/element_bloc.dart';
// import 'package:megaladon/presentation/routing/router.dart';
//
// class MoreElementModal extends StatelessWidget {
//
//   final ElementModel element;
//
//   const MoreElementModal({
//     Key? key,
//     required this.element
//   }) : super(key: key);
//
//   _edit(BuildContext context) => () {
//     context.router.popAndPush(UpdateElementRoute(element: element));
//   };
//
//   _delete(BuildContext context) => () {
//     context.read<ElementBloc>().add(ElementDeleteEvent(element.id));
//     context.router.pop();
//   };
//
//   _addElement(BuildContext context) => () {
//     context.router.popAndPushAll([
//       ElementDetailsRoute(element: element),
//       CreateElementRoute(parent: element)
//     ]);
//   };
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//         child: SafeArea(
//           top: false,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               ListTile(
//                 title: const Text('Edit').tr(),
//                 leading: const  Icon(Icons.edit),
//                 onTap: _edit(context),
//               ),
//               ListTile(
//                 title: const  Text('Copy').tr(),
//                 leading: const  Icon(Icons.content_copy),
//                 onTap: () => Navigator.of(context).pop(),
//               ),
//               ListTile(
//                 title: const  Text('add_title').tr(args: ["element".tr()]),
//                 leading: const  Icon(Icons.add_circle_outline_outlined),
//                 onTap: _addElement(context),
//               ),
//               ListTile(
//                 title: const  Text('Cut').tr(),
//                 leading: const  Icon(Icons.content_cut),
//                 onTap: () => Navigator.of(context).pop(),
//               ),
//               ListTile(
//                 title: const  Text('Delete').tr(),
//                 leading: const  Icon(Icons.delete),
//                 onTap: _delete(context),
//               )
//             ],
//           ),
//         )
//     );
//   }
// }
//

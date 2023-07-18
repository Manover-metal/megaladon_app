import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/data/repositories/review_repository.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/form/picker/star_picker.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/snackbars/error_snackbar.dart';
import 'package:megaladon/presentation/widgets/tiles/executor_tile.dart';

class ReviewScreen extends StatefulWidget {
  final OrderModel order;

  const ReviewScreen({super.key, required this.order});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late StarPickerController controller;

  _back() {
    context.router.pop();
  }

  @override
  void initState() {
    controller = StarPickerController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  _review() {
    ReviewRepository.review(widget.order.id, controller.value ).then((value) {
      _back();
    }).catchError((error) {
      if(error is DioError) {
        showErrorSnackBar(context, ErrorModel.parseDio(error).messages[0]);
      } else {
        showErrorSnackBar(context, ErrorModel.nothing.messages[0]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                 HeaderAppBar(
                  isBack: true,
                  title: "Feedback_on_order".tr()+'№1321412313',
                ),
                const SizedBox(height: 20,),
                if(widget.order.executor != null) ...[
                  ExecutorTile(executor: widget.order.executor!,),
                  const SizedBox(height: 20,),
                ],
                StarPicker(controller: controller),
                const SizedBox(height: 20,),
                ElevatedButtonApp(text: "Leave_feedback".tr(), onPressed: _review),
                OutlinedButtonApp(text: "Back".tr(), onPressed: _back)

              ],
            ),
          ),
        ),
      ),
    );
  }
}
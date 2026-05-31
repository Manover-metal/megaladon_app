import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/data/repositories/review_repository.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/form/picker/star_picker.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/snackbars/error_snackbar.dart';
import 'package:megaladon/presentation/widgets/tiles/executor_tile.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({required this.order, super.key});
  final OrderModel order;

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late StarPickerController controller;

  void _back() {
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

  void _review() {
    ReviewRepository.review(widget.order.id, controller.value).then((value) {
      _back();
    }).catchError((error) {
      if (error is DioException) {
        showErrorSnackBar(context, ErrorModel.parseDio(error).messages[0]);
      } else {
        showErrorSnackBar(context, ErrorModel.nothing.messages[0]);
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  HeaderAppBar(
                    isBack: true,
                    title: AppLocalizations.of(context)!
                        .feedbackOnOrderId(widget.order.id.toString()),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (widget.order.executor != null) ...[
                    ExecutorTile(
                      executor: widget.order.executor!,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                  StarPicker(controller: controller),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButtonApp(
                      text: AppLocalizations.of(context)!.leave_feedback,
                      onPressed: _review),
                  OutlinedButtonApp(
                      text: AppLocalizations.of(context)!.back,
                      onPressed: _back)
                ],
              ),
            ),
          ),
        ),
      );
}

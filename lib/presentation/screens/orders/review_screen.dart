import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/orders/review/review_cubit.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/form/picker/star_picker.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';
import 'package:megaladon/presentation/widgets/tiles/executor_tile.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({required this.order, super.key});
  final OrderModel order;

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late StarPickerController controller;

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

  void _back() => context.router.pop();

  void _submit() =>
      context.read<ReviewCubit>().submit(widget.order.id, controller.value);

  @override
  Widget build(BuildContext context) => BlocListener<ReviewCubit, ReviewState>(
        listener: (context, state) {
          if (state is ReviewSuccess) {
            _back();
          } else if (state is ReviewError) {
            CustomSnackBar.error(
              Text(
                state.error.messages.isNotEmpty
                    ? state.error.messages.first
                    : AppLocalizations.of(context)!.unknown_error,
              ),
            ).view(context);
          }
        },
        child: Scaffold(
          appBar: HeaderAppBar(
            isBack: true,
            title: AppLocalizations.of(context)!
                .feedbackOnOrderId(widget.order.id.toString()),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  if (widget.order.executor != null) ...[
                    ExecutorTile(executor: widget.order.executor!),
                    const SizedBox(height: 20),
                  ],
                  StarPicker(controller: controller),
                  const SizedBox(height: 20),
                  BlocBuilder<ReviewCubit, ReviewState>(
                    builder: (context, state) => ElevatedButtonApp(
                      text: AppLocalizations.of(context)!.leave_feedback,
                      onPressed: state is ReviewLoading ? null : _submit,
                    ),
                  ),
                  OutlinedButtonApp(
                    text: AppLocalizations.of(context)!.back,
                    onPressed: _back,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

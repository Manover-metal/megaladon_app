import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/enum_form_state.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/form/update/order/order_update_form_cubit.dart';
import 'package:megaladon/logic/screens/orders/details/order_screen_details_cubit.dart';
import 'package:megaladon/logic/screens/orders/my/order_screen_my_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/form/field/description_field.dart';
import 'package:megaladon/presentation/widgets/form/field/number_field.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/form/multi_picker/file_multi_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/city_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/order_category_picker.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/snackbars/error_snackbar.dart';

class UpdateOrderScreen extends StatefulWidget {
  const UpdateOrderScreen({required this.order, super.key});
  final OrderModel order;

  @override
  State<UpdateOrderScreen> createState() => _UpdateOrderScreenState();
}

class _UpdateOrderScreenState extends State<UpdateOrderScreen> {
  late OrderCategoryPickerController _orderCategoryController;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  late CityPickerController _cityController;
  late TextEditingController _priceMaxController;
  late TextEditingController _priceRecommendedController;
  late FileMultiPickerController _fileController;

  void _back() {
    context.router.pop();
  }

  Future<void> _create() async {
    if (_checkForm()) {
      await context.read<OrderUpdateFormCubit>().updateFetch(widget.order.id);
    }
  }

  bool _checkForm() {
    var form = context.read<OrderUpdateFormCubit>();
    return form.checkUpdate(
        title: _titleController.value.text,
        description: _descriptionController.value.text,
        category: _orderCategoryController.value,
        city: _cityController.value,
        priceMax: _priceMaxController.value.text,
        priceRecommended: _priceRecommendedController.value.text,
        files: _fileController.value);
  }

  void _listenerForm(BuildContext context, OrderUpdateFormState state) {
    if (state.status) {
      for (final element in state.props) {
        if (element is FormzInput && element.isNotValid) {
          return showErrorSnackBar(context, element.error.toString());
        }
      }
    }
    if (state.formState == EnumFormState.success) {
      context.read<OrderScreenDetailsCubit>().fetch(id: widget.order.id);
      context.read<OrderScreenMyCubit>().fetchMy();
      context.router
          .popUntil((route) => route.settings.name == InitialRouter.name);
      context.router.navigate(InitialRouter(children: [
        OrderRouter(children: [DetailsOrderRoute(orderId: widget.order.id)])
      ]));
    } else if (state.formState == EnumFormState.error) {
      if (state.error != null) {
        showErrorSnackBar(context, state.error!.messages[0]);
      }
    }
  }

  @override
  void initState() {
    _orderCategoryController =
        OrderCategoryPickerController(category: widget.order.category);
    _titleController = TextEditingController(text: widget.order.title);
    _cityController = CityPickerController(city: widget.order.city);
    _priceMaxController =
        TextEditingController(text: widget.order.priceMax.toString());
    _priceRecommendedController =
        TextEditingController(text: widget.order.priceRecommended.toString());
    _descriptionController =
        TextEditingController(text: widget.order.description);
    _fileController = FileMultiPickerController();
    super.initState();
  }

  @override
  void dispose() {
    _orderCategoryController.dispose();
    _titleController.dispose();
    _cityController.dispose();
    _descriptionController.dispose();
    _priceMaxController.dispose();
    _priceRecommendedController.dispose();
    _fileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: HeaderAppBar(
            isBack: true,
            title: AppLocalizations.of(context)!.change_order),
        body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  OrderCategoryPicker(
                      label: AppLocalizations.of(context)!.category,
                      controller: _orderCategoryController),
                  TextFieldApp(
                    controller: _titleController,
                    label: AppLocalizations.of(context)!.header,
                  ),
                  CityPicker(
                      label: AppLocalizations.of(context)!.city,
                      controller: _cityController),
                  DescriptionFieldApp(
                      label: AppLocalizations.of(context)!.store_data,
                      controller: _descriptionController),
                  NumberFieldApp(
                    label: AppLocalizations.of(context)!.desired_budget,
                    controller: _priceMaxController,
                  ),
                  NumberFieldApp(
                    label: AppLocalizations.of(context)!.allowed_budget,
                    controller: _priceRecommendedController,
                  ),
                  FileMultiPicker(controller: _fileController),
                  const SizedBox(height: 30),
                  BlocConsumer<OrderUpdateFormCubit, OrderUpdateFormState>(
                      listener: _listenerForm,
                      builder: (context, state) {
                        if (state.formState == EnumFormState.fetch) {
                          return ElevatedButtonApp(
                            child: Loader(
                                color: Theme.of(context).colorScheme.surface),
                            onPressed: () {},
                          );
                        }
                        return ElevatedButtonApp(
                          text: AppLocalizations.of(context)!.edit,
                          onPressed: _create,
                        );
                      }),
                  OutlinedButtonApp(
                    text: AppLocalizations.of(context)!.cancel,
                    onPressed: _back,
                  ),
                ],
              ),
            ),
          ),
      );
}

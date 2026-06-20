import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/core/icons/icons.dart';
import 'package:megaladon/data/models/enum_form_state.dart';
import 'package:megaladon/data/models/form/localizable_error.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/form/create/order/order_create_form_cubit.dart';
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
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  late OrderCategoryPickerController _orderCategoryController;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  late CityPickerController _cityController;
  late TextEditingController _priceMaxController;
  late TextEditingController _executionDaysController;
  late FileMultiPickerController _fileController;

  void _back() {
    context.router.pop();
  }

  Future<void> _create() async {
    if (_checkForm()) {
      await context.read<OrderCreateFormCubit>().createFetch();
    }
  }

  bool _checkForm() {
    var form = context.read<OrderCreateFormCubit>();
    return form.checkCreate(
        title: _titleController.value.text,
        description: _descriptionController.value.text,
        category: _orderCategoryController.value,
        city: _cityController.value!,
        priceMax: _priceMaxController.value.text,
        executionDays: _executionDaysController.value.text,
        files: _fileController.value);
  }

  void _listenerForm(BuildContext context, OrderCreateFormState state) {
    if (!state.status) {
      for (final element in state.props) {
        if (element is FormzInput && element.isNotValid) {
          final err = element.error;
          return CustomSnackBar.error(
            Text(err is LocalizableError
                ? err.localize(AppLocalizations.of(context)!)
                : err.toString()),
          ).view(context);
        }
      }
    }
    print(state.formState);
    if (state.formState == EnumFormState.success) {
      print('success callback');
      context.read<OrderScreenMyCubit>().fetchMy();
      context.router
          .popUntil((route) => route.settings.name == InitialRouter.name);
      context.router.navigate(const InitialRouter(children: [
        OrderRouter(children: [ListMyOrdersRoute()])
      ]));
    } else if (state.formState == EnumFormState.error) {
      print('error callback');

      if (state.error != null) {
        CustomSnackBar.error(
          Text(
            state.error?.messages.isNotEmpty == true
                ? state.error!.messages.first
                : AppLocalizations.of(context)!.unknown_error,
          ),
        ).view(context);
      }
    }
  }

  @override
  void initState() {
    _orderCategoryController = OrderCategoryPickerController();
    _titleController = TextEditingController();
    _cityController = CityPickerController();
    _priceMaxController = TextEditingController();
    _executionDaysController = TextEditingController();
    _descriptionController = TextEditingController();
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
    _executionDaysController.dispose();
    _fileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: HeaderAppBar(
            isBack: true, title: AppLocalizations.of(context)!.create_an_order),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 30),
                BlocBuilder<OrderCreateFormCubit, OrderCreateFormState>(
                  builder: (context, state) => Column(
                    children: [
                      OrderCategoryPicker(
                        label: AppLocalizations.of(context)!.select_a_category,
                        controller: _orderCategoryController,
                        errorText: state.category.displayError
                            ?.localize(AppLocalizations.of(context)!),
                      ),
                      CityPicker(
                        label: AppLocalizations.of(context)!.choose_city,
                        controller: _cityController,
                        errorText: state.city.displayError
                            ?.localize(AppLocalizations.of(context)!),
                      ),
                    ],
                  ),
                ),
                BlocConsumer<OrderCreateFormCubit, OrderCreateFormState>(
                    listener: _listenerForm,
                    builder: (context, state) => Column(
                          children: [
                            TextFieldApp(
                              controller: _titleController,
                              label: AppLocalizations.of(context)!.header,
                              icon: const Icon(
                                  IconPack.job_description_kwo7og605c2l),
                              errorText: state.title.displayError
                                  ?.localize(AppLocalizations.of(context)!),
                            ),
                            DescriptionFieldApp(
                              label: AppLocalizations.of(context)!
                                  .description_of_work,
                              controller: _descriptionController,
                              icon: const Icon(IconPack.description),
                              errorText: state.description.displayError
                                  ?.localize(AppLocalizations.of(context)!),
                            ),
                            NumberFieldApp(
                              label:
                                  AppLocalizations.of(context)!.desired_budget,
                              controller: _priceMaxController,
                              icon: const Icon(Icons.money_sharp),
                              errorText: state.priceMax.displayError
                                  ?.localize(AppLocalizations.of(context)!),
                            ),
                            NumberFieldApp(
                              label: AppLocalizations.of(context)!
                                  .execution_days_label,
                              controller: _executionDaysController,
                              icon: const Icon(Icons.calendar_today),
                              errorText: state.executionDays.displayError
                                  ?.localize(AppLocalizations.of(context)!),
                            ),
                            FileMultiPicker(controller: _fileController),
                            const SizedBox(height: 30),
                            if (state.formState == EnumFormState.fetch)
                              ElevatedButtonApp(
                                child: Loader(
                                    color:
                                        Theme.of(context).colorScheme.surface),
                                onPressed: () {},
                              )
                            else
                              ElevatedButtonApp(
                                text: AppLocalizations.of(context)!.create,
                                onPressed: _create,
                              ),
                          ],
                        )),
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

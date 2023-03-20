import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/core/icons/icons.dart';
import 'package:megaladon/data/models/enum_form_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:megaladon/generated/locale_keys.g.dart';
import 'package:megaladon/logic/form/create/order/order_create_form_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/form/field/description_field.dart';
import 'package:megaladon/presentation/widgets/form/multi_picker/file_multi_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/order_category_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/city_picker.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/form/field/number_field.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/snackbars/error_snackbar.dart';

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
  late TextEditingController _priceRecommendedController;
  late FileMultiPickerController _fileController;

  _back() {
    context.router.pop();
  }

  _create() {
    if(_checkForm()) {
      context.read<OrderCreateFormCubit>().createFetch().then((value) {
        context.router.popUntil((route) => route.settings.name == InitialRouter.name);
        context.router.navigate(const InitialRouter(
            children: [
              OrderRouter(
                  children: [ListMyOrdersRoute()]
              )
            ]
        ));
      }).catchError((error) {
        if(error is DioError) {
          showErrorSnackBar(context, error.response?.data['message']);
        }
      });
    }
  }

  _checkForm() {
    OrderCreateFormCubit form = context.read<OrderCreateFormCubit>();
    return form.checkCreate(
        title: _titleController.value.text,
        description: _descriptionController.value.text,
        category: _orderCategoryController.value,
        city: _cityController.value,
        priceMax: _priceMaxController.value.text,
        priceRecommended: _priceRecommendedController.value.text,
        files: _fileController.value
    );
  }

  _listenerForm(BuildContext context, OrderCreateFormState state) {
    if(state.status.isInvalid) {
      for (var element in state.props) {
        if(element is FormzInput && element.invalid) {
          return showErrorSnackBar(context, element.error.toString());
        }
      }
    }
  }

  @override
  void initState() {
    _orderCategoryController = OrderCategoryPickerController();
    _titleController = TextEditingController();
    _cityController = CityPickerController();
    _priceMaxController = TextEditingController();
    _priceRecommendedController = TextEditingController();
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
    _priceRecommendedController.dispose();
    _fileController.dispose();
    super.dispose();
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
                HeaderAppBar(isBack: true, title: LocaleKeys.Create_an_order.tr()),
                const SizedBox(height: 30),

                OrderCategoryPicker(label: LocaleKeys.Select_a_category.tr(), controller: _orderCategoryController, ),
                CityPicker(label: LocaleKeys.Choose_city.tr(), controller: _cityController),
                TextFieldApp(controller: _titleController, label: 'Заголовок', icon: Icon(IconPack.job_description_kwo7og605c2l),),
                DescriptionFieldApp(label: LocaleKeys.Description_of_work.tr(), controller: _descriptionController,icon: Icon(IconPack.description),),
                NumberFieldApp(label: LocaleKeys.Desired_budget.tr(), controller: _priceMaxController,icon: Icon(Icons.money_sharp),),
                NumberFieldApp(label: LocaleKeys.Allowed_budget.tr(), controller: _priceRecommendedController,icon: Icon(Icons.money_sharp),),
                FileMultiPicker(controller: _fileController),
                const SizedBox(height: 30),
                // BlocConsumer(builder: builder, listener: listener)
                BlocConsumer<OrderCreateFormCubit, OrderCreateFormState>(
                    listener: _listenerForm,
                    builder: (context, state) {
                      if(state.formState == EnumFormState.fetch) {
                        return ElevatedButtonApp(child: Loader(color: Theme.of(context).colorScheme.background), onPressed: () {},);
                      }
                      return ElevatedButtonApp(text: 'Создать', onPressed: _create,);
                    }
                ),
                OutlinedButtonApp(text: LocaleKeys.Cancel.tr(), onPressed: _back,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
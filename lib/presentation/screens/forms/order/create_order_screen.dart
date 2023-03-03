import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/logic/form/create/ad/ad_create_form_cubit.dart';
import 'package:megaladon/logic/form/create/order/order_create_form_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/form/field/description_field.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/order_category_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/city_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/order_category_picker.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/form/field/text_number_field.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/snackbars/error_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class CreateOrderScreen extends StatefulWidget {
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

  _back() {
    context.router.pop();
  }

  _create() {
    if(_checkForm()) {
      context.read<OrderCreateFormCubit>().createFetch().then((value) {
        context.router.navigate(InitialRouter(
          children: [
            OrderRouter(
              children: [
                DetailsOrderRoute(orderId: value.id)
              ]
            )
          ]
        ));
      }).catchError((error) {

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
        priceMax: int.tryParse(_priceMaxController.value.text),
        priceRecommended: int.tryParse(_priceRecommendedController.value.text)
    );
  }

  _listenerForm(BuildContext context, OrderCreateFormState state) {
    if(state.status.isInvalid) {
      if(state.title.invalid) {
        showErrorSnackBar(context, state.title.error.toString());
      } else if(state.description.invalid) {
        showErrorSnackBar(context, state.description.error.toString());
      } else if(state.category.invalid) {
        showErrorSnackBar(context, state.category.error.toString());
      } else if(state.city.invalid) {
        showErrorSnackBar(context, state.city.error.toString());
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
    super.initState();
  }



  @override
  void dispose() {
    _orderCategoryController.dispose();
    _titleController.dispose();
    _cityController.dispose();
    _priceMaxController.dispose();
    _priceRecommendedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                HeaderAppBar(isBack: true, ),
                TitleApp('Создать заказ'),
                SizedBox(height: 30),
                OrderCategoryPicker(label: 'Категория', controller: _orderCategoryController),
                TextFieldApp(controller: _titleController, label: 'Заголовок',),
                CityPicker(label: 'Город', controller: _cityController),
                DescriptionFieldApp(label: 'Описание', controller: _descriptionController),
                TextNumberFieldApp(label: 'Желаемый бюджет (не обязательно)', controller: _priceMaxController,),
                TextNumberFieldApp(label: 'Допустимый бюджет (не обязательно)', controller: _priceRecommendedController,),
                BlocListener<OrderCreateFormCubit, OrderCreateFormState>(
                  listener: _listenerForm,
                  child: ElevatedButtonApp(text: 'Создать', onPressed: _create,),
                ),
                OutlinedButtonApp(text: 'Отменить', onPressed: _back,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
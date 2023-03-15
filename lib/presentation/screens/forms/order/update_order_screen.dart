import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/enum_form_state.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/logic/form/create/ad/ad_create_form_cubit.dart';
import 'package:megaladon/logic/form/create/order/order_create_form_cubit.dart';
import 'package:megaladon/logic/form/update/order/order_update_form_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/form/field/description_field.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/order_category_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/city_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/order_category_picker.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/form/field/number_field.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/snackbars/error_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class UpdateOrderScreen extends StatefulWidget {
  final OrderModel order;

  const UpdateOrderScreen({super.key, required this.order});

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

  _back() {
    context.router.pop();
  }

  _create() {
    if(_checkForm()) {
      context.router.popUntil((route) => route.settings.name == InitialRouter.name);
      context.read<OrderUpdateFormCubit>().updateFetch(widget.order.id).then((value) {
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
    OrderUpdateFormCubit form = context.read<OrderUpdateFormCubit>();
    return form.checkUpdate(
        title: _titleController.value.text,
        description: _descriptionController.value.text,
        category: _orderCategoryController.value,
        city: _cityController.value,
        priceMax: _priceMaxController.value.text,
        priceRecommended: _priceRecommendedController.value.text
    );
  }

  _listenerForm(BuildContext context, OrderUpdateFormState state) {
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
    _orderCategoryController = OrderCategoryPickerController(category: widget.order.category);
    _titleController = TextEditingController(text: widget.order.title);
    _cityController = CityPickerController(city: widget.order.city);
    _priceMaxController = TextEditingController(text: widget.order.priceMax.toString());
    _priceRecommendedController = TextEditingController(text: widget.order.priceRecommended.toString());
    _descriptionController = TextEditingController(text: widget.order.description);
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
                TitleApp('Изменить заказ'),
                SizedBox(height: 30),
                OrderCategoryPicker(label: 'Категория', controller: _orderCategoryController),
                TextFieldApp(controller: _titleController, label: 'Заголовок',),
                CityPicker(label: 'Город', controller: _cityController),
                DescriptionFieldApp(label: 'Описание', controller: _descriptionController),
                NumberFieldApp(label: 'Желаемый бюджет (не обязательно)', controller: _priceMaxController,),
                NumberFieldApp(label: 'Допустимый бюджет (не обязательно)', controller: _priceRecommendedController,),
                BlocConsumer<OrderUpdateFormCubit, OrderUpdateFormState>(
                  listener: _listenerForm,
                  builder: (context, state) {
                    if(state.formState == EnumFormState.fetch) {
                      return ElevatedButtonApp(child: Loader(color: Theme.of(context).colorScheme.background), onPressed: () {},);
                    }
                    return ElevatedButtonApp(text: 'Изменить', onPressed: _create,);
                  }
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
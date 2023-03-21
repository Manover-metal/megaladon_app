import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/enum_form_state.dart';
import 'package:megaladon/logic/form/create/offer/create_offer_form_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/form/field/expired_at_field.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/form/field/number_field.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/city_picker.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/snackbars/error_snackbar.dart';

class CreateOfferScreen extends StatefulWidget {

  final int orderId;

  const CreateOfferScreen({super.key, required this.orderId});

  @override
  State<CreateOfferScreen> createState() => _CreateOfferScreenState();
}

class _CreateOfferScreenState extends State<CreateOfferScreen> {
  late CityPickerController _cityController;
  late TextEditingController _expiredAtController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;
  late TextEditingController _priceController;

  _back() {
    context.router.pop();
  }

  _create() {
    if(_checkForm()) {
      context.read<CreateOfferFormCubit>().createFetch(widget.orderId).then((value) {
        context.router.popUntil((route) => route.settings.name == InitialRouter.name);
        context.router.navigate(InitialRouter(
            children: [
              OrderRouter(
                  children: [DetailsOfferRoute(orderId: widget.orderId, offerId: value.id)]
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
    CreateOfferFormCubit form = context.read<CreateOfferFormCubit>();
    return form.checkCreate(
        description: _descriptionController.value.text,
        price: _priceController.value.text,
        city: _cityController.value,
        date: _dateController.value.text,
        expiredAt: _expiredAtController.value.text
    );
  }

  _listenerForm(BuildContext context, CreateOfferFormState state) {
    if(state.status.isInvalid) {
      for (var element in state.props) {
        if(element is FormzInput && element.invalid) {
          return showErrorSnackBar(context, element.error.toString());
        }
      }
    }
  }

  @override
  initState() {
    _cityController = CityPickerController();
    _expiredAtController = TextEditingController();
    _dateController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _cityController.dispose();
    _expiredAtController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
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
                HeaderAppBar(isBack: true, title: "Отклик на заказ №".tr()+'${widget.orderId}'),
                const SizedBox(height: 20,),
                ExpiredAtFieldApp(label: "Актуален до".tr(), icon: const Icon(Icons.calendar_month), controller: _expiredAtController,),
                TextFieldApp(label: "Время на работу".tr(), icon: const Icon(Icons.watch_later_outlined), controller: _dateController,),
                NumberFieldApp(label: "Цена".tr(), icon: const Icon(Icons.credit_card), controller: _priceController,),
                TextFieldApp(label: "Описание {}".tr(), icon: const Icon(Icons.message), controller: _descriptionController,),
                CityPicker(label: "Город".tr(), icon: const Icon(Icons.place) , controller: _cityController),
                BlocConsumer<CreateOfferFormCubit, CreateOfferFormState>(
                  listener: _listenerForm,
                  builder: (context, state) {
                    if(state.formState == EnumFormState.fetch) {
                      return ElevatedButtonApp(child: Loader(color: Theme.of(context).colorScheme.background), onPressed: () {},);
                    }
                    return ElevatedButtonApp(text: "Откликнуться".tr(), onPressed: _create,);
                  }
                ),
                OutlinedButtonApp(
                  text: "Отмена".tr(),
                  onPressed: _back,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
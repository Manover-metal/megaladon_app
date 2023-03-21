import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/core/icons/icons.dart';
import 'package:megaladon/data/models/enum_form_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:megaladon/generated/locale_keys.g.dart';
import 'package:megaladon/logic/form/create/ad/ad_create_form_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/form/field/description_field.dart';
import 'package:megaladon/presentation/widgets/form/multi_picker/media_multi_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/advert_category_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/city_picker.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/form/field/number_field.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/snackbars/error_snackbar.dart';

class CreateAdScreen extends StatefulWidget {
  const CreateAdScreen({super.key});

  @override
  State<CreateAdScreen> createState() => _CreateAdScreenState();
}

class _CreateAdScreenState extends State<CreateAdScreen> {
  late AdvertCategoryPickerController _advertCategoryController;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late CityPickerController _cityController;
  late TextEditingController _priceController;
  late TextEditingController _phoneController;
  late ImageMultiPickerController _imageController;

  _back() {
    context.router.pop();
  }
  
  _create() {
    if(_checkForm()) {
      context.read<AdCreateFormCubit>().createFetch().then((value) {
        context.router.popUntil((route) => route.settings.name == InitialRouter.name);
        context.router.navigate( const InitialRouter(
          children: [
            AdRouter(
              children: [MyAdsRoute()]
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
    AdCreateFormCubit form = context.read<AdCreateFormCubit>();
    return form.checkCreate(
      title: _titleController.value.text,
      description: _descriptionController.value.text,
      price: _priceController.value.text,
      category: _advertCategoryController.value,
      city: _cityController.value,
      phone: _phoneController.value.text,
      media: _imageController.value
    );
  }

  _listenerForm(BuildContext context, AdCreateFormState state) {
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
    _advertCategoryController = AdvertCategoryPickerController();
    _titleController = TextEditingController();
    _cityController = CityPickerController();
    _priceController = TextEditingController();
    _descriptionController = TextEditingController();
    _phoneController = TextEditingController();
    _imageController = ImageMultiPickerController();
    super.initState();
  }
  
  

  @override
  void dispose() {
    _advertCategoryController.dispose();
    _titleController.dispose();
    _cityController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    _imageController.dispose();
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
                HeaderAppBar(isBack: true, title: "Создание объявления".tr(),),
                const SizedBox(height: 30),
                TextFieldApp(controller: _titleController, label: "Название {}*".tr(), icon: const Icon(Icons.edit)),
                AdvertCategoryPicker(label: "Выберите категорию".tr(), controller: _advertCategoryController),
                CityPicker(label: "Выберите город".tr(), controller: _cityController),
                DescriptionFieldApp(label: "Описание вашего предложения".tr(), controller: _descriptionController, icon: const Icon(IconPack.description),),
                NumberFieldApp(label: "Цена".tr(), controller: _priceController, icon: const  Icon(Icons.money_sharp),),
                TextFieldApp(controller: _phoneController, label: "Дополнительный телефон".tr(), icon: const Icon(Icons.phone),),
                ImageMultiPicker(controller: _imageController),
                const SizedBox(height: 20),
                BlocConsumer<AdCreateFormCubit, AdCreateFormState>(
                  listener: _listenerForm,
                  builder: (context, state) {
                    if(state.formState == EnumFormState.fetch) {
                      return ElevatedButtonApp(child: Loader(color: Theme.of(context).colorScheme.background), onPressed: () {},);
                    }
                    return ElevatedButtonApp(text: "Создать объявление".tr(), onPressed: _create,);
                  }
                ),
                OutlinedButtonApp(text: "Отмена".tr(), onPressed: _back,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/logic/form/create/ad/ad_create_form_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/form/field/description_field.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/advert_category_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/city_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/advert_category_picker.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/form/field/text_number_field.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/snackbars/error_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class CreateAdScreen extends StatefulWidget {
  @override
  State<CreateAdScreen> createState() => _CreateAdScreenState();
}

class _CreateAdScreenState extends State<CreateAdScreen> {
  late AdvertCategoryPickerController _advertCategoryController;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  late CityPickerController _cityController;
  late TextEditingController _priceController;

  _back() {
    context.router.pop();
  }
  
  _create() {
    if(_checkForm()) {
      context.read<AdCreateFormCubit>().createFetch().then((value) {
        context.router.navigate(InitialRouter(
          children: [
            AdRouter(
              children: [DetailsAdRoute(id: value.id)]
            )
          ]
        ));
      }).catchError((error) {

      });
    }
  }

  _checkForm() {
    AdCreateFormCubit form = context.read<AdCreateFormCubit>();
    return form.checkCreate(
      title: _titleController.value.text,
      description: _descriptionController.value.text,
      price: int.tryParse(_priceController.value.text),
      category: _advertCategoryController.value,
      city: _cityController.value
    );
  }

  _listenerForm(BuildContext context, AdCreateFormState state) {
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
    _advertCategoryController = AdvertCategoryPickerController();
    _titleController = TextEditingController();
    _cityController = CityPickerController();
    _priceController = TextEditingController();
    _descriptionController = TextEditingController();
    super.initState();
  }
  
  

  @override
  void dispose() {
    _advertCategoryController.dispose();
    _titleController.dispose();
    _cityController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
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
                TitleApp('Создать объявление'),
                SizedBox(height: 30),
                AdvertCategoryPicker(label: 'Категория', controller: _advertCategoryController),
                TextFieldApp(controller: _titleController, label: 'Название',),
                CityPicker(label: 'Город', controller: _cityController),
                DescriptionFieldApp(label: 'Описание', controller: _descriptionController),
                TextNumberFieldApp(label: 'Цена', controller: _priceController,),
                // BlocConsumer(builder: builder, listener: listener)
                BlocListener<AdCreateFormCubit, AdCreateFormState>(
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
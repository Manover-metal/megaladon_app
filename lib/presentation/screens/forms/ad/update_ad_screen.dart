import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/advert_model.dart';
import 'package:megaladon/data/models/enum_form_state.dart';
import 'package:megaladon/logic/form/update/ad/ad_update_form_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/form/field/description_field.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/advert_category_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/city_picker.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/form/field/number_field.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/snackbars/error_snackbar.dart';

class UpdateAdScreen extends StatefulWidget {
  final AdvertModel advert;

  const UpdateAdScreen({super.key, required this.advert});

  @override
  State<UpdateAdScreen> createState() => _UpdateAdScreenState();
}

class _UpdateAdScreenState extends State<UpdateAdScreen> {
  late AdvertCategoryPickerController _advertCategoryController;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _phoneController;
  late CityPickerController _cityController;
  late TextEditingController _priceController;

  _back() {
    context.router.pop();
  }

  _create() {
    if(_checkForm()) {
      context.router.popUntil((route) => route.settings.name == InitialRouter.name);
      context.read<AdUpdateFormCubit>().updateFetch(widget.advert.id).then((value) {
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
    AdUpdateFormCubit form = context.read<AdUpdateFormCubit>();
    return form.checkUpdate(
        title: _titleController.value.text,
        description: _descriptionController.value.text,
        price: _priceController.value.text,
        category: _advertCategoryController.value,
        city: _cityController.value,
        phone: _phoneController.value.text
    );
  }

  _listenerForm(BuildContext context, AdUpdateFormState state) {
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
    _advertCategoryController = AdvertCategoryPickerController(category: widget.advert.category);
    _titleController = TextEditingController(text: widget.advert.title);
    _cityController = CityPickerController(city: widget.advert.city);
    _priceController = TextEditingController(text: widget.advert.price.toString());
    _descriptionController = TextEditingController(text: widget.advert.description);
    _phoneController = TextEditingController(text: widget.advert.additionalPhone);
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
                HeaderAppBar(isBack: true, title: 'Изменить объявление'),
                SizedBox(height: 30),
                AdvertCategoryPicker(label: 'Категория', controller: _advertCategoryController),
                TextFieldApp(controller: _titleController, label: 'Название',),
                CityPicker(label: 'Город', controller: _cityController),
                DescriptionFieldApp(label: 'Описание', controller: _descriptionController),
                NumberFieldApp(label: 'Цена', controller: _priceController,),
                TextFieldApp(controller: _phoneController, label: 'Дополнительный телефон'),

                // BlocConsumer(builder: builder, listener: listener)
                BlocConsumer<AdUpdateFormCubit, AdUpdateFormState>(
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
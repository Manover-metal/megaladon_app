import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/core/icons/icons.dart';
import 'package:megaladon/data/models/dictionary/advert_type.dart';
import 'package:megaladon/data/models/enum_form_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:megaladon/logic/form/create/ad/ad_create_form_cubit.dart';
import 'package:megaladon/logic/screens/orders/my/order_screen_my_cubit.dart';
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
  const CreateAdScreen({super.key, required this.type});

  final AdvertType type;

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
  
  _create() async {
    if(_checkForm()) {
      await context.read<AdCreateFormCubit>().createFetch();
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
      media: _imageController.value,
      type: widget.type
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
    if(state.formState == EnumFormState.success) {
      context.read<OrderScreenMyCubit>().refresh();
      context.router.popUntil((route) => route.settings.name == InitialRouter.name);
      context.router.navigate( const InitialRouter(
          children: [
            AdRouter(
                children: [MyAdsRoute()]
            )
          ]
      ));
    } else if(state.formState == EnumFormState.error) {
      if(state.error != null) {
        showErrorSnackBar(context, state.error!.messages[0]);
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
                if(widget.type == AdvertType.advert) HeaderAppBar(isBack: true, title: "Creating_an_ad".tr(),)
                else if(widget.type == AdvertType.service) HeaderAppBar(isBack: true, title: "Creating_an_service".tr()),
                const SizedBox(height: 30),
                TextFieldApp(controller: _titleController, label: "name_field".tr(), icon: const Icon(Icons.edit)),
                AdvertCategoryPicker(label: "Select_a_category".tr(), controller: _advertCategoryController),
                CityPicker(label: "Choose_city".tr(), controller: _cityController),
                DescriptionFieldApp(label: "Description_of_your_offer".tr(), controller: _descriptionController, icon: const Icon(IconPack.description),),
                NumberFieldApp(label: "Price".tr(), controller: _priceController, icon: const  Icon(Icons.money_sharp),),
                TextFieldApp(controller: _phoneController, label: "Additional_Phone".tr(), icon: const Icon(Icons.phone),),
                ImageMultiPicker(controller: _imageController),
                const SizedBox(height: 20),
                BlocConsumer<AdCreateFormCubit, AdCreateFormState>(
                  listener: _listenerForm,
                  builder: (context, state) {
                    if(state.formState == EnumFormState.fetch) {
                      return ElevatedButtonApp(child: Loader(color: Theme.of(context).colorScheme.background), onPressed: () {},);
                    }
                    if(widget.type == AdvertType.advert) {
                      return ElevatedButtonApp(text: "Create_ad".tr(), onPressed: _create,);
                    } else if(widget.type == AdvertType.service) {
                      return ElevatedButtonApp(text: "Create_service".tr(), onPressed: _create,);
                    }
                    return Container();
                  }
                ),
                OutlinedButtonApp(text: "Cancel".tr(), onPressed: _back,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
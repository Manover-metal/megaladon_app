import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/core/icons/icons.dart';
import 'package:megaladon/data/models/advert_model.dart';
import 'package:megaladon/data/models/dictionary/advert_type.dart';
import 'package:megaladon/data/models/enum_form_state.dart';
import 'package:megaladon/logic/form/update/ad/ad_update_form_cubit.dart';
import 'package:megaladon/logic/screens/orders/details/order_screen_details_cubit.dart';
import 'package:megaladon/logic/screens/orders/my/order_screen_my_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/form/field/description_field.dart';
import 'package:megaladon/presentation/widgets/form/field/phone_field.dart';
import 'package:megaladon/presentation/widgets/form/multi_picker/media_multi_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/advert_category_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/city_picker.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/form/field/number_field.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/snackbars/error_snackbar.dart';

class UpdateAdScreen extends StatefulWidget {
  final AdvertModel advert;
  final AdvertType type;

  const UpdateAdScreen({super.key, required this.advert, required this.type});

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
  late ImageMultiPickerController _imageController;

  _back() {
    context.router.pop();
  }

  _create() async {
    if(_checkForm()) {
      await context.read<AdUpdateFormCubit>().updateFetch(widget.advert.id);
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
      phone: _phoneController.value.text,
      media: _imageController.value,
      type: widget.type
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
    if(state.formState == EnumFormState.success) {
      context.read<OrderScreenMyCubit>().refresh();
      context.read<OrderScreenDetailsCubit>().fetch(id: widget.advert.id);
      context.router.popUntil((route) => route.settings.name == InitialRouter.name);
      context.router.navigate(InitialRouter(
          children: [
            AdRouter(
                children: [DetailsAdRoute(id: widget.advert.id)]
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
    _advertCategoryController = AdvertCategoryPickerController(category: widget.advert.category);
    _titleController = TextEditingController(text: widget.advert.title);
    _cityController = CityPickerController(city: widget.advert.city);
    _priceController = TextEditingController(text: widget.advert.price.toString());
    _descriptionController = TextEditingController(text: widget.advert.description);
    _phoneController = TextEditingController(text: widget.advert.additionalPhone);
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
                if(widget.type == AdvertType.advert) HeaderAppBar(isBack: true, title: "Edit_ad".tr(),)
                else if(widget.type == AdvertType.service) HeaderAppBar(isBack: true, title: "Edit_service".tr()),
                const SizedBox(height: 30),
                TextFieldApp(controller: _titleController, label: "name_field".tr(), icon: const Icon(Icons.edit)),
                AdvertCategoryPicker(label: "Select_a_category".tr(), controller: _advertCategoryController),
                CityPicker(label: "Choose_city".tr(), controller: _cityController),
                DescriptionFieldApp(label: "Description_of_your_offer".tr(), controller: _descriptionController, icon: const Icon(IconPack.description),),
                NumberFieldApp(label: "Price".tr(), controller: _priceController, icon: const  Icon(Icons.money_sharp),),
                PhoneField(controller: _phoneController, label: "Additional_Phone".tr(), icon: const Icon(Icons.phone),),
                ImageMultiPicker(controller: _imageController),
                // BlocConsumer(builder: builder, listener: listener)
                BlocConsumer<AdUpdateFormCubit, AdUpdateFormState>(
                    listener: _listenerForm,
                    builder: (context, state) {
                      if(state.formState == EnumFormState.fetch) {
                        return ElevatedButtonApp(child: Loader(color: Theme.of(context).colorScheme.background), onPressed: () {},);
                      }
                      return ElevatedButtonApp(text: "Edit".tr(), onPressed: _create,);

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
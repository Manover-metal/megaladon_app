import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:megaladon/core/icons/icons.dart';
import 'package:megaladon/data/models/advert_model.dart';
import 'package:megaladon/data/models/dictionary/advert_type.dart';
import 'package:megaladon/data/models/enum_form_state.dart';
import 'package:megaladon/data/models/form/localizable_error.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/form/update/ad/ad_update_form_cubit.dart';
import 'package:megaladon/logic/screens/orders/my/order_screen_my_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/form/field/description_field.dart';
import 'package:megaladon/presentation/widgets/form/field/number_field.dart';
import 'package:megaladon/presentation/widgets/form/field/phone_field.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/form/multi_picker/media_multi_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/advert_category_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/city_picker.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';

class UpdateAdScreen extends StatefulWidget {
  const UpdateAdScreen({required this.advert, required this.type, super.key});
  final AdvertModel advert;
  final AdvertType type;

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

  void _back() {
    context.router.pop();
  }

  Future<void> _create() async {
    if (_checkForm()) {
      await context.read<AdUpdateFormCubit>().updateFetch(widget.advert.id);
    }
  }

  bool _checkForm() {
    var form = context.read<AdUpdateFormCubit>();
    return form.checkUpdate(
      title: _titleController.value.text,
      description: _descriptionController.value.text,
      price: _priceController.value.text,
      category: _advertCategoryController.value,
      city: _cityController.value,
      phone: _phoneController.value.text,
      media: _imageController.value,
      type: widget.type,
    );
  }

  dynamic _listenerForm(BuildContext context, AdUpdateFormState state) {
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
    if (state.formState == EnumFormState.success) {
      context.read<OrderScreenMyCubit>().refresh();
      context.router
          .popUntil((route) => route.settings.name == InitialRouter.name);
      context.router.navigate(InitialRouter(children: [
        AdRouter(children: [DetailsAdRoute(id: widget.advert.id)])
      ]));
    } else if (state.formState == EnumFormState.error) {
      if (state.error != null) {
        CustomSnackBar.error(
          Text(
            state.error!.messages.isNotEmpty
                ? state.error!.messages.first
                : AppLocalizations.of(context)!.unknown_error,
          ),
        ).view(context);
      }
    }
  }

  final phoneMaskFormatter = MaskTextInputFormatter(
      mask: '+7 (###) ###-##-##',
      filter: {'#': RegExp('[0-9]')},
      type: MaskAutoCompletionType.lazy);

  @override
  void initState() {
    _advertCategoryController =
        AdvertCategoryPickerController(category: widget.advert.category);
    _titleController = TextEditingController(text: widget.advert.title);
    _cityController = CityPickerController(city: widget.advert.city);
    _priceController =
        TextEditingController(text: widget.advert.price.toString());
    _descriptionController =
        TextEditingController(text: widget.advert.description);
    _phoneController = TextEditingController(
        text: phoneMaskFormatter.maskText(widget.advert.additionalPhone ?? ''));
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
  Widget build(BuildContext context) => Scaffold(
        appBar: HeaderAppBar(
            isBack: true,
            title: widget.type == AdvertType.advert
                ? AppLocalizations.of(context)!.edit_ad
                : AppLocalizations.of(context)!.editService),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 30),
                BlocConsumer<AdUpdateFormCubit, AdUpdateFormState>(
                    listener: _listenerForm,
                    builder: (context, state) => Column(
                          children: [
                            TextFieldApp(
                              controller: _titleController,
                              label: AppLocalizations.of(context)!.name_field,
                              icon: const Icon(Icons.edit),
                              errorText: state.title.displayError
                                  ?.localize(AppLocalizations.of(context)!),
                            ),
                            AdvertCategoryPicker(
                                label: AppLocalizations.of(context)!
                                    .select_a_category,
                                controller: _advertCategoryController,
                                errorText: state.category.displayError
                                    ?.localize(AppLocalizations.of(context)!)),
                            CityPicker(
                                label:
                                    AppLocalizations.of(context)!.choose_city,
                                controller: _cityController,
                                errorText: state.city.displayError
                                    ?.localize(AppLocalizations.of(context)!)),
                            DescriptionFieldApp(
                              label: AppLocalizations.of(context)!
                                  .description_of_your_offer,
                              controller: _descriptionController,
                              icon: const Icon(IconPack.description),
                              errorText: state.description.displayError
                                  ?.localize(AppLocalizations.of(context)!),
                            ),
                            NumberFieldApp(
                              label: AppLocalizations.of(context)!.price,
                              controller: _priceController,
                              icon: const Icon(Icons.money_sharp),
                              errorText: state.price.displayError
                                  ?.localize(AppLocalizations.of(context)!),
                            ),
                            PhoneField(
                              controller: _phoneController,
                              label: AppLocalizations.of(context)!
                                  .additional_Phone,
                              icon: const Icon(Icons.phone),
                              errorText: state.phone.displayError
                                  ?.localize(AppLocalizations.of(context)!),
                            ),
                            ImageMultiPicker(controller: _imageController),
                            if (state.formState == EnumFormState.fetch)
                              ElevatedButtonApp(
                                child: Loader(
                                    color:
                                        Theme.of(context).colorScheme.surface),
                                onPressed: () {},
                              )
                            else
                              ElevatedButtonApp(
                                text: AppLocalizations.of(context)!.edit,
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

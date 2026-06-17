import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/core/icons/icons.dart';
import 'package:megaladon/data/models/dictionary/advert_type.dart';
import 'package:megaladon/data/models/enum_form_state.dart';
import 'package:megaladon/data/models/form/localizable_error.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/form/create/ad/ad_create_form_cubit.dart';
import 'package:megaladon/logic/screens/advert/main/advert_screen_main_cubit.dart';
import 'package:megaladon/logic/screens/advert/my/advert_screen_my_cubit.dart';
import 'package:megaladon/logic/screens/orders/my/order_screen_my_cubit.dart';
import 'package:megaladon/logic/screens/service/main/service_screen_main_cubit.dart';
import 'package:megaladon/logic/screens/service/my/service_screen_my_cubit.dart';
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

class CreateAdScreen extends StatefulWidget {
  const CreateAdScreen({required this.type, super.key});

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

  void _back() {
    context.router.pop();
  }

  Future<void> _create() async {
    if (_checkForm()) {
      await context.read<AdCreateFormCubit>().createFetch();
    }
  }

  bool _checkForm() {
    var form = context.read<AdCreateFormCubit>();
    return form.checkCreate(
        title: _titleController.value.text,
        description: _descriptionController.value.text,
        price: _priceController.value.text,
        category: _advertCategoryController.value,
        city: _cityController.value,
        phone: _phoneController.value.text,
        media: _imageController.value,
        type: widget.type);
  }

  dynamic _listenerForm(BuildContext context, AdCreateFormState state) {
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
      if (state.type == AdvertType.service) {
        context.read<ServiceScreenMainCubit>().fetch();
        context.read<ServiceScreenMyCubit>().fetch();
      } else {
        context.read<AdvertScreenMainCubit>().fetch();
        context.read<AdvertScreenMyCubit>().fetch();
      }
      context.router
          .popUntil((route) => route.settings.name == InitialRouter.name);
      context.router.navigate(const InitialRouter(children: [
        AdRouter(children: [MyAdsRoute()])
      ]));
    } else if (state.formState == EnumFormState.error) {
      if (state.error != null) {
        CustomSnackBar.error(
          Text(
            state.error?.messages.isNotEmpty == true
                ? state.error!.messages.first
                : AppLocalizations.of(context)!.unknown_error,
          ),
        ).view(context);
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
    _phoneController = TextEditingController(text: '+7');
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
  Widget build(BuildContext context) => Scaffold(
        appBar: HeaderAppBar(
            isBack: true,
            title: widget.type == AdvertType.advert
                ? AppLocalizations.of(context)!.creating_an_ad
                : AppLocalizations.of(context)!.creating_an_service),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 30),
                BlocConsumer<AdCreateFormCubit, AdCreateFormState>(
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
                            const SizedBox(height: 20),
                            if (state.formState == EnumFormState.fetch)
                              ElevatedButtonApp(
                                child: Loader(
                                    color:
                                        Theme.of(context).colorScheme.surface),
                                onPressed: () {},
                              )
                            else if (widget.type == AdvertType.advert)
                              ElevatedButtonApp(
                                text: AppLocalizations.of(context)!.create_ad,
                                onPressed: _create,
                              )
                            else if (widget.type == AdvertType.service)
                              ElevatedButtonApp(
                                text: AppLocalizations.of(context)!
                                    .create_service,
                                onPressed: _create,
                              )
                            else
                              Container(),
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

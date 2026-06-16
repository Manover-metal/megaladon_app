import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/enum_form_state.dart';
import 'package:megaladon/data/models/form/localizable_error.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/form/create/offer/create_offer_form_cubit.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/form/field/number_field.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/city_picker.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';

class CreateOfferScreen extends StatefulWidget {
  const CreateOfferScreen({required this.orderId, super.key});
  final int orderId;

  @override
  State<CreateOfferScreen> createState() => _CreateOfferScreenState();
}

class _CreateOfferScreenState extends State<CreateOfferScreen> {
  late CityPickerController _cityController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;
  late TextEditingController _priceController;

  void _back() {
    context.router.pop();
  }

  Future<void> _create() async {
    if (_checkForm()) {
      await context.read<CreateOfferFormCubit>().createFetch(widget.orderId);
    }
  }

  bool _checkForm() {
    var form = context.read<CreateOfferFormCubit>();
    return form.checkCreate(
      description: _descriptionController.value.text,
      price: _priceController.value.text,
      city: _cityController.value,
      date: _dateController.value.text,
    );
  }

  void _listenerForm(BuildContext context, CreateOfferFormState state) {
    if (state.formState == EnumFormState.success) {
      CustomSnackBar.success(
        Text(AppLocalizations.of(context)!.responseSent),
      ).view(context);
      context.router.pop();
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
  }

  @override
  void initState() {
    _cityController = CityPickerController();
    _dateController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _cityController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: HeaderAppBar(
            isBack: true,
            title: AppLocalizations.of(context)!
                .responseToOrderId(widget.orderId.toString())),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                BlocConsumer<CreateOfferFormCubit, CreateOfferFormState>(
                    listener: _listenerForm,
                    builder: (context, state) => Column(
                          children: [
                            TextFieldApp(
                              label: AppLocalizations.of(context)!.time_to_work,
                              icon: const Icon(Icons.watch_later_outlined),
                              controller: _dateController,
                              errorText: state.date.displayError
                                  ?.localize(AppLocalizations.of(context)!),
                            ),
                            NumberFieldApp(
                              label: AppLocalizations.of(context)!.price,
                              icon: const Icon(Icons.credit_card),
                              controller: _priceController,
                              errorText: state.price.displayError
                                  ?.localize(AppLocalizations.of(context)!),
                            ),
                            TextFieldApp(
                              label: AppLocalizations.of(context)!
                                  .description_field,
                              icon: const Icon(Icons.message),
                              controller: _descriptionController,
                              errorText: state.description.displayError
                                  ?.localize(AppLocalizations.of(context)!),
                            ),
                            CityPicker(
                                label: AppLocalizations.of(context)!.city,
                                icon: const Icon(Icons.place),
                                controller: _cityController,
                                errorText: state.city.displayError
                                    ?.localize(AppLocalizations.of(context)!)),
                            if (state.formState == EnumFormState.fetch)
                              ElevatedButtonApp(
                                child: Loader(
                                    color:
                                        Theme.of(context).colorScheme.surface),
                                onPressed: () {},
                              )
                            else
                              ElevatedButtonApp(
                                text: AppLocalizations.of(context)!.respond,
                                onPressed: _create,
                              ),
                          ],
                        )),
                OutlinedButtonApp(
                  text: AppLocalizations.of(context)!.cancel,
                  onPressed: _back,
                )
              ],
            ),
          ),
        ),
      );
}

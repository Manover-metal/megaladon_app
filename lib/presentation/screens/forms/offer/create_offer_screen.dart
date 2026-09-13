import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/enum_form_state.dart';
import 'package:megaladon/data/models/form/price_editing_controller.dart';
import 'package:megaladon/data/models/offer_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/form/create/offer/create_offer_form_cubit.dart';
import 'package:megaladon/presentation/widgets/auth/auth_scaffold.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/field/price_field.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/city_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/offer_price_type_picker.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';

/// Отклик на заказ. Собран так же, как экраны регистрации: заголовок с
/// пояснением, поля карточками. Под ценой — за что она: за всю работу или
/// за штуку; это видит заказчик в карточке и на странице отклика.
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
  late PriceEditingController _priceController;

  /// Как умолчание в `order_offers.price_type` — за всю работу.
  OfferPriceType _priceType = OfferPriceType.total;

  Future<void> _create() async {
    final cubit = context.read<CreateOfferFormCubit>();
    if (!cubit.checkCreate(
      description: _descriptionController.value.text,
      price: _priceController.number,
      city: _cityController.value,
      date: _dateController.value.text,
    )) {
      return;
    }

    await cubit.createFetch(widget.orderId, priceType: _priceType);
  }

  // Ошибки полей рисуются под полями, снекбар — только за ответом сервера.
  void _listen(BuildContext context, CreateOfferFormState state) {
    if (state.formState == EnumFormState.success) {
      CustomSnackBar.success(
        Text(AppLocalizations.of(context)!.responseSent),
      ).view(context);
      context.router.pop();
    } else if (state.formState == EnumFormState.error && state.error != null) {
      CustomSnackBar.error(
        Text(
          state.error!.messages.isNotEmpty
              ? state.error!.messages.first
              : AppLocalizations.of(context)!.unknown_error,
        ),
      ).view(context);
    }
  }

  @override
  void initState() {
    _cityController = CityPickerController();
    _dateController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = PriceEditingController();
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<CreateOfferFormCubit, CreateOfferFormState>(
      listenWhen: (a, b) => a.formState != b.formState,
      listener: _listen,
      child: AuthScaffold(
        title: l10n.responseToOrderId(widget.orderId.toString()),
        children: [
          AuthHeading(
            title: l10n.offer_create_title,
            subtitle: l10n.offer_create_subtitle,
          ),
          const SizedBox(height: 20),
          BlocBuilder<CreateOfferFormCubit, CreateOfferFormState>(
            builder: (context, state) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthFieldGroup(
                  children: [
                    PriceFieldApp(
                      label: l10n.price,
                      controller: _priceController,
                      errorText: state.price.displayError?.localize(l10n),
                    ),
                    OfferPriceTypePicker(
                      label: l10n.offerPriceTypeLabel,
                      value: _priceType,
                      onChanged: (type) => setState(() => _priceType = type),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                AuthFieldGroup(
                  title: l10n.conditionsLabel,
                  children: [
                    TextFieldApp(
                      label: l10n.time_to_work,
                      controller: _dateController,
                      errorText: state.date.displayError?.localize(l10n),
                    ),
                    CityPicker(
                      label: l10n.city,
                      controller: _cityController,
                      errorText: state.city.displayError?.localize(l10n),
                    ),
                    TextFieldApp(
                      label: l10n.commentLabel,
                      controller: _descriptionController,
                      errorText:
                          state.description.displayError?.localize(l10n),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          BlocBuilder<CreateOfferFormCubit, CreateOfferFormState>(
            builder: (context, state) {
              if (state.formState == EnumFormState.fetch) {
                return ElevatedButtonApp(
                  onPressed: () {},
                  child: Loader(color: Theme.of(context).colorScheme.surface),
                );
              }
              return ElevatedButtonApp(
                text: l10n.respond,
                onPressed: _create,
              );
            },
          ),
        ],
      ),
    );
  }
}

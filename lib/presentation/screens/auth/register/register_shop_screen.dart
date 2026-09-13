import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:megaladon/data/models/request/params/register/register_store_request_params.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/form/register/register_store/register_store_form_cubit.dart';
import 'package:megaladon/logic/register/register_store/register_store_bloc.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/auth/auth_scaffold.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/field/number_field.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/form/multi_picker/contact_multi_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/city_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/type_picker.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/user_agreement_text.dart';

class RegisterStoreScreen extends StatefulWidget {
  const RegisterStoreScreen({super.key});

  @override
  State<RegisterStoreScreen> createState() => _RegisterStoreScreenState();
}

class _RegisterStoreScreenState extends State<RegisterStoreScreen> {
  late TextEditingController _nameController;
  late TextEditingController _binController;
  late CityPickerController _cityPickerController;
  late TypePickerController _typePickerController;
  late TextEditingController _fullAddressController;
  late ContactTypeMultiPickerController _contactController;

  Future<void> _register() async {
    // Координаты берём один раз за нажатие. Раньше их запрашивали дважды:
    // сначала внутри проверки формы, потом ещё раз перед отправкой.
    final position = await _resolveLocation();
    if (position == null || !mounted) return;
    if (!_checkForm(position)) return;

    context.read<RegisterStoreBloc>().add(RegisterStoreFetchEvent(
          params: RegisterStoreRequestParams(
              name: _nameController.value.text,
              bin: _binController.value.text,
              lat: position.latitude,
              lon: position.longitude,
              fullAddress: _fullAddressController.value.text,
              city: _cityPickerController.value!,
              type: _typePickerController.value!,
              contacts:
                  _contactController.value.map((e) => e.getData()).toList()),
        ));
  }

  // Ошибки полей рисуются под полями, ошибка списка — под его карточкой.
  // Снекбар остаётся за ответом сервера.
  void _listenRegister(BuildContext context, RegisterStoreState state) {
    if (state is RegisterStoreSuccess) {
      unawaited(_openProfile());
    } else if (state is RegisterStoreError) {
      CustomSnackBar.error(
        Text(
          state.error.messages.isNotEmpty
              ? state.error.messages.first
              : AppLocalizations.of(context)!.unknown_error,
        ),
      ).view(context);
    }
  }

  /// Перечитываем профиль, чтобы появилась новая роль и кнопка регистрации
  /// с экрана профиля исчезла.
  Future<void> _openProfile() async {
    final router = context.router;
    await context.read<ProfileScreenCubit>().fetch();
    unawaited(
        router.navigate(const InitialRouter(children: [ProfileRouter()])));
  }

  /// Одна попытка получить координаты. Причина отказа объясняется на языке
  /// приложения — раньше это были захардкоженные русские строки.
  Future<Position?> _resolveLocation() async {
    final l10n = AppLocalizations.of(context)!;

    if (!await Geolocator.isLocationServiceEnabled()) {
      if (mounted) {
        CustomSnackBar.error(Text(l10n.location_service_disabled))
            .view(context);
      }
      return null;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (mounted) {
        CustomSnackBar.error(Text(l10n.location_permission_denied))
            .view(context);
      }
      return null;
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  bool _checkForm(Position position) {
    var form = context.read<RegisterStoreFormCubit>();
    return form.checkRegisterForm(
        name: _nameController.value.text,
        fullAddress: _fullAddressController.value.text,
        bin: _binController.value.text,
        lat: position.latitude.toString(),
        lon: position.longitude.toString(),
        city: _cityPickerController.value,
        type: _typePickerController.value,
        contacts: _contactController.value.map((e) => e.getData()).toList());
  }

  @override
  void initState() {
    _nameController = TextEditingController();
    _fullAddressController = TextEditingController();
    _binController = TextEditingController();
    _cityPickerController = CityPickerController();
    _typePickerController = TypePickerController();
    _contactController = ContactTypeMultiPickerController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fullAddressController.dispose();
    _binController.dispose();
    _cityPickerController.dispose();
    _typePickerController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<RegisterStoreBloc, RegisterStoreState>(
      listener: _listenRegister,
      child: AuthScaffold(
        title: l10n.shop_registration,
        footer: const UserAgreementText(),
        children: [
          AuthHeading(
            title: l10n.shop_registration,
            subtitle: l10n.store_registration_subtitle,
          ),
          const SizedBox(height: 20),
          BlocBuilder<RegisterStoreFormCubit, RegisterStoreFormState>(
            builder: (context, formState) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthFieldGroup(
                  children: [
                    TextFieldApp(
                      label: l10n.names,
                      controller: _nameController,
                      errorText: formState.name.displayError?.localize(l10n),
                    ),
                    TypePicker(
                      label: l10n.type,
                      controller: _typePickerController,
                      errorText: formState.type.displayError?.localize(l10n),
                    ),
                    NumberFieldApp(
                      label: l10n.bIN,
                      controller: _binController,
                      errorText: formState.bin.displayError?.localize(l10n),
                    ),
                    TextFieldApp(
                      label: l10n.full_address,
                      controller: _fullAddressController,
                    ),
                    CityPicker(
                      label: l10n.city,
                      controller: _cityPickerController,
                      errorText: formState.city.displayError?.localize(l10n),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                AuthFieldGroup(
                  title: l10n.contacts,
                  children: [
                    ContactTypeMultiPicker(controller: _contactController),
                  ],
                ),
                if (formState.contacts.displayError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 4),
                    child: Text(
                      formState.contacts.displayError!.localize(l10n),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          AuthNote(
            icon: Icons.location_on_outlined,
            title: l10n.map_point,
            text: l10n.store_location_hint,
          ),
          const SizedBox(height: 20),
          BlocBuilder<RegisterStoreBloc, RegisterStoreState>(
            builder: (context, state) {
              if (state is RegisterStoreLoading) {
                return ElevatedButtonApp(
                  onPressed: () {},
                  child: Loader(color: Theme.of(context).colorScheme.surface),
                );
              }
              return ElevatedButtonApp(
                text: l10n.register,
                onPressed: _register,
              );
            },
          ),
        ],
      ),
    );
  }
}

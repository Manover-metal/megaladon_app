import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:megaladon/data/models/request/params/update/change_store_request_params.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/form/update/store/change_store_form_cubit.dart';
import 'package:megaladon/logic/screens/profile/change_store/change_store_bloc.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/auth/auth_scaffold.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/form/multi_picker/contact_multi_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/city_picker.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';

/// Изменение магазина. Собран так же, как регистрация магазина: заголовок с
/// пояснением, поля карточками, подсказка про геопозицию. БИН здесь не
/// редактируется — поле убрано, а бэкенд без `bin` в запросе оставляет
/// сохранённое значение как есть.
class ChangeStoreScreen extends StatefulWidget {
  const ChangeStoreScreen({super.key});

  @override
  State<ChangeStoreScreen> createState() => _ChangeStoreScreenState();
}

class _ChangeStoreScreenState extends State<ChangeStoreScreen> {
  late TextEditingController _nameController;
  late CityPickerController _cityPickerController;
  late TextEditingController _fullAddressController;
  late ContactTypeMultiPickerController _contactController;

  Future<void> _save() async {
    // Координаты берём один раз за нажатие. Раньше их запрашивали дважды:
    // сначала внутри проверки формы, потом ещё раз перед отправкой.
    final position = await _resolveLocation();
    if (position == null || !mounted) return;
    if (!_checkForm(position)) return;

    context.read<ChangeStoreBloc>().add(ChangeStoreFetchEvent(
          params: ChangeStoreRequestParams(
              name: _nameController.value.text,
              lat: position.latitude,
              lon: position.longitude,
              fullAddress: _fullAddressController.value.text,
              city: _cityPickerController.value!,
              contacts:
                  _contactController.value.map((e) => e.getData()).toList()),
        ));
  }

  // Ошибки полей рисуются под полями, ошибка списка — под его карточкой.
  // Снекбар остаётся за ответом сервера.
  void _listenChange(BuildContext context, ChangeStoreState state) {
    if (state is ChangeStoreSuccess) {
      unawaited(_openProfile());
    } else if (state is ChangeStoreError) {
      CustomSnackBar.error(
        Text(
          state.error.messages.isNotEmpty
              ? state.error.messages.first
              : AppLocalizations.of(context)!.unknown_error,
        ),
      ).view(context);
    }
  }

  /// Перечитываем профиль, чтобы вкладка магазина показала новые данные.
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
    final form = context.read<ChangeStoreFormCubit>();
    return form.checkChangeForm(
        name: _nameController.value.text,
        fullAddress: _fullAddressController.value.text,
        lat: position.latitude.toString(),
        lon: position.longitude.toString(),
        city: _cityPickerController.value,
        contacts: _contactController.value.map((e) => e.getData()).toList());
  }

  @override
  void initState() {
    final store = context.read<ProfileScreenCubit>().state.user?.store;
    _nameController = TextEditingController(text: store?.name);
    _fullAddressController = TextEditingController(text: store?.fullAddress);
    _cityPickerController = CityPickerController(city: store?.city);
    _contactController =
        ContactTypeMultiPickerController(contacts: store?.contacts);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fullAddressController.dispose();
    _cityPickerController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<ChangeStoreBloc, ChangeStoreState>(
      listener: _listenChange,
      child: AuthScaffold(
        title: l10n.change_store,
        children: [
          AuthHeading(
            title: l10n.change_store,
            subtitle: l10n.change_store_subtitle,
          ),
          const SizedBox(height: 20),
          BlocBuilder<ChangeStoreFormCubit, ChangeStoreFormState>(
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
          BlocBuilder<ChangeStoreBloc, ChangeStoreState>(
            builder: (context, state) {
              if (state is ChangeStoreLoading) {
                return ElevatedButtonApp(
                  onPressed: () {},
                  child: Loader(color: Theme.of(context).colorScheme.surface),
                );
              }
              return ElevatedButtonApp(
                text: l10n.save_changes,
                onPressed: _save,
              );
            },
          ),
        ],
      ),
    );
  }
}

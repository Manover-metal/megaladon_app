import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:megaladon/data/models/dictionary/service_type_model.dart';
import 'package:megaladon/data/models/request/params/register/register_executor_request_params.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/form/register/register_executor/register_executor_form_cubit.dart';
import 'package:megaladon/logic/register/register_executor/register_executor_bloc.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/auth/auth_scaffold.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/field/number_field.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/form/multi_picker/order_category_multi_picker.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/user_agreement_text.dart';

class RegisterExecutorScreen extends StatefulWidget {
  const RegisterExecutorScreen({super.key});

  @override
  State<RegisterExecutorScreen> createState() => _RegisterExecutorScreenState();
}

class _RegisterExecutorScreenState extends State<RegisterExecutorScreen> {
  late TextEditingController _nameController;
  late TextEditingController _binController;
  late TextEditingController _fullAddressController;
  late OrderCategoryMultiPickerController _serviceController;

  List<ServiceTypeModel> get _services => _serviceController.value
      .map((e) => ServiceTypeModel(id: e.value.id, name: e.value.name))
      .toList();

  Future<void> _register() async {
    // Координаты берём один раз за нажатие: раньше GPS опрашивался дважды —
    // в проверке формы и ещё раз перед отправкой.
    final position = await _resolveLocation();
    if (position == null || !mounted) return;
    if (!_checkForm(position)) return;

    context.read<RegisterExecutorBloc>().add(RegisterExecutorFetchEvent(
          params: RegisterExecutorRequestParams(
              name: _nameController.value.text,
              bin: _binController.value.text,
              lat: position.latitude,
              lon: position.longitude,
              fullAddress: _fullAddressController.value.text,
              services: _services),
        ));
  }

  // Ошибки полей рисуются под полями, ошибка списка — под его карточкой.
  // Снекбар остаётся за ответом сервера.
  void _listenRegister(BuildContext context, RegisterExecutorState state) {
    if (state is RegisterExecutorSuccess) {
      unawaited(_openProfile());
    } else if (state is RegisterExecutorError) {
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
    var form = context.read<RegisterExecutorFormCubit>();
    return form.checkRegisterForm(
        name: _nameController.value.text,
        fullAddress: _fullAddressController.value.text,
        bin: _binController.value.text,
        lat: position.latitude.toString(),
        lon: position.longitude.toString(),
        services: _services);
  }

  @override
  void initState() {
    _nameController = TextEditingController();
    _fullAddressController = TextEditingController();
    _binController = TextEditingController();
    _serviceController = OrderCategoryMultiPickerController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fullAddressController.dispose();
    _binController.dispose();
    _serviceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<RegisterExecutorBloc, RegisterExecutorState>(
      listener: _listenRegister,
      child: AuthScaffold(
        title: l10n.artist_registration,
        footer: const UserAgreementText(),
        children: [
          AuthHeading(
            title: l10n.artist_registration,
            subtitle: l10n.executor_registration_subtitle,
          ),
          const SizedBox(height: 20),
          BlocBuilder<RegisterExecutorFormCubit, RegisterExecutorFormState>(
            builder: (context, formState) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthFieldGroup(
                  children: [
                    TextFieldApp(
                      label: l10n.name,
                      controller: _nameController,
                      errorText: formState.name.displayError?.localize(l10n),
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
                  ],
                ),
                const SizedBox(height: 20),
                AuthFieldGroup(
                  title: l10n.services,
                  children: [
                    OrderCategoryMultiPicker(controllers: _serviceController),
                  ],
                ),
                if (formState.services.displayError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 4),
                    child: Text(
                      formState.services.displayError!.localize(l10n),
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
            text: l10n.executor_location_hint,
          ),
          const SizedBox(height: 20),
          BlocBuilder<RegisterExecutorBloc, RegisterExecutorState>(
            builder: (context, state) {
              if (state is RegisterExecutorLoading) {
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

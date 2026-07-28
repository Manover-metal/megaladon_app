import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:megaladon/data/models/dictionary/service_type_model.dart';
import 'package:megaladon/data/models/form/localizable_error.dart';
import 'package:megaladon/data/models/request/params/register/register_executor_request_params.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/form/register/register_executor/register_executor_form_cubit.dart';
import 'package:megaladon/logic/register/register_executor/register_executor_bloc.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/field/number_field.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/form/multi_picker/order_category_multi_picker.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';
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

  Future<void> _register() async {
    if (await _checkForm()) {
      var position = await getLocation();
      if (position != null) {
        context.read<RegisterExecutorBloc>().add(RegisterExecutorFetchEvent(
              params: RegisterExecutorRequestParams(
                  name: _nameController.value.text,
                  bin: _binController.value.text,
                  lat: position.latitude,
                  lon: position.longitude,
                  fullAddress: _fullAddressController.value.text,
                  services: _serviceController.value
                      .map((e) =>
                          ServiceTypeModel(id: e.value.id, name: e.value.name))
                      .toList()),
            ));
      }
    }
  }

  dynamic _listenerForm(BuildContext context, RegisterExecutorFormState state) {
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

  void Function(BuildContext context, RegisterExecutorState state)
      _listenRegister(bool isListener) => (context, state) async {
            if (state is RegisterExecutorSuccess) {
              final router = context.router;
              final profileCubit = context.read<ProfileScreenCubit>();
              // Перечитываем профиль, чтобы появился executor и кнопка
              // «зарегистрироваться исполнителем» исчезла.
              await profileCubit.fetch();
              router.navigate(const InitialRouter(children: [ProfileRouter()]));
            } else if (state is RegisterExecutorError && isListener) {
              CustomSnackBar.error(
                Text(
                  state.error.messages.isNotEmpty
                      ? state.error.messages.first
                      : AppLocalizations.of(context)!.unknown_error,
                ),
              ).view(context);
            }
          };

  Future<bool> _checkForm() async {
    var position = await getLocation();

    if (position != null) {
      if (!mounted) return false;
      var form = context.read<RegisterExecutorFormCubit>();
      return form.checkRegisterForm(
          name: _nameController.value.text,
          fullAddress: _fullAddressController.value.text,
          bin: _binController.value.text,
          lat: position.latitude.toString(),
          lon: position.longitude.toString(),
          services: _serviceController.value
              .map((e) => ServiceTypeModel(id: e.value.id, name: e.value.name))
              .toList());
    } else {
      return false;
    }
  }

  Future<Position?> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      CustomSnackBar.error(
        const Text('Отключена геопозиция'),
      ).view(context);
      // Location services are disabled
      return null;
    }

    // Request location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        CustomSnackBar.error(
          const Text('Отключенено разрешение на получение геопозиция'),
        ).view(context);
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      CustomSnackBar.error(
        const Text('Отключенено разрешение на получение геопозиция'),
      ).view(context);
      return null;
    }

    // Get the current position (latitude and longitude)
    var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return position;
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
  Widget build(BuildContext context) => Scaffold(
        body: MultiBlocListener(
          listeners: [
            BlocListener<RegisterExecutorFormCubit, RegisterExecutorFormState>(
              listener: _listenerForm,
            ),
            BlocListener<RegisterExecutorBloc, RegisterExecutorState>(
              listener: _listenRegister(true),
            ),
          ],
          child: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TitleApp(AppLocalizations.of(context)!.artist_registration),
                    const SizedBox(
                      height: 20,
                    ),
                    BlocBuilder<RegisterExecutorFormCubit,
                        RegisterExecutorFormState>(
                      builder: (context, formState) => Column(
                        children: [
                          TextFieldApp(
                            label: AppLocalizations.of(context)!.name,
                            icon: const Icon(Icons.person_add_alt_1),
                            controller: _nameController,
                            errorText: formState.name.displayError
                                ?.localize(AppLocalizations.of(context)!),
                          ),
                          NumberFieldApp(
                            label: AppLocalizations.of(context)!.bIN,
                            icon: const Icon(Icons.wallet),
                            controller: _binController,
                            errorText: formState.bin.displayError
                                ?.localize(AppLocalizations.of(context)!),
                          ),
                          TextFieldApp(
                            label: AppLocalizations.of(context)!.full_address,
                            icon: const Icon(Icons.maps_home_work_outlined),
                            controller: _fullAddressController,
                          ),
                          OrderCategoryMultiPicker(
                              controllers: _serviceController),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<RegisterExecutorBloc, RegisterExecutorState>(
                      builder: (context, state) {
                        if (state is RegisterExecutorLoading) {
                          return ElevatedButtonApp(
                            child: const Loader(
                              color: Colors.black,
                            ),
                            onPressed: () {},
                          );
                        }
                        return ElevatedButtonApp(
                          text: AppLocalizations.of(context)!.register,
                          onPressed: _register,
                        );
                      },
                    ),
                    const UserAgreementText()
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

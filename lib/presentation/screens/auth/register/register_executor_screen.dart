import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:megaladon/data/models/request/params/register/register_executor_request_params.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/form/register/register_executor/register_executor_form_cubit.dart';
import 'package:megaladon/logic/register/register_executor/register_executor_bloc.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/field/number_field.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/form/multi_picker/service_type_multi_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/city_picker.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/snackbars/error_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class RegisterExecutorScreen extends StatefulWidget {
  const RegisterExecutorScreen({super.key});

  @override
  State<RegisterExecutorScreen> createState() => _RegisterExecutorScreenState();
}

class _RegisterExecutorScreenState extends State<RegisterExecutorScreen> {
  late TextEditingController _nameController;
  late TextEditingController _binController;
  late TextEditingController _fullAddressController;
  late ServiceTypeMultiPickerController _serviceController;
  late CityPickerController _cityController;
  late TextEditingController _descriptionController;

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
                  services:
                      _serviceController.value.map((e) => e.value).toList(),
                  description: _descriptionController.value.text,
                  city: _cityController.value),
            ));
      }
    }
  }

  dynamic _listenerForm(BuildContext context, RegisterExecutorFormState state) {
    if (state.status) {
      for (final element in state.props) {
        if (element is FormzInput && element.isNotValid) {
          return showErrorSnackBar(context, element.error.toString());
        }
      }
    }
  }

  Null Function(BuildContext context, RegisterExecutorState state)
      _listenRegister(bool isListener) => (context, state) {
            if (state is RegisterExecutorSuccess) {
              context.router
                  .navigate(const InitialRouter(children: [ProfileRouter()]));
            } else if (state is RegisterExecutorError && isListener) {
              showErrorSnackBar(context, state.error.messages[0]);
            }
          };

  Future<bool> _checkForm() async {
    var position = await getLocation();

    if (position != null) {
      var form = context.read<RegisterExecutorFormCubit>();
      return form.checkRegisterForm(
          name: _nameController.value.text,
          fullAddress: _fullAddressController.value.text,
          bin: _binController.value.text,
          lat: position.latitude.toString(),
          lon: position.longitude.toString(),
          city: _cityController.value,
          description: _descriptionController.value.text,
          services: _serviceController.value.map((e) => e.value).toList());
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
      // Location services are disabled
      showErrorSnackBar(context, 'Отключенена геопозиция');
      return null;
    }

    // Request location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showErrorSnackBar(
            context, 'Отключенено разрешение на получение геопозиция');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showErrorSnackBar(
          context, 'Отключенено разрешение на получение геопозиция');
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
    _serviceController = ServiceTypeMultiPickerController();
    _cityController = CityPickerController();
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fullAddressController.dispose();
    _binController.dispose();
    _serviceController.dispose();
    _descriptionController.dispose();
    _cityController.dispose();
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
                    TextFieldApp(
                      label: AppLocalizations.of(context)!.name,
                      icon: const Icon(Icons.person_add_alt_1),
                      controller: _nameController,
                    ),
                    TextFieldApp(
                      label: AppLocalizations.of(context)!.description,
                      icon: const Icon(Icons.description),
                      controller: _descriptionController,
                    ),
                    NumberFieldApp(
                      label: AppLocalizations.of(context)!.bIN,
                      icon: const Icon(Icons.wallet),
                      controller: _binController,
                    ),
                    CityPicker(
                        label: AppLocalizations.of(context)!.city,
                        controller: _cityController,
                        icon: const Icon(Icons.location_city)),
                    TextFieldApp(
                      label: AppLocalizations.of(context)!.full_address,
                      icon: const Icon(Icons.maps_home_work_outlined),
                      controller: _fullAddressController,
                    ),
                    ServiceTypeMultiPicker(
                        serviceTypeControllers: _serviceController),
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
                    Text.rich(
                      TextSpan(children: [
                        TextSpan(
                            text: AppLocalizations.of(context)!
                                .by_clicking_on_the_Continue_button_you_accept),
                        TextSpan(
                            text: AppLocalizations.of(context)!
                                .user_Agreement_Terms,
                            style: const TextStyle(
                                decoration: TextDecoration.underline))
                      ]),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

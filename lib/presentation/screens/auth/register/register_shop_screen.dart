import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:megaladon/data/models/request/params/register/register_store_request_params.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/form/register/register_store/register_store_form_cubit.dart';
import 'package:megaladon/logic/register/register_store/register_store_bloc.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/field/number_field.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/form/multi_picker/contact_multi_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/city_picker.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class RegisterStoreScreen extends StatefulWidget {
  const RegisterStoreScreen({super.key});

  @override
  State<RegisterStoreScreen> createState() => _RegisterStoreScreenState();
}

class _RegisterStoreScreenState extends State<RegisterStoreScreen> {
  late TextEditingController _nameController;
  late TextEditingController _binController;
  late CityPickerController _cityPickerController;
  late TextEditingController _fullAddressController;
  late ContactTypeMultiPickerController _contactController;

  Future<void> _register() async {
    if (await _checkForm()) {
      var position = await getLocation();
      if (position != null) {
        context.read<RegisterStoreBloc>().add(RegisterStoreFetchEvent(
              params: RegisterStoreRequestParams(
                  name: _nameController.value.text,
                  bin: _binController.value.text,
                  lat: position.latitude,
                  lon: position.longitude,
                  fullAddress: _fullAddressController.value.text,
                  city: _cityPickerController.value,
                  contacts: _contactController.value
                      .map((e) => e.getData())
                      .toList()),
            ));
      }
    }
  }

  dynamic _listenerForm(BuildContext context, RegisterStoreFormState state) {
    if (state.status) {
      for (final element in state.props) {
        if (element is FormzInput && element.isNotValid) {
          return CustomSnackBar.error(
            Text(element.error.toString()),
          ).view(context);
        }
      }
    }
  }

  Null Function(BuildContext context, RegisterStoreState state) _listenRegister(
          bool isListener) =>
      (context, state) {
        if (state is RegisterStoreSuccess) {
          context.router
              .navigate(const InitialRouter(children: [ProfileRouter()]));
        } else if (state is RegisterStoreError && isListener) {
          CustomSnackBar.error(
            Text(
              state.error.messages.isNotEmpty
                  ? state.error.messages.first
                  : AppLocalizations.of(context)!.unknown_error,
            ),
          ).view(context);
        }
      };

  Future<Position?> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      CustomSnackBar.error(
        const Text('Отключена геопозиция'),
      ).view(context);
      return null;
    }

    // Request location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        CustomSnackBar.error(
          const Text('Отключено разрешение на получение геопозиции'),
        ).view(context);
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      CustomSnackBar.error(
        const Text('Отключено разрешение на получение геопозиции'),
      ).view(context);
      return null;
    }

    // Get the current position (latitude and longitude)
    var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return position;
  }

  Future<bool> _checkForm() async {
    var position = await getLocation();
    if (position != null) {
      var form = context.read<RegisterStoreFormCubit>();
      return form.checkRegisterForm(
          name: _nameController.value.text,
          fullAddress: _fullAddressController.value.text,
          bin: _binController.value.text,
          lat: position.latitude.toString(),
          lon: position.longitude.toString(),
          city: _cityPickerController.value,
          contacts: _contactController.value.map((e) => e.getData()).toList());
    } else {
      return false;
    }
  }

  @override
  void initState() {
    _nameController = TextEditingController();
    _fullAddressController = TextEditingController();
    _binController = TextEditingController();
    _cityPickerController = CityPickerController();
    _contactController = ContactTypeMultiPickerController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fullAddressController.dispose();
    _binController.dispose();
    _cityPickerController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: MultiBlocListener(
                listeners: [
                  BlocListener<RegisterStoreFormCubit, RegisterStoreFormState>(
                    listener: _listenerForm,
                  ),
                  BlocListener<RegisterStoreBloc, RegisterStoreState>(
                    listener: _listenRegister(true),
                  ),
                ],
                child: Column(
                  children: [
                    TitleApp(AppLocalizations.of(context)!.shop_registration),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFieldApp(
                      label: AppLocalizations.of(context)!.names,
                      icon: const Icon(Icons.person_add_alt_1),
                      controller: _nameController,
                    ),
                    NumberFieldApp(
                      label: AppLocalizations.of(context)!.bIN,
                      icon: const Icon(Icons.wallet),
                      controller: _binController,
                    ),
                    TextFieldApp(
                      label: AppLocalizations.of(context)!.full_address,
                      icon: const Icon(Icons.maps_home_work_outlined),
                      controller: _fullAddressController,
                    ),
                    CityPicker(
                        label: AppLocalizations.of(context)!.city,
                        controller: _cityPickerController),
                    ContactTypeMultiPicker(
                      controller: _contactController,
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<RegisterStoreBloc, RegisterStoreState>(
                      builder: (context, state) {
                        if (state is RegisterStoreLoading) {
                          return ElevatedButtonApp(
                            child: const Loader(color: Colors.black),
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

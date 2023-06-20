import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:megaladon/data/models/request/params/register/register_store_request_params.dart';
import 'package:megaladon/logic/form/register/register_store/register_store_form_cubit.dart';
import 'package:megaladon/logic/register/register_store/register_store_bloc.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/field/number_field.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/form/multi_picker/contact_multi_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/city_picker.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/snackbars/error_snackbar.dart';
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

  _register() async {

    if(await _checkForm()) {
      Position? position =  await getLocation();
      if(position != null) {
        context.read<RegisterStoreBloc>().add(
          RegisterStoreFetchEvent(
            params: RegisterStoreRequestParams(
              name: _nameController.value.text,
              bin: _binController.value.text,
              lat: position.latitude,
              lon: position.longitude,
              fullAddress: _fullAddressController.value.text,
              city: _cityPickerController.value,
              contacts: _contactController.value.map((e) {
                return e.getData();
              }).toList()
            ),
          )
        );
      }
    }
  }

  _listenerForm(BuildContext context, RegisterStoreFormState state) {
    if(state.status.isInvalid) {
      for (var element in state.props) {
        if(element is FormzInput && element.invalid) {
          return showErrorSnackBar(context, element.error.toString());
        }
      }
    }
  }

  _listenRegister(bool isListener) => (BuildContext context, RegisterStoreState state) {
    if(state is RegisterStoreSuccess) {
      context.router.navigate(const InitialRouter(
          children: [
            ProfileRouter()
          ]
      ));
    } else if(state is RegisterStoreError && isListener) {
      showErrorSnackBar(context, state.error.messages[0]);
    }
  };

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
        showErrorSnackBar(context, 'Отключенено разрешение на получение геопозиция');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showErrorSnackBar(context, 'Отключенено разрешение на получение геопозиция');
      return null;
    }

    // Get the current position (latitude and longitude)
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return position;
  }

  Future<bool> _checkForm() async {
    Position? position =  await getLocation();
    if(position != null) {
      RegisterStoreFormCubit form = context.read<RegisterStoreFormCubit>();
      return form.checkRegisterForm(
          name: _nameController.value.text,
          fullAddress: _fullAddressController.value.text,
          bin: _binController.value.text,
          lat: position.latitude.toString(),
          lon: position.longitude.toString(),
          city: _cityPickerController.value,
          contacts: _contactController.value.map((e) {
            return e.getData();
          }).toList()
      );
    }
    else {
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
  Widget build(BuildContext context) {
    return Scaffold(
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
                  TitleApp("Shop_registration".tr()),
                  const SizedBox(height: 20,),
                  TextFieldApp(
                    label: "Names".tr(),
                    icon: const Icon(Icons.person_add_alt_1),
                    controller: _nameController,
                  ),
                  NumberFieldApp(
                    label: "BIN".tr(),
                    icon: const Icon(Icons.wallet),
                    controller: _binController,
                  ),
                  TextFieldApp(
                    label: "Full_address".tr(),
                    icon: const Icon(Icons.maps_home_work_outlined),
                    controller: _fullAddressController,
                  ),
                  CityPicker(
                      label: "City".tr(),
                      controller: _cityPickerController
                  ),
                  ContactTypeMultiPicker(
                    controller: _contactController,
                  ),
                  const SizedBox(height: 20),

                  BlocBuilder<RegisterStoreBloc, RegisterStoreState>(
                    builder: (context, state) {
                      if (state is RegisterStoreLoading) {
                        return ElevatedButtonApp(
                          child: const Loader(),
                          onPressed: () {},
                        );
                      }
                      return ElevatedButtonApp(
                        text: "Register".tr(),
                        onPressed: _register,
                      );
                    },
                  ),
                   Text.rich(
                      TextSpan(
                          children: [
                            TextSpan(text: "By_clicking_on_the_Continue_button_you_accept".tr()),
                            TextSpan(text: "user_Agreement_Terms".tr(),
                                style: TextStyle(
                                    decoration: TextDecoration.underline
                                )
                            )
                          ]
                      ),
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
}
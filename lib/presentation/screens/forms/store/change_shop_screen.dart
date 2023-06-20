import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:megaladon/data/models/request/params/update/change_store_request_params.dart';
import 'package:megaladon/logic/form/update/store/change_store_form_cubit.dart';
import 'package:megaladon/logic/screens/profile/change_store/change_store_bloc.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/field/number_field.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/form/multi_picker/contact_multi_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/city_picker.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/snackbars/error_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class ChangeStoreScreen extends StatefulWidget {
  const ChangeStoreScreen({super.key});

  @override
  State<ChangeStoreScreen> createState() => _ChangeStoreScreenState();
}

class _ChangeStoreScreenState extends State<ChangeStoreScreen> {
  late TextEditingController _nameController;
  late TextEditingController _binController;
  late CityPickerController _cityPickerController;
  late TextEditingController _fullAddressController;
  late ContactTypeMultiPickerController _contactController;

  _register() async {
    if(await _checkForm()) {
      Position? position = await getLocation();
      if(position != null) {
        context.read<ChangeStoreBloc>().add(
            ChangeStoreFetchEvent(
              params: ChangeStoreRequestParams(
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


  _listenerForm(BuildContext context, ChangeStoreFormState state) {
    if(state.status.isInvalid) {
      for (var element in state.props) {
        if(element is FormzInput && element.invalid) {
          return showErrorSnackBar(context, element.error.toString());
        }
      }
    }
  }

  _listenChange(bool isListener) => (BuildContext context, ChangeStoreState state) {
    if(state is ChangeStoreSuccess) {
      context.router.navigate(const InitialRouter(
          children: [
            ProfileRouter()
          ]
      ));
    } else if(state is ChangeStoreError && isListener) {
      showErrorSnackBar(context, state.error.messages[0]);
    }
  };

  Future<bool> _checkForm() async {
    Position? position = await getLocation();
    if(position != null) {
      ChangeStoreFormCubit form = context.read<ChangeStoreFormCubit>();
      return form.checkChangeForm(
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
    }else {
      return false;
    }

  }

  @override
  void initState() {
    ProfileScreenState state = context.read<ProfileScreenCubit>().state;
    _nameController = TextEditingController(text: state.store?.name);
    _fullAddressController = TextEditingController(text: state.store?.fullAddress);
    _binController = TextEditingController(text: state.store?.bin.toString());
    _cityPickerController = CityPickerController(city: state.store?.city);
    _contactController = ContactTypeMultiPickerController(contacts: state.store?.contacts);
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
                BlocListener<ChangeStoreFormCubit, ChangeStoreFormState>(
                  listener: _listenerForm,
                ),
                BlocListener<ChangeStoreBloc, ChangeStoreState>(
                  listener: _listenChange(true),
                ),
              ],
              child: Column(
                children: [
                  TitleApp('Shop_registration'.tr()),
                  const SizedBox(height: 20,),
                  TextFieldApp(
                    label: 'Names'.tr(),
                    icon: const Icon(Icons.person_add_alt_1),
                    controller: _nameController,
                  ),
                  NumberFieldApp(
                    label: 'BIN'.tr(),
                    icon: const Icon(Icons.wallet),
                    controller: _binController,
                  ),
                  TextFieldApp(
                    label: 'Full_address'.tr(),
                    icon: const Icon(Icons.maps_home_work_outlined),
                    controller: _fullAddressController,
                  ),
                  CityPicker(
                      label: 'City'.tr(),
                      controller: _cityPickerController
                  ),
                  ContactTypeMultiPicker(
                    controller: _contactController,
                  ),
                  const SizedBox(height: 20),

                  BlocBuilder<ChangeStoreBloc, ChangeStoreState>(
                    builder: (context, state) {
                      if (state is ChangeStoreLoading) {
                        return ElevatedButtonApp(
                          child: const Loader(),
                          onPressed: () {},
                        );
                      }
                      return ElevatedButtonApp(
                        text: 'Edit'.tr(),
                        onPressed: _register,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
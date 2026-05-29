import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:megaladon/data/models/request/params/update/change_executor_request_params.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/form/update/executor/change_executor_form_cubit.dart';
import 'package:megaladon/logic/screens/profile/change_executor/change_executor_bloc.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/field/number_field.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/form/multi_picker/service_type_multi_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/city_picker.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/snackbars/error_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class ChangeExecutorScreen extends StatefulWidget {
  const ChangeExecutorScreen({super.key});

  @override
  State<ChangeExecutorScreen> createState() => _ChangeExecutorScreenState();
}

class _ChangeExecutorScreenState extends State<ChangeExecutorScreen> {
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
        context.read<ChangeExecutorBloc>().add(ChangeExecutorFetchEvent(
              params: ChangeExecutorRequestParams(
                  name: _nameController.value.text,
                  bin: _binController.value.text,
                  lat: position.latitude,
                  lon: position.longitude,
                  fullAddress: _fullAddressController.value.text,
                  services:
                      _serviceController.value.map((e) => e.value).toList(),
                  city: _cityController.value,
                  description: _descriptionController.value.text),
            ));
      }
    }
  }

  dynamic _listenerForm(BuildContext context, ChangeExecutorFormState state) {
    if (state.status) {
      for (final element in state.props) {
        if (element is FormzInput && element.isNotValid) {
          return showErrorSnackBar(context, element.error.toString());
        }
      }
    }
  }

  Null Function(BuildContext context, ChangeExecutorState state) _listenChange(
          bool isListener) =>
      (context, state) {
        if (state is ChangeExecutorSuccess) {
          context.router
              .navigate(const InitialRouter(children: [ProfileRouter()]));
        } else if (state is ChangeExecutorError && isListener) {
          showErrorSnackBar(context, state.error.messages[0]);
        }
      };

  Future<bool> _checkForm() async {
    var position = await getLocation();
    if (position != null) {
      var form = context.read<ChangeExecutorFormCubit>();
      return form.checkChangeForm(
          name: _nameController.value.text,
          fullAddress: _fullAddressController.value.text,
          bin: _binController.value.text,
          lat: position.latitude.toString(),
          lon: position.longitude.toString(),
          services: _serviceController.value.map((e) => e.value).toList(),
          city: _cityController.value,
          description: _descriptionController.value.text);
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
    var state = context.read<ProfileScreenCubit>().state;
    _nameController = TextEditingController(text: state.executor?.name);
    _fullAddressController =
        TextEditingController(text: state.executor?.fullAddress);
    _binController = TextEditingController(text: state.executor?.bin);
    _serviceController =
        ServiceTypeMultiPickerController(services: state.executor?.services);
    _descriptionController =
        TextEditingController(text: state.executor?.description);
    _cityController = CityPickerController(city: state.executor?.city);
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
            BlocListener<ChangeExecutorFormCubit, ChangeExecutorFormState>(
              listener: _listenerForm,
            ),
            BlocListener<ChangeExecutorBloc, ChangeExecutorState>(
              listener: _listenChange(true),
            ),
          ],
          child: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TitleApp(
                        AppLocalizations.of(context)!.change_artist_details),
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
                    BlocBuilder<ChangeExecutorBloc, ChangeExecutorState>(
                      builder: (context, state) {
                        if (state is ChangeExecutorLoading) {
                          return ElevatedButtonApp(
                            child: const Loader(),
                            onPressed: () {},
                          );
                        }
                        return ElevatedButtonApp(
                          text: AppLocalizations.of(context)!.edit,
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

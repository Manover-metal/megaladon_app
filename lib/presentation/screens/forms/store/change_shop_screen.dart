import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:megaladon/data/models/form/localizable_error.dart';
import 'package:megaladon/data/models/request/params/update/change_store_request_params.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
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
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';
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

  Future<void> _register() async {
    if (await _checkForm()) {
      var position = await getLocation();
      if (position != null) {
        context.read<ChangeStoreBloc>().add(ChangeStoreFetchEvent(
              params: ChangeStoreRequestParams(
                  name: _nameController.value.text,
                  bin: _binController.value.text,
                  lat: position.latitude,
                  lon: position.longitude,
                  fullAddress: _fullAddressController.value.text,
                  city: _cityPickerController.value!,
                  contacts: _contactController.value
                      .map((e) => e.getData())
                      .toList()),
            ));
      }
    }
  }

  Future<Position?> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      CustomSnackBar.error(
        const Text('Отключенена геопозиция'),
      ).view(context);
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

  dynamic _listenerForm(BuildContext context, ChangeStoreFormState state) {
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

  Null Function(BuildContext context, ChangeStoreState state) _listenChange(
          bool isListener) =>
      (context, state) {
        if (state is ChangeStoreSuccess) {
          context.router
              .navigate(const InitialRouter(children: [ProfileRouter()]));
        } else if (state is ChangeStoreError && isListener) {
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
      var form = context.read<ChangeStoreFormCubit>();
      return form.checkChangeForm(
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
    var state = context.read<ProfileScreenCubit>().state;
    _nameController = TextEditingController(text: state.user?.store?.name);
    _fullAddressController =
        TextEditingController(text: state.user?.store?.fullAddress);
    _binController =
        TextEditingController(text: state.user?.store?.bin.toString());
    _cityPickerController = CityPickerController(city: state.user?.store?.city);
    _contactController =
        ContactTypeMultiPickerController(contacts: state.user?.store?.contacts);
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
        appBar: HeaderAppBar(
          isBack: true,
          title: AppLocalizations.of(context)!.change_store,
        ),
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
                    BlocBuilder<ChangeStoreFormCubit, ChangeStoreFormState>(
                      builder: (context, formState) => Column(
                        children: [
                          TextFieldApp(
                            label: AppLocalizations.of(context)!.names,
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
                          CityPicker(
                              label: AppLocalizations.of(context)!.city,
                              controller: _cityPickerController,
                              errorText: formState.city.displayError
                                  ?.localize(AppLocalizations.of(context)!)),
                          ContactTypeMultiPicker(
                            controller: _contactController,
                          ),
                        ],
                      ),
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

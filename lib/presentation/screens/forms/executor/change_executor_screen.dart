import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:megaladon/data/models/dictionary/order_category_model.dart';
import 'package:megaladon/data/models/dictionary/service_type_model.dart';
import 'package:megaladon/data/models/form/localizable_error.dart';
import 'package:megaladon/data/models/request/params/update/change_executor_request_params.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/form/update/executor/change_executor_form_cubit.dart';
import 'package:megaladon/logic/screens/profile/change_executor/change_executor_bloc.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/field/number_field.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/form/multi_picker/order_category_multi_picker.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';
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
  late OrderCategoryMultiPickerController _serviceController;

  Future<void> _register() async {
    if (await _checkForm()) {
      var position = await getLocation();
      if (position == null) return;
      if (!mounted) return;
      context.read<ChangeExecutorBloc>().add(ChangeExecutorFetchEvent(
            params: ChangeExecutorRequestParams(
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

  dynamic _listenerForm(BuildContext context, ChangeExecutorFormState state) {
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

  Null Function(BuildContext context, ChangeExecutorState state) _listenChange(
          bool isListener) =>
      (context, state) {
        if (state is ChangeExecutorSuccess) {
          context.router
              .navigate(const InitialRouter(children: [ProfileRouter()]));
        } else if (state is ChangeExecutorError && isListener) {
          CustomSnackBar.error(
            Text(state.error.messages.isNotEmpty
                ? state.error.messages.first
                : AppLocalizations.of(context)!.unknown_error),
          ).view(context);
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
      // Location services are disabled
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

  @override
  void initState() {
    var state = context.read<ProfileScreenCubit>().state;
    _nameController = TextEditingController(text: state.user?.executor?.name);
    _fullAddressController =
        TextEditingController(text: state.user?.executor?.fullAddress);
    _binController = TextEditingController(text: state.user?.executor?.bin);
    _serviceController = OrderCategoryMultiPickerController(
        categories: state.user?.executor?.services
            .map((s) => OrderCategoryModel(id: s.id, name: s.name))
            .toList());
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
        appBar: HeaderAppBar(
          isBack: true,
          title: AppLocalizations.of(context)!.change_executor,
        ),
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
                    BlocBuilder<ChangeExecutorFormCubit,
                        ChangeExecutorFormState>(
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

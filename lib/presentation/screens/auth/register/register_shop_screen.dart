import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/request/params/register/register_store_request_params.dart';
import 'package:megaladon/logic/form/register/register_store/register_store_form_cubit.dart';
import 'package:megaladon/logic/register/register_store/register_store_bloc.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/field/double_field.dart';
import 'package:megaladon/presentation/widgets/form/field/number_field.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/form/multi_picker/contact_multi_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/city_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/store_type_picker.dart';
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
  late StoreTypePickerController _storeTypeController;
  late CityPickerController _cityPickerController;
  late TextEditingController _latController;
  late TextEditingController _lonController;
  late TextEditingController _fullAddressController;
  late ContactTypeMultiPickerController _contactController;

  _register() {
    if(_checkForm()) {
      context.read<RegisterStoreBloc>().add(
        RegisterStoreFetchEvent(
          params: RegisterStoreRequestParams(
            name: _nameController.value.text,
            bin: _binController.value.text,
            lat: double.parse(_latController.value.text),
            lon: double.parse(_lonController.value.text),
            fullAddress: _fullAddressController.value.text,
            city: _cityPickerController.value,
            type: _storeTypeController.value,
            contacts: _contactController.value.map((e) {
              return e.getData();
            }).toList()
          ),
        )
      );
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

  _checkForm() {
    RegisterStoreFormCubit form = context.read<RegisterStoreFormCubit>();
    return form.checkRegisterForm(
        name: _nameController.value.text,
        fullAddress: _fullAddressController.value.text,
        bin: _binController.value.text,
        lat: _latController.value.text,
        lon: _lonController.value.text,
        type: _storeTypeController.value,
        city: _cityPickerController.value,
        contacts: _contactController.value.map((e) {
          return e.getData();
        }).toList()
    );
  }

  @override
  void initState() {
    _nameController = TextEditingController();
    _fullAddressController = TextEditingController();
    _binController = TextEditingController();
    _latController = TextEditingController();
    _lonController = TextEditingController();
    _cityPickerController = CityPickerController();
    _storeTypeController = StoreTypePickerController();
    _contactController = ContactTypeMultiPickerController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fullAddressController.dispose();
    _binController.dispose();
    _latController.dispose();
    _lonController.dispose();
    _cityPickerController.dispose();
    _storeTypeController.dispose();
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
                  StoreTypePicker(
                    label: "Type_of_business".tr(),
                    controller: _storeTypeController,
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
                  DoubleFieldApp(
                    label: "Latitude".tr(),
                    icon: const Icon(Icons.place),
                    controller: _latController,
                  ),
                  DoubleFieldApp(
                    label: "Longitude".tr(),
                    icon: const Icon(Icons.place_outlined),
                    controller: _lonController,
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
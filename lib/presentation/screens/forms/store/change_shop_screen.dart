import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/request/params/update/change_store_request_params.dart';
import 'package:megaladon/logic/form/update/store/change_store_form_cubit.dart';
import 'package:megaladon/logic/screens/profile/change_store/change_store_bloc.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';
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

class ChangeStoreScreen extends StatefulWidget {
  const ChangeStoreScreen({super.key});

  @override
  State<ChangeStoreScreen> createState() => _ChangeStoreScreenState();
}

class _ChangeStoreScreenState extends State<ChangeStoreScreen> {
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
      context.read<ChangeStoreBloc>().add(
        ChangeStoreFetchEvent(
          params: ChangeStoreRequestParams(
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

  _checkForm() {
    ChangeStoreFormCubit form = context.read<ChangeStoreFormCubit>();
    return form.checkChangeForm(
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
    ProfileScreenState state = context.read<ProfileScreenCubit>().state;
    _nameController = TextEditingController(text: state.store?.name);
    _fullAddressController = TextEditingController(text: state.store?.fullAddress);
    _binController = TextEditingController(text: state.store?.bin.toString());
    _latController = TextEditingController(text: state.store?.lat.toString());
    _lonController = TextEditingController(text: state.store?.lon.toString());
    _cityPickerController = CityPickerController(city: state.store?.city);
    _storeTypeController = StoreTypePickerController(type: state.store?.type);
    _contactController = ContactTypeMultiPickerController(contacts: state.store?.contacts);
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
                BlocListener<ChangeStoreFormCubit, ChangeStoreFormState>(
                  listener: _listenerForm,
                ),
                BlocListener<ChangeStoreBloc, ChangeStoreState>(
                  listener: _listenChange(true),
                ),
              ],
              child: Column(
                children: [
                  TitleApp('Регистрация магазина'),
                  const SizedBox(height: 20,),
                  TextFieldApp(
                    label: 'Названия',
                    icon: const Icon(Icons.person_add_alt_1),
                    controller: _nameController,
                  ),
                  NumberFieldApp(
                    label: 'БИН',
                    icon: const Icon(Icons.wallet),
                    controller: _binController,
                  ),
                  StoreTypePicker(
                    label: 'Тип бизнеса',
                    controller: _storeTypeController,
                  ),
                  TextFieldApp(
                    label: 'Полный адрес',
                    icon: const Icon(Icons.maps_home_work_outlined),
                    controller: _fullAddressController,
                  ),
                  CityPicker(
                      label: 'Город',
                      controller: _cityPickerController
                  ),
                  DoubleFieldApp(
                    label: 'Широта',
                    icon: const Icon(Icons.place),
                    controller: _latController,
                  ),
                  DoubleFieldApp(
                    label: 'Долгота',
                    icon: const Icon(Icons.place_outlined),
                    controller: _lonController,
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
                        text: 'Изменить',
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
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/request/params/register/register_executor_request_params.dart';
import 'package:megaladon/data/models/request/params/update/change_executor_request_params.dart';
import 'package:megaladon/generated/locale_keys.g.dart';
import 'package:megaladon/logic/form/register/register_executor/register_executor_form_cubit.dart';
import 'package:megaladon/logic/form/update/executor/change_executor_form_cubit.dart';
import 'package:megaladon/logic/register/register_executor/register_executor_bloc.dart';
import 'package:megaladon/logic/screens/profile/change_executor/change_executor_bloc.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/field/double_field.dart';
import 'package:megaladon/presentation/widgets/form/field/number_field.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/form/multi_picker/service_type_multi_picker.dart';
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
  late TextEditingController _latController;
  late TextEditingController _lonController;
  late TextEditingController _fullAddressController;
  late ServiceTypeMultiPickerController _serviceController;

  _register() {
    if(_checkForm()) {
      context.read<ChangeExecutorBloc>().add(ChangeExecutorFetchEvent(
        params: ChangeExecutorRequestParams(
            name: _nameController.value.text,
            bin: _binController.value.text,
            lat: double.parse(_latController.value.text),
            lon: double.parse(_lonController.value.text),
            fullAddress: _fullAddressController.value.text,
            services: _serviceController.value.map((e) => e.value).toList()
          ),
        )
      );
    }
  }

  _listenerForm(BuildContext context, ChangeExecutorFormState state) {
    if(state.status.isInvalid) {
      for (var element in state.props) {
        if(element is FormzInput && element.invalid) {
          return showErrorSnackBar(context, element.error.toString());
        }
      }
    }
  }

  _listenChange(bool isListener) => (BuildContext context, ChangeExecutorState state) {
    if(state is ChangeExecutorSuccess) {
      context.router.navigate(const InitialRouter(
          children: [
            ProfileRouter()
          ]
      ));
    } else if(state is ChangeExecutorError && isListener) {
      showErrorSnackBar(context, state.error.messages[0]);
    }
  };

  _checkForm() {
    ChangeExecutorFormCubit form = context.read<ChangeExecutorFormCubit>();
    return form.checkChangeForm(
        name: _nameController.value.text,
        fullAddress: _fullAddressController.value.text,
        bin: _binController.value.text,
        lat: _latController.value.text,
        lon: _lonController.value.text,
        services: _serviceController.value.map((e) => e.value).toList()
    );
  }

  @override
  void initState() {
    ProfileScreenState state = context.read<ProfileScreenCubit>().state;
    _nameController = TextEditingController(text: state.executor?.name);
    _fullAddressController = TextEditingController(text: state.executor?.fullAddress);
    _binController = TextEditingController(text: state.executor?.bin);
    _latController = TextEditingController(text: state.executor?.lat.toString());
    _lonController = TextEditingController(text: state.executor?.lon.toString());
    _serviceController = ServiceTypeMultiPickerController(services: state.executor?.services);
    super.initState();
  }


  @override
  void dispose() {
    _nameController.dispose();
    _fullAddressController.dispose();
    _binController.dispose();
    _latController.dispose();
    _lonController.dispose();
    _serviceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  const TitleApp('Изменить данные исполнителя'),
                  const SizedBox(height: 20,),
                  TextFieldApp(
                    label: 'Имя',
                    icon: const Icon(Icons.person_add_alt_1),
                    controller: _nameController,
                  ),
                  NumberFieldApp(
                    label: 'БИН',
                    icon: const Icon(Icons.wallet),
                    controller: _binController,
                  ),
                  TextFieldApp(
                    label: 'Полный адрес',
                    icon: const Icon(Icons.maps_home_work_outlined),
                    controller: _fullAddressController,
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
                  ServiceTypeMultiPicker(serviceTypeControllers: _serviceController),

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
// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/request/params/register/register_executor_request_params.dart';
import 'package:megaladon/generated/locale_keys.g.dart';
import 'package:megaladon/logic/form/register/register_executor/register_executor_form_cubit.dart';
import 'package:megaladon/logic/register/register_executor/register_executor_bloc.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/field/double_field.dart';
import 'package:megaladon/presentation/widgets/form/field/number_field.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/snackbars/error_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class RegisterExecutorScreen extends StatefulWidget {

  @override
  State<RegisterExecutorScreen> createState() => _RegisterExecutorScreenState();
}

class _RegisterExecutorScreenState extends State<RegisterExecutorScreen> {
  late TextEditingController _nameController;
  late TextEditingController _binController;
  late TextEditingController _latController;
  late TextEditingController _lonController;
  late TextEditingController _fullAddressController;


  _register() {
    if(_checkForm()) {
      context.read<RegisterExecutorBloc>().add(RegisterExecutorFetchEvent(
        params: RegisterExecutorRequestParams(
            name: _nameController.value.text,
            bin: _binController.value.text,
            lat: double.parse(_latController.value.text),
            lon: double.parse(_lonController.value.text),
            fullAddress: _fullAddressController.value.text
          ),
        )
      );
    }
  }

  _listenerForm(BuildContext context, RegisterExecutorFormState state) {
    if(state.status.isInvalid) {
      if(state.name.invalid) {
        showErrorSnackBar(context, state.name.error.toString());
      } else if(state.bin.invalid) {
        showErrorSnackBar(context, state.bin.error.toString());
      } else if(state.lat.invalid) {
        showErrorSnackBar(context, state.lat.error.toString());
      } else if(state.lon.invalid) {
        showErrorSnackBar(context, state.lon.error.toString());
      }
    }
  }

  _listenRegister(bool isListener) => (BuildContext context, RegisterExecutorState state) {
    if(state is RegisterExecutorSuccess) {
      context.router.replace(ProfileRouter());
    } else if(state is RegisterExecutorError && isListener) {
      showErrorSnackBar(context, state.error.messages[0]);
    }
  };

  _checkForm() {
    RegisterExecutorFormCubit form = context.read<RegisterExecutorFormCubit>();
    return form.checkRegisterForm(
        name: _nameController.value.text,
        fullAddress: _fullAddressController.value.text,
        bin: _binController.value.text,
        lat: _latController.value.text,
        lon: _lonController.value.text,
        services: []
    );
  }

  @override
  void initState() {
    _nameController = TextEditingController();
    _fullAddressController = TextEditingController();
    _binController = TextEditingController();
    _latController = TextEditingController();
    _lonController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  TitleApp('Регистрация исполнителя'),
                  SizedBox(height: 20,),
                  TextFieldApp(
                    label: 'Имя',
                    icon: Icon(Icons.person_add_alt_1),
                    controller: _nameController,
                  ),
                  NumberFieldApp(
                    label: 'БИН',
                    icon: Icon(Icons.wallet),
                    controller: _binController,
                  ),
                  TextFieldApp(
                    label: 'Полный адрес',
                    icon: Icon(Icons.maps_home_work_outlined),
                    controller: _fullAddressController,
                  ),
                  DoubleFieldApp(
                    label: 'Широта',
                    icon: Icon(Icons.place),
                    controller: _latController,
                  ),
                  DoubleFieldApp(
                    label: 'Высота',
                    icon: Icon(Icons.place_outlined),
                    controller: _lonController,
                  ),
                  BlocBuilder<RegisterExecutorBloc, RegisterExecutorState>(
                    builder: (context, state) {
                      if (state is RegisterExecutorLoading) {
                        return ElevatedButtonApp(
                          child: Loader(),
                          onPressed: () {},
                        );
                      }
                      return ElevatedButtonApp(
                        text: LocaleKeys.Register.tr(),
                        onPressed: _register,
                      );
                    },
                  ),
                  Text.rich(
                    TextSpan(
                      // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          TextSpan(
                              text: 'Нажимая на кнопку “Продолжить”, вы принимаете '),
                          TextSpan(text: 'Условия пользовательского соглашения',
                              style: TextStyle(

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
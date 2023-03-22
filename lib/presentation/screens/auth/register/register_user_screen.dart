import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/request/params/register/register_user_request_params.dart';
import 'package:megaladon/generated/locale_keys.g.dart';
import 'package:megaladon/logic/form/register/register_user/register_user_form_cubit.dart';
import 'package:megaladon/logic/register/register_user/register_user_bloc.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/city_picker.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/snackbars/error_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';


class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _passwordVerifyController;
  late CityPickerController _cityController;


  _checkForm() {
    RegisterUserFormCubit form = context.read<RegisterUserFormCubit>();
    return form.checkRegisterForm(
        name: _nameController.value.text,
        phone: _phoneController.value.text,
        password: _passwordController.value.text,
        passwordConfirmation: _passwordVerifyController.value.text
    );
  }

  _listenerForm(BuildContext context, RegisterUserFormState state) {
    if(state.status.isInvalid) {
      for (var element in state.props) {
        if(element is FormzInput && element.invalid) {
          return showErrorSnackBar(context, element.error.toString());
        }
      }
    }
  }

  _listenRegister(bool isListener) => (BuildContext context, RegisterUserState state) {
    if(state is RegisterUserSuccess) {
      String phone = context.read<RegisterUserFormCubit>().state.phone.value;
      context.router.replace(VerifyRoute(phone: phone));
    } else if(state is RegisterUserError && isListener) {
      showErrorSnackBar(context, state.error.messages[0]);
    }
  };

  _register() {
    if(_checkForm()) {
      context.read<RegisterUserBloc>().add(RegisterUserFetchEvent(
          RegisterUserRequestParams(
            name: _nameController.value.text,
            phone: _phoneController.value.text,
            password: _passwordController.value.text,
            passwordConfirmation: _passwordVerifyController.value.text,
            city: _cityController.value
          )
        )
      );
    }
  }

  @override
  void initState() {
    _listenRegister(false)(context, context.read<RegisterUserBloc>().state);
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordVerifyController = TextEditingController();
    _cityController = CityPickerController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _passwordVerifyController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<RegisterUserFormCubit, RegisterUserFormState>(
            listener: _listenerForm,
          ),
          BlocListener<RegisterUserBloc, RegisterUserState>(
            listener: _listenRegister(true),
          ),
        ],
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Spacer(),
                TitleApp("Registration".tr()),
                const SizedBox(height: 20,),
                TextFieldApp(
                  icon: const Icon(Icons.person_add_alt_1),
                  label: "What_is_your_name".tr(),
                  controller: _nameController,
                ),
                TextFieldApp(
                  icon: const Icon(Icons.phone),
                  label: "Your_phone_number".tr(),
                  controller: _phoneController,
                ),
                TextFieldApp(
                  icon: const Icon(Icons.lock),
                  label: "Choose_password".tr(),
                  controller: _passwordController,
                ),
                TextFieldApp(
                  icon: const Icon(Icons.lock),
                  label: "Confirm_the_password".tr(),
                  controller: _passwordVerifyController,
                ),
                CityPicker(
                  icon: const Icon(Icons.location_city),
                  label: "Choose_city".tr(),
                  controller: _cityController,
                ),
                BlocBuilder<RegisterUserBloc, RegisterUserState>(
                  builder: (context, state) {
                    if(state is RegisterUserLoading) {
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
                    children:  [
                      TextSpan(text: "By_clicking_on_the_Continue_button_you_accept".tr()),
                      TextSpan(text: "ser_Agreement_Terms".tr(),
                          style: TextStyle(
                              decoration: TextDecoration.underline
                          )
                      )
                    ],
                    style: Theme.of(context).textTheme.bodySmall
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(flex: 3,),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
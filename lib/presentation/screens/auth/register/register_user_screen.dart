import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/request/params/register/register_user_request_params.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/form/register/register_user/register_user_form_cubit.dart';
import 'package:megaladon/logic/register/register_user/register_user_bloc.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/field/password_field.dart';
import 'package:megaladon/presentation/widgets/form/field/phone_field.dart';
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

  bool _checkForm() {
    var form = context.read<RegisterUserFormCubit>();
    return form.checkRegisterForm(
        name: _nameController.value.text,
        phone: _phoneController.value.text,
        password: _passwordController.value.text,
        passwordConfirmation: _passwordVerifyController.value.text);
  }

  dynamic _listenerForm(BuildContext context, RegisterUserFormState state) {
    if (!state.status) {
      for (final element in state.props) {
        if (element is FormzInput && element.isNotValid) {
          return showErrorSnackBar(context, element.error.toString());
        }
      }
    }
  }

  Null Function(BuildContext context, RegisterUserState state) _listenRegister(
          bool isListener) =>
      (context, state) {
        if (state is RegisterUserSuccess) {
          var phone = context.read<RegisterUserFormCubit>().state.phone.value;
          context.router.replace(VerifyRoute(phone: phone));
        } else if (state is RegisterUserError && isListener) {
          showErrorSnackBar(context, state.error.messages[0]);
        }
      };

  void _register() {
    if (_checkForm()) {
      context.read<RegisterUserBloc>().add(RegisterUserFetchEvent(
          RegisterUserRequestParams(
              name: _nameController.value.text,
              phone: _phoneController.value.text,
              password: _passwordController.value.text,
              passwordConfirmation: _passwordVerifyController.value.text,
              city: _cityController.value)));
    }
  }

  @override
  void initState() {
    _listenRegister(false)(context, context.read<RegisterUserBloc>().state);
    _nameController = TextEditingController();
    _phoneController = TextEditingController(text: '+7');
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
  Widget build(BuildContext context) => Scaffold(
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
                  TitleApp(AppLocalizations.of(context)!.registration),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFieldApp(
                    icon: const Icon(Icons.person_add_alt_1),
                    label: AppLocalizations.of(context)!.what_is_your_name,
                    controller: _nameController,
                  ),
                  PhoneField(
                    icon: const Icon(Icons.phone),
                    label: AppLocalizations.of(context)!.your_phone_number,
                    controller: _phoneController,
                  ),
                  PasswordFieldApp(
                    icon: const Icon(Icons.lock),
                    label: AppLocalizations.of(context)!.choose_password,
                    controller: _passwordController,
                  ),
                  PasswordFieldApp(
                    icon: const Icon(Icons.lock),
                    label: AppLocalizations.of(context)!.confirm_the_password,
                    controller: _passwordVerifyController,
                  ),
                  CityPicker(
                    icon: const Icon(Icons.location_city),
                    label: AppLocalizations.of(context)!.choose_city,
                    controller: _cityController,
                  ),
                  BlocBuilder<RegisterUserBloc, RegisterUserState>(
                    builder: (context, state) {
                      if (state is RegisterUserLoading) {
                        return ElevatedButtonApp(
                          child: const Loader(),
                          onPressed: () {},
                        );
                      }
                      return ElevatedButtonApp(
                        text: AppLocalizations.of(context)!.register,
                        onPressed: _register,
                      );
                    },
                  ),
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(
                          text: AppLocalizations.of(context)!
                              .by_clicking_on_the_Continue_button_you_accept),
                      TextSpan(
                          text: AppLocalizations.of(context)!
                              .user_Agreement_Terms,
                          style: const TextStyle(
                              decoration: TextDecoration.underline))
                    ], style: Theme.of(context).textTheme.bodySmall),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(
                    flex: 3,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

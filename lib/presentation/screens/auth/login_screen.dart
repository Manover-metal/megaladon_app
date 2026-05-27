import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/form/auth/auth_form_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/field/password_field.dart';
import 'package:megaladon/presentation/widgets/form/field/phone_field.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/snackbars/error_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _password;
  late TextEditingController _phone;

  _register() {
    context.router.popAndPush(const RegisterUserRoute());
  }

  _login() {
    if(_checkForm()) {
      context.read<AuthBloc>().add(AuthLoginEvent(
          _phone.value.text,
          _password.value.text
        )
      );
    }
  }

  @override
  void initState() {
    _password = TextEditingController();
    _phone = TextEditingController(text: '+7');
    super.initState();
  }

  _checkForm() {
    AuthFormCubit form = context.read<AuthFormCubit>();
    return form.checkLogin(
        phone: _phone.value.text,
        password: _password.value.text,
    );
  }

  @override
  void dispose() {
    _password.dispose();
    _phone.dispose();
    super.dispose();
  }

  _listenerAuth(BuildContext context, AuthState state) {
    if(state is AuthLoginState) {
      context.router.replaceAll([const InitialRouter(
          children: [
            ProfileRouter()
          ]
      )]);
    } else if(state is AuthErrorState) {
      showErrorSnackBar(context, state.error.messages[0]);
    } else if(state is AuthTransitionVerify) {
      context.router.replace(VerifyRoute(phone: _phone.value.text));
    }
  }

  _listenerForm(BuildContext context, AuthFormState state) {
    if (!state.status) {
      for (var element in state.props) {
        if (element is FormzInput && element.isNotValid) {
          return showErrorSnackBar(context, element.error.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: MultiBlocListener(
            listeners: [
              BlocListener<AuthBloc, AuthState>(listener: _listenerAuth),
              BlocListener<AuthFormCubit, AuthFormState>(listener: _listenerForm)
            ],
            child: Column(
              children: [
                const Spacer(),
                TitleApp("Authorization".tr()),
                // Spacer(),
                const SizedBox(height: 20,),
                PhoneField(
                  icon: const Icon(Icons.person),
                  label: "Your_phone_number".tr(),
                  controller: _phone,
                ),
                PasswordFieldApp(
                  icon: const Icon(Icons.lock),
                  label: "Your_password".tr(),
                  controller: _password,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text("Forgot_your_password".tr(),
                    style: Theme.of(context).textTheme.bodySmall
                  ),
                ),
                const SizedBox(height: 25,),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if(state is AuthLoadingState) {
                      return ElevatedButtonApp(child: Loader(color: Theme.of(context).colorScheme.background), onPressed: (){});
                    }
                    return ElevatedButtonApp(text: "Sign_in".tr(), onPressed: _login);
                  }
                ),
                OutlinedButtonApp(text:"Registration".tr(), onPressed: _register),
                const Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
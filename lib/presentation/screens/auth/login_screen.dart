import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/generated/locale_keys.g.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/form/auth/auth_form_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/snackbars/error_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _password;
  late TextEditingController _phone;

  _register() {
    context.router.popAndPush(RegisterUserRoute());
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
    _phone = TextEditingController();
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
      context.router.navigate(InitialRouter(
          children: [
            ProfileRouter()
          ]
      ));
    } else if(state is AuthErrorState) {
      showErrorSnackBar(context, state.error);
    } else if(state is AuthTransitionVerify) {
      context.router.replace(VerifyRoute(phone: _phone.value.text));
    }
  }

  _listenerForm(BuildContext context, AuthFormState state) {
    if(state.status.isInvalid) {
      if(state.phone.invalid) {
        showErrorSnackBar(context, state.phone.error.toString());
      } else if(state.password.invalid) {
        showErrorSnackBar(context, state.password.error.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          child: MultiBlocListener(
            listeners: [
              BlocListener<AuthBloc, AuthState>(listener: _listenerAuth),
              BlocListener<AuthFormCubit, AuthFormState>(listener: _listenerForm)
            ],
            child: Column(
              children: [
                Spacer(),
                TitleApp(LocaleKeys.Authorization.tr()),
                // Spacer(),
                SizedBox(height: 20,),
                TextFieldApp(
                  icon: Icon(Icons.person),
                  label: LocaleKeys.Your_phone_number.tr(),
                  controller: _phone,
                ),
                TextFieldApp(
                  icon: Icon(Icons.lock),
                  label: LocaleKeys.Your_password.tr(),
                  controller: _password,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(LocaleKeys.Forgot_your_password.tr(),
                    style: Theme.of(context).textTheme.bodySmall
                  ),
                ),
                SizedBox(height: 25,),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if(state is AuthLoadingState) {
                      return ElevatedButtonApp(child: Loader(), onPressed: (){});
                    }
                    return ElevatedButtonApp(text: LocaleKeys.Sign_in.tr(), onPressed: _login);
                  }
                ),
                OutlinedButtonApp(text: LocaleKeys.Registration.tr(), onPressed: _register),
                Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
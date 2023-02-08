import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/form/auth/auth_form_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/text_field.dart';
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
    AuthFormState state = context.read<AuthFormCubit>().state;

    if(state.status.isValidated) {
      context.read<AuthBloc>().add(AuthLoginEvent(state.phone.value, state.password.value));
    }
  }

  _changePassword() {
    context.read<AuthFormCubit>().changePassword(_password.value.text);
  }

  _changeEmail() {
    context.read<AuthFormCubit>().changeEmail(_phone.value.text);
  }

  @override
  void initState() {
    _password = TextEditingController()..addListener(_changePassword);
    _phone = TextEditingController()..addListener(_changeEmail);
    super.initState();
  }

  @override
  void dispose() {
    _password.removeListener(_changePassword);
    _phone.removeListener(_changeEmail);
    _password.dispose();
    _phone.dispose();
    super.dispose();
  }

  _listenerAuth(BuildContext context, AuthState state) => () {
      print(state);
  };

  _listenerForm(BuildContext context, AuthFormState state) => () {
    print(state);
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: MultiBlocListener(
              listeners: [
                BlocListener<AuthBloc, AuthState>(listener: _listenerAuth),
                BlocListener<AuthFormCubit, AuthFormState>(listener: _listenerForm)
              ],
              child: Column(
                children: [
                  TitleApp('Авторизация'),
                  SizedBox(height: 20,),
                  TextFieldApp(
                    label: 'Телефон',
                    controller: _phone,
                  ),
                  TextFieldApp(
                    label: 'Пароль',
                    controller: _password,
                  ),
                  Text('забыли пароль?'),
                  ElevatedButtonApp(text: 'Войти', onPressed: _login),
                  OutlinedButtonApp(text: 'Регистрация', onPressed: _register)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
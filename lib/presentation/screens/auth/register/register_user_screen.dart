import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/logic/form/register/register_user/register_user_form_cubit.dart';
import 'package:megaladon/logic/register/register_user/register_user_bloc.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/snackbars/error_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class RegisterUserScreen extends StatefulWidget {
  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _passwordVerifyController;


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
      if(state.name.invalid) {
        showErrorSnackBar(context, state.name.error.toString());
      } else if(state.phone.invalid) {
        showErrorSnackBar(context, state.phone.error.toString());
      } else if(state.password.invalid) {
        showErrorSnackBar(context, state.password.error.toString());
      } else if(state.passwordConfirmation.invalid) {
        showErrorSnackBar(context, state.passwordConfirmation.error.toString());
      }
    }
  }

  _listenRegister(bool isListener) => (BuildContext context, RegisterUserState state) {
    if(state is RegisterUserSuccess) {
      String phone = context.read<RegisterUserFormCubit>().state.phone.value;
      context.router.replace(VerifyRoute(phone: phone));
    } else if(state is RegisterUserError && isListener) {
      showErrorSnackBar(context, state.error);
    }
  };

  _register() {
    if(_checkForm()) {
      context.read<RegisterUserBloc>().add(RegisterUserFetchEvent(
          _nameController.value.text,
          _phoneController.value.text,
          _passwordController.value.text,
          _passwordController.value.text
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
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _passwordVerifyController.dispose();
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
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Spacer(),
                TitleApp('Регистрация'),
                SizedBox(height: 20,),
                TextFieldApp(
                  icon: Icon(Icons.person_add_alt_1),
                  label: 'Ваше имя',
                  controller: _nameController,
                ),
                TextFieldApp(
                  icon: Icon(Icons.phone),
                  label: 'Телефон',
                  controller: _phoneController,
                ),
                TextFieldApp(
                  icon: Icon(Icons.lock),
                  label: 'Пароль',
                  controller: _passwordController,
                ),
                TextFieldApp(
                  icon: Icon(Icons.lock),
                  label: 'Подтвердите пароль',
                  controller: _passwordVerifyController,
                ),
                BlocBuilder<RegisterUserBloc, RegisterUserState>(
                  builder: (context, state) {
                    if(state is RegisterUserLoading) {
                      return ElevatedButtonApp(
                        child: Loader(),
                        onPressed: () {},
                      );
                    }
                    return ElevatedButtonApp(
                      text: 'Продолжить',
                      onPressed: _register,
                    );

                  },
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'Нажимая на кнопку “Продолжить”, вы принимаете '),
                      TextSpan(text: 'Условия пользовательского соглашения',
                          style: TextStyle(
                              decoration: TextDecoration.underline
                          )
                      )
                    ],
                    style: Theme.of(context).textTheme.bodySmall
                  ),
                  textAlign: TextAlign.center,
                ),
                Spacer(flex: 3,),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
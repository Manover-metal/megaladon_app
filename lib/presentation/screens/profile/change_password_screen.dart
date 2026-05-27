import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/generated/locale_keys.g.dart';
import 'package:megaladon/logic/screens/profile/change_password/change_password_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/field/password_field.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/snackbars/error_snackbar.dart';
import 'package:megaladon/presentation/widgets/snackbars/success_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late TextEditingController _oldPassword;
  late TextEditingController _password;
  late TextEditingController _passwordConfirmation;

  _login() {
    if(_checkForm()) {
      context.read<ChangePasswordCubit>().changePassword(
        oldPassword: _oldPassword.value.text,
        password: _password.value.text,
        passwordConfirmation: _passwordConfirmation.value.text
      );
    }
  }

  @override
  void initState() {
    _password = TextEditingController();
    _oldPassword = TextEditingController();
    _passwordConfirmation = TextEditingController();

    super.initState();
  }

  _checkForm() {
    ChangePasswordCubit form = context.read<ChangePasswordCubit>();
    return form.check(
      oldPassword: _oldPassword.value.text,
      password: _password.value.text,
      passwordConfirmation: _passwordConfirmation.value.text
    );
  }

  @override
  void dispose() {
    _password.dispose();
    _oldPassword.dispose();
    _passwordConfirmation.dispose();
    super.dispose();
  }

  _listenerForm(BuildContext context, ChangePasswordState state) {
    if(state.status == ChangePasswordStatus.success) {
      showSuccessSnackBar(context, "Password_changed_successfully".tr());
      context.router.navigate(const InitialRouter(
          children: [
            ProfileRouter()
          ]
      ));
    } else if(state.status == ChangePasswordStatus.error) {
      return showErrorSnackBar(context, state.error!.messages[0]);
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
              BlocListener<ChangePasswordCubit, ChangePasswordState>(listener: _listenerForm)
            ],
            child: Column(
              children: [
                const Spacer(),
                 TitleApp("Change_password".tr()),
                const SizedBox(height: 20,),
                PasswordFieldApp(
                  icon: const Icon(Icons.lock),
                  label: "Your_password".tr(),
                  controller: _oldPassword,
                ),
                PasswordFieldApp(
                  icon: const Icon(Icons.lock),
                  label: "Choose_password".tr(),
                  controller: _password,
                ),
                PasswordFieldApp(
                  icon: const Icon(Icons.lock),
                  label: "Confirm_the_password".tr(),
                  controller: _passwordConfirmation,
                ),
                const SizedBox(height: 25,),
                BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
                    builder: (context, state) {
                      if(state.status == ChangePasswordStatus.loading) {
                        return ElevatedButtonApp(child: Loader(color: Theme.of(context).colorScheme.background), onPressed: (){});
                      }
                      return ElevatedButtonApp(text: "Edit".tr(), onPressed: _login);
                    }
                ),
                const Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
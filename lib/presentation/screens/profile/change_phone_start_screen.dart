import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/generated/locale_keys.g.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/form/auth/auth_form_cubit.dart';
import 'package:megaladon/logic/screens/profile/change_password/change_password_cubit.dart';
import 'package:megaladon/logic/screens/profile/change_phone/change_phone_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/snackbars/error_snackbar.dart';
import 'package:megaladon/presentation/widgets/snackbars/success_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class ChangePhoneStartScreen extends StatefulWidget {
  const ChangePhoneStartScreen({super.key});

  @override
  State<ChangePhoneStartScreen> createState() => _ChangePhoneStartScreenState();
}

class _ChangePhoneStartScreenState extends State<ChangePhoneStartScreen> {
  late TextEditingController _newPhone;
  late TextEditingController _password;

  _login() {
    if(_checkForm()) {
      context.read<ChangePhoneCubit>().changePhoneStart(
          phone: _newPhone.value.text,
          password: _password.value.text,
      );
    }
  }

  @override
  void initState() {
    _password = TextEditingController();
    _newPhone = TextEditingController();

    super.initState();
  }

  _checkForm() {
    ChangePhoneCubit form = context.read<ChangePhoneCubit>();
    return form.checkStep1(
      phone: _newPhone.value.text,
      password: _password.value.text,
    );
  }

  @override
  void dispose() {
    _password.dispose();
    _newPhone.dispose();
    super.dispose();
  }

  _listenerForm(BuildContext context, ChangePhoneState state) {
    if(state.status == ChangePhoneStatus.success
      || state.status == ChangePhoneStatus.initial2
    ) {
      context.router.popAndPush(const ChangePhoneEndRoute());
    } else if(state.status == ChangePhoneStatus.error) {
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
              BlocListener<ChangePhoneCubit, ChangePhoneState>(listener: _listenerForm)
            ],
            child: Column(
              children: [
                const Spacer(),
                 TitleApp("Изменить номер телефона".tr()),
                const SizedBox(height: 20,),
                TextFieldApp(
                  icon: const Icon(Icons.phone),
                  label: "Новый телефон".tr(),
                  controller: _newPhone,
                ),
                TextFieldApp(
                  icon: const Icon(Icons.lock),
                  label: "Ваш пароль".tr(),
                  controller: _password,
                ),
                const SizedBox(height: 25,),
                BlocBuilder<ChangePhoneCubit, ChangePhoneState>(
                    builder: (context, state) {
                      if(state.status == ChangePhoneStatus.loading) {
                        return ElevatedButtonApp(child: Loader(color: Theme.of(context).colorScheme.background), onPressed: (){});
                      }
                      return ElevatedButtonApp(text: "Отправить код".tr(), onPressed: _login);
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
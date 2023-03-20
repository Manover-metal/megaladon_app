import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/logic/screens/profile/change_phone/change_phone_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/snackbars/error_snackbar.dart';
import 'package:megaladon/presentation/widgets/snackbars/success_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class ChangePhoneEndScreen extends StatefulWidget {
  const ChangePhoneEndScreen({super.key});

  @override
  State<ChangePhoneEndScreen> createState() => _ChangePhoneEndScreenState();
}

class _ChangePhoneEndScreenState extends State<ChangePhoneEndScreen> {
  late TextEditingController _newPhone;
  late TextEditingController _code;

  _login() {
    if(_checkForm()) {
      context.read<ChangePhoneCubit>().changePhoneEnd(
        phone: _newPhone.value.text,
        code: _code.value.text,
      );
    }
  }

  @override
  void initState() {
    _code = TextEditingController();
    _newPhone = TextEditingController();
    super.initState();
  }

  _checkForm() {
    ChangePhoneCubit form = context.read<ChangePhoneCubit>();
    return form.checkStep2(
      phone: _newPhone.value.text,
      code: _code.value.text,
    );
  }

  @override
  void dispose() {
    _code.dispose();
    _newPhone.dispose();
    super.dispose();
  }

  _listenerForm(BuildContext context, ChangePhoneState state) {
    if(state.status == ChangePhoneStatus.success2) {
      showSuccessSnackBar(context, 'Номер телефона успешно изменен');
      context.router.navigate(const InitialRouter(
          children: [
            ProfileRouter()
          ]
      ));
    } else if(state.status == ChangePhoneStatus.error2) {
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
                const TitleApp('Изменить номер телефона'),
                const SizedBox(height: 20,),
                TextFieldApp(
                  icon: const Icon(Icons.phone),
                  label: 'Старый телефон',
                  controller: _newPhone,
                ),
                TextFieldApp(
                  icon: const Icon(Icons.lock),
                  label: 'Код',
                  controller: _code,
                ),

                const SizedBox(height: 25,),
                BlocBuilder<ChangePhoneCubit, ChangePhoneState>(
                    builder: (context, state) {
                      if(state.status == ChangePhoneStatus.loading2) {
                        return ElevatedButtonApp(child: Loader(color: Theme.of(context).colorScheme.background), onPressed: (){});
                      }
                      return ElevatedButtonApp(text: 'Изменить', onPressed: _login);
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
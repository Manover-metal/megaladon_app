import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/form/verify/verify_form_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/loader.dart';
import 'package:megaladon/presentation/widgets/snackbars/error_snackbar.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyScreen extends StatefulWidget {

  final String phone;

  const VerifyScreen({super.key, required this.phone});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  late TextEditingController _pinController;

  bool _checkForm() {
    return context.read<VerifyFormCubit>().checkForm(_pinController.value.text);
  }
  
  _verify() {
    if(_checkForm()) {
      context.read<AuthBloc>().add(AuthVerifyEvent(
        widget.phone,
        _pinController.value.text

      ));
    }
  }
  
  @override
  void initState() {
    _listenerVerify(false);
    _pinController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }
  
  _listenerForm(BuildContext context, VerifyFormState state) {
    if(state.pincode.invalid) showErrorSnackBar(context, state.pincode.error.toString());
  }

  _listenerVerify(bool isListener) => (BuildContext context, AuthState state) {
    if(state is AuthLoginState) {
      context.router.navigate(InitialRouter(
        children: [
          ProfileRouter()
        ]
      ));
    } else if(state is AuthErrorState && isListener) {
      showErrorSnackBar(context, state.error.messages[0]);
    }
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<VerifyFormCubit, VerifyFormState>(
            listener: _listenerForm,
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: _listenerVerify(true),
          )
        ],
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Spacer(),
                TitleApp('Регистрация'),
                SizedBox(height: 20,),
                PinCodeTextField(
                    appContext: context,
                    length: 6,
                    controller: _pinController,
                    backgroundColor: Theme.of(context).colorScheme.onBackground,
                    enableActiveFill: true,
                    pinTheme: PinTheme(
                      fieldOuterPadding: EdgeInsets.zero,
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(10),
                      activeColor: Theme.of(context).colorScheme.secondary,
                      selectedColor: Theme.of(context).colorScheme.secondary,
                      inactiveColor: Theme.of(context).colorScheme.secondary,
                      activeFillColor: Theme.of(context).colorScheme.onBackground,
                      selectedFillColor: Theme.of(context).colorScheme.onBackground,
                      inactiveFillColor: Theme.of(context).colorScheme.onBackground,
                    ), onChanged: (String value) {  },
                ),
                Text('Введите 6-ти значный код из смс'),
                BlocBuilder<AuthBloc,AuthState>(
                  builder: (context, state) {
                    if(state is AuthLoginState) {
                      return ElevatedButtonApp(child: Loader(color: Theme.of(context).colorScheme.background,), onPressed: _verify,);
                    }
                    return ElevatedButtonApp(text: 'Подтвердить', onPressed: _verify,);
                  }
                ),
                OutlinedButtonApp(text: 'Выслать код повторно'),
                Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
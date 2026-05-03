import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
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
  late PinInputController _pinController;

  bool _checkForm() {
    return context.read<VerifyFormCubit>().checkForm(_pinController.text);
  }
  
  _verify() {
    if(_checkForm()) {
      context.read<AuthBloc>().add(AuthVerifyEvent(
        widget.phone,
        _pinController.text

      ));
    }
  }
  
  @override
  void initState() {
    _listenerVerify(false);
    _pinController = PinInputController();
    super.initState();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }
  
  _listenerForm(BuildContext context, VerifyFormState state) {
    if(state.pincode.isNotValid) showErrorSnackBar(context, state.pincode.error.toString());
  }

  _listenerVerify(bool isListener) => (BuildContext context, AuthState state) {
    if(state is AuthLoginState) {
      context.router.navigate(const InitialRouter(
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
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Spacer(),
                TitleApp("Registration".tr()),
                const SizedBox(height: 20,),
                MaterialPinField(
                  pinController: _pinController,
                    length: 6,
                    theme: MaterialPinTheme(
                      borderRadius: BorderRadius.circular(10),
                    ), onChanged: (String value) {  },
                ),
                 Text("Enter_6digit_code_from_SMS".tr()),
                BlocBuilder<AuthBloc,AuthState>(
                  builder: (context, state) {
                    if(state is AuthLoginState) {
                      return ElevatedButtonApp(
                        onPressed: _verify,
                        child: Loader(color: Theme.of(context).colorScheme.background)
                      );
                    }
                    return ElevatedButtonApp(text: "Confirm".tr(), onPressed: _verify,);
                  }
                ),
                OutlinedButtonApp(text: "Send_code_again".tr()),
                const Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
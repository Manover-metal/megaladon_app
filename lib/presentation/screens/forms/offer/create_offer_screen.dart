import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class CreateOfferScreen extends StatelessWidget {

  _back(BuildContext context) => () {
    context.router.pop();
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                HeaderAppBar(isBack: true,),
                TitleApp('Отклик на заказ №321231231'),
                SizedBox(height: 20,),
                TextFieldApp(label: 'Актуален до:', icon: Icon(Icons.calendar_month),),
                TextFieldApp(label: 'Актуален до:', icon: Icon(Icons.watch_later_outlined),),
                TextFieldApp(label: 'Цена:', icon: Icon(Icons.credit_card),),
                TextFieldApp(label: 'Описание работ:', icon: Icon(Icons.message),),
                TextFieldApp(label: 'Город:', icon: Icon(Icons.place),),
                ElevatedButtonApp(
                  text: 'Откликнуться'
                ),
                OutlinedButtonApp(
                  text: 'Отмена',
                  onPressed: _back(context),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class AddAnythingBottomSheet extends StatelessWidget {

  _createAdvert(BuildContext context) => () {
    context.router.navigate(const CreateAdRoute());
  };

  _createOrder(BuildContext context) => () {
    context.router.navigate(const CreateOrderRoute());
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Theme.of(context).colorScheme.background,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            TitleApp('Создать'),
            Divider(thickness: 1,height: 20,),
            ElevatedButtonApp(
              text: 'Объявление',
              onPressed: _createAdvert(context),
            ),
            ElevatedButtonApp(
              text: 'Заказ',
              onPressed: _createOrder(context),
            ),
            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }

}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class AddAnythingBottomSheet extends StatelessWidget {
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
              text: 'Объявление'
            ),
            ElevatedButtonApp(
                text: 'Заказ'
            ),
            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }

}
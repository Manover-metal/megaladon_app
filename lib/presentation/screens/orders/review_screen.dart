import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/form/picker/star_picker.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';
import 'package:megaladon/presentation/widgets/tiles/executor_tile.dart';

class ReviewScreen extends StatelessWidget {

  final OrderModel order;

  const ReviewScreen({super.key, required this.order});

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
                const HeaderAppBar(
                  isBack: true,
                ),
                TitleApp('Отзыв по заказу №1321412313'),
                SizedBox(height: 20,),
                if(order.executor != null) ...[
                  ExecutorTile(executor: order.executor!,),
                  SizedBox(height: 20,),
                ],
                StarPicker(),
                TextFieldApp(label: 'Комментарий по работе',),
                SizedBox(height: 20,),
                ElevatedButtonApp(text: 'Оставить отзыв'),
                OutlinedButtonApp(text: 'Назад', onPressed: _back(context),)

              ],
            ),
          ),
        ),
      ),
    );
  }


}
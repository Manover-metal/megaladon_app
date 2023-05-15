import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('"Заказы" - список размещенных на платформе заказов для поиска лучшего предложения от исполнителей.'),
                Text('"Металлопрокат" - список компаний занимаеющихся продажей готовой продукции.'),
                Text('"+" (Заказ) - создание заказа для поиска исполнителей.'),
                Text('"+" (Услуги) - создание услуг для распространения своих услуг'),
                Text('"+" (Объявление) - создание объявления для продажи товаров или оказание услуг машиностроения.'),
                Text('"Торговая площадка" - список объявлений о продажи товара или оказании услуг машиностроения.'),
                Text('"Профиль" - профиль пользователя.'),

              ],
            ),
          ),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: HeaderAppBar(
                    isBack: true,
                    title: "About_the_application".tr()
                  ),
                )
              )
            ];
          },
        ),

      ),
    );
  }

}
import 'package:flutter/material.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: NestedScrollView(
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '"Заказы" - список размещенных на платформе заказов для поиска лучшего предложения от исполнителей.'),
                    Text(
                        '"Металлопрокат" - список компаний занимаеющихся продажей готовой продукции.'),
                    Text(
                        '"+" (Заказ) - создание заказа для поиска исполнителей.'),
                    Text(
                        '"+" (Услуги) - создание услуг для распространения своих услуг'),
                    Text(
                        '"+" (Объявление) - создание объявления для продажи товаров или оказание услуг машиностроения.'),
                    Text(
                        '"Торговая площадка" - список объявлений о продажи товара или оказании услуг машиностроения.'),
                    Text('"Профиль" - профиль пользователя.'),
                  ],
                ),
              ),
            ),
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: HeaderAppBar(
                    isBack: true,
                    title: AppLocalizations.of(context)!.about_the_application),
              ))
            ],
          ),
        ),
      );
}

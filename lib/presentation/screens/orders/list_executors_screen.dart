import 'package:flutter/material.dart';
import 'package:megaladon/presentation/widgets/card/offer_card.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class ListExecutorsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                HeaderAppBar(
                  isBack: true,
                ),
                TitleApp('Исполнители'),
                SizedBox(height: 20,),

                ...List.generate(3, (index) {
                  return OfferCard();
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

}
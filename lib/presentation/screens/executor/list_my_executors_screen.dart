import 'package:flutter/material.dart';
import 'package:megaladon/presentation/widgets/card/executor_card.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class ListExecutorScreen extends StatelessWidget {
  const ListExecutorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              HeaderAppBar(
                isMenu: true,
              ),
              TitleApp('Исполнители'),
              SizedBox(
                height: 20,
              ),

              Column(
                children: List.generate(6, (index) => ExecutorCard()),
              )
            ],
          ),
        ),
      )),
    );
  }
}

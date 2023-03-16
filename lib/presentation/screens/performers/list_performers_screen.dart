// ignore_for_file: prefer_const_constructors

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/generated/locale_keys.g.dart';
import 'package:megaladon/presentation/screens/performers/detail_performers_screen.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class ListPerformersScreen extends StatelessWidget {
  const ListPerformersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0),
        
          // width: MediaQuery.of(context).size.width,
          // color: Colors.red,
          child: Column(
            children: [
              HeaderAppBar(
                isMenu: true,
              ),
              TitleApp('Исполнители'),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  child: Icon(Icons.filter_alt, size: 30),
                  // onTap: _showFilter,
                ),
              ),

              Column(
                      children: List.generate(6, (index) => DetailPerformersScreen()),
                    )
            ],
          ),
        ),
      )),
    );
  }
}

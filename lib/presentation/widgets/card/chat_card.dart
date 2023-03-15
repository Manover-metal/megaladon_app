// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  // final Image img;
  // final String name;
  // final String time;
  // final String sms;
  const ChatCard({
    super.key,
    // required this.img,
    // required this.name,
    // required this.time,
    // required this.sms
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.symmetric(vertical: 5),
      width: double.infinity,
      // height: MediaQuery.of(context).size.height / 7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.tertiary,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/logo/logo.png'),
                      fit: BoxFit.fill),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  // width: MediaQuery.of(context).size.width - 10,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Дональд Трамп',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Spacer(flex: 1,),
                          Text('24:50'),
                          Icon(Icons.check)
                        ],
                      ),
                      Text(
                          'Видеохотинг, предоставляющий пользователям услуги хранения, доставки и показа видео. ',
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

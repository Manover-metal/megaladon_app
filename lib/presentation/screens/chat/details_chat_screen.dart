import 'package:flutter/material.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class DetailsChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  HeaderAppBar(isBack: true, title: 'Чат с Трамп'),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.height * 0.6,
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            message_one(context),
                            message_tw(context)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(child: TextField()),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).colorScheme.primary
                          ),
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.near_me_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        )),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Row message_tw(BuildContext context) {
    return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  padding: EdgeInsets.all(10),
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10, left: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'Nick Name 2',
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    fontSize: 20,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary,
                                                  ),
                                                ),
                                                Text(
                                                  'заказчик',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Theme.of(context).colorScheme.tertiary,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/logo/logo.png'),
                                                  fit: BoxFit.fill),
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Таким образом, внедрение современных методик предоставляет широкие возможности для форм воздействия. В своём стремлении улучшить пользовательский опыт мы упускаем, что активно развивающиеся страны третьего мира, превозмогая сложившуюся непростую экономическую.',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            '12:32',
                                            style: TextStyle(
                                               color: Theme.of(context).colorScheme.tertiary,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(
                                            Icons.check,
                                            color: Theme.of(context).colorScheme.tertiary,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
  }

  Row message_one(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.tertiary,
            ),
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/logo/logo.png'),
                                                    fit: BoxFit.fill),
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                            ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10 , left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nick Name',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            'исполнитель',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                            ),
                          )
                        ],
                      ),
                    ),
                    
                  ],
                ),
                Text(
                    'Таким образом, внедрение современных методик предоставляет широкие возможности для форм воздействия. В своём стремлении улучшить пользовательский опыт мы упускаем, что активно развивающиеся страны третьего мира, превозмогая сложившуюся непростую экономическую.'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '12:32',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

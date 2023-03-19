import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/presentation/routing/router.dart';

class ChatCard extends StatelessWidget {

  const ChatCard({
    super.key,
  });

  _onTap(BuildContext context) => () {
    context.router.navigate(const DetailsChatRouter());
  };

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onTap(context),
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.symmetric(vertical: 5),
        width: double.infinity,
        // height: MediaQuery.of(context).size.height / 7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.tertiary,
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                      image: AssetImage('assets/logo/logo.png'),
                      fit: BoxFit.fill
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: const [
                      Expanded(
                        child: Text(
                          'Дональд Трамп',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text('24:50'),
                      Icon(Icons.check),
                    ],
                  ),
                  const Text(
                      'Видеохотинг, предоставляющий пользователям услуги хранения, доставки и показа видео. ',
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

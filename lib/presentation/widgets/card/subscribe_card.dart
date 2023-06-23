import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/data/models/dictionary/subscribe_model.dart';
import 'package:megaladon/data/repositories/subscribe_repository.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/snackbars/error_snackbar.dart';
import 'package:megaladon/presentation/widgets/snackbars/success_snackbar.dart';
import 'package:megaladon/presentation/widgets/tiles/data_tile.dart';

class SubscribeCard extends StatelessWidget {

  final SubscribeModel subscribe;

  const SubscribeCard({
    super.key,
    required this.subscribe,
  });

  _onTap(BuildContext context) => () {
    if(subscribe.type == SubscribeType.executor) {
      SubscribeRepository.createForExecutor(subscribe.id).then(_then(context)).catchError(_catch(context));
    } else {
      SubscribeRepository.createForExecutor(subscribe.id).then(_then(context)).catchError(_catch(context));
    }
  };

  _then(BuildContext context) => (val) {
    showSuccessSnackBar(context, 'Вы взяли подписку на ${subscribe.duration} дней');
  };

  _catch(BuildContext context) => (err) {
    if(err is DioError) {
      showErrorSnackBar(context, err.response?.data['message'] ?? 'Неизвестная ошибка');
    } else {
      showErrorSnackBar(context, 'Неизвестная ошибка');
    }
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: double.infinity,
      // height: MediaQuery.of(context).size.height / 7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.tertiary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DataTile(title: 'Price'.tr(), data: subscribe.price.toString()),
          DataTile(title: 'Период'.tr(), data: '${subscribe.duration} дней'),
          SizedBox(height: 10),
          ElevatedButtonApp(
              text: 'Купить',
              onPressed: _onTap(context),
          ),
          // Row(
          //   children: [
          //     Expanded(child: Text('Price'.tr())),
          //     Expanded(child: Text(subscribe.price.toString(), textAlign: TextAlign.end,)),
          //   ],
          // )
        ],
      ),
    );
  }
}

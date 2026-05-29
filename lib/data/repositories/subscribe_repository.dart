import 'package:megaladon/core/dio/index.dart';

class SubscribeRepository {
  static Future createForExecutor(int subscriptionId) =>
      ApiService.I.post('/invoice/executor/create',
          data: {'subscription_id': subscriptionId});

  static Future createForStore(int subscriptionId) => ApiService.I
      .post('/invoice/store/create', data: {'subscription_id': subscriptionId});
}

import 'package:firebase_messaging/firebase_messaging.dart';

class FbNotificationService {

  FbNotificationService();


  static late FirebaseMessaging _instance;

  static Future initialize() async {
    _instance = FirebaseMessaging.instance;
    NotificationSettings settings = await _instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  static FirebaseMessaging get I => _instance;
}
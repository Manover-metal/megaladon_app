import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:megaladon/core/dio/index.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class PusherConfig {
  static const APP_ID = 1612424;
  static const APP_KEY = '490aa92190e5a2d1297a';
  static const APP_SECRET = '6d88e34a02c414bc799b';
  static const APP_CLUSTER = 'eu';

  static const HOST_END_POINT = '';
  static final HOST_AUTH_POINT = "${ApiService.I.options.baseUrl}/auth/pusher-login";
  static const PORT = 6001;
}

class PusherService {
  static late PusherChannelsFlutter _pusher;

  static Future init(String token) async {
    _pusher = PusherChannelsFlutter.getInstance();
    print(token);
    try {
      await _pusher.init(
          apiKey: PusherConfig.APP_KEY,
          authEndpoint: PusherConfig.HOST_AUTH_POINT,
          cluster: PusherConfig.APP_CLUSTER,
          onConnectionStateChange: (currentState, b) {
            print("Connection: $currentState");
          },
          onAuthorizer: (String channelName, String socketID, dynamic options) async {
            print('token: $token, $socketID');
            var result = await http.post(Uri.parse(PusherConfig.HOST_AUTH_POINT),
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer $token',
                },
                body: 'socket_id=$socketID&channel_name=$channelName'
            );
            print('result: $result');
            print(result.body);
            var json = jsonDecode(result.body);
            print(json);
            print(json['auth']);
            return json;
          },
          onSubscriptionError: (String message, dynamic e) {
            print("onSubscriptionError: $message Exception: $e");
          },
          onDecryptionFailure: (String event, String reason) {
            print("onDecryptionFailure: $event reason: $reason");
          },
          onMemberAdded: (String channelName, PusherMember member) {
            print("onMemberAdded: $channelName member: $member");
          },
          onMemberRemoved: (String channelName, PusherMember member) {
            print("onMemberRemoved: $channelName member: $member");
          },
          onEvent: (e) {
            print(e);
          }
      );
    } catch(e) {
      print(e);
    }

  }

  static PusherChannelsFlutter get instance => _pusher;
}
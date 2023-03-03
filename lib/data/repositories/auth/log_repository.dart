import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

class TelegramLogerRepository {
  final TeleDart teledart;
  final String chatId;

  TelegramLogerRepository._(this.teledart, this.chatId);

  static Future<TelegramLogerRepository> initialize() async {

    String telegramBotToken = dotenv.env['TELEGRAM_BOT_TOKEN']!;
    String chatId = dotenv.env['TELEGRAM_CHAT_ID']!;

    final username = (await Telegram(telegramBotToken).getMe()).username;
    TeleDart teledart = TeleDart(telegramBotToken, Event(username!));

    return TelegramLogerRepository._(teledart, chatId);
  }

  sendLog(error, stacktrace) {
    print('error');
    if (kDebugMode) {
      print('aaaa');
      print(error);
    }else {
      teledart.sendMessage(chatId, '$error\n$stacktrace');
    }
  }

  sendMessage(String message) {
    teledart.sendMessage(chatId, message.toString());
  }
}
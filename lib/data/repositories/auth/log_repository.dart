import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

class TelegramLogerRepository {
  TelegramLogerRepository._(this.teledart, this.chatId);
  final TeleDart teledart;
  final String chatId;

  static Future<TelegramLogerRepository> initialize() async {
    var telegramBotToken = dotenv.env['TELEGRAM_BOT_TOKEN']!;
    var chatId = dotenv.env['TELEGRAM_CHAT_ID']!;

    final username = (await Telegram(telegramBotToken).getMe()).username;
    var teledart = TeleDart(telegramBotToken, Event(username!));

    return TelegramLogerRepository._(teledart, chatId);
  }

  void sendLog(error, stacktrace) {
    if (kDebugMode) {
      print(error);
    } else {
      teledart.sendMessage(chatId, '$error\n$stacktrace');
    }
  }

  void sendMessage(String message) {
    teledart.sendMessage(chatId, message.toString());
  }
}

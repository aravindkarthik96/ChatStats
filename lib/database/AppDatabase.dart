import 'dart:async';
import 'package:chat_stats/database/messages/Message.dart';
import 'package:chat_stats/database/emojis/MessageEmojiDao.dart';
import 'package:chat_stats/database/emojis/MessageEmojis.dart';
import 'package:chat_stats/database/messages/MessagesDao.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'AppDatabase.g.dart';

@Database(version: 3, entities: [Message, MessageEmojis])
abstract class AppDatabase extends FloorDatabase {
  MessagesDao get messagesDao;
  MessageEmojiDao get messageEmojiDao;
}


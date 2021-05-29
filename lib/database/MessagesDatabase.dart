import 'dart:async';
import 'package:chat_stats/database/Message.dart';
import 'package:chat_stats/database/MessagesDao.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'messages_database.g.dart';

@Database(version: 1, entities: [Message])
abstract class MessagesDatabase extends FloorDatabase {
  MessagesDao get messagesDao;
}


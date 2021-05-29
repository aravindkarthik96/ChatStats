import 'dart:async';
import 'package:chat_stats/database/Message.dart';
import 'package:chat_stats/database/MessagesDao.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'AppDatabase.g.dart';

@Database(version: 2, entities: [Message])
abstract class AppDatabase extends FloorDatabase {
  MessagesDao get messagesDao;
}


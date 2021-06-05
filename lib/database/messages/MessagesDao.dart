import 'dart:collection';

import 'package:chat_stats/database/messages/Message.dart';
import 'package:floor/floor.dart';

@dao
abstract class MessagesDao {
  @Query("select * from Message")
  Future<List<Message>> getAllMessages();

  @Query("SELECT COUNT(*) FROM Message")
  Future<Iterable<String>?> getMessageCount();

  @Query("select count(*) from Message where senderName = :senderName")
  Future<String?> getMessageCountFor(String senderName);

  @Query("select distinct senderName from Message")
  Future<Iterable<String>?> getParticipants();

  @insert
  Future<void> insertMessage(Message message);

  @insert
  Future<void> insertAllMessage(List<Message> messages);

  @Query("delete from Message")
  Future<void> clearAllMessages();
}
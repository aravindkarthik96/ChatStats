import 'package:chat_stats/database/Message.dart';
import 'package:floor/floor.dart';

abstract class MessagesDao {
  @Query("select * from messages")
  Future<List<Message>> getAllMessages();

  @insert
  Future<void> insertMessage(Message message);
}
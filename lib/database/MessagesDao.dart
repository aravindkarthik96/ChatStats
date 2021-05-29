import 'package:chat_stats/database/Message.dart';
import 'package:floor/floor.dart';

abstract class MessagesDao {
  @Query("select * from Message")
  Future<List<Message>> getAllMessages();

  @insert
  Future<void> insertMessage(Message message);

  @insert
  Future<void> insertAllMessage(List<Message> messages);

  @Query("delete from Message")
  Future<void> clearAllMessages();
}
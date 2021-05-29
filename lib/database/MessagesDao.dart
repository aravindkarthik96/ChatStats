import 'package:chat_stats/database/Message.dart';
import 'package:floor/floor.dart';

@dao
abstract class MessagesDao {
  @Query("select * from Message")
  Future<List<Message>> getAllMessages();

  @Query("select count(*) from Message")
  Future<int?> getMessageCount();

  @Query("select count(*) from Message where senderName = :senderName")
  Future<int?> getMessageCountFor(String senderName);

  @Query("select count(distinct senderName) from Message")
  Future<List<String>> getParticipants();

  @insert
  Future<void> insertMessage(Message message);

  @insert
  Future<void> insertAllMessage(List<Message> messages);

  @Query("delete from Message")
  Future<void> clearAllMessages();
}
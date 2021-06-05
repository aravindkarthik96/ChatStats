import 'dart:collection';

import 'package:chat_stats/database/emojis/MessageEmojis.dart';
import 'package:floor/floor.dart';

@dao
abstract class MessageEmojiDao {
  @Query("delete from MessageEmojis")
  Future<void> clearAllEmojis();

  @Query("SELECT COUNT(distinct emoji) FROM MessageEmojis")
  Future<Map<String, Object>?> getUniqueEmojiCount();

  @Query("SELECT emoji, COUNT(emoji) as count FROM MessageEmojis group by emoji order by count desc")
  Future<Map<String, Object>?> getUsagePerEmoji();

  @Query("select count(*) from MessageEmojis where senderName = :senderName")
  Future<Map<String, Object>?> getMessageCountFor(String senderName);

  @Query("select distinct senderName from MessageEmojis")
  Future<Map<String, Object>?> getParticipants();

  @insert
  Future<void> insertMessageEmojis(List<MessageEmojis> emojis);


}
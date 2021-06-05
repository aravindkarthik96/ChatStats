import 'package:floor/floor.dart';

@entity
class MessageEmojis {
  @primaryKey
  final int emojiID;
  int messageID;
  String messageDate;
  String messageTime;
  String senderName;
  String emoji;

  MessageEmojis(
      this.emojiID,
      this.messageID,
      this.messageDate,
      this.messageTime,
      this.senderName,
      this.emoji
  );
}

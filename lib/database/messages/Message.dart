import 'package:floor/floor.dart';

@entity
class Message {
  @primaryKey
  final int messageID;
  String messageDate;
  String messageTime;
  String senderName;
  String messageText;

  Message(this.messageID, this.messageDate,this.messageTime,this.senderName,this.messageText);
}
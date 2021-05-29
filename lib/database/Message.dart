import 'package:floor/floor.dart';

@entity
class Message {
  @primaryKey
  int messageID;
  String messageDate;
  String messageTime;
  String senderName;
}
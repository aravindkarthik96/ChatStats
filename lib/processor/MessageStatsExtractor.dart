
import 'dart:collection';

import 'package:chat_stats/database/Message.dart';

Future<int?> getTotalMessagesExchanged(db) async {
  var result = await db.database.rawQuery("select count(*) as count from Message");
  print(result);
  var count = result.first["count"];
  print(count);
  return count;
}

Future<List<String>> getParticipants(db) async {
  var result = await db.database.rawQuery("select distinct senderName from Message");
  var participants = "";
  print(result.length);
  List<String> participantsList = [];

  result.forEach((element) {
    print(element.values);
    participantsList.add(element.values.first.toString());
    participants = participants + element.values.first.toString() + " ";
  });

  print(participants);

  return participantsList;
}

String getParticipantsNames(List<String> participants) {
  return (participants.toString().replaceAll("[","")).replaceAll("]", "");
}

Future<int?> getMessageCountForParticipant(participant, db) async {
  var result = await db.database.rawQuery("select count(*) as count from Message where senderName = '$participant'");
  var count = result.first["count"];
  return count as int;
}

Future<String> getOldestTextDate(db) async {
  var result = await getOldestMessage(db);
  print(result);
  var date = result.messageText;
  return date.toString();
}

Future<Message> getOldestMessage(db) async {
  List<Map<String, Object?>> result = await db.database.rawQuery("select * from Message limit 2");
  print(result);
  var messageInList = result[1];

  return Message(messageInList["messageID"] as int,
      messageInList["messageDate"] as String,
      messageInList["messageTime"] as String,
      messageInList["senderName"] as String,
      messageInList["messageText"] as String);
}




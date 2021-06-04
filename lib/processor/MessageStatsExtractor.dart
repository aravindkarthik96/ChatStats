import 'package:chat_stats/database/Message.dart';
import 'package:chat_stats/database/MessageCountOnDay.dart';

Future<int?> getTotalMessagesExchanged(db) async {
  var result =
      await db.database.rawQuery("select count(*) as count from Message");
  print(result);
  var count = result.first["count"];
  print(count);
  return count;
}

Future<List<String>> getParticipants(db) async {
  var result =
      await db.database.rawQuery("select distinct senderName from Message");
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
  return (participants.toString().replaceAll("[", "")).replaceAll("]", "");
}

Future<int?> getMessageCountForParticipant(participant, db) async {
  var result = await db.database.rawQuery(
      "select count(*) as count from Message where senderName = '$participant'");
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
  List<Map<String, Object?>> result =
      await db.database.rawQuery("select * from Message limit 2");
  print(result);
  var messageInList = result[1];

  return Message(
      messageInList["messageID"] as int,
      messageInList["messageDate"] as String,
      messageInList["messageTime"] as String,
      messageInList["senderName"] as String,
      messageInList["messageText"] as String);
}

Future<MessageCountOnDay> getDayWithTheHighestChatCount(db) async {
  List<Map<String, Object?>> data = await db.database.rawQuery(
      "select distinct messageDate, count(*) as count from Message group by messageDate order by count desc");
  print(data);
  //temp, remove
  bookingCountPerDay(db);
  var messageCountOnDay = MessageCountOnDay(
      parseDate(data.first["messageDate"].toString()),
      data.first["count"].toString(),
      data.first["messageDate"].toString());
  return messageCountOnDay;
}

DateTime parseDate(String dateString) {
  // var dateStringClean = dateString.replaceAll("/", "");
  // var date = Jiffy(dateStringClean,"ddmmyy").format("yMMMMd");
  // // return DateFormat("ddmmyy").parse(dateString);
  var split = dateString.split("/");
  var dateTime = DateTime(
      (int.parse(split[2])) + 2000, int.parse(split[1]), int.parse(split[0]));
  print(dateString + " " + dateTime.toString());
  return dateTime;
}

Future<List<MessageCountOnDay>?> bookingCountPerDay(db) async {
  List<Map<String, Object?>> data = await db.database.rawQuery(
      "select distinct messageDate, count(*) as count from Message group by messageDate");
  print(data);
  // List<MessageCountOnDay> list = await compute(getMessageCountList, data);
  return null;
}

Future<List<MessageCountOnDay>> getMessageCountList(
    List<Map<String, Object>> data) async {
  List<MessageCountOnDay> finalList = List.empty(growable: true);

  data.forEach((element) {
    finalList.add(MessageCountOnDay(
        parseDate(data.first["messageDate"].toString()),
        element["messageCount"].toString(),
        data.first["messageDate"].toString()));
  });

  return finalList;
}

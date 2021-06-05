import 'dart:collection';

import 'package:chat_stats/database/AppDatabase.dart';
import 'package:chat_stats/database/messages/Message.dart';
import 'package:chat_stats/database/messages/MessageCountByDay.dart';
import 'package:chat_stats/database/messages/MessageCountOnDay.dart';
import 'package:chat_stats/database/emojis/MessageEmojis.dart';
import 'package:flutter/foundation.dart';

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
  getMessageCountPerDay(db);
  var messageCountOnDay = MessageCountOnDay(
      parseDate(data.first["messageDate"].toString()),
      int.parse(data.first["count"].toString()),
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
  print(split);
  print(dateTime);
  return dateTime;
}

Future<List<MessageCountOnDay>?> getMessageCountPerDay(db) async {
  List<Map<String, Object?>> data = await db.database.rawQuery(
      "select distinct messageDate, count(*) as count from Message group by messageDate");
  print(data);
  var list = await compute(getMessageCountList, data);
  return list;
}

List<MessageCountOnDay> getMessageCountList(List<Map<String, Object?>> data) {
  List<MessageCountOnDay> finalList = List.empty(growable: true);

  data.forEach((element) {
    print(element);
    finalList.add(MessageCountOnDay(
        parseDate(element["messageDate"].toString()),
        int.parse(element["count"].toString()),
        element["messageDate"].toString()));
  });

  return finalList;
}

Future<List<MessageCountOnDayOfWeek>> getMessageCountByDayOfWeek(
    List<MessageCountOnDay> data) async {
  var hashMap = HashMap<String, int>();
  hashMap.putIfAbsent("Sunday", () => 0);
  hashMap.putIfAbsent("Monday", () => 0);
  hashMap.putIfAbsent("Tuesday", () => 0);
  hashMap.putIfAbsent("Wednesday", () => 0);
  hashMap.putIfAbsent("Thursday", () => 0);
  hashMap.putIfAbsent("Friday", () => 0);
  hashMap.putIfAbsent("Saturday", () => 0);

  data.forEach((element) {
    var weekday = element.messageDate.weekday;
    if (weekday == DateTime.sunday) {
      hashMap["Sunday"] = hashMap["Sunday"]! + element.messageCount;
    } else if (weekday == DateTime.monday) {
      hashMap["Monday"] = hashMap["Monday"]! + element.messageCount;
    } else if (weekday == DateTime.tuesday) {
      hashMap["Tuesday"] = hashMap["Tuesday"]! + element.messageCount;
    } else if (weekday == DateTime.wednesday) {
      hashMap["Wednesday"] = hashMap["Wednesday"]! + element.messageCount;
    } else if (weekday == DateTime.thursday) {
      hashMap["Thursday"] = hashMap["Thursday"]! + element.messageCount;
    } else if (weekday == DateTime.friday) {
      hashMap["Friday"] = hashMap["Friday"]! + element.messageCount;
    } else if (weekday == DateTime.saturday) {
      hashMap["Saturday"] = hashMap["Saturday"]! + element.messageCount;
    }
  });
  List<MessageCountOnDayOfWeek> list = [];
  hashMap.forEach((key, value) {
    list.add(MessageCountOnDayOfWeek(key, value));
  });

  return list;
}

var emojiRegex = RegExp(
    "r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'");
RegExp rx = RegExp(
    r'[\p{Extended_Pictographic}\u{1F3FB}-\u{1F3FF}\u{1F9B0}-\u{1F9B3}]',
    unicode: true);

Future<List<MessageEmojis>> getEmojis(AppDatabase db) async {
  final data = await db.messagesDao.getAllMessages();
  print("EXTRACTING EMOJI");
  List<MessageEmojis> messageEmojis = [];
  data.forEach((element) {
    var messageEmojiList =
        rx.allMatches(element.messageText).map((z) => z.group(0)).toList();
    messageEmojiList.forEach((emojis) {
      if (emojis != null) {
        messageEmojis.add(MessageEmojis(
            messageEmojis.length,
            element.messageID,
            element.messageDate,
            element.messageTime,
            element.senderName,
            emojis));
      }
    });
  });
  print("EMOJI: ${messageEmojis.length}");

  return messageEmojis;
}

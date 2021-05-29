import 'dart:io';
import 'package:chat_stats/database/AppDatabase.dart';
import 'package:chat_stats/database/Message.dart';
import 'package:flutter/foundation.dart';

final databaseFuture = $FloorAppDatabase.databaseBuilder('app_database.db').build();


List<Message> loopMessages(List<String> rawList) {
  int index = 0;

  List<Message> messageList = [];

  rawList.forEach((rawMessage) {
    index++;
    var generatedMessage = generateMessage(rawMessage.toString(), index);
    if(generatedMessage != null) {
      messageList.add(generatedMessage);
    }
  });
  return messageList;
}

Message? generateMessage(String rawMessage, int index) {
  print(rawMessage);
  var indexOfDateOpenBracket = rawMessage.toString().indexOf("[", 0);
  var indexOfDateCloseBracket = rawMessage.toString().indexOf("]", 0) + 1;
  var indexOfMessageBeginning =
  rawMessage.toString().indexOf(":", indexOfDateCloseBracket);

  if (indexOfMessageBeginning < 0 ||
      indexOfDateCloseBracket < 0 ||
      indexOfDateOpenBracket < 0) {
    print("Skipping message: $rawMessage");
    return null;
  }

  var messageTimeSection =
  rawMessage.substring(indexOfDateOpenBracket, indexOfDateCloseBracket);
  var senderName = rawMessage.substring(
      indexOfDateCloseBracket + 1, indexOfMessageBeginning);

  var indexOfDateTimeSeparator = messageTimeSection.indexOf(",", 0);

  var messageDate = messageTimeSection.substring(1, indexOfDateTimeSeparator);

  print(messageTimeSection);
  var messageTime = messageTimeSection.substring(
      indexOfDateTimeSeparator + 2, messageTimeSection.indexOf("]", 0));

  print("SenderName: $senderName , MessageDate: $messageDate , MessageTime: $messageTime");

  String messageText = rawMessage.substring(indexOfMessageBeginning, rawMessage.length);
  return Message(index, messageDate, messageTime, senderName, messageText);
}


class MessageProcessor {
   insertMessagesIntoDB(File uploadedFile) async {
    var list = await uploadedFile.readAsLines();
    var db = await databaseFuture;
    var messagesList = await compute(loopMessages,list);
    await db.messagesDao.clearAllMessages();
    await db.messagesDao.insertAllMessage(messagesList).whenComplete(() => {
      print("inserted all records into the DB")
    }).onError((error, stackTrace) =>
      print("failed to insert records")
    );
  }

}

class MessagesMessage {
  AppDatabase database;
  List<String> messageList;

  MessagesMessage(this.database,this.messageList);
}
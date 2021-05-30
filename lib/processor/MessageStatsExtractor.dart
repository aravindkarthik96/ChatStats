
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

Future<int?> getMessageCountForParticipant(participant, db) async {
  var result = await db.database.rawQuery("select count(*) as count from Message where senderName = '$participant'");
  var count = result.first["count"];
  return count as int;
}

Future<String> getOldestText(db) async {
  var result = await db.database.rawQuery("select min(messageDate) as date from Message");
  var date = result.first["date"];
  return date.toString();
}


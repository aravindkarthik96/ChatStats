import 'package:chat_stats/processor/MessageProcessor.dart';
import 'package:chat_stats/processor/MessageStatsExtractor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ViewChatStatsPage extends StatefulWidget {
  final String title;
  ViewChatStatsPage({Key? key, required this.title}) : super(key: key);



  @override
  _ViewChatStatsPage createState() {
    return _ViewChatStatsPage();
  }
}

class _ViewChatStatsPage extends State<ViewChatStatsPage> {

  int? _totalMessagesExchanged = 0;
  String? _chatParticipants;
  String _participantStats = "";

  var _oldestText = "";

  _ViewChatStatsPage() {
    loadData();
  }

  void loadData() async {
    var db = await databaseFuture;


    var messagesDao = db.messagesDao;
    // _totalMessagesExchanged = await getTotalMessagesExchanged(db);
    _totalMessagesExchanged = await getTotalMessagesExchanged(db);
    var participants = await getParticipants(db);
    _chatParticipants = participants.toString();
    _participantStats = "";
    participants.forEach((participant) async {
      var messageCountForParticipant = await getMessageCountForParticipant(participant, db);
      var participantStat = "$participant has sent $messageCountForParticipant messages \n";
      print(participantStat);
      _participantStats = _participantStats + participantStat;
    });

    _oldestText = await getOldestText(db);

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(_chatParticipants.toString()),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Text(
            "Total messages exchanged: \n" +  _totalMessagesExchanged.toString(),
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.start,
            softWrap: true,
          ),
          Text(
            "Participants: \n" + _chatParticipants.toString(),
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.start,
            softWrap: true,
          ),
          Text(
            "Participants stats: \n" + _participantStats.toString(),
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.start,
            softWrap: true,
          ),
          Text(
            "Conversation start date: \n" + _oldestText.toString(),
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.start,
            softWrap: true,
          )
        ],
      ),
    );
  }

}
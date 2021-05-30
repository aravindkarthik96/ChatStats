import 'package:chat_stats/database/Message.dart';
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

  Message? _oldestText;

  _ViewChatStatsPage() {
    loadData();
  }

  void loadData() async {
    var db = await databaseFuture;
    _totalMessagesExchanged = await getTotalMessagesExchanged(db);
    var participants = await getParticipants(db);
    _chatParticipants = getParticipantsNames(participants);
    _participantStats = "";
    participants.forEach((participant) async {
      var messageCountForParticipant = await getMessageCountForParticipant(participant, db);
      var participantStat = "$participant has sent $messageCountForParticipant messages \n";
      print(participantStat);
      _participantStats = _participantStats + participantStat;
    });

    _oldestText = await getOldestMessage(db);

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    var cardMargins = EdgeInsets.fromLTRB(16, 8, 16, 8);
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Chat of " + _chatParticipants.toString()),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: cardMargins,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.send_to_mobile, size: 50,),
                    minLeadingWidth: 16.0,
                    title: Text("Total messages exchanged"),
                    subtitle: Text(_totalMessagesExchanged.toString()),
                  ),
                ],
              ),
            ),
            Card(
              margin: cardMargins,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.people, size: 50),
                    minLeadingWidth: 16.0,
                    title: Text("Participants"),
                    subtitle: Text(_chatParticipants.toString()),
                  ),
                ],
              ),
            ),
            Card(
              margin: cardMargins,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.query_stats, size: 50),
                    minLeadingWidth: 16.0,
                    title: Text("Messages per person"),
                    subtitle: Text(_participantStats.toString()),
                  ),
                ],
              ),
            ),
            Card(
              margin: cardMargins,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.update, size: 50),
                    minLeadingWidth: 16.0,
                    title: Text("Conversation begin date"),
                    subtitle: Text((_oldestText?.messageDate).toString() +" , "+ (_oldestText?.messageTime).toString()),
                  ),
                ],
              ),
            ),
            Card(
              margin: cardMargins,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.add_comment, size: 50),
                    minLeadingWidth: 16.0,
                    title: Text("First Text"),
                    subtitle: Text((_oldestText?.senderName).toString() + (_oldestText?.messageText).toString()),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}
import 'package:chat_stats/database/messages/Message.dart';
import 'package:chat_stats/database/messages/MessageCountByDay.dart';
import 'package:chat_stats/database/messages/MessageCountOnDay.dart';
import 'package:chat_stats/processor/MessageProcessor.dart';
import 'package:chat_stats/processor/MessageStatsExtractor.dart';
import 'package:chat_stats/uicomponents/DailyMessageCountChart.dart';
import 'package:chat_stats/uicomponents/EmojiStatsWidget.dart';
import 'package:chat_stats/uicomponents/MessageCountByDayOfWeekPieChart.dart';
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
  List<MessageCountOnDay> _messageCountOnDayList = [];

  Message? _oldestText;

  MessageCountOnDay? _highestChatCountDate;

  List<MessageCountOnDayOfWeek> _dayOfWeekMessageCount = [];

  _ViewChatStatsPage() {
    loadData();
  }

  void loadData() async {
    var db = await databaseFuture;
    _totalMessagesExchanged = await getTotalMessagesExchanged(db);
    var participants = await getParticipants(db);
    _chatParticipants = getParticipantsDisplayNames(participants);
    _participantStats = "";
    participants.forEach((participant) async {
      var messageCountForParticipant =
          await getMessageCountForParticipant(participant, db);
      var participantStat =
          "$participant has sent $messageCountForParticipant messages \n";
      print(participantStat);
      _participantStats = _participantStats + participantStat;
    });

    _oldestText = await getOldestMessage(db);
    _highestChatCountDate = await getDayWithTheHighestChatCount(db);
    _messageCountOnDayList =
        await getMessageCountPerDay(db) ?? _messageCountOnDayList;
    _dayOfWeekMessageCount =
        await getMessageCountByDayOfWeek(_messageCountOnDayList);
    setState(() {});
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
                    leading: Icon(
                      Icons.send_to_mobile,
                      size: 50,
                    ),
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
                    subtitle: Text((_oldestText?.messageDate).toString() +
                        " , " +
                        (_oldestText?.messageTime).toString()),
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
                    subtitle: Text((_oldestText?.senderName).toString() +
                        (_oldestText?.messageText).toString()),
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
                    leading: Icon(Icons.highlight, size: 50),
                    minLeadingWidth: 16.0,
                    title: Text("Highest number of texts in one day"),
                    subtitle: Text(
                        (_highestChatCountDate?.messageCount).toString() +
                            " texts on " +
                            (_highestChatCountDate?.messageDateString)
                                .toString()
                                .toString()),
                  ),
                ],
              ),
            ),
            Card(
              margin: cardMargins,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.date_range, size: 50),
                    minLeadingWidth: 16.0,
                    title: Text("Message count over time"),
                    subtitle: Text("Message count progression over time"),
                  ),
                  SizedBox(
                    height: 500,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: DailyMessageCountChart.withSampleData(
                          _messageCountOnDayList),
                    ),
                  )
                ],
              ),
            ),
            Card(
              margin: cardMargins,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.date_range, size: 50),
                    minLeadingWidth: 16.0,
                    title: Text("Message count distribution"),
                    subtitle:
                        Text("Insights about your emoji usage"),
                  ),
                  SizedBox(
                    height: 400,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: MessageCountByDayOfWeekPieChart.withSampleData(
                          _dayOfWeekMessageCount),
                    ),
                  )
                ],
              ),
            ),
            EmojiStatsWidget(),
            Padding(padding: const EdgeInsets.all(16.0), child: null)
          ],
        ),
      ),
    );
  }
}

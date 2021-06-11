import 'package:chat_stats/database/emojis/MessageEmojiCounts.dart';
import 'package:chat_stats/processor/MessageProcessor.dart';
import 'package:chat_stats/processor/MessageStatsExtractor.dart';
import 'package:flutter/material.dart';

class EmojiStatsWidget extends StatefulWidget {
  EmojiStatsWidget();

  @override
  _EmojiStatsWidgetState createState() {
    return _EmojiStatsWidgetState();
  }
}

class _EmojiStatsWidgetState extends State<EmojiStatsWidget> {
  var isLoading = true;

  MessageEmojiCountStats _topEmojiStats = MessageEmojiCountStats([], 0);
  List<Widget> topEmojiList = [];
  _EmojiStatsWidgetState() {
    loadData();
  }

  void loadData() async {
    var db = await databaseFuture;
    var emojis = await getEmojis(db);
    var messageEmojiDao = db.messageEmojiDao;
    await messageEmojiDao.clearAllEmojis();
    await messageEmojiDao
        .insertMessageEmojis(emojis)
        .onError((error, stackTrace) => print("Error inserting emojis"+ stackTrace.toString()))
        .then((value) => print("Inserted ${emojis.length} emojis into db"));
    _topEmojiStats = await getTopUsedEmoji(messageEmojiDao,db);
    _topEmojiStats.topEmojisList.forEach((MessageEmojiCount element) {
      topEmojiList.add(
          Row(
            children: [
              Text(element.emoji, style: Theme.of(context).textTheme.headline4),
              Text("  Used " + element.emojiCount.toString() + " times", style: Theme.of(context).textTheme.headline5,),
            ],
          )
      );
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.emoji_emotions, size: 50),
            minLeadingWidth: 16.0,
            title: Text("Emoji stats"),
            subtitle: Text("Fun stats about your emoji usage"),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (isLoading)
                  Center(child: CircularProgressIndicator(color: Colors.green))
                else
                  Column(
                    children: topEmojiList,
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

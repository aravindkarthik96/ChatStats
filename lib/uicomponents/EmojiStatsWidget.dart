import 'package:chat_stats/database/AppDatabase.dart';
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

  _EmojiStatsWidgetState() {
    loadData();
  }

  void loadData() async {
    var db = await databaseFuture;
    var emojis = await getEmojis(db);
    db.messageEmojiDao.insertMessageEmojis(emojis).onError((error, stackTrace) => print("Error inserting emojis"))
        .then((value) => print("Inserted ${emojis.length} emojis into db"));
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.date_range, size: 50),
            minLeadingWidth: 16.0,
            title: Text("Message count distribution"),
            subtitle:
            Text("Message count distribution over days of week"),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if(isLoading) Center(child: CircularProgressIndicator(color: Colors.green)) else Text("EmojiStats"),
              ],
            ),
          )
        ],
      ),
    );
  }
}

import 'package:chat_stats/database/messages/Message.dart';
import 'package:chat_stats/processor/MessageProcessor.dart';
import 'package:chat_stats/processor/MessageStatsExtractor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_smart_reply/flutter_smart_reply.dart';

class ChatBotPage extends StatefulWidget {
  final String title;
  ChatBotPage({Key? key, required this.title}) : super(key: key);

  @override
  _ChatBotPage createState() {
    return _ChatBotPage();
  }
}

class _ChatBotPage extends State<ChatBotPage>{
  List<TextMessage> _textMessages = [];
  _ChatBotPage() {
    // FlutterSmartReply.getSmartReplies();
  }
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("ChatBot"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: 20,
            // shrinkWrap: true,
            padding: EdgeInsets.only(top: 10,bottom: 60),
            physics: RangeMaintainingScrollPhysics(),
            itemBuilder: (context, index){
              return Container(
                padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
                child: Align(
                  alignment: (index % 2 == 0?Alignment.topLeft:Alignment.topRight),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (index % 2 == 0?Colors.grey.shade200:Colors.blue[200]),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Text("Dummy text", style: TextStyle(fontSize: 15),),
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 0,right: 0,bottom: 0,top: 0),
              child: Card(
                elevation: 10,
                // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                child: Container(
                  height: 60,
                  width: double.infinity,
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 24,),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                              hintText: "Write message...",
                              hintStyle: TextStyle(color: Colors.black54),
                              border: InputBorder.none
                          ),
                        ),
                      ),
                      SizedBox(width: 15,),
                      FloatingActionButton(
                        onPressed: (){},
                        child: Icon(Icons.send,color: Colors.white,size: 18,),
                        backgroundColor: Colors.blue,
                        elevation: 0,
                      ),
                    ],

                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

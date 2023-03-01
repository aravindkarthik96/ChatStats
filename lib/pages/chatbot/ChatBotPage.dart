import 'package:chat_stats/processor/MessageProcessor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ChatBotPage extends StatefulWidget {
  ChatBotPage({Key? key}) : super(key: key);

  @override
  _ChatBotPage createState() {
    return _ChatBotPage();
  }
}

class ChatBotMessage {
  String messageTime;
  bool isSender;
  String messageText;
  ChatBotMessage(this.messageTime,this.isSender,this.messageText);
}

class _ChatBotPage extends State<ChatBotPage>{
   final _textBoxController = TextEditingController();
   final _chatFocusNode = FocusNode()..addListener(() {
   });
   final _scrollController = ScrollController();
  List<ChatBotMessage> _textMessages = [];

  _ChatBotPage() {
    loadData();
  }

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
            itemCount: _textMessages.length,
            // shrinkWrap: true,
            controller: _scrollController,
            padding: EdgeInsets.only(top: 10,bottom: 60),
            itemBuilder: (context, index){
              return Container(
                padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
                child: Align(
                  alignment: (_textMessages[index].isSender ?Alignment.topRight:Alignment.topLeft),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (_textMessages[index].isSender?Colors.lightBlueAccent:Colors.grey.shade200),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Text(_textMessages[index].messageText, style: TextStyle(fontSize: 15),),
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
                          controller: _textBoxController,
                          focusNode: _chatFocusNode,
                          decoration: InputDecoration(
                              hintText: "Write message...",
                              hintStyle: TextStyle(color: Colors.black54),
                              border: InputBorder.none
                          ),
                        ),
                      ),
                      SizedBox(width: 15,),
                      FloatingActionButton(
                        onPressed: _sendMessage,
                        child: Icon(Icons.send,color: Colors.white,size: 18,),
                        backgroundColor: Colors.blue,
                        elevation: 20,
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

  void loadData() {
    var db =  databaseFuture;

  }

  void _sendMessage() {
    if(_textBoxController.text.isNotEmpty) {
      print("message sent");
      setState(() {
        _textMessages.add(ChatBotMessage(DateTime.now().toString(), true, _textBoxController.text));
        _textBoxController.text = "";
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent + 10);
  }
}

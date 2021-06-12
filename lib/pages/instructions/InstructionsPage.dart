import 'package:chat_stats/database/messages/Message.dart';
import 'package:chat_stats/processor/MessageProcessor.dart';
import 'package:chat_stats/processor/MessageStatsExtractor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InstructionsPage extends StatefulWidget {
  final String title;
  InstructionsPage({Key? key, required this.title}) : super(key: key);

  @override
  _InstructionsPage createState() {
    return _InstructionsPage();
  }
}

class _InstructionsPage extends State<InstructionsPage>{
  _InstructionsPage() {

  }

  @override
  Widget build(BuildContext context) {
    var cardMargins = EdgeInsets.fromLTRB(16, 8, 16, 8);
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Instructions"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}

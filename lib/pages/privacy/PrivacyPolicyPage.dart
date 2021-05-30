import 'package:chat_stats/database/Message.dart';
import 'package:chat_stats/processor/MessageProcessor.dart';
import 'package:chat_stats/processor/MessageStatsExtractor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PrivacyPolicyPage extends StatefulWidget {
  final String title;
  PrivacyPolicyPage({Key? key, required this.title}) : super(key: key);

  @override
  _PrivacyPolicyPage createState() {
    return _PrivacyPolicyPage();
  }
}

class _PrivacyPolicyPage extends State<PrivacyPolicyPage>{
  _PrivacyPolicyPage() {

  }

  @override
  Widget build(BuildContext context) {
    var cardMargins = EdgeInsets.fromLTRB(16, 8, 16, 8);
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Privacy"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(Icons.privacy_tip, color: Colors.green,size: 50),
              ),
              Text(
                  "Your data is private",
                  style: Theme.of(context).textTheme.headline6
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                    "This app does not and will not be collecting any form of usage data ever, This is a non profit side project created solely out of boredome",
                    style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(Icons.signal_cellular_connected_no_internet_4_bar, color: Colors.green,size: 50),
              ),
              Text(
                  "Dont trust us?",
                  style: Theme.of(context).textTheme.headline6
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "This app does not connect to the internet for any reason what so ever, You can turn off your internet on your device and everything on the app would continue to work normally",
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

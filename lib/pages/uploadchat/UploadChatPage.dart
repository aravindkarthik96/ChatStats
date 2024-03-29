import 'dart:io';

import 'package:chat_stats/database/AppDatabase.dart';
import 'package:chat_stats/pages/chatbot/ChatBotPage.dart';
import 'package:chat_stats/pages/instructions/InstructionsPage.dart';
import 'package:chat_stats/pages/privacy/PrivacyPolicyPage.dart';
import 'package:chat_stats/pages/stats/ViewChatStatsPage.dart';
import 'package:chat_stats/processor/MessageProcessor.dart';
import 'package:chat_stats/processor/MessageStatsExtractor.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';

import 'package:receive_sharing_intent/receive_sharing_intent.dart';

const APP_OPEN_STATE = 0;
const FILE_UPLOADED_STATE = 1;
const PROCESSING_STATE = 2;
const PROCESSING_COMPLETE_STATE = 3;
const VIEW_DATA_STATE = 4;

class UploadChatPage extends StatefulWidget {
  UploadChatPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _UploadChatState createState() => _UploadChatState();
}

class _UploadChatState extends State<UploadChatPage> {
  String _fileUploadStatus = "Upload your chat file";
  String? _fileName;
  List<PlatformFile>? _paths;
  Color _fileUploadIndicatorColor = Colors.grey;
  Color _fabColor = Colors.blue;
  Widget _fabwidget = Icon(Icons.upload_file);

  File? uploadedFile;

  int _currentState = APP_OPEN_STATE;
  StreamSubscription? _intentDataStreamSubscription;
  List<SharedMediaFile>? _sharedFiles;
  String? _sharedText;

  _UploadChatState() {
    print("opening file");
    lookForOldChats();
  }

  void checkReceivedFiles() {
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getMediaStream().listen((List<SharedMediaFile> value) {
          setState(() {
            print("Shared:" + (_sharedFiles?.map((f)=> f.path).join(",") ?? ""));
            _sharedFiles = value;
            _fileName = value.toString();
          });
        }, onError: (err) {
          print("getIntentDataStream error: $err");
        });
  }

  void lookForOldChats() async {
    var db = await databaseFuture;
    var messageCount = await getTotalMessagesExchanged(db);
    if (messageCount != null && messageCount > 0) {
      await setProcessedFileName();
      updateState(PROCESSING_COMPLETE_STATE);
    }
  }

  Future<void> setProcessedFileName() async {
    AppDatabase db = await databaseFuture;
    var participants = await getParticipants(db);
    setState(() {
      _fileName = "Chat of ${getParticipantsDisplayNames(participants)}";
    });
  }

  void _fabPressed() {
    if (_currentState == FILE_UPLOADED_STATE) {
      _processChat();
    } else if (_currentState == APP_OPEN_STATE) {
      _openFileExplorer();
    } else if (_currentState == PROCESSING_STATE) {
    } else if (_currentState == PROCESSING_COMPLETE_STATE) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ViewChatStatsPage(title: widget.title)),
      );
    }
  }

  void _openChatBot() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ChatBotPage()),
    );
  }

  @override
  void initState() {
    super.initState();

    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
          setState(() {
            _fileName = value;
          });
        }, onError: (err) {
          print("getLinkStream error: $err");
        });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription?.cancel();
    super.dispose();
  }

  void _reset() {
    updateState(APP_OPEN_STATE);
  }

  void _openInstructions() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => InstructionsPage(title: widget.title)),
    );
  }

  void _openPrivacyPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PrivacyPolicyPage(title: widget.title)),
    );
  }

  void updateState(int newState) {
    setState(() {
      if (newState == APP_OPEN_STATE) {
        _fileUploadStatus = "Upload your chat file";
        _fileUploadIndicatorColor = Colors.grey;
        _fabColor = Colors.grey;
        _fabwidget = Icon(Icons.upload_file);
        uploadedFile = null;
        _fileName = "";
        _paths = null;
      } else if (newState == FILE_UPLOADED_STATE) {
        _fileUploadStatus = "File Selected";
        _fileUploadIndicatorColor = Colors.blue;
        _fabColor = Colors.blue;
        _fabwidget = Icon(Icons.play_arrow);
      } else if (newState == PROCESSING_STATE) {
        _fileUploadStatus = "Processing your chat";
        _fabwidget = CircularProgressIndicator(color: Colors.white);
        _fileUploadIndicatorColor = Colors.orange;
        _fabColor = Colors.orange;
      } else if (newState == PROCESSING_COMPLETE_STATE) {
        _fileUploadStatus = "Successfully processed your chat";
        _fileUploadIndicatorColor = Colors.green;
        _fabColor = Colors.green;
        _fabwidget = Icon(Icons.bar_chart_sharp);
        setProcessedFileName();
      } else if (newState == VIEW_DATA_STATE) {}
      _currentState = newState;
    });
  }

  void _processChat() async {
    if (uploadedFile == null) {
      return;
    }
    updateState(PROCESSING_STATE);
    MessageProcessor messageProcessor = MessageProcessor();
    await messageProcessor.insertMessagesIntoDB(uploadedFile!);
    updateState(PROCESSING_COMPLETE_STATE);
  }

  void _openFileExplorer() async {
    print("opening");
    _fileUploadStatus = "select a file";
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ["txt"],
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
      //set failed state
    } catch (ex) {
      print(ex);
      //set failed state
    }
    if (!mounted) return;
    setState(() {
      print(_paths!.first.extension);
      _fileName =
          _paths != null ? _paths!.map((e) => e.name).toString() : '...';
      uploadedFile = File(_paths!.first.path!);
      updateState(FILE_UPLOADED_STATE);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: _fileUploadIndicatorColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.chat_bubble_rounded,
                size: 100.0, color: _fileUploadIndicatorColor),
            Padding(
                padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                child: Text(
                  _fileUploadStatus,
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                )),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '$_fileName',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
            ),
            getRestButton()
          ],
        ),
      ),
      floatingActionButton: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Wrap(
            spacing: 16,
            children: [
              FloatingActionButton(
                heroTag: "privacy_button",
                onPressed: _openPrivacyPage,
                backgroundColor: Colors.amberAccent,
                child: Icon(Icons.privacy_tip),
              ),
              FloatingActionButton(
                heroTag: "action button",
                onPressed: _fabPressed,
                backgroundColor: _fabColor,
                child: _fabwidget,
              ),
              getStartChatButton(_currentState)
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  TextButton getRestButton() {
    if(_fileName != null && _fileName!.isNotEmpty) {
      return TextButton(onPressed: _reset, child: Text("Reset"));
    } else {
      return TextButton(onPressed: _openInstructions, child: Text("Instructions"));
    }
  }

  Widget getStartChatButton(int currentState) {
    if(_currentState == PROCESSING_COMPLETE_STATE) {
      return FloatingActionButton(
        heroTag: "Create bot",
        onPressed: _openChatBot,
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.assignment_ind),
      );
    } else {
      return FloatingActionButton(
        heroTag: "Create bot",
        onPressed: null,
        backgroundColor: Colors.grey,
        child: Icon(Icons.assignment_ind),
      );
    }
  }
}

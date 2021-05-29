import 'dart:io';

import 'package:chat_stats/processor/MessageProcessor.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MyApp());
}

const APP_OPEN_STATE = 0;
const FILE_UPLOADED_STATE = 1;
const PROCESSING_STATE = 2;
const PROCESSING_COMPLETE_STATE = 3;
const VIEW_DATA_STATE = 4;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UploadChatPage(title: 'ChatStat 💬'),
    );
  }
}

class ViewChatStatsPage extends StatefulWidget {
  ViewChatStatsPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _ViewChatStatsPage createState() => _ViewChatStatsPage();
}

class _ViewChatStatsPage extends State<ViewChatStatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [],
      ),
    );
  }
}

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

  void _reset() {
    updateState(APP_OPEN_STATE);
  }

  void updateState(int newState) {
    setState(() {
      if (newState == APP_OPEN_STATE) {
        _fileUploadStatus = "Upload your chat file";
        _fileUploadIndicatorColor = Colors.grey;
        _fabColor = Colors.grey;
        _fabwidget = Icon(Icons.upload_file);
        uploadedFile = null;
        _fileName = null;
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
            Text(
              '$_fileName',
              style: Theme.of(context).textTheme.headline6,
            ),
            TextButton(onPressed: _reset, child: Text("Reset"))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fabPressed,
        backgroundColor: _fabColor,
        child: _fabwidget,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

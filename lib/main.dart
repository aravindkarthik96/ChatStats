import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'ChatStat 💬'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _fileUploadStatus = "Upload your chat file";
  String? _fileName;
  List<PlatformFile>? _paths;
  Color _fileUploadIndicatorColor = Colors.grey;

  Color _fabColor = Colors.blue;
  Widget _fabwidget = Icon(Icons.upload_file);

  File? uploadedFile;

  void _fabPressed()  {
    if(_fileName != null) {
      _processChat();
    } else {
      _openFileExplorer();
    }
  }

  void _processChat() {
    setState(() {
      _fileUploadStatus = "Processing your chat";
      _fabwidget = CircularProgressIndicator(color: Colors.white);
      _fileUploadIndicatorColor = Colors.orange;
    });
  }

  void setUploadState() {
    _fabColor = Colors.blue;
    _fabwidget = Icon(Icons.upload_file);
  }
  void setProcessState() {
    _fabColor = Colors.orange;
    _fabwidget = Icon(Icons.play_arrow);
  }

  void _openFileExplorer() async {
    print("opening");
    _fileUploadStatus = "select a file";
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ["txt"],
      ))?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
      setState(() {
        _fileUploadIndicatorColor = Colors.red;
        _fileUploadStatus = "File failed to loaded";
        setUploadState();
      });
    } catch (ex) {
      print(ex);
      setState(() {
        _fileUploadIndicatorColor = Colors.red;
        _fileUploadStatus = "File failed to loaded";
        setUploadState();
      });
    }
    if (!mounted) return;
    setState(() {
      print(_paths!.first.extension);
      _fileName =
      _paths != null ? _paths!.map((e) => e.name).toString() : '...';
      _fileUploadStatus = "File loaded";
      _fileUploadIndicatorColor = Colors.blue;
      uploadedFile = File(_paths!.first.path!);
      setProcessState();
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
            Icon(Icons.chat_bubble_rounded,size: 100.0,color: _fileUploadIndicatorColor),
            Padding(padding: EdgeInsets.fromLTRB(40, 20,40, 20),
            child: Text(
              _fileUploadStatus,
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            )),
            Text(
              '$_fileName',
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fabPressed,
        backgroundColor: _fabColor,
        child: _fabwidget,

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
      ,
    );
  }
}

import 'dart:async';
import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:nft_flutter/main.dart';
import 'package:nft_flutter/message_screens/messagesModel.dart';
import 'package:nft_flutter/auth_files/prov.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import 'package:intl/intl.dart' show DateFormat;

class UserMessages extends StatefulWidget {
  final bool pre_messg;
  final String docID;
  final String name;
  final String toUID;
  const UserMessages(
      {Key? key,
      required this.name,
      required this.docID,
      required this.toUID,
      required this.pre_messg})
      : super(key: key);

  @override
  _UserMessagesState createState() => _UserMessagesState();
}

class _UserMessagesState extends State<UserMessages> {
  final auth = FirebaseAuth.instance;
  late User user;
  FlutterSoundRecorder? _flutterSoundRecorder;
  final audioPlayer = AssetsAudioPlayer();
  String? filePath;
  bool _play = false;
  String _recorderTxt = '00:00:00';

  void startIt() async {
    filePath = '/sdcard/Download/temp.wav';
    _flutterSoundRecorder = FlutterSoundRecorder();
    await _flutterSoundRecorder!.openAudioSession(
        focus: AudioFocus.requestFocusAndStopOthers,
        category: SessionCategory.playAndRecord,
        mode: SessionMode.modeDefault,
        device: AudioDevice.speaker);
    await _flutterSoundRecorder!
        .setSubscriptionDuration(Duration(milliseconds: 10));
    await initializeDateFormatting();

    await Permission.microphone.request();
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
  }

  //final recorder = RecordScound();
  TextEditingController textEditingController = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  String uid = "";
  String name = "";

  @override
  void initState() {
    super.initState();
    startIt();
  }

  @override
  Widget build(BuildContext context) {
    textEditingController.text = widget.pre_messg
        ? "I am interested in your organoid as a part of my study, would you be interested to participate?"
        : " ";
    user = auth.currentUser!;
    return Scaffold(
        appBar: AppBar(elevation: 0.0, title: Text(widget.name)),
        body: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: StreamBuilder(
                  stream: getCommentsStream(context),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    } else if (snapshot.data.docs.length == 0) {
                      return Center(child: Text("No Messages"));
                    } else {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (BuildContext context, int index) =>
                              buildCommentsViewCard(
                                  context, snapshot.data.docs[index]));
                    }
                  }),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding:
                    EdgeInsets.only(left: 15, bottom: 5, top: 10, right: 15),
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    // buildRecordButton(),
                    // Text(_recorderTxt),
                    // buildStopButton(),
                    // SizedBox(
                    //   width: 15,
                    // ),
                    Expanded(
                      child: Form(
                        key: formKey,
                        child: TextFormField(
                          maxLines: 2,
                          controller: textEditingController,
                          decoration: InputDecoration(
                              hintText: "Write message...",
                              hintStyle: TextStyle(color: Colors.black54),
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    FloatingActionButton(
                      onPressed: () async {
                        DateTime date2 = DateTime.now();
                        var formatter2 = new DateFormat("MM/dd/yyyy hh:mm a");
                        String formatteddate2 = formatter2.format(date2);
                        await FirebaseFirestore.instance
                            .collection("messages")
                            .doc(widget.docID)
                            .collection("messages")
                            .doc()
                            .set({
                          "date": formatteddate2,
                          "from": user.uid,
                          "to": widget.toUID,
                          "message": textEditingController.text
                        });
                        textEditingController.clear();
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                      backgroundColor: color,
                      elevation: 0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget buildRecordButton() {
    return IconButton(
      icon: Icon(CupertinoIcons.mic),
      onPressed: () async {
        print("pressed");
        record();
        setState(() {});
      },
    );
  }

  Widget buildStopButton() {
    return IconButton(
      icon: Icon(CupertinoIcons.stop),
      onPressed: () async {
        print("pressed");
        stopRecord();
        setState(() {});
      },
    );
  }

  Future<void> record() async {
    Directory dir = Directory(path.dirname(filePath!));
    if (!dir.existsSync()) {
      dir.createSync();
    }
    _flutterSoundRecorder!.openAudioSession();
    await _flutterSoundRecorder!.startRecorder(
      toFile: filePath,
      codec: Codec.pcm16WAV,
    );

    StreamSubscription _recorderSubscription =
        _flutterSoundRecorder!.onProgress!.listen((e) {
      var date = DateTime.fromMillisecondsSinceEpoch(e.duration.inMilliseconds,
          isUtc: true);
      var txt = DateFormat('mm:ss:SS', 'en_GB').format(date);

      setState(() {
        _recorderTxt = txt.substring(0, 8);
      });
    });
    _recorderSubscription.cancel();
  }

  Future<String?> stopRecord() async {
    print(_recorderTxt);
    _flutterSoundRecorder!.closeAudioSession();
    return await _flutterSoundRecorder!.stopRecorder();
  }

  Future<void> startPlaying() async {
    audioPlayer.open(
      Audio.file(filePath!),
      autoStart: true,
      showNotification: true,
    );
  }

  Future<void> stopPlaying() async {
    audioPlayer.stop();
  }

  Stream<QuerySnapshot> getCommentsStream(BuildContext context) async* {
    uid = await Prov.of(context)!.auth.getCurrentUID();
    yield* FirebaseFirestore.instance
        .collection("messages")
        .doc(widget.docID)
        .collection("messages")
        .orderBy("date")
        .snapshots();
  }

  Widget buildCommentsViewCard(
      BuildContext context, DocumentSnapshot documentSnapshot) {
    final messages = MessagesModel.fromSnapshot(documentSnapshot);
    return messages.from != uid
        ? Padding(
            padding: const EdgeInsets.only(top: 10, right: 50, left: 10),
            child: Column(children: [
              Card(
                  color: Colors.grey[350],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15, top: 5, bottom: 5, right: 15),
                      child: ListView(shrinkWrap: true, children: [
                        Text(messages.message,
                            style: TextStyle(color: Colors.black)),
                        SizedBox(height: 5),
                        Text(messages.date,
                            style: TextStyle(color: Colors.grey)),
                      ])))
            ]))
        : Padding(
            padding: const EdgeInsets.only(top: 10, left: 50, right: 10),
            child: Column(children: [
              Card(
                  color: color,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15, top: 5, bottom: 5, right: 15),
                      child: ListView(shrinkWrap: true, children: [
                        Text(messages.message,
                            style: TextStyle(color: Colors.white)),
                        SizedBox(height: 5),
                        Text(messages.date,
                            style: TextStyle(color: Colors.white70)),
                      ])))
            ]));
  }
}

final pathToSave = 'example.aac';

class RecordScound {
  bool _isRecorderInitialised = false;
  FlutterSoundRecorder? _flutterSoundRecorder;
  bool get isRecording => _flutterSoundRecorder!.isRecording;

  Future init() async {
    _flutterSoundRecorder = FlutterSoundRecorder();

    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException(
          "Microphone permissions are disabled.");
    }

    await _flutterSoundRecorder!.openAudioSession();
    _isRecorderInitialised = true;
  }

  Future dispose() async {
    _flutterSoundRecorder!.closeAudioSession();
    _flutterSoundRecorder = null;
    _isRecorderInitialised = false;
  }

  Future _record() async {
    if (!_isRecorderInitialised)
      return await _flutterSoundRecorder!.startRecorder(toFile: pathToSave);
  }

  Future _stop() async {
    if (!_isRecorderInitialised)
      return await _flutterSoundRecorder!.stopRecorder();
  }

  Future toggleRecording() async {
    if (_flutterSoundRecorder!.isStopped) {
      await _record();
    } else {
      await _stop();
    }
  }
}

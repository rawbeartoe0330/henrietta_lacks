import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nft_flutter/patient_screens/consent_screen.dart';
import 'package:nft_flutter/patient_screens/participantOrganoids.dart';
import 'package:nft_flutter/researcher_screens/studyModel.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class StudyDets extends StatefulWidget {
  final String docId;
  const StudyDets({Key? key, required this.docId}) : super(key: key);

  @override
  _StudyDetsState createState() => _StudyDetsState();
}

class _StudyDetsState extends State<StudyDets> {
  final List samples = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text("Study Details"),
        ),
        body: StreamBuilder(
            stream: getStudyDets(context),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return Container();
              } else {
                return buildStudyCard(context, snapshot.data);
              }
            }));
  }

  getStudyDets(context) async* {
    yield* FirebaseFirestore.instance
        .collection("studies")
        .doc(widget.docId)
        .snapshots();
  }

  buildStudyCard(BuildContext context, DocumentSnapshot snapshot) {
    final study = StudyModel.fromSnapshot(snapshot);
    String? videoId = YoutubePlayer.convertUrlToId(study.videoLink);
    return Container(
      padding: EdgeInsets.only(right: 15, left: 15),
      child: Column(children: [
        SizedBox(height: 20),
        Text(study.title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        SizedBox(height: 15),
        Text("Status: " + study.status, style: TextStyle(fontSize: 18)),
        SizedBox(height: 20),
        study.brief != ""
            ? Text(study.brief,
                style: TextStyle(fontSize: 18), textAlign: TextAlign.center)
            : Container(),
        SizedBox(height: 20),
        Text("Related Publications", style: TextStyle(fontSize: 18)),
        InkWell(
            child: Text("Click here",
                style: TextStyle(fontSize: 18, color: Colors.blue)),
            onTap: () {
              _launchURL(study.websiteLink);
            }),

        SizedBox(height: 20),
        Text(study.researcherName + " talks about it",
            style: TextStyle(fontSize: 18)),
        study.videoLink != ""
            ? YoutubePlayer(
                controller: YoutubePlayerController(
                  initialVideoId: videoId!,
                  flags: YoutubePlayerFlags(
                    hideControls: false,
                    controlsVisibleAtStart: true,
                    autoPlay: false,
                    mute: false,
                  ),
                ),
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.blue,
              )
            : Container(),
        SizedBox(height: 30),

        // widget.role == 'physician'
        //     ?
        Table(
          children: [
            TableRow(children: [
              TextButton(
                  onPressed: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => UserMessages(docID: ,)));
                  },
                  child: Text("Patient FAQ", style: TextStyle(fontSize: 18))),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ParticipantOrganoids()));
                  },
                  child: Text("Other participants",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18)))
            ]),
            TableRow(
              children: [
                TextButton(
                    child: Text("Participate",
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ConsentPage(
                              title: study.title, resID: study.researcherUID)));
                    }),
                TextButton(
                    onPressed: () {
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => UserMessages(docID: ,)));
                    },
                    child: Text("Message Researcher",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18))),
              ],
            )
          ],
        ),

        //     : Container()
      ]),
    );
  }

  samplesWidget(study) {
    // if (study.samplesNeeded != null) {
    return study.samplesNeeded.values.map<Widget>((e) => Text(e)).toList();
    //}
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

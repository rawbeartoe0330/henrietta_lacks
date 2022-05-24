import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nft_flutter/researcher_screens/patientsModel.dart';
import 'package:nft_flutter/researcher_screens/studyModel.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class StudyDetails extends StatefulWidget {
  final String docId;
  const StudyDetails({Key? key, required this.docId}) : super(key: key);

  @override
  _StudyDetailsState createState() => _StudyDetailsState();
}

class _StudyDetailsState extends State<StudyDetails> {
  final List samples = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Study Details"),
      ),
      body: ListView(children: [
        StreamBuilder(
            stream: getStudyDets(context),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return Container();
              } else {
                return buildStudyCard(context, snapshot.data);
              }
            }),
        StreamBuilder(
            stream: getPatients(context),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return Container();
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        "Patients involved:",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) =>
                            buildPatientCard(
                                context, snapshot.data.docs[index])),
                  ],
                );
              }
            }),
      ]),
    );
  }

  getStudyDets(context) async* {
    yield* FirebaseFirestore.instance
        .collection("studies")
        .doc(widget.docId)
        .snapshots();
  }

  getPatients(context) async* {
    yield* FirebaseFirestore.instance
        .collection("studies")
        .doc(widget.docId)
        .collection("patients")
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
      ]),
    );
  }

  buildPatientCard(BuildContext context, DocumentSnapshot snapshot) {
    final pat = PatientsModel.fromSnapshot(snapshot);
    return Container(
      padding: EdgeInsets.only(right: 15, left: 15),
      child: ListView(shrinkWrap: true, children: [
        SizedBox(height: 20),
        Text(pat.name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left),
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

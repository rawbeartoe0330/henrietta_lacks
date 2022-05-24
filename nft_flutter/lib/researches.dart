import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nft_flutter/patient_screens/studyDets.dart';
import 'package:nft_flutter/researcher_screens/studyModel.dart';

List<String> studies = [
  "Rehabilitation After Breast Cancer",
  "Imaging With [11C]Martinostat in Breast Cancer",
  "[18F] F-GLN by PET/CT in Breast Cancer",
  "Elevate! : An Elderly Breast Cancer Cohort Study"
];

class Researches extends StatefulWidget {
  const Researches({Key? key}) : super(key: key);

  @override
  _ResearchesState createState() => _ResearchesState();
}

class _ResearchesState extends State<Researches> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(elevation: 0.0, title: Text("Ongoing Researches")),
        body: StreamBuilder(
          stream: getStudies(context),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (!snapshot.hasData) {
              return Container();
            } else if (snapshot.data.docs.length == 0) {
              return Center(
                child: Text(
                  "No studies",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) =>
                      buildStudyList(context, snapshot.data.docs[index]));
            }
          },
        ));
  }

  getStudies(context) async* {
    yield* FirebaseFirestore.instance
        .collection("studies")
        .where("title", isGreaterThan: "")
        .snapshots();
  }

  buildStudyList(BuildContext context, DocumentSnapshot snapshot) {
    final study = StudyModel.fromSnapshot(snapshot);
    return ListTile(
      title: Text(study.title),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => StudyDets(docId: study.docID)));
      },
    );
  }
}

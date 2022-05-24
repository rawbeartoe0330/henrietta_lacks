import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nft_flutter/auth_files/prov.dart';
import 'package:nft_flutter/patient_screens/studyDets.dart';
import 'package:nft_flutter/researcher_screens/studyModel.dart';

class MyStudies extends StatefulWidget {
  const MyStudies({Key? key}) : super(key: key);

  @override
  _MyStudiesState createState() => _MyStudiesState();
}

class _MyStudiesState extends State<MyStudies> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Studies"),
      ),
      body: StreamBuilder(
        stream: getStudies(context),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else if (snapshot.data.docs.length == 0) {
            return Center(
              child: Text(
                "You currently aren't involved in any studies",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            );
          } else {
            return Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) =>
                      buildCard(context, snapshot.data.docs[index])),
            );
          }
        },
      ),
    );
  }

  getStudies(context) async* {
    final uid = await Prov.of(context)!.auth.getCurrentUID();
    yield* FirebaseFirestore.instance
        .collection("studies")
        .where("patients", arrayContains: uid)
        .snapshots();
  }

  buildCard(BuildContext context, DocumentSnapshot snapshot) {
    final study = StudyModel.fromSnapshot(snapshot);
    return ListTile(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => StudyDets(docId: study.docID)));
        },
        title: Text(study.title));
  }
}

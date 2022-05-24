import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nft_flutter/researcher_screens/add_study.dart';
import 'package:nft_flutter/message_screens/messageList.dart';
import 'package:nft_flutter/auth_files/prov.dart';
import 'package:nft_flutter/researcher_screens/studyDetails.dart';
import 'package:nft_flutter/researcher_screens/studyModel.dart';
import 'package:nft_flutter/typesTable.dart';

class Studies extends StatefulWidget {
  const Studies({Key? key}) : super(key: key);

  @override
  _StudiesState createState() => _StudiesState();
}

class _StudiesState extends State<Studies> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AddStudy()));
          },
          child: Icon(CupertinoIcons.add),
        ),
        appBar: AppBar(
          elevation: 0.0,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MessageList()));
              },
              icon: Icon(CupertinoIcons.bubble_left),
              color: Colors.white,
            ),
            IconButton(
                onPressed: () {
                  // Navigator.of(context).push(
                  //     MaterialPageRoute(builder: (context) => TypesTable()));
                },
                icon: Icon(CupertinoIcons.table))
          ],
          title: Text("Ongoing Studies"),
        ),
        body: StreamBuilder(
          stream: getStudies(context),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (!snapshot.hasData) {
              return Container();
            } else if (snapshot.data.docs.length == 0) {
              return Center(
                child: Text(
                  "You currently haven't created a study \n\n Click on the + to add a study",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) =>
                      buildStudiesCard(context, snapshot.data.docs[index]));
            }
          },
        ));
  }

  getStudies(context) async* {
    final uid = await Prov.of(context)!.auth.getCurrentUID();
    yield* FirebaseFirestore.instance
        .collection("studies")
        .where("researcherUID", isEqualTo: uid)
        .snapshots();
  }

  buildStudiesCard(BuildContext context, DocumentSnapshot snapshot) {
    final study = StudyModel.fromSnapshot(snapshot);
    return InkWell(
        child: ListTile(title: Text(study.title)),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => StudyDetails(docId: study.docID)));
        });
  }
}

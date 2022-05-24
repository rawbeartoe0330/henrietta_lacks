import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:nft_flutter/biobank/organoidModel.dart';
import 'package:nft_flutter/message_screens/messages.dart';
import 'package:nft_flutter/patient_screens/patientModel.dart';

class OrganoidDetails extends StatefulWidget {
  final String orgUID;
  final String patUID;
  const OrganoidDetails({Key? key, required this.orgUID, required this.patUID})
      : super(key: key);

  @override
  _OrganoidDetailsState createState() => _OrganoidDetailsState();
}

class _OrganoidDetailsState extends State<OrganoidDetails> {
  final auth = FirebaseAuth.instance;
  late User user;
  @override
  Widget build(BuildContext context) {
    user = auth.currentUser!;
    return Scaffold(
      appBar: AppBar(elevation: 0.0, title: Text("Details")),
      body: Container(
        child: ListView(
          children: [
            StreamBuilder(
                stream: getDetails(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else {
                    return buildDetailsCard(context, snapshot.data);
                  }
                }),
            StreamBuilder(
                stream: getPatDetails(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else {
                    return buildPatDetailsCard(context, snapshot.data);
                  }
                })
          ],
        ),
      ),
    );
  }

  getDetails() async* {
    yield* FirebaseFirestore.instance
        .collection("organoids")
        .doc(widget.orgUID)
        .snapshots();
  }

  getPatDetails() async* {
    yield* FirebaseFirestore.instance
        .collection("patients")
        .doc(widget.patUID)
        .snapshots();
  }

  buildDetailsCard(BuildContext context, DocumentSnapshot snapshot) {
    final dets = OrganoidModel.fromSnapshot(snapshot);
    return Padding(
        padding: const EdgeInsets.only(top: 30, right: 20, left: 20),
        child: ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              Center(child: Image.network(dets.image)),
              SizedBox(height: 25),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("ER: " + dets.er, style: TextStyle(fontSize: 20)),
                Text("PR: " + dets.pr, style: TextStyle(fontSize: 20)),
                Text("HER2: " + dets.her2, style: TextStyle(fontSize: 20))
              ]),
              SizedBox(height: 15),
              Text("IPM: " + dets.organoidID, style: TextStyle(fontSize: 20)),
              SizedBox(height: 15),
              Text("TP#: " + dets.tpno, style: TextStyle(fontSize: 20)),
              SizedBox(height: 15),
              Text("Tissue Type: " + dets.tissueType,
                  style: TextStyle(fontSize: 20)),
              SizedBox(height: 15),
              Text("Pathology Site: " + dets.pathologySite,
                  style: TextStyle(fontSize: 20))
            ]));
  }

  buildPatDetailsCard(BuildContext context, DocumentSnapshot snapshot) {
    final dets = PatientModel.fromSnapshot(snapshot);
    return Padding(
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: ListView(shrinkWrap: true, children: [
          SizedBox(height: 15),
          Text("Age: " + dets.age.toString(), style: TextStyle(fontSize: 20)),
          SizedBox(height: 15),
          Text("Age at Surgery: 25", style: TextStyle(fontSize: 20)),
          SizedBox(height: 15),
          Text("Medical History: " + dets.medHist.toString(),
              style: TextStyle(fontSize: 20)),
          SizedBox(height: 15),
          Text("Surgical History: " + dets.surHist.toString(),
              style: TextStyle(fontSize: 20)),
          SizedBox(height: 15),
          Text("Social History: " + dets.socHist.toString(),
              style: TextStyle(fontSize: 20)),
          SizedBox(height: 15),
          Text("Reproductive History: " + dets.repHist.toString(),
              style: TextStyle(fontSize: 20)),
          SizedBox(height: 15),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            ElevatedButton(
                onPressed: () async {
                  String? docID;

                  final docRef = await FirebaseFirestore.instance
                      .collection("messages")
                      .where("participants", arrayContains: dets.uid!)
                      .get();
                  print("here: " + docRef.docs.isEmpty.toString());
                  if (docRef.docs.isEmpty) {
                    DocumentReference documentReference =
                        FirebaseFirestore.instance.collection("messages").doc();
                    await documentReference.set({
                      "participants":
                          FieldValue.arrayUnion([dets.uid!, user.uid])
                    });

                    docID = documentReference.id;
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => UserMessages(
                            pre_messg: true,
                            name: dets.name!,
                            docID: docID!,
                            toUID: dets.uid!)));
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => UserMessages(
                            pre_messg: false,
                            name: dets.name!,
                            docID: docRef.docs[0].id,
                            toUID: dets.uid!)));
                  }
                },
                child: Text("Message Patient", style: TextStyle(fontSize: 18))),
            ElevatedButton(
                onPressed: () async {},
                child:
                    Text("Message Physician", style: TextStyle(fontSize: 18)))
          ])
        ]));
  }
}

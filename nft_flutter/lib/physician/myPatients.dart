import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nft_flutter/auth_files/prov.dart';
import 'package:nft_flutter/message_screens/messageList.dart';
import 'package:nft_flutter/physician/patientDets.dart';
import 'package:nft_flutter/blockchain_connection/patientListModel.dart';
import 'package:nft_flutter/physician/patientDetModel.dart';
import 'package:nft_flutter/physician/physicianModel.dart';
import 'package:nft_flutter/researches.dart';
import 'package:provider/provider.dart';

List<String> imgs = [
  'assets/female1.jpg',
  'assets/female2.jpeg',
  'assets/female3.jpg',
  'assets/female4.jpeg',
  'assets/male1.jpg',
  'assets/male2.jpg',
  'assets/male3.jpg',
  'assets/male4.png',
  'assets/male5.jpg'
];

class MyPatients extends StatefulWidget {
  const MyPatients({Key? key}) : super(key: key);

  @override
  _MyPatientsState createState() => _MyPatientsState();
}

class _MyPatientsState extends State<MyPatients> {
  @override
  Widget build(BuildContext context) {
    var listModel = Provider.of<PatientListModel>(context);

    return Scaffold(
        appBar: AppBar(elevation: 0.0, title: Text("Patients")),
        body: StreamBuilder(
            stream: getStream(context),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return Container();
              } else if (snapshot.data.docs.length == 0) {
                return Center(child: Text("No Patients"));
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) =>
                        buildCard(context, snapshot.data.docs[index]));
              }
            }));
  }

  getStream(context) async* {
    final uid = await Prov.of(context)!.auth.getCurrentUID();
    yield* FirebaseFirestore.instance
        .collection("physician")
        .doc(uid)
        .collection("patients")
        .snapshots();
  }

  buildCard(BuildContext context, DocumentSnapshot snapshot) {
    final pat = PatientDetModel.fromSnapshot(snapshot);
    return ListTile(
        title: Text(pat.name),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PatientDets(uid: pat.uid)));
        });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nft_flutter/biobank/organoidModel.dart';
import 'package:nft_flutter/patient_screens/patientModel.dart';

class PatientDets extends StatefulWidget {
  final String uid;
  const PatientDets({Key? key, required this.uid}) : super(key: key);

  @override
  _PatientDetsState createState() => _PatientDetsState();
}

class _PatientDetsState extends State<PatientDets> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(elevation: 0.0, title: Text("Patient Details")),
        body: Column(
          children: [
            StreamBuilder(
                stream: getStream(context),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else if (snapshot.data.docs.length == 0) {
                    return Center(child: Text("No Patients"));
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) =>
                            buildCard(context, snapshot.data.docs[index]));
                  }
                }),
            StreamBuilder(
                stream: getOrganoidStream(context),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else if (snapshot.data.docs.length == 0) {
                    return Card(
                        child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 10),
                      child: Text("No Organoid for this patient"),
                    ));
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) =>
                            buildOrganoidCard(
                                context, snapshot.data.docs[index]));
                  }
                }),
          ],
        ));
  }

  getStream(context) async* {
    yield* FirebaseFirestore.instance
        .collection("patients")
        .where("uid", isEqualTo: widget.uid)
        .snapshots();
  }

  getOrganoidStream(context) async* {
    yield* FirebaseFirestore.instance
        .collection("organoids")
        .where("patientUID", isEqualTo: widget.uid)
        .snapshots();
  }

  buildCard(BuildContext context, DocumentSnapshot snapshot) {
    final pat = PatientModel.fromSnapshot(snapshot);
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Card(
            child: ListTile(
                subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      Text("Medical History: " + pat.medHist.toString(),
                          style: TextStyle(fontSize: 14, color: Colors.black)),
                      SizedBox(height: 5),
                      Text("Social History: " + pat.socHist.toString(),
                          style: TextStyle(fontSize: 14, color: Colors.black)),
                      SizedBox(height: 5),
                      Text("Reproductive History: " + pat.repHist.toString(),
                          style: TextStyle(fontSize: 14, color: Colors.black)),
                      SizedBox(height: 5),
                      Text("Surgeon History: " + pat.surHist.toString(),
                          style: TextStyle(fontSize: 14, color: Colors.black))
                    ]),
                title: Text(pat.name!, style: TextStyle(fontSize: 20)),
                leading: CircleAvatar(
                  radius: 15,
                  child: Text(pat.name!.substring(0, 1),
                      style: TextStyle(fontSize: 20)),
                ))));
  }

  buildOrganoidCard(BuildContext context, DocumentSnapshot snapshot) {
    final organoid = OrganoidModel.fromSnapshot(snapshot);
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Card(
            child: ListTile(
          title: Text(organoid.tpno, style: TextStyle(fontSize: 20)),
        )));
  }
}

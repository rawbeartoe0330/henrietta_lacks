import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nft_flutter/auth_files/prov.dart';
import 'package:nft_flutter/blockchain_connection/patientListModel.dart';
import 'package:nft_flutter/main.dart';
import 'package:nft_flutter/patient_screens/patientModel.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

String fatherName = "";
String motherName = "";

class _ProfileState extends State<Profile> {
  final auth = FirebaseAuth.instance;
  late User user;
  @override
  Widget build(BuildContext context) {
    user = auth.currentUser!;

    return Scaffold(
      appBar: AppBar(elevation: 0.0),
      body: Container(
          child: Stack(children: [
        new Column(children: <Widget>[
          new Container(
              height: MediaQuery.of(context).size.height * .23, color: color)
        ]),
        StreamBuilder(
            stream: getStream(context),
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
                        buildCard(context, snapshot.data.docs[index]));
              }
            }),
        Align(
          alignment: Alignment.topCenter,
          child: CircleAvatar(
            radius: 30,
            child: Text(user.displayName!.substring(0, 1),
                style: TextStyle(fontSize: 35)),
          ),
        ),
      ])),
    );
  }

  getStream(context) async* {
    final uid = await Prov.of(context)!.auth.getCurrentUID();
    yield* FirebaseFirestore.instance
        .collection("patients")
        .where("uid", isEqualTo: uid)
        .snapshots();
  }

  buildCard(BuildContext context, DocumentSnapshot snapshot) {
    final pat = PatientModel.fromSnapshot(snapshot);
    return ListView(
      shrinkWrap: true,
      children: [
        SizedBox(height: 30),
        Padding(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Card(
            elevation: 5,
            color: Colors.grey.shade300,
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Text(user.displayName!,
                      style: TextStyle(fontSize: 25),
                      textAlign: TextAlign.center),
                  SizedBox(height: 15),
                  Divider(
                      height: 0,
                      indent: 20,
                      endIndent: 20,
                      thickness: 1,
                      color: Colors.black12),
                  SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: (context),
                          builder: (builder) {
                            return AlertDialog(
                              content: Container(
                                height: 300,
                                child: Column(
                                  children: [
                                    Text("Mother: " + pat.motherName!,
                                        style: TextStyle(fontSize: 20)),
                                    SizedBox(height: 20),
                                    Text("Father: " + pat.fatherName!,
                                        style: TextStyle(fontSize: 20)),
                                    SizedBox(height: 20),
                                    Text(
                                        "Father History: " +
                                            pat.fatherHist.toString(),
                                        style: TextStyle(fontSize: 20)),
                                    SizedBox(height: 20),
                                    Text(
                                        "Mother History: " +
                                            pat.motherHist.toString(),
                                        style: TextStyle(fontSize: 20))
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    child: ListTile(
                        leading: Icon(CupertinoIcons.person_2),
                        title: Text(
                          "Family",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                          ),
                        )),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: (context),
                          builder: (builder) {
                            return AlertDialog(
                                content: Container(
                                    height: 500,
                                    child: Column(children: [
                                      Text(
                                          "Medical History: " +
                                              pat.medHist.toString(),
                                          style: TextStyle(fontSize: 20)),
                                      SizedBox(height: 20),
                                      Text(
                                          "Surgical History: " +
                                              pat.surHist.toString(),
                                          style: TextStyle(fontSize: 20)),
                                      SizedBox(height: 20),
                                      Text(
                                          "Reproduction History: " +
                                              pat.repHist.toString(),
                                          style: TextStyle(fontSize: 20)),
                                      SizedBox(height: 20),
                                      Text(
                                          "Social History: " +
                                              pat.socHist.toString(),
                                          style: TextStyle(fontSize: 20)),
                                      SizedBox(height: 20),
                                      Text(
                                          "Allergies: " +
                                              pat.allergies.toString(),
                                          style: TextStyle(fontSize: 20))
                                    ])));
                          });
                    },
                    child: ListTile(
                        leading: Icon(CupertinoIcons.plus),
                        title: Text(
                          "Medical History",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                          ),
                        )),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: (context),
                          builder: (builder) {
                            return AlertDialog(
                                content: Container(
                                    height: 300,
                                    child: Column(children: [
                                      Text("Primary: " + pat.primary!,
                                          style: TextStyle(fontSize: 20)),
                                      SizedBox(height: 20),
                                      Text("Radiologist: " + pat.radiologist!,
                                          style: TextStyle(fontSize: 20)),
                                      SizedBox(height: 20),
                                      Text("Pathologist: " + pat.pathologist!,
                                          style: TextStyle(fontSize: 20)),
                                      SizedBox(height: 20),
                                      Text("Surgeon: " + pat.surgeon!,
                                          style: TextStyle(fontSize: 20)),
                                      SizedBox(height: 20),
                                      Text(
                                          "Medical Oncologist: " +
                                              pat.moncologist!,
                                          style: TextStyle(fontSize: 20)),
                                      SizedBox(height: 20),
                                      Text(
                                          "Radiation Oncologist: " +
                                              pat.roncologist!,
                                          style: TextStyle(fontSize: 20))
                                    ])));
                          });
                    },
                    child: ListTile(
                        leading: Icon(Icons.local_hospital_rounded),
                        title: Text(
                          "Physicians",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

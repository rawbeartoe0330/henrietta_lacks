import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nft_flutter/blockchain_connection/patientListModel.dart';
import 'package:nft_flutter/main.dart';
import 'package:nft_flutter/message_screens/messageList.dart';
import 'package:nft_flutter/organoidGallery.dart';
import 'package:nft_flutter/patient_screens/myStudies.dart';
import 'package:nft_flutter/patient_screens/profile.dart';
import 'package:nft_flutter/patient_screens/samples.dart';
import 'package:nft_flutter/researches.dart';
import 'package:provider/provider.dart';

class MyDets extends StatefulWidget {
  const MyDets({Key? key}) : super(key: key);

  @override
  _MyDetsState createState() => _MyDetsState();
}

class _MyDetsState extends State<MyDets> {
  final auth = FirebaseAuth.instance;
  late User user;
  @override
  Widget build(BuildContext context) {
    user = auth.currentUser!;
    String sex = "";
    var listModel = Provider.of<PatientListModel>(context);
    listModel.patients.forEach((element) {
      if (element.patientName == user.displayName) {
        setState(() {
          //sex = element.patientSex;
        });
      }
    });
    return Scaffold(
        //appBar: AppBar(),
        body: Stack(children: [
      new Column(children: <Widget>[
        new Container(
            height: MediaQuery.of(context).size.height * .43, color: color)
      ]),
      ListView(shrinkWrap: true, children: [
        SizedBox(height: 160),
        Text(
          "Welcome " + user.displayName! + "!",
          style: TextStyle(
              fontSize: 30, fontFamily: "KarlaSB", color: Colors.white),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30),
        Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Card(
                elevation: 5,
                color: Colors.grey.shade300,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 15, bottom: 15, left: 10, right: 10),
                  child: Table(
                      border: TableBorder.symmetric(
                          inside:
                              BorderSide(width: 0.5, color: Colors.black26)),
                      children: [
                        TableRow(children: [
                          InkWell(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors.white30,
                                      child: Icon(CupertinoIcons.person,
                                          size: 40, color: color),
                                    ),
                                    Text('Me',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 22)),
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Profile()));
                              }),
                          InkWell(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors.white30,
                                      child: Icon(CupertinoIcons.creditcard,
                                          color: color, size: 40)),
                                  Text('Biowallet',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 22)),
                                ],
                              ),
                            ),
                            onTap: () async {
                              bool organoid = false;
                              String docID = "CoLab";
                              await FirebaseFirestore.instance
                                  .collection("organoids")
                                  .where("patientUID", isEqualTo: user.uid)
                                  .get()
                                  .then((value) {
                                setState(() {
                                  organoid = true;
                                  docID = value.docs[0].reference.id;
                                });
                              });
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Samples(
                                      organoid: organoid, docID: docID)));
                            },
                          ),
                          InkWell(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors.white30,
                                      child: Icon(CupertinoIcons.chat_bubble_2,
                                          color: color, size: 40)),
                                  Text("Co-Lab",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 22)),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MessageList()));
                            },
                          ),
                        ]),
                        TableRow(children: [
                          InkWell(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.white30,
                                        child: Icon(
                                            CupertinoIcons.chart_pie_fill,
                                            color: color,
                                            size: 40)),
                                    Text('Portfolio',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 22)),
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MyStudies()));
                              }),
                          InkWell(
                              child: Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Column(children: [
                                    CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.white30,
                                        child: Icon(
                                            // CupertinoIcons.photo_on_rectangle,
                                            CupertinoIcons
                                                .square_stack_3d_down_right_fill,
                                            color: color,
                                            size: 40)),
                                    Text('Gallery',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 22)),
                                  ])),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => OrganoidGallery()));
                              }),
                          InkWell(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.white30,
                                        child: Icon(
                                            CupertinoIcons.lab_flask_solid,
                                            color: color,
                                            size: 40)),
                                    Text('Research',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 22)),
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Researches()));
                              }),
                        ])
                      ]),
                )))
      ])
    ]));
  }
}

// Center(
//             child: Column(children: [
//           SizedBox(height: 40),
//           CircleAvatar(
//             backgroundColor: Colors.transparent,
//             radius: 40,
//             child: Image.asset((imgs.toList()..shuffle()).first),
//           ),
//           SizedBox(height: 20),
//           Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//             Text(
//               "Name: ",
//               style: TextStyle(fontSize: 20, color: Color),
//             ),
//             Text(
//               widget.name,
//               style: TextStyle(fontSize: 20),
//             )
//           ]),
//           SizedBox(height: 10),
//           Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//             Text(
//               "Age: ",
//               style: TextStyle(fontSize: 20, color: Color),
//             ),
//             Text(
//               widget.age,
//               style: TextStyle(fontSize: 20),
//             )
//           ]),
//           SizedBox(height: 10),
//           Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//             Text(
//               "Sex: ",
//               style: TextStyle(fontSize: 20, color: Color),
//             ),
//             Text(
//               sex,
//               style: TextStyle(fontSize: 20),
//             )
//           ]),
//           SizedBox(height: 15),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Text(
//                 "Biospecimens Given:",
//                 style: TextStyle(fontSize: 20),
//               ),
//               Text(
//                 "Submitted on:",
//                 style: TextStyle(fontSize: 20),
//               ),
//             ],
//           ),
//           SizedBox(height: 10),
//           Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
//             Column(
//               children: [
//                 Text("Blood", style: TextStyle(fontSize: 18)),
//                 Icon(Icons.thermostat, color: Colors.red.shade900),
//                 Icon(Icons.thermostat, color: Colors.red.shade900),
//                 Icon(Icons.thermostat, color: Colors.red.shade900)
//               ],
//             ),
//             Text("09/10/2017", style: TextStyle(fontSize: 18))
//           ]),
//           SizedBox(height: 10),
//           Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
//             Column(
//               children: [
//                 Text("Tissues", style: TextStyle(fontSize: 18)),
//                 SizedBox(width: 5),
//                 Icon(CupertinoIcons.scissors_alt,
//                     color: Colors.indigo.shade900),
//                 Icon(CupertinoIcons.scissors_alt, color: Colors.indigo.shade900)
//               ],
//             ),
//             Text(
//               "03/16/2018",
//               style: TextStyle(fontSize: 18),
//             )
//           ]),
//           SizedBox(height: 10),
//           SizedBox(height: 10),
//           TextButton(
//               onPressed: () {},
//               child: Text(
//                 "Add Sample",
//                 style: TextStyle(fontSize: 18),
//               )),
//         ]))
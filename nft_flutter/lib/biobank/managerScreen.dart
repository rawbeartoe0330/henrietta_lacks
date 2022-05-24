import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nft_flutter/biobank/addOrganoid.dart';
import 'package:nft_flutter/biobank/createOrganoid.dart';
import 'package:nft_flutter/biobank/managerDets.dart';
import 'package:nft_flutter/biobank/organoidPage.dart';
import 'package:nft_flutter/main.dart';
import 'package:nft_flutter/organoidGallery.dart';

class ManagerScreen extends StatefulWidget {
  const ManagerScreen({Key? key}) : super(key: key);

  @override
  _ManagerScreenState createState() => _ManagerScreenState();
}

class _ManagerScreenState extends State<ManagerScreen> {
  final auth = FirebaseAuth.instance;
  late User user;
  @override
  Widget build(BuildContext context) {
    user = auth.currentUser!;
    return Scaffold(
        //appBar: AppBar(),
        body: Stack(children: [
      new Column(children: <Widget>[
        new Container(
            height: MediaQuery.of(context).size.height * .43, color: color)
      ]),
      ListView(shrinkWrap: true, children: [
        SizedBox(height: 95),
        Text(
          "Welcome " + user.displayName! + "!",
          style: TextStyle(
              fontSize: 40, fontFamily: "KarlaSB", color: Colors.white),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 50),
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
                                  child: Column(children: [
                                    CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.white30,
                                        child: Icon(CupertinoIcons.person,
                                            color: color, size: 40)),
                                    Text("My        Profile",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 22))
                                  ])),
                              onTap: () {
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) => MessageList()));
                              },
                            ),
                            InkWell(
                                child: Padding(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: Column(children: [
                                      CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.white30,
                                          child: Icon(CupertinoIcons.person_2,
                                              color: color, size: 40)),
                                      Text('View Patients',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 22))
                                    ])),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => OrganoidPage()));
                                }),
                            InkWell(
                                child: Padding(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: Column(children: [
                                      CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.white30,
                                          child: Icon(
                                              CupertinoIcons.bubble_left,
                                              color: color,
                                              size: 40)),
                                      Text('View Requests',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 22))
                                    ])),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ManagerDets()));
                                }),
                          ]),
                          TableRow(children: [
                            InkWell(
                                child: Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Column(children: [
                                      CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.white30,
                                          child: Icon(CupertinoIcons.add,
                                              color: color, size: 40)),
                                      Text('Add Samples',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 22))
                                    ])),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => FindPatient()));
                                }),
                            InkWell(
                                child: Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Column(children: [
                                      CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.white30,
                                          child: Icon(CupertinoIcons.search,
                                              color: color, size: 40)),
                                      Text('View    Gallery',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 22))
                                    ])),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => OrganoidGallery()));
                                }),
                            InkWell(
                                child: Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Column(children: [
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.white30,
                                        child: Icon(
                                            CupertinoIcons.table_badge_more,
                                            color: color,
                                            size: 40),
                                      ),
                                      Text('New Studies',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 22))
                                    ])),
                                onTap: () {
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //     builder: (context) => Researches()));
                                })
                          ])
                        ]))))
      ])
    ]));
  }
}

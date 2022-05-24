import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nft_flutter/main.dart';
import 'package:nft_flutter/organoidGallery.dart';
import 'package:nft_flutter/researcher_screens/permissionedOrganoid.dart';

class ResearcherScreen extends StatefulWidget {
  const ResearcherScreen({Key? key}) : super(key: key);

  @override
  _ResearcherScreenState createState() => _ResearcherScreenState();
}

class _ResearcherScreenState extends State<ResearcherScreen> {
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
        SizedBox(height: 140),
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
                                      Text('My       Profile',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 22))
                                    ])),
                                onTap: () {
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //     builder: (context) => PhysicianDets()));
                                }),
                            InkWell(
                                child: Padding(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: Column(children: [
                                      CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.white30,
                                          child: Icon(CupertinoIcons.table,
                                              color: color, size: 40)),
                                      Text('My    Studies',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 22))
                                    ])),
                                onTap: () {
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //     builder: (context) => MessageList()));
                                }),
                            InkWell(
                                child: Padding(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: Column(children: [
                                      CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.white30,
                                          child: Icon(CupertinoIcons.drop,
                                              color: color, size: 40)),
                                      SizedBox(height: 8),
                                      Text('Permissioned Organoids',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 19))
                                    ])),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          PermissionedOrganoids()));
                                })
                          ]),
                          TableRow(children: [
                            InkWell(
                              child: Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Column(children: [
                                    CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.white30,
                                        child: Icon(CupertinoIcons.bubble_left,
                                            color: color, size: 40)),
                                    Text("View    Chats",
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
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Column(children: [
                                      CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.white30,
                                          child: Icon(CupertinoIcons.search,
                                              color: color, size: 40)),
                                      Text('View        Co-Lab',
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
                                        child: Icon(CupertinoIcons.list_bullet,
                                            color: color, size: 40),
                                      ),
                                      Text('Post a Request',
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

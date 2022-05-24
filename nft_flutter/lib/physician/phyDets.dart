import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nft_flutter/auth_files/prov.dart';
import 'package:nft_flutter/main.dart';
import 'package:nft_flutter/physician/physicianModel.dart';

class PhysicianDets extends StatefulWidget {
  const PhysicianDets({Key? key}) : super(key: key);

  @override
  _PhysicianDetsState createState() => _PhysicianDetsState();
}

class _PhysicianDetsState extends State<PhysicianDets> {
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
        .collection("physician")
        .where("uid", isEqualTo: uid)
        .snapshots();
  }

  buildCard(BuildContext context, DocumentSnapshot snapshot) {
    final pat = PhysicianModel.fromSnapshot(snapshot);
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
                  ListTile(
                    title: Row(
                      children: [
                        Text(
                          "Email: ",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          pat.email,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                      title: Row(
                    children: [
                      Text(
                        "Type: ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      Text(
                        pat.phyType,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nft_flutter/biobank/organoidModel.dart';

class Organoids extends StatefulWidget {
  final String docID;
  const Organoids({Key? key, required this.docID}) : super(key: key);

  @override
  _OrganoidsState createState() => _OrganoidsState();
}

class _OrganoidsState extends State<Organoids> {
  final auth = FirebaseAuth.instance;
  late User user;
  @override
  Widget build(BuildContext context) {
    user = auth.currentUser!;
    return StreamBuilder(
      stream: getStream(context),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else if (snapshot.data.docs.length == 0) {
          return Center(
            child: Text(
              "You currently don't have any organoids",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          );
        } else {
          return Container(
            height: MediaQuery.of(context).size.height * 0.25,
            child: ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) =>
                    buildCard(context, snapshot.data.docs[index])),
          );
        }
      },
    );
  }

  getStream(context) async* {
    yield* FirebaseFirestore.instance
        .collection("organoids")
        .where("patientUID", isEqualTo: user.uid)
        .snapshots();
  }

  buildCard(BuildContext context, DocumentSnapshot snapshot) {
    final organoidDet = OrganoidModel.fromSnapshot(snapshot);
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(organoidDet.organoidID),
          Text(organoidDet.pathologySite),
          Text(organoidDet.tissueType)
        ],
      ),
      subtitle:
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text("ER: " + organoidDet.er),
        Text("PR: " + organoidDet.pr),
        Text("HER2: " + organoidDet.her2),
      ]),
      trailing: getImage(organoidDet.image),
    );
  }

  getImage(img) {
    print(img);
    if (img != "") {
      return SizedBox(child: Image.network(img));
    } else {
      return SizedBox(width: 0, height: 0);
    }
  }
}

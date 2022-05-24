import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nft_flutter/biobank/organoidModel.dart';

class PermissionedOrganoids extends StatefulWidget {
  const PermissionedOrganoids({Key? key}) : super(key: key);

  @override
  _PermissionedOrganoidsState createState() => _PermissionedOrganoidsState();
}

class _PermissionedOrganoidsState extends State<PermissionedOrganoids> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Researcher Wallet")),
      // body: Container(
      //     child: StreamBuilder(
      //         stream: getOrganoids(),
      //         builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      //           return ListView.builder(
      //               shrinkWrap: true,
      //               itemCount: snapshot.data.docs.length,
      //               itemBuilder: (BuildContext context, int index) =>
      //                   buildCard(context, snapshot.data.docs[index]));
      //         })),
    );
  }

  getOrganoids() async* {
    yield* FirebaseFirestore.instance
        .collection("organoids")
        .where("organoidID", isEqualTo: "IPM-06")
        .snapshots();
  }

  buildCard(BuildContext context, DocumentSnapshot snapshot) {
    final org = OrganoidModel.fromSnapshot(snapshot);
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      children: [
        Image.network(org.image, scale: 3.5),
        Padding(
          padding: const EdgeInsets.only(top: 50, right: 20),
          child: Center(
              child: Column(
            children: [
              Text(org.tpno, style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("ER: " + org.er),
                Text("PR: " + org.pr),
                Text("HER2: " + org.her2),
              ]),
              SizedBox(height: 10),
              Text("Tissue Type: " + org.tissueType,
                  style: TextStyle(fontSize: 17)),
              SizedBox(height: 10),
              Text("Site: " + org.pathologySite, style: TextStyle(fontSize: 17))
            ],
          )),
        )
      ],
    );
  }
}

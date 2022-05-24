import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nft_flutter/auth_files/prov.dart';
import 'package:nft_flutter/biobank/createOrganoid.dart';
import 'package:nft_flutter/biobank/organoidDetails.dart';
import 'package:nft_flutter/biobank/organoidModel.dart';
import 'package:nft_flutter/organoidGallery.dart';

class OrganoidPage extends StatefulWidget {
  const OrganoidPage({Key? key}) : super(key: key);

  @override
  _OrganoidPageState createState() => _OrganoidPageState();
}

class _OrganoidPageState extends State<OrganoidPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Organoids"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => OrganoidGallery()));
            },
            icon: Icon(CupertinoIcons.square_grid_2x2),
          )
        ],
      ),
      body: Container(
          child: ListView(children: [
        StreamBuilder(
            stream: getStream(context),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return Container();
              } else if (snapshot.data.docs.length == 0) {
                return Center(
                  child: Text(
                    "You currently haven't added an organoid \n\n Click on the + to add an organoid",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                );
              } else {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) =>
                        buildCard(context, snapshot.data.docs[index]));
              }
            })
      ])),
    );
  }

  getStream(context) async* {
    final uid = await Prov.of(context)!.auth.getCurrentUID();
    yield* FirebaseFirestore.instance
        .collection("organoids")
        .where("manager", isEqualTo: uid)
        .orderBy("TP")
        .snapshots();
  }

  buildCard(BuildContext context, DocumentSnapshot snapshot) {
    final organoid = OrganoidModel.fromSnapshot(snapshot);
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => OrganoidDetails(docID: organoid.docID)));
      },
      child: ListTile(
        title: Text(organoid.name),
        subtitle: Text(organoid.tpno),
      ),
    );
  }
}

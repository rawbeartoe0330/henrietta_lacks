import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nft_flutter/biobank/organoidModel.dart';
import 'package:nft_flutter/organoidGallery.dart';

class OrganoidDetails extends StatefulWidget {
  final String docID;
  const OrganoidDetails({Key? key, required this.docID}) : super(key: key);

  @override
  _OrganoidDetailsState createState() => _OrganoidDetailsState();
}

class _OrganoidDetailsState extends State<OrganoidDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Details"),
        ),
        body: Container(
            child: StreamBuilder(
                stream: getStream(context),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
                })));
  }

  getStream(context) async* {
    yield* FirebaseFirestore.instance
        .collection("organoids")
        .doc(widget.docID)
        .collection("organoid")
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

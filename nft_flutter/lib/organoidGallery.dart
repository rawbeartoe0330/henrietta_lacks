import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nft_flutter/biobank/organoidModel.dart';
import 'package:nft_flutter/organoidDetails.dart';

class OrganoidGallery extends StatefulWidget {
  const OrganoidGallery({Key? key}) : super(key: key);

  @override
  _OrganoidGalleryState createState() => _OrganoidGalleryState();
}

class _OrganoidGalleryState extends State<OrganoidGallery> {
  final FirebaseFirestore fb = FirebaseFirestore.instance;
  bool isGrid = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0.0, title: Text("Co-Lab")),
      body: ListView(
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                isGrid = !isGrid;
              });
            },
            icon: Icon(CupertinoIcons.square_grid_2x2),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: FutureBuilder(
              future: getImages(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return isGrid
                      ? GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return buildCard(
                                context, snapshot.data!.docs[index]);
                          },
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2))
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return buildCard(
                                context, snapshot.data!.docs[index]);
                          });
                } else if (snapshot.connectionState == ConnectionState.none) {
                  return Text("No data");
                }
                return CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }

  buildCard(BuildContext context, DocumentSnapshot snapshot) {
    final org = OrganoidModel.fromSnapshot(snapshot);
    return InkWell(
        child: Card(
            child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(org.study),
                Icon(
                  CupertinoIcons.star_fill,
                  color: Colors.yellow,
                  size: 15,
                )
              ],
            ),
            Image.network(org.image)
          ],
        )),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  OrganoidDetails(orgUID: org.docID, patUID: org.patientUID)));
        });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getImages() async {
    return fb.collection("organoids").where("image", isNotEqualTo: "").get();
  }
}

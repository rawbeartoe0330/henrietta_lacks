import 'package:cloud_firestore/cloud_firestore.dart';

class PhysicianModel {
  String avatarUrl;
  String email;
  String name;
  String phyType;
  String uid;
  String docID;

  PhysicianModel(this.avatarUrl, this.email, this.name, this.phyType, this.uid,
      this.docID);

  PhysicianModel.fromSnapshot(DocumentSnapshot snapshot)
      : avatarUrl = snapshot['avatarUrl'],
        email = snapshot['email'],
        name = snapshot['name'],
        phyType = snapshot['phyType'],
        uid = snapshot['uid'],
        docID = snapshot.id;
}

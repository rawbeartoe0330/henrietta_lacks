import 'package:cloud_firestore/cloud_firestore.dart';

class ManagerModel {
  String avatarURL;
  String docID;
  String uid;
  String email;
  String name;

  ManagerModel(this.avatarURL, this.docID, this.uid, this.email, this.name);

  ManagerModel.fromSnapshot(DocumentSnapshot snapshot)
      : avatarURL = snapshot['avatarURL'],
        docID = snapshot.id,
        uid = snapshot['uid'],
        email = snapshot['email'],
        name = snapshot['name'];
}

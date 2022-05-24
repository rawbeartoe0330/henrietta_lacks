import 'package:cloud_firestore/cloud_firestore.dart';

class PatientsModel {
  String name;
  String uid;
  String docID;

  PatientsModel(this.name, this.uid, this.docID);

  PatientsModel.fromSnapshot(DocumentSnapshot snapshot)
      : name = snapshot['name'],
        uid = snapshot['uid'],
        docID = snapshot.id;
}

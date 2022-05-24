import 'package:cloud_firestore/cloud_firestore.dart';

class PatientDetModel {
  String name;
  String uid;
  String docID;

  PatientDetModel(this.name, this.uid, this.docID);

  PatientDetModel.fromSnapshot(DocumentSnapshot snapshot)
      : name = snapshot['name'],
        uid = snapshot['uid'],
        docID = snapshot.id;
}

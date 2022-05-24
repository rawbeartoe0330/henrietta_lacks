import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  var participants;
  String docID;

  MessageModel(this.participants, this.docID);

  MessageModel.fromSnapshot(DocumentSnapshot snapshot)
      : participants = snapshot['participants'],
        docID = snapshot.id;
}

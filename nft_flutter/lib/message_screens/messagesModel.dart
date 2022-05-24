import 'package:cloud_firestore/cloud_firestore.dart';

class MessagesModel {
  String to;
  String from;
  String message;
  String date;
  String docID;

  MessagesModel(this.to, this.from, this.date, this.message, this.docID);

  MessagesModel.fromSnapshot(DocumentSnapshot snapshot)
      : to = snapshot['to'],
        from = snapshot['from'],
        message = snapshot['message'],
        date = snapshot['date'],
        docID = snapshot.id;
}

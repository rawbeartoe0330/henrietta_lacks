import 'package:cloud_firestore/cloud_firestore.dart';

class ImageModel {
  String url;

  ImageModel(this.url);

  ImageModel.fromSnapshot(DocumentSnapshot snapshot) : url = snapshot['url'];
}

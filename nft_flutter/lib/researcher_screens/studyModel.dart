import 'package:cloud_firestore/cloud_firestore.dart';

class StudyModel {
  String title;
  String brief;
  String websiteLink;
  String videoLink;
  String status;
  String researcherName;
  String researcherUID;
  String docID;
  var patients;

  StudyModel(
      this.title,
      this.brief,
      this.websiteLink,
      this.videoLink,
      this.status,
      this.researcherName,
      this.researcherUID,
      this.docID,
      this.patients);

  StudyModel.fromSnapshot(DocumentSnapshot snapshot)
      : title = snapshot['title'],
        brief = snapshot['brief'],
        websiteLink = snapshot['websiteLink'],
        videoLink = snapshot['videoLink'],
        status = snapshot['status'],
        researcherName = snapshot['researcherName'],
        researcherUID = snapshot['researcherUID'],
        docID = snapshot.id,
        patients = snapshot['patients'];
}

import 'package:cloud_firestore/cloud_firestore.dart';

class OrganoidModel {
  String tpno;
  String docID;
  String manager;
  String patientUID;
  String name;
  String er;
  String pr;
  String her2;
  String organoidID;
  String image;
  String tissueType;
  String pathologySite;
  String study;

  OrganoidModel(
      this.tpno,
      this.docID,
      this.manager,
      this.patientUID,
      this.name,
      this.er,
      this.pr,
      this.her2,
      this.organoidID,
      this.image,
      this.tissueType,
      this.pathologySite,
      this.study);

  OrganoidModel.fromSnapshot(DocumentSnapshot snapshot)
      : tpno = snapshot['TP'],
        docID = snapshot.id,
        manager = snapshot['manager'],
        patientUID = snapshot['patientUID'],
        name = snapshot['name'],
        er = snapshot['er'],
        pr = snapshot['pr'],
        her2 = snapshot['her2'],
        organoidID = snapshot['organoidID'],
        image = snapshot['image'],
        tissueType = snapshot['tissueType'],
        pathologySite = snapshot['pathologySite'],
        study = snapshot["study"];
}

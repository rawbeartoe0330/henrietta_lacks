import 'package:cloud_firestore/cloud_firestore.dart';

class PatientModel {
  String? name;
  String? motherName;
  String? fatherName;
  var age;
  String? uid;
  String? email;
  var allergies;
  var medHist;
  var repHist;
  var surHist;
  var socHist;
  var fatherHist;
  var motherHist;
  String? avatarUrl;
  String? primary;
  String? radiologist;
  String? pathologist;
  String? surgeon;
  String? moncologist;
  String? roncologist;

  PatientModel(
      this.name,
      this.motherName,
      this.fatherName,
      this.age,
      this.uid,
      this.email,
      this.allergies,
      this.medHist,
      this.repHist,
      this.surHist,
      this.socHist,
      this.fatherHist,
      this.motherHist,
      this.avatarUrl,
      this.primary,
      this.radiologist,
      this.pathologist,
      this.surgeon,
      this.moncologist,
      this.roncologist);

  PatientModel.fromSnapshot(DocumentSnapshot snapshot)
      : name = snapshot['name'],
        motherName = snapshot['motherName'],
        fatherName = snapshot['fatherName'],
        age = snapshot['age'],
        uid = snapshot['uid'],
        email = snapshot['email'],
        allergies = snapshot['allergies'],
        medHist = snapshot['medHist'],
        repHist = snapshot['repHist'],
        surHist = snapshot['surHist'],
        socHist = snapshot['socHist'],
        fatherHist = snapshot['fatherHist'],
        motherHist = snapshot['motherHist'],
        avatarUrl = snapshot['avatarUrl'],
        primary = snapshot['primary'],
        radiologist = snapshot['radiologist'],
        pathologist = snapshot['pathologist'],
        surgeon = snapshot['surgeon'],
        moncologist = snapshot['moncologist'],
        roncologist = snapshot['roncologist'];

  PatientModel.fromMap(Map<String, dynamic> mapData) {
    this.name = mapData['name'];
    this.motherName = mapData['motherName'];
    this.fatherName = mapData['fatherName'];
    this.age = mapData['age'];
    this.uid = mapData['uid'];
    this.email = mapData['email'];
    this.allergies = mapData['allergies'];
    this.medHist = mapData['medHist'];
    this.repHist = mapData['repHist'];
    this.surHist = mapData['surHist'];
    this.socHist = mapData['socHist'];
    this.fatherHist = mapData['fatherHist'];
    this.motherHist = mapData['motherHist'];
    this.avatarUrl = mapData['avatarUrl'];
  }
}

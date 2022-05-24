import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nft_flutter/blockchain_connection/patientListModel.dart';
import 'package:nft_flutter/patient_screens/patientModel.dart';

class AuthService {
  final FirebaseAuth _firebaseauth = FirebaseAuth.instance;

  Stream<String?> get authStateChange => _firebaseauth.authStateChanges().map(
        (User? user) => user?.uid,
      );

  Future<String> getCurrentUID() async {
    return (await _firebaseauth.currentUser)!.uid;
  }

  Future getCurrentUser() async {
    return await _firebaseauth.currentUser;
  }

  Future<String> createPatientWithEmailAndPassword(
      String name, String email, String password) async {
    await _firebaseauth.createUserWithEmailAndPassword(
        email: email, password: password);
    await FirebaseFirestore.instance
        .collection("patients")
        .doc(_firebaseauth.currentUser!.uid)
        .set({
      'name': name,
      'email': _firebaseauth.currentUser!.email,
      'uid': _firebaseauth.currentUser!.uid,
      'avatarUrl': '',
    });
    await _firebaseauth.currentUser!.updateDisplayName(name);
    return _firebaseauth.currentUser!.uid;
  }

  Future<String> createResearcherWithEmailAndPassword(
      String name, String email, String password) async {
    await _firebaseauth.createUserWithEmailAndPassword(
        email: email, password: password);
    await FirebaseFirestore.instance
        .collection("researcher")
        .doc(_firebaseauth.currentUser!.uid)
        .set({
      'name': name,
      'email': _firebaseauth.currentUser!.email,
      'uid': _firebaseauth.currentUser!.uid,
      'avatarUrl': '',
    });
    await _firebaseauth.currentUser!.updateDisplayName(name);
    return _firebaseauth.currentUser!.uid;
  }

  Future<String> createManagerWithEmailAndPassword(
      String name, String email, String password) async {
    await _firebaseauth.createUserWithEmailAndPassword(
        email: email, password: password);
    await FirebaseFirestore.instance
        .collection("biobankmanager")
        .doc(_firebaseauth.currentUser!.uid)
        .set({
      'name': name,
      'email': _firebaseauth.currentUser!.email,
      'uid': _firebaseauth.currentUser!.uid,
      'avatarUrl': '',
    });
    await _firebaseauth.currentUser!.updateDisplayName(name);
    return _firebaseauth.currentUser!.uid;
  }

  Future<String> createPhysicianWithEmailAndPassword(
      String name, String email, String password, String phyType) async {
    await _firebaseauth.createUserWithEmailAndPassword(
        email: email, password: password);
    await FirebaseFirestore.instance
        .collection("physician")
        .doc(_firebaseauth.currentUser!.uid)
        .set({
      'name': name,
      'email': _firebaseauth.currentUser!.email,
      'uid': _firebaseauth.currentUser!.uid,
      'avatarUrl': '',
      'phyType': phyType
    });
    await _firebaseauth.currentUser!.updateDisplayName(name);
    return _firebaseauth.currentUser!.uid;
  }

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    return (await _firebaseauth.signInWithEmailAndPassword(
            email: email, password: password))
        .user!
        .uid;
  }

  signOut() {
    return _firebaseauth.signOut();
  }

  Future sendPasswordResetLink(String email) {
    return _firebaseauth.sendPasswordResetEmail(email: email);
  }

  Future<List<PatientModel>> fetchAllUsers(User currentUser) async {
    List<PatientModel> userList = [];

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("patients").get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != _firebaseauth.currentUser!.uid) {
        userList.add(PatientModel.fromMap(
          querySnapshot.docs[i].data() as Map<String, dynamic>,
        ));
      }
    }
    return userList;
  }
}

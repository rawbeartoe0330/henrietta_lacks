import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nft_flutter/auth_files/auth.dart';
import 'package:nft_flutter/biobank/addOrganoid.dart';
import 'package:nft_flutter/main.dart';
import 'package:nft_flutter/patient_screens/patientModel.dart';
import 'package:string_validator/string_validator.dart';

class FindPatient extends StatefulWidget {
  const FindPatient({Key? key}) : super(key: key);

  @override
  _FindPatientState createState() => _FindPatientState();
}

class _FindPatientState extends State<FindPatient> {
  TextEditingController email = TextEditingController();
  AuthService _authService = AuthService();
  String query = "";
  late List<PatientModel> userList;

  @override
  void initState() {
    super.initState();

    _authService.getCurrentUser().then((user) {
      _authService.fetchAllUsers(user).then((List<PatientModel> list) {
        setState(() {
          userList = list;
        });
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create Organoid"),
        ),
        body: Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: ListView(children: [
              Material(
                  elevation: 5,
                  shadowColor: Colors.black26,
                  child: TextFormField(
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: email,
                      onChanged: (val) {
                        setState(() {
                          query = val;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            )),
                        hintText: "Email",
                      ))),
              buildSuggestions(query)
            ])));
  }

  buildSuggestions(String query) {
    final List<PatientModel> suggestionList = query.isEmpty
        ? []
        : userList.where((PatientModel user) {
            String _query = query.toLowerCase();
            bool matchesEmail = contains(_query, user.email);
            return (matchesEmail);
          }).toList();

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: suggestionList.length,
      itemBuilder: ((context, index) {
        PatientModel searchedUser = PatientModel(
            suggestionList[index].name,
            suggestionList[index].motherName,
            suggestionList[index].fatherName,
            suggestionList[index].age,
            suggestionList[index].uid,
            suggestionList[index].email,
            suggestionList[index].allergies,
            suggestionList[index].medHist,
            suggestionList[index].repHist,
            suggestionList[index].surHist,
            suggestionList[index].socHist,
            suggestionList[index].fatherHist,
            suggestionList[index].motherHist,
            suggestionList[index].avatarUrl,
            suggestionList[index].primary,
            suggestionList[index].radiologist,
            suggestionList[index].pathologist,
            suggestionList[index].surgeon,
            suggestionList[index].moncologist,
            suggestionList[index].radiologist);
        return ListTile(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Select this patient?"),
                    actions: [
                      TextButton(
                          onPressed: () async {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AddOrganoid(
                                      name: searchedUser.name!,
                                      puid: searchedUser.uid!,
                                    )));
                          },
                          child: Text("Yes"))
                    ],
                  );
                });
          },
          title: Text(
            searchedUser.name!,
            style: TextStyle(fontFamily: 'SFProSBold'),
          ),
          subtitle: Text(
            searchedUser.email!,
            style: TextStyle(fontFamily: 'SFProSBold', color: color),
          ),
        );
      }),
    );
  }
}

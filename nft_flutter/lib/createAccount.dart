//

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nft_flutter/biobank/organoidPage.dart';
import 'package:nft_flutter/blockchain_connection/patientListModel.dart';
import 'package:nft_flutter/blockchain_connection/researcherListModel.dart';
import 'package:nft_flutter/main.dart';
import 'package:nft_flutter/patient_screens/createPatient.dart';
import 'package:nft_flutter/auth_files/prov.dart';
import 'package:nft_flutter/physician/phyDets.dart';
import 'package:nft_flutter/researcher_screens/studies.dart';
import 'package:provider/provider.dart';
import 'package:nft_flutter/patient_screens/myDets.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String _selectedRole = "Patient";
  final ImagePicker _picker = ImagePicker();
  File? _image;
  bool phy = false;
  String? phyType = "Primary";

  @override
  Widget build(BuildContext context) {
    var listModel = Provider.of<ResearcherListModel>(context);
    var patientlsitmodel = Provider.of<PatientListModel>(context);
    TextEditingController name = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    TextEditingController number = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
        appBar: AppBar(elevation: 0.0, title: Text("Create an Account")),
        body: SingleChildScrollView(
          child: Center(
              child: Column(children: [
            Form(
                key: _formKey,
                child: ListView(shrinkWrap: true, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    CircleAvatar(
                        backgroundColor: Colors.grey.shade300,
                        radius: 50,
                        child: Icon(CupertinoIcons.person_alt, size: 80)),
                    Padding(
                        padding: EdgeInsets.only(top: 60),
                        child: IconButton(
                            icon: Icon(CupertinoIcons.camera, size: 25),
                            onPressed: () {
                              getImage();
                            }))
                  ]),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedRole,
                        icon:
                            Icon(Icons.arrow_drop_down_outlined, color: color),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(
                            color: color,
                            fontSize: 15,
                            fontFamily: "SFProSBold"),
                        underline: Container(height: 2, color: color),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedRole = newValue!;
                          });
                        },
                        items: <String>[
                          'Patient',
                          'Physician',
                          'Researcher',
                          'BioBank Manager',
                          'IRB member',
                          'Allies',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "SFProSBold",
                                    color: color)),
                          );
                        }).toList()),
                  ),
                  phy
                      ? Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: DropdownButton<String>(
                              isExpanded: true,
                              value: phyType,
                              icon: Icon(Icons.arrow_drop_down_outlined,
                                  color: color),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(
                                  color: color,
                                  fontSize: 15,
                                  fontFamily: "SFProSBold"),
                              underline: Container(height: 2, color: color),
                              onChanged: (String? newValue) {
                                setState(() {
                                  phyType = newValue;
                                });
                              },
                              items: <String>[
                                'Primary',
                                'Radiologist',
                                'Pathologist',
                                'Surgeon',
                                'Medical Oncologist',
                                'Radiation Oncologist'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: "SFProSBold",
                                          color: color)),
                                );
                              }).toList()),
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.only(right: 20, left: 20),
                    child: Material(
                        elevation: 5,
                        shadowColor: Colors.black26,
                        child: TextFormField(
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            controller: name,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  )),
                              hintText: "First Name",
                            ))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                        "If you are not the patient, please enter the patient's name"),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 20, left: 20, top: 20),
                    child: Material(
                        elevation: 5,
                        shadowColor: Colors.black26,
                        child: TextFormField(
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            controller: number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  )),
                              hintText: "Phone Number",
                            ))),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 20, left: 20, top: 20),
                    child: Material(
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
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  )),
                              hintText: "Email",
                            ))),
                  ),
                  Padding(
                      padding:
                          const EdgeInsets.only(right: 20, left: 20, top: 20),
                      child: Material(
                          elevation: 5,
                          shadowColor: Colors.black26,
                          child: TextFormField(
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              obscureText: true,
                              controller: password,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                          width: 0, style: BorderStyle.none)),
                                  hintText: "Password"))))
                ])),
            SizedBox(height: 20),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(color)),
                onPressed: () async {
                  final auth = Prov.of(context)!.auth;
                  // if (_image == null) {
                  //   showDialog(
                  //       context: context,
                  //       builder: (context) {
                  //         return AlertDialog(title: Text("Please add an image"));
                  //       });
                  // }
                  if (_formKey.currentState!.validate()) {
                    final String uid =
                        await Prov.of(context)!.auth.getCurrentUID();
                    if (_selectedRole == "Patient") {
                      await auth.createPatientWithEmailAndPassword(
                        name.text,
                        email.text,
                        password.text,
                      );
                      //patientlsitmodel.addPatient(
                      //, patientName, patientInfo, patientHistory);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => CreatePatient(
                              email: email.text, name: name.text)));
                      // Navigator.of(context).pushReplacement(MaterialPageRoute(
                      //     builder: (context) => CreatePatient(
                      //
                      //     name: name.text, email: email.text)));
                    } else if (_selectedRole == "Researcher") {
                      await auth.createResearcherWithEmailAndPassword(
                        name.text,
                        email.text,
                        password.text,
                      );
                      listModel.addResearcher(name.text, uid);
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => Studies()));
                    } else if (_selectedRole == "BioBank Manager") {
                      await auth.createManagerWithEmailAndPassword(
                        name.text,
                        email.text,
                        password.text,
                      );
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => OrganoidPage()));
                    } else if (_selectedRole == "Physician") {
                      await auth.createPhysicianWithEmailAndPassword(
                          name.text, email.text, password.text, phyType!);
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => PhysicianDets()));
                    }
                  }
                },
                child: Text("Create Account",
                    style: TextStyle(fontSize: 18, color: Colors.white)))
          ])),
        ));
  }

  Future getImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image!.path);
    });
  }

  Widget setImage() {
    // if (userData.avatarUrl == null || userData.avatarUrl == "") {
    //   return Text(userData.name[0], style: TextStyle(color: Colors.black));
    // } else
    if (_image != null) {
      return CircleAvatar(radius: 50, backgroundImage: FileImage(_image!));
    } else {
      return Image.asset("assets/img.png");
    }
    // else {
    //   return CircleAvatar(
    //       radius: 50, backgroundImage: NetworkImage(userData.avatarUrl));
    // }
  }
}

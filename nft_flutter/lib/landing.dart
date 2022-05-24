import 'package:flutter/material.dart';
import 'package:nft_flutter/biobank/managerScreen.dart';
import 'package:nft_flutter/createAccount.dart';
import 'package:nft_flutter/main.dart';
import 'package:nft_flutter/main_page.dart';
import 'package:nft_flutter/patient_screens/myDets.dart';
import 'package:nft_flutter/blockchain_connection/patientListModel.dart';
import 'package:nft_flutter/auth_files/prov.dart';
import 'package:nft_flutter/physician/physicianScreen.dart';
import 'package:nft_flutter/researcher_screens/researcherScreen.dart';
import 'package:nft_flutter/researcher_screens/studies.dart';
import 'package:provider/provider.dart';

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _error;
  String _selectedRole = "Patient";

  @override
  Widget build(BuildContext context) {
    var listModel = Provider.of<PatientListModel>(context);
    String age = "";
    String sex = "";
    return Scaffold(
        appBar: AppBar(
            elevation: 0.0,
            title: Text("Welcome | Biobank"),
            centerTitle: true),
        body: SingleChildScrollView(
            child: Center(
                child: Column(children: [
          showAlert(),
          SizedBox(height: 40),
          Text("Have an Account?", style: TextStyle(fontSize: 20)),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: DropdownButton<String>(
                isExpanded: true,
                value: _selectedRole,
                icon: Icon(Icons.arrow_drop_down_outlined, color: color),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(
                    color: color, fontSize: 15, fontFamily: "SFProSBold"),
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
          Form(
              key: _formKey,
              child: ListView(shrinkWrap: true, children: [
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
                  padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
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
                          controller: password,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                )),
                            hintText: "Password",
                          ))),
                ),
              ])),
          SizedBox(height: 30),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(color)),
              onPressed: () async {
                final auth = Prov.of(context)!.auth;
                try {
                  await auth.signInWithEmailAndPassword(
                      email.text, password.text);

                  // await FirebaseFirestore.instance
                  //     .collection("userData")
                  //     .where("email", isEqualTo: email.text)
                  //     .get()
                  //     .then((value) {
                  //   setState(() {
                  //     role = value.docs[0].data()['role'];
                  //     name = value.docs[0].data()['name'];
                  //   });
                  // });
                  if (_selectedRole == "Physician") {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => PhysicianScreen()));
                  } else if (_selectedRole == "Patient") {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => MyDets()));
                    // for (int i = 0; i < listModel.patientCount; i++) {
                    //   if (listModel.patients[i].patientName == name) {
                    //     setState(() {
                    //       age = "23";
                    //       //sex = listModel.patients[i].patientSex;
                    //     });
                    //   }
                    // }
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => MyDets()));
                  } else if (_selectedRole == "Researcher") {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => ResearcherScreen()));
                  } else if (_selectedRole == "BioBank Manager") {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => ManagerScreen()));
                  }
                } catch (err) {
                  setState(() {
                    print(err);
                    _error = err.toString();
                  });
                }
              },
              child: Text("Login",
                  style: TextStyle(fontSize: 18, color: Colors.white))),
          SizedBox(height: 40),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("Don't have an account?", style: TextStyle(fontSize: 20)),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CreateAccount()));
                },
                child: Text("Create Account", style: TextStyle(fontSize: 18)))
          ]),

          // Exit
          SizedBox(height: 160),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            //Text("If you want to exit -->", style: TextStyle(fontSize: 20)),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MainPage()));
                },
                child: Text("Exit", style: TextStyle(fontSize: 18)))
          ])
        ]))));
  }

  Widget showAlert() {
    if (_error != null) {
      return Container(
        color: Color.fromARGB(255, 253, 228, 0),
        width: double.infinity,
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: Text(
                _error!,
                maxLines: 3,
              ),
            ),
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _error = null;
                  });
                }),
          ],
        ),
      );
    } else {
      return SizedBox();
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nft_flutter/blockchain_connection/studyListModel.dart';
import 'package:nft_flutter/main.dart';
import 'package:provider/provider.dart';

class AddStudy extends StatefulWidget {
  const AddStudy({Key? key}) : super(key: key);

  @override
  _AddStudyState createState() => _AddStudyState();
}

class _AddStudyState extends State<AddStudy> {
  TextEditingController title = TextEditingController();
  TextEditingController brief = TextEditingController();
  TextEditingController videoLink = TextEditingController();
  TextEditingController websiteLink = TextEditingController();
  int currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  String? dropdownValue = "Completed";
  final auth = FirebaseAuth.instance;
  late User user;

  @override
  Widget build(BuildContext context) {
    var listModel = Provider.of<StudyListModel>(context);
    final isLastStep = currentStep == getSteps().length - 1;
    user = auth.currentUser!;
    return Scaffold(
        appBar: AppBar(elevation: 0.0, title: Text("Add Study")),
        body: Stepper(
            elevation: 0,
            currentStep: currentStep,
            type: StepperType.horizontal,
            steps: getSteps(),
            onStepContinue: () async {
              if (isLastStep) {
                listModel.addStudy(user.uid, title.text, "", "", "", "", "");
                //if (_formKey2.currentState!.validate()) {
                await FirebaseFirestore.instance
                    .collection("studies")
                    .doc()
                    .set({
                  "title": title.text,
                  "brief": brief.text == "" ? "" : brief.text,
                  "videoLink": videoLink.text == "" ? "" : videoLink.text,
                  "websiteLink": websiteLink.text == "" ? "" : websiteLink.text,
                  "status": dropdownValue,
                  "researcherName": user.displayName,
                  "researcherUID": user.uid,
                });
                Navigator.of(context).pop();
                //}
              } else {
                //if (currentStep == 0) {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    currentStep = currentStep + 1;
                  });
                } else {}
                //}
              }
            },
            onStepCancel: currentStep == 0
                ? null
                : () {
                    setState(() {
                      currentStep = currentStep - 1;
                    });
                  },
            controlsBuilder:
                (BuildContext context, ControlsDetails controlsDetails) {
              return Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(children: [
                    Expanded(
                        child: ElevatedButton(
                      onPressed: controlsDetails.onStepContinue,
                      child: Text(isLastStep ? "Confirm" : "Continue"),
                    )),
                    SizedBox(width: 20),
                    if (currentStep != 0)
                      Expanded(
                          child: TextButton(
                        onPressed: controlsDetails.onStepCancel,
                        child: Text("Back"),
                      ))
                  ]));
            }));
  }

  List<Step> getSteps() => [
        Step(
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 0,
            title: Container(),
            content: Form(
              key: _formKey,
              child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: ListView(shrinkWrap: true, children: [
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
                          controller: title,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                )),
                            hintText: "Title",
                          )),
                    ),
                    SizedBox(height: 20),
                    DropdownButton<String>(
                        isExpanded: true,
                        value: dropdownValue,
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
                            dropdownValue = newValue;
                          });
                        },
                        items: <String>[
                          'Completed',
                          'Recruiting',
                          'In-Progress',
                          'Waiting for Approval'
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
                    SizedBox(height: 25),
                  ])),
            )),
        Step(
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 1,
            title: Container(),
            content: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text("Tell us a little bit about your study"),
                  Material(
                      elevation: 5,
                      shadowColor: Colors.black26,
                      child: TextFormField(
                          minLines: 3,
                          maxLines: 5,
                          controller: brief,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      width: 0, style: BorderStyle.none)),
                              hintText: "Short Description (Optional)"))),
                  SizedBox(height: 20),
                  Text(
                    "Do you have a link to a YouTube video that explains your study?",
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: 10),
                  Material(
                      elevation: 5,
                      shadowColor: Colors.black26,
                      child: TextFormField(
                          controller: videoLink,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      width: 0, style: BorderStyle.none)),
                              hintText: "YouTube Link"))),
                  Text("Please put only a YouTube link here",
                      style: TextStyle(color: Colors.red, fontSize: 12)),
                  SizedBox(height: 20),
                  Text(
                    "Do you have a link to a website that gives more details on the study?",
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: 10),
                  Material(
                      elevation: 5,
                      shadowColor: Colors.black26,
                      child: TextFormField(
                          controller: websiteLink,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      width: 0, style: BorderStyle.none)),
                              hintText: "Website Link"))),
                  SizedBox(height: 20),
                ],
              ),
            )),
      ];

  //       Container(
  //           padding: const EdgeInsets.only(left: 20, right: 20),
  //           child: Form(
  //               key: _formKey,
  //               child: ListView(children: [
  //                 SizedBox(height: 20),
  //                 Center(
  //                     child: Text("Study Details",
  //                         style: TextStyle(fontSize: 20))),
  //                 SizedBox(height: 20),
  //                 Material(
  //                     elevation: 5,
  //                     shadowColor: Colors.black26,
  //                     child: TextFormField(
  //                         validator: (val) {
  //                           if (val == null || val.isEmpty) {
  //                             return 'Please enter some text';
  //                           }
  //                           return null;
  //                         },
  //                         controller: title,
  //                         decoration: InputDecoration(
  //                           border: OutlineInputBorder(
  //                               borderRadius: BorderRadius.circular(20),
  //                               borderSide: BorderSide(
  //                                 width: 0,
  //                                 style: BorderStyle.none,
  //                               )),
  //                           hintText: "Title",
  //                         ))),
  //                 SizedBox(height: 20),
  //                 Material(
  //                     elevation: 5,
  //                     shadowColor: Colors.black26,
  //                     child: TextFormField(
  //                         minLines: 3,
  //                         maxLines: 5,
  //                         controller: brief,
  //                         keyboardType: TextInputType.multiline,
  //                         decoration: InputDecoration(
  //                             border: OutlineInputBorder(
  //                                 borderRadius: BorderRadius.circular(20),
  //                                 borderSide: BorderSide(
  //                                     width: 0, style: BorderStyle.none)),
  //                             hintText: "Short Description (Optional)"))),
  //                 SizedBox(height: 20),
  //                 Row(children: [
  //                   Text("Status", style: TextStyle(fontSize: 18)),
  //                   Spacer(),
  //                   DropdownButton<String>(
  //                       value: dropdownValue,
  //                       icon: Icon(Icons.arrow_drop_down_outlined,
  //                           color: Color),
  //                       iconSize: 24,
  //                       elevation: 16,
  //                       style: TextStyle(
  //                           color: Color,
  //                           fontSize: 15,
  //                           fontFamily: "SFProSBold"),
  //                       underline: Container(height: 2, color: Color),
  //                       onChanged: (String? newValue) {
  //                         setState(() {
  //                           dropdownValue = newValue;
  //                         });
  //                       },
  //                       items: <String>[
  //                         'Completed',
  //                         'Recruiting',
  //                         'In-Progress',
  //                         'Waiting for Approval'
  //                       ].map<DropdownMenuItem<String>>((String value) {
  //                         return DropdownMenuItem<String>(
  //                           value: value,
  //                           child: Text(value,
  //                               style: TextStyle(
  //                                   fontSize: 15,
  //                                   fontFamily: "SFProSBold",
  //                                   color: Color)),
  //                         );
  //                       }).toList())
  //                 ]),
  //                 SizedBox(height: 20),
  //                 Text(
  //                   "Do you have a link to a video that explains your study? Put it down here",
  //                   style: TextStyle(fontSize: 15),
  //                 ),
  //                 SizedBox(height: 10),
  //                 Material(
  //                     elevation: 5,
  //                     shadowColor: Colors.black26,
  //                     child: TextFormField(
  //                         controller: brief,
  //                         keyboardType: TextInputType.multiline,
  //                         decoration: InputDecoration(
  //                             border: OutlineInputBorder(
  //                                 borderRadius: BorderRadius.circular(20),
  //                                 borderSide: BorderSide(
  //                                     width: 0, style: BorderStyle.none)),
  //                             hintText: "Video Link"))),
  //                 SizedBox(height: 20),
  //                 Text(
  //                   "Do you have a link to a site that gives more details on the study? Put it down here",
  //                   style: TextStyle(fontSize: 15),
  //                 ),
  //                 SizedBox(height: 10),
  //                 Material(
  //                     elevation: 5,
  //                     shadowColor: Colors.black26,
  //                     child: TextFormField(
  //                         controller: brief,
  //                         keyboardType: TextInputType.multiline,
  //                         decoration: InputDecoration(
  //                             border: OutlineInputBorder(
  //                                 borderRadius: BorderRadius.circular(20),
  //                                 borderSide: BorderSide(
  //                                     width: 0, style: BorderStyle.none)),
  //                             hintText: "Website Link"))),
  //                 SizedBox(height: 20),
  //                 ElevatedButton(
  //                     style: ButtonStyle(
  //                         backgroundColor: MaterialStateProperty.all<Color>(
  //                             Color)),
  //                     onPressed: () async {
  //                       final auth = Prov.of(context)!.auth.getCurrentUID();
  //                       if (_formKey.currentState!.validate()) {
  //                         showDialog(
  //                             barrierColor: Colors.black38,
  //                             context: context,
  //                             builder: (context) {
  //                               return WillPopScope(
  //                                   onWillPop: () async {
  //                                     return false;
  //                                   },
  //                                   child: AlertDialog(
  //                                     content: Text(
  //                                         "I understand that this study and all it's details will be visible to all the other users on this app. \n\nI also agree that all the information provided by me is correct to my knowledge"),
  //                                     actions: [
  //                                       ElevatedButton(
  //                                           child: Text("I agree"),
  //                                           style: ButtonStyle(
  //                                               backgroundColor:
  //                                                   MaterialStateProperty.all<
  //                                                           Color>(
  //                                                       Color)),
  //                                           onPressed: () async {
  //                                             Navigator.of(context).pop();
  //                                             Navigator.of(context).pop();
  //                                             await FirebaseFirestore.instance
  //                                                 .collection("studies")
  //                                                 .doc()
  //                                                 .set({
  //                                               "researcherName":
  //                                                   user.displayName,
  //                                               "researcherUID": user.uid,
  //                                               "title": title.text,
  //                                               "brief": brief.text == ""
  //                                                   ? ""
  //                                                   : brief.text,
  //                                               "status": dropdownValue == ""
  //                                                   ? "Completed"
  //                                                   : dropdownValue,
  //                                               "videoLink":
  //                                                   videoLink.text == ""
  //                                                       ? ""
  //                                                       : videoLink.text,
  //                                               "websiteLink":
  //                                                   websiteLink.text == ""
  //                                                       ? ""
  //                                                       : websiteLink.text
  //                                             });
  //                                           })
  //                                     ],
  //                                   ));
  //                             });
  //                       }
  //                     },
  //                     child: Text("Add Study",
  //                         style: TextStyle(fontSize: 18, color: Colors.white)))
  //               ]))));
  // }
}

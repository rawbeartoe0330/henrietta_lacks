import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:nft_flutter/main.dart';
import 'package:nft_flutter/patient_screens/myDets.dart';
import 'package:nft_flutter/blockchain_connection/patientListModel.dart';
import 'package:nft_flutter/auth_files/prov.dart';
import 'package:nft_flutter/patient_screens/view_consent_PDF.dart';
import 'package:provider/provider.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:sticky_headers/sticky_headers.dart';

//widget allows me to retrieve the name and email from previous screen

class CreatePatient extends StatefulWidget {
  final String email;
  final String name;
  const CreatePatient({Key? key, required this.name, required this.email})
      : super(key: key);

  @override
  _CreatePatientState createState() => _CreatePatientState();
}

class _CreatePatientState extends State<CreatePatient> {
  final auth = FirebaseAuth.instance;
  late User user;
  int currentStep = 0;
  String gender = "female";
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String formatteddate = "";
  String birthDate = "";
  String birthMonth = "";
  String birthYear = "";
  int age = 0;
  TextEditingController lastName = TextEditingController();
  TextEditingController motherName = TextEditingController();
  TextEditingController fatherName = TextEditingController();
  TextEditingController height = TextEditingController();
  TextEditingController weight = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  bool breastCancer = false;
  bool otherCancer = false;
  String cancerType = "Acute Lymphocytic Leukemia (ALL) in Adults";
  Map<String, bool> medHxt = {
    'Diabetes(High Blood Sugar)': false,
    'Heart Disease/High Blood Pressure': false,
    'History of Blood Clots': false,
    'Anemia/ Low Blood Count': false,
    'Thyroid Problems': false,
    'Liver Problems': false,
    'Kidney Problems': false,
    'GI/Stomach Problems': false,
    'Urinary/Bladder': false,
    'Mental History(Depression/Anxiety)': false,
    'Other': false
  };
  Map<String, bool> surHxt = {
    'Heart Surgery': false,
    'Blood Vessel Surgery': false,
    'Removal of Ovaries': false,
    'Hysterectomy': false,
    'Surgery on arms/legs': false,
    'Head/Neck Surgery': false,
    'Brain Surgery': false,
    'Bowel Surgery': false,
    'Kidney/Bladder surgery': false,
    'Plastic Surgery': false,
    'Prostate Surgery': false,
    'Breast Surgery': false,
    'Cancer Surgery': false,
    'Lung Surgery': false,
    'Heart Angioplasty/stent': false,
    'Cesarean section': false,
    'Other': false
  };
  Map<String, bool> allergies = {
    'Penicillin': false,
    'Tetracycline': false,
    'Sulfa': false,
    'Morphine': false,
    'Erythromycin': false,
    'Codeine': false,
    'Iodine/Betadine': false,
    'Radiographic dyes (IVP dye)': false,
    'Adhesive Tape': false,
    'Shellfish': false,
    'Other': false
  };
  Map<String, bool> socHxt = {
    'Cigs': false,
    'Former Tabocco': false,
    'Alcohol': false,
    'Former Alcohol': false,
  };
  Map<String, bool> repHxt = {
    'Fertile but no pregnancies yet': false,
    'Infertility': false,
    'Abnormal Menses': false,
    'Post Menopause': false,
    'Pre Menopuase': false,
  };
  Map<String, bool> motherHxt = {
    'Cancer': false,
    'Alcohol abuse': false,
    'Asthma': false,
    'Bleeding tendency': false,
    'Heart disease': false,
    'Deep vein thrombosis (DVT)': false,
    'Sugar Diabetes': false,
    'High Cholesterol': false,
    'High Triglycerides': false,
    'High Blood Pressure': false,
    'Lung Blood Clot': false,
    'Stroke': false,
    'Clotting Disorders': false,
    'Varicose veins': false,
    'Abnormal Menses': false,
    "Infertility": false
  };
  Map<String, bool> fatherHxt = {
    'Cancer': false,
    'Alcohol abuse': false,
    'Asthma': false,
    'Bleeding tendency': false,
    'Heart disease': false,
    'Deep vein thrombosis (DVT)': false,
    'Sugar Diabetes': false,
    'High Cholesterol': false,
    'High Triglycerides': false,
    'High Blood Pressure': false,
    'Lung Blood Clot': false,
    'Stroke': false,
    'Clotted superficial veins': false,
    'Clotting Disorders': false,
    'Varicose veins': false,
  };
  Map<String, bool> sad = {
    "None": false,
    "Local": false,
    "Advanced": false,
    "Metastatic": false,
  };
  Map<String, bool> gm = {
    "BRCA 1": false,
    "BRCA 2": false,
    "Other": false,
  };
  Map<String, bool> ctp = {
    "Yes(Current)": false,
    "Yes(Previous)": false,
    "No": false,
  };
  Map<String, bool> recurrency = {
    "Yes(Current)": false,
    "Yes(Previous)": false,
    "No": false,
  };
  Map<String, bool> timerecurrency = {
    "<6mo": false,
    "6-24mo": false,
    ">24mo": false,
  };
  Map<String, bool> bcs = {
    "Lumpectomy": false,
    "Other": false,
  };
  Map<String, bool> lns = {
    "Biopsy": false,
    "Removal": false,
    "Left": false,
    "Right": false,
  };
  Map<String, bool> mas = {
    "Left": false,
    "Right": false,
  };
  Map<String, bool> br = {
    "Left": false,
    "Right": false,
  };
  Map<String, bool> drug = {
    "AC": false,
    "AC-T": false,
    "CAF": false,
    "CMF": false,
    "FEC": false,
    "TAC": false,
  };
  Map<String, bool> rt = {
    "Internal Left": false,
    "Internal Right": false,
    "External Left": false,
    "External Right": false,
  };
  Map<String, bool> ht = {
    "Tamoxifen": false,
    "Raloxifene": false,
    "Aromatase Inhibitors": false,
    "Other": false,
  };

  Map<String, bool> tt = {
    "Tratuzumab": false,
    "Tratuzuma-deruxtecan": false,
    "Pertuzumab": false,
    "Ado-trastuzumab": false,
    "Sacituzumab": false,
    "Other": false
  };
  Map<String, bool> tki = {
    "Tucatinib": false,
    "Neratinib": false,
    "Lapatinib": false,
  };
  Map<String, bool> cdk = {
    "Palbociclib": false,
    "Ribociclib": false,
    "Abemaciclib": false,
    "Alpelisib": false,
  };
  Map<String, bool> mtor = {
    "Everolimus": false,
    "Other": false,
  };
  Map<String, bool> parp = {
    "Olaparib": false,
    "Talazoparib": false,
  };
  Map<String, bool> imm = {
    "PD-1": false,
    "PD-L1": false,
    "Other": false,
  };
  Map<String, bool> comm = {
    "Surgical - breast or chest wall": false,
    "Surgical-lymphedema": false,
    "Blood clots": false,
    "Menopause related": false,
    "Secondary cancers": false,
    "Lung inflammation": false,
    "Heart failure": false,
    "Other": false
  };
  Map<String, bool> otherCan = {
    "Prior Surgery": false,
    "Chemo": false,
    "Radiation": false,
  };

  List<String> medHist = [];
  List<String> surHist = [];
  List<String> allergy = [];
  List<String> socHist = [];
  List<String> repHist = [];
  List<String> motherHist = [];
  List<String> fatherHist = [];

  setSelectedRadioTile(String val) {
    setState(() {
      gender = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    String birthPlace = countryValue + stateValue + cityValue;
    user = auth.currentUser!;
    var listModel = Provider.of<PatientListModel>(context);
    final isLastStep = currentStep == getSteps().length - 1;
    return Scaffold(
        appBar: AppBar(title: Text("Add Patient Details")),
        body: Stepper(
            elevation: 0,
            currentStep: currentStep,
            type: StepperType.horizontal,
            steps: getSteps(),
            onStepContinue: () async {
              if (isLastStep) {
                if (_formKey2.currentState!.validate()) {
                  List<String> totHist =
                      medHist + surHist + socHist + repHist + allergy;
                  String info = "23" + "US" + gender;
                  print(user.uid);
                  print(widget.name);
                  print(birthPlace);
                  print(gender);
                  print(motherName.text);
                  print(totHist.toString());
                  motherHxt.forEach((key, value) {
                    if (motherHxt[key] == true) {
                      if (!motherHist.contains(key)) motherHist.add(key);
                    }
                  });
                  fatherHxt.forEach((key, value) {
                    if (fatherHxt[key] == true) {
                      if (!fatherHist.contains(key)) fatherHist.add(key);
                    }
                  });

                  /// Listmodel --> Connection to Blockchain starts here
                  ///
                  listModel.addPatient(
                      user.uid, widget.name, info, "totHist.toString()");
                  final uid = await Prov.of(context)!.auth.getCurrentUID();

                  await FirebaseFirestore.instance
                      .collection("patients")
                      .doc(uid)
                      .update({
                    "age": age,
                    "medHist": FieldValue.arrayUnion(medHist),
                    "surHist": FieldValue.arrayUnion(surHist),
                    "socHist": FieldValue.arrayUnion(socHist),
                    "repHist": FieldValue.arrayUnion(repHist),
                    "allergies": FieldValue.arrayUnion(allergy),
                    "motherName": motherName.text,
                    "motherHist": FieldValue.arrayUnion(motherHist),
                    "fatherName": fatherName.text,
                    "fatherHist": FieldValue.arrayUnion(fatherHist)
                  });
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => MyDets()));
                }
              } else {
                if (currentStep == 0) {
                  //if (_formKey.currentState!.validate()) {
                  setState(() {
                    currentStep = currentStep + 1;
                  });
                  // } else {
                  //   return null;
                  // }
                } else if (currentStep == 1) {
                  setState(() {
                    medHxt.forEach((key, value) {
                      if (medHxt[key] == true) {
                        if (!medHist.contains(key)) medHist.add(key);
                      }
                    });
                    currentStep = currentStep + 1;
                  });
                } else if (currentStep == 2) {
                  setState(() {
                    surHxt.forEach((key, value) {
                      if (surHxt[key] == true) {
                        if (!surHist.contains(key)) surHist.add(key);
                      }
                    });
                    currentStep = currentStep + 1;
                  });
                } else if (currentStep == 3) {
                  setState(() {
                    socHxt.forEach((key, value) {
                      if (socHxt[key] == true) {
                        if (!socHist.contains(key)) socHist.add(key);
                      }
                    });
                    currentStep = currentStep + 1;
                  });
                } else if (currentStep == 4) {
                  setState(() {
                    repHxt.forEach((key, value) {
                      if (repHxt[key] == true) {
                        if (!repHist.contains(key)) repHist.add(key);
                      }
                    });
                    currentStep = currentStep + 1;
                  });
                } else if (currentStep == 5) {
                  setState(() {
                    allergies.forEach((key, value) {
                      if (allergies[key] == true) {
                        if (!allergy.contains(key)) allergy.add(key);
                      }
                    });
                    currentStep = currentStep + 1;
                  });
                } else if (currentStep == 6) {
                  setState(() {
                    repHxt.forEach((key, value) {
                      if (repHxt[key] == true) {
                        if (!repHist.contains(key)) repHist.add(key);
                      }
                    });
                    currentStep = currentStep + 1;
                  });
                } else if (currentStep == 7) {
                  setState(() {
                    //   repHxt.forEach((key, value) {
                    //     if (repHxt[key] == true) {
                    //       if (!repHist.contains(key)) repHist.add(key);
                    //     }
                    //   });
                    currentStep = currentStep + 1;
                  });
                } else if (currentStep == 8) {
                  setState(() {
                    //   repHxt.forEach((key, value) {
                    //     if (repHxt[key] == true) {
                    //       if (!repHist.contains(key)) repHist.add(key);
                    //     }
                    //   });
                    currentStep = currentStep + 1;
                  });
                } else if (currentStep == 9) {
                  setState(() {
                    //   repHxt.forEach((key, value) {
                    //     if (repHxt[key] == true) {
                    //       if (!repHist.contains(key)) repHist.add(key);
                    //     }
                    //   });
                    currentStep = currentStep + 1;
                  });
                }
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
                  margin: EdgeInsets.only(left: 20),
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
                child: Column(children: [
                  Padding(
                      padding: const EdgeInsets.only(right: 20, left: 20),
                      child: Material(
                          elevation: 5,
                          shadowColor: Colors.black26,
                          child: TextFormField(
                              initialValue: widget.name,
                              enabled: false,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      )))))),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 20, left: 20, top: 20, bottom: 15),
                    child: Material(
                        elevation: 5,
                        shadowColor: Colors.black26,
                        child: TextFormField(
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Please enter name';
                              }
                              return null;
                            },
                            controller: lastName,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  )),
                              hintText: "Last Name",
                            ))),
                  ),
                  Text(
                    "Sex at birth",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  //Male or Female
                  Row(children: [
                    Expanded(
                        child: RadioListTile(
                            value: "female",
                            groupValue: gender,
                            onChanged: (value) {
                              setSelectedRadioTile(value.toString());
                            },
                            title: Text("Female"))),
                    Expanded(
                        child: RadioListTile(
                      value: "male",
                      groupValue: gender,
                      onChanged: (value) {
                        setSelectedRadioTile(value.toString());
                      },
                      title: Text("Male"),
                    ))
                  ]),
                  Column(children: [
                    Padding(
                        padding: const EdgeInsets.only(bottom: 10, top: 10),
                        child: Text("Date of Birth",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(children: [
                        ElevatedButton(
                            onPressed: () {
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  maxTime: DateTime.now(),
                                  minTime: DateTime(DateTime.now().year - 120),
                                  onConfirm: (date) {
                                var formatter = new DateFormat('dd-MMMM-yyyy');
                                formatteddate = formatter.format(date);
                                var formatter1 = new DateFormat('d');
                                birthDate = formatter1.format(date);
                                var formatter2 = new DateFormat("M");
                                birthMonth = formatter2.format(date);
                                var formatter3 = new DateFormat("y");
                                birthYear = formatter3.format(date);
                                setState(() {
                                  DateTime currentDate = DateTime.now();
                                  int current = currentDate.year;
                                  age = current - int.parse(birthYear);
                                  int month1 = currentDate.month;
                                  int month2 = int.parse(birthMonth);
                                  if (month2 > month1) {
                                    age--;
                                  } else if (month1 == month2) {
                                    int day1 = currentDate.day;
                                    int day2 = int.parse(birthDate);
                                    if (day2 > day1) {
                                      age--;
                                    }
                                  }
                                });
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.en);
                            },
                            child: Text("Select Date")),
                        Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              "Age:  " + age.toString(),
                              style: TextStyle(fontSize: 18),
                            )),
                      ]),
                    ),
                    SizedBox(height: 45),
                    /*Row(children: [
                      Expanded(
                          child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 20, left: 20),
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
                                      controller: height,
                                      // keyboardType:
                                      //     TextInputType.numberWithOptions(),
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: BorderSide(
                                                  width: 0,
                                                  style: BorderStyle.none)),
                                          hintText: "Height"))))),
                      Expanded(
                          child: Padding(
                              padding: const EdgeInsets.only(right: 20),
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
                                      controller: weight,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      keyboardType:
                                          TextInputType.numberWithOptions(),
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: BorderSide(
                                                  width: 0,
                                                  style: BorderStyle.none)),
                                          hintText: "Weight in lb")))))
                    ]), */
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: CSCPicker(
                        countrySearchPlaceholder:
                            countryValue == "" ? "Country" : countryValue,
                        selectedItemStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        dropdownHeadingStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                        dropdownItemStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        dropdownDialogRadius: 10.0,
                        searchBarRadius: 10.0,
                      ),
                    )
                  ]),
                  SizedBox(height: 20),
                ]))),
        /* 
          **** COMMENTING STEPS **** 

          Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: Container(),
          content: Column(children: [
            StickyHeader(
                header: Center(
                  child: Container(
                    padding: EdgeInsets.only(left: 40, right: 40),
                    color: Colors.grey.shade300,
                    child: Column(
                      children: [
                        Text("Medical History",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text("Please select ALL that are applicable",
                            style: TextStyle(fontSize: 16)),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                content: Column(
                  children: [
                    ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: medHxt.keys.map((String key) {
                          return new CheckboxListTile(
                              title: Text(key),
                              value: medHxt[key],
                              onChanged: (bool? val) {
                                setState(() {
                                  medHxt[key] = val!;
                                });
                              });
                        }).toList()),
                    SizedBox(height: 20)
                  ],
                )),
          ]),
        ),
        Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: Container(),
          content: Column(children: [
            StickyHeader(
                header: Center(
                  child: Container(
                    padding: EdgeInsets.only(left: 40, right: 40),
                    color: Colors.grey.shade300,
                    child: Column(
                      children: [
                        Text("Surgical History",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text("Please select ALL that are applicable",
                            style: TextStyle(fontSize: 16)),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                content: Column(
                  children: [
                    ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: surHxt.keys.map((String key) {
                          return new CheckboxListTile(
                              title: Text(key),
                              value: surHxt[key],
                              onChanged: (bool? val) {
                                setState(() {
                                  surHxt[key] = val!;
                                });
                              });
                        }).toList()),
                    SizedBox(height: 20)
                  ],
                )),
          ]),
        ),
        Step(
          state: currentStep > 3 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 3,
          title: Container(),
          content: Column(children: [
            StickyHeader(
                header: Center(
                  child: Container(
                    padding: EdgeInsets.only(left: 40, right: 40),
                    color: Colors.grey.shade300,
                    child: Column(
                      children: [
                        Text("Please select ALL that are applicable",
                            style: TextStyle(fontSize: 16)),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                content: Column(
                  children: [
                    ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: socHxt.keys.map((String key) {
                          return new CheckboxListTile(
                              title: Text(key),
                              value: socHxt[key],
                              onChanged: (bool? val) {
                                setState(() {
                                  socHxt[key] = val!;
                                });
                              });
                        }).toList()),
                    SizedBox(height: 20)
                  ],
                )),
          ]),
        ), 
        Step(
          state: currentStep > 4 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 4,
          title: Container(),
          content: Column(children: [
            StickyHeader(
                header: Center(
                  child: Container(
                    padding: EdgeInsets.only(left: 40, right: 40),
                    color: Colors.grey.shade300,
                    child: Column(
                      children: [
                        Text("Reproductive History",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text("Please select ALL that are applicable",
                            style: TextStyle(fontSize: 16)),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                content: Column(
                  children: [
                    ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: repHxt.keys.map((String key) {
                          return new CheckboxListTile(
                              title: Text(key),
                              value: repHxt[key],
                              onChanged: (bool? val) {
                                setState(() {
                                  repHxt[key] = val!;
                                });
                              });
                        }).toList()),
                    SizedBox(height: 20)
                  ],
                )),
          ]),
        ),    */
        Step(
          state: currentStep > 5 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 5,
          title: Container(),
          content: Column(children: [
            StickyHeader(
                header: Center(
                  child: Container(
                    padding: EdgeInsets.only(left: 40, right: 40),
                    color: Colors.grey.shade300,
                    child: Column(
                      children: [
                        Text("Allergies",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text("Please select ALL that are applicable",
                            style: TextStyle(fontSize: 16)),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                content: Column(
                  children: [
                    ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: allergies.keys.map((String key) {
                          return new CheckboxListTile(
                              title: Text(key),
                              value: allergies[key],
                              onChanged: (bool? val) {
                                setState(() {
                                  allergies[key] = val!;
                                });
                              });
                        }).toList()),
                    SizedBox(height: 20)
                  ],
                )),
          ]),
        ),
        Step(
          state: currentStep > 6 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 6,
          title: Container(),
          content: Column(children: [
            StickyHeader(
                header: Center(
                  child: Container(
                    padding: EdgeInsets.only(left: 40, right: 40),
                    color: Colors.grey.shade300,
                    child: Column(
                      children: [
                        Text("Cancer History",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text("Please select ALL that are applicable",
                            style: TextStyle(fontSize: 16)),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                content: Column(
                  children: [
                    ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          CheckboxListTile(
                            value: breastCancer,
                            title: Text("Breast Cancer"),
                            onChanged: (value) {
                              setState(() {
                                breastCancer = value!;
                              });
                            },
                          ),
                          breastCancer
                              ? Column(children: [
                                  TextFormField(
                                      validator: (val) {
                                        if (val == null || val.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: BorderSide(
                                                  width: 0,
                                                  style: BorderStyle.none)),
                                          hintText: "Age at Diagnosis")),
                                  Text("Stage at diagnosis"),
                                  ListView(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      children: sad.keys.map((String key) {
                                        return new CheckboxListTile(
                                            title: Text(key),
                                            value: sad[key],
                                            onChanged: (bool? val) {
                                              setState(() {
                                                sad[key] = val!;
                                              });
                                            });
                                      }).toList()),
                                  Text("Genetic mutations"),
                                  ListView(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      children: gm.keys.map((String key) {
                                        return new CheckboxListTile(
                                            title: Text(key),
                                            value: gm[key],
                                            onChanged: (bool? val) {
                                              setState(() {
                                                gm[key] = val!;
                                              });
                                            });
                                      }).toList()),
                                  Text("Clinical trial participation"),
                                  ListView(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      children: ctp.keys.map((String key) {
                                        return new CheckboxListTile(
                                            title: Text(key),
                                            value: ctp[key],
                                            onChanged: (bool? val) {
                                              setState(() {
                                                ctp[key] = val!;
                                              });
                                            });
                                      }).toList()),
                                  Text("Recurrence"),
                                  ListView(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      children:
                                          recurrency.keys.map((String key) {
                                        return new CheckboxListTile(
                                            title: Text(key),
                                            value: recurrency[key],
                                            onChanged: (bool? val) {
                                              setState(() {
                                                recurrency[key] = val!;
                                              });
                                            });
                                      }).toList()),
                                  Text("Time to Recurrence"),
                                  ListView(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      children:
                                          timerecurrency.keys.map((String key) {
                                        return new CheckboxListTile(
                                            title: Text(key),
                                            value: timerecurrency[key],
                                            onChanged: (bool? val) {
                                              setState(() {
                                                timerecurrency[key] = val!;
                                              });
                                            });
                                      }).toList()),
                                  Text("Breast conserving surgery"),
                                  ListView(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      children: bcs.keys.map((String key) {
                                        return new CheckboxListTile(
                                            title: Text(key),
                                            value: bcs[key],
                                            onChanged: (bool? val) {
                                              setState(() {
                                                bcs[key] = val!;
                                              });
                                            });
                                      }).toList()),
                                  Text("Lymph node surgery"),
                                  ListView(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      children: lns.keys.map((String key) {
                                        return new CheckboxListTile(
                                            title: Text(key),
                                            value: lns[key],
                                            onChanged: (bool? val) {
                                              setState(() {
                                                lns[key] = val!;
                                              });
                                            });
                                      }).toList()),
                                  Text("Mastectomy"),
                                  ListView(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      children: mas.keys.map((String key) {
                                        return new CheckboxListTile(
                                            title: Text(key),
                                            value: mas[key],
                                            onChanged: (bool? val) {
                                              setState(() {
                                                mas[key] = val!;
                                              });
                                            });
                                      }).toList()),
                                  Text("Breast reconstruction"),
                                  ListView(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      children: br.keys.map((String key) {
                                        return new CheckboxListTile(
                                            title: Text(key),
                                            value: br[key],
                                            onChanged: (bool? val) {
                                              setState(() {
                                                br[key] = val!;
                                              });
                                            });
                                      }).toList()),
                                  Text("Drug Combinations"),
                                  ListView(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      children: drug.keys.map((String key) {
                                        return new CheckboxListTile(
                                            title: Text(key),
                                            value: drug[key],
                                            onChanged: (bool? val) {
                                              setState(() {
                                                drug[key] = val!;
                                              });
                                            });
                                      }).toList()),
                                  Text("Radiation Therapy"),
                                  ListView(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      children: rt.keys.map((String key) {
                                        return new CheckboxListTile(
                                            title: Text(key),
                                            value: rt[key],
                                            onChanged: (bool? val) {
                                              setState(() {
                                                rt[key] = val!;
                                              });
                                            });
                                      }).toList()),
                                  Text("Hormone Therapy"),
                                  ListView(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      children: ht.keys.map((String key) {
                                        return new CheckboxListTile(
                                            title: Text(key),
                                            value: ht[key],
                                            onChanged: (bool? val) {
                                              setState(() {
                                                ht[key] = val!;
                                              });
                                            });
                                      }).toList()),
                                  Text("Targeted Therapy"),
                                  ListView(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      children: tt.keys.map((String key) {
                                        return new CheckboxListTile(
                                            title: Text(key),
                                            value: tt[key],
                                            onChanged: (bool? val) {
                                              setState(() {
                                                tt[key] = val!;
                                              });
                                            });
                                      }).toList()),
                                  Text("Tyrosine kinase inhibitors"),
                                  ListView(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      children: tki.keys.map((String key) {
                                        return new CheckboxListTile(
                                            title: Text(key),
                                            value: tki[key],
                                            onChanged: (bool? val) {
                                              setState(() {
                                                tki[key] = val!;
                                              });
                                            });
                                      }).toList()),
                                  Text("CDK inhibitors"),
                                  ListView(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      children: cdk.keys.map((String key) {
                                        return new CheckboxListTile(
                                            title: Text(key),
                                            value: cdk[key],
                                            onChanged: (bool? val) {
                                              setState(() {
                                                cdk[key] = val!;
                                              });
                                            });
                                      }).toList()),
                                  Text("mTOR inhibitors"),
                                  ListView(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      children: mtor.keys.map((String key) {
                                        return new CheckboxListTile(
                                            title: Text(key),
                                            value: mtor[key],
                                            onChanged: (bool? val) {
                                              setState(() {
                                                mtor[key] = val!;
                                              });
                                            });
                                      }).toList()),
                                  Text("PARP inhibitor"),
                                  ListView(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      children: parp.keys.map((String key) {
                                        return new CheckboxListTile(
                                            title: Text(key),
                                            value: parp[key],
                                            onChanged: (bool? val) {
                                              setState(() {
                                                parp[key] = val!;
                                              });
                                            });
                                      }).toList()),
                                  Text("Immunotherapy"),
                                  ListView(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      children: imm.keys.map((String key) {
                                        return new CheckboxListTile(
                                            title: Text(key),
                                            value: imm[key],
                                            onChanged: (bool? val) {
                                              setState(() {
                                                imm[key] = val!;
                                              });
                                            });
                                      }).toList()),
                                  Text("Complications"),
                                  ListView(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      children: comm.keys.map((String key) {
                                        return new CheckboxListTile(
                                            title: Text(key),
                                            value: comm[key],
                                            onChanged: (bool? val) {
                                              setState(() {
                                                comm[key] = val!;
                                              });
                                            });
                                      }).toList()),
                                ])
                              : Container(),
                          CheckboxListTile(
                              title: Text("Other Cancer"),
                              value: otherCancer,
                              onChanged: (value) {
                                setState(() {
                                  otherCancer = value!;
                                });
                              }),
                          otherCancer
                              ? Column(
                                  children: [
                                    DropdownButton<String>(
                                        isExpanded: true,
                                        value: cancerType,
                                        icon: Icon(
                                            Icons.arrow_drop_down_outlined,
                                            color: color),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: TextStyle(
                                            color: color,
                                            fontSize: 15,
                                            fontFamily: "SFProSBold"),
                                        underline:
                                            Container(height: 2, color: color),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            cancerType = newValue!;
                                          });
                                        },
                                        items: <String>[
                                          'Acute Lymphocytic Leukemia (ALL) in Adults',
                                          'Acute Myeloid Leukemia (AML) in Adults',
                                          'Adrenal Cancer',
                                          'Anal Cancer',
                                          'Basal and Squamous Cell Skin Cancer',
                                          'Bile Duct Cancer',
                                          'Bladder Cancer',
                                          'Bone Cancer',
                                          'Brain and Spinal Cord Tumors in Adults',
                                          'Brain and Spinal Cord Tumors in Children',
                                          'Cancer in Adolescents',
                                          'Cancer in Children',
                                          'Cancer in Young Adults',
                                          'Cancer of Unknown Primary',
                                          'Cervical Cancer',
                                          'Chronic Lymphocytic Leukemia (CLL)',
                                          'Chronic Myeloid Leukemia (CML)',
                                          'Chronic Myelomonocytic Leukemia (CMML)',
                                          'Colorectal Cancer',
                                          'Endometrial Cancer',
                                          'Esophagus Cancer',
                                          'Ewing Family of Tumors',
                                          'Eye Cancer (Ocular Melanoma)',
                                          'Gallbladder Cancer',
                                          'Gastrointestinal Neuroendocrine (Carcinoid) Tumors',
                                          'Gastrointestinal Stromal Tumor (GIST)',
                                          'Head and Neck Cancers',
                                          'Hodgkin Lymphoma',
                                          'Kaposi Sarcoma',
                                          'Kidney Cancer',
                                          'Laryngeal and Hypopharyngeal Cancer',
                                          'Leukemia',
                                          'Leukemia in Children',
                                          'Liver Cancer',
                                          'Lung Cancer',
                                          'Lung Carcinoid Tumor',
                                          'Lymphoma',
                                          'Lymphoma of the Skin',
                                          'Malignant Mesothelioma',
                                          'Melanoma Skin Cancer',
                                          'Merkel Cell Skin Cancer',
                                          'Multiple Myeloma',
                                          'Myelodysplastic Syndromes',
                                          'Nasal Cavity and Paranasal Sinuses Cancer',
                                          'Nasopharyngeal Cancer',
                                          'Neuroblastoma',
                                          'Non-Hodgkin Lymphoma',
                                          'Non-Hodgkin Lymphoma in Children',
                                          'Oral Cavity (Mouth) and Oropharyngeal (Throat) Cancer',
                                          'Osteosarcoma',
                                          'Ovarian Cancer',
                                          'Pancreatic Cancer',
                                          'Pancreatic Neuroendocrine Tumor (NET)',
                                          'Penile Cancer',
                                          'Pituitary Tumors',
                                          'Prostate Cancer',
                                          'Retinoblastoma',
                                          'Rhabdomyosarcoma',
                                          'Salivary Gland Cancer',
                                          'Skin Cancer',
                                          'Small Intestine Cancer',
                                          'Soft Tissue Sarcoma',
                                          'Stomach Cancer',
                                          'Testicular Cancer',
                                          'Thymus Cancer',
                                          'Thyroid Cancer',
                                          'Uterine Sarcoma',
                                          'Vaginal Cancer',
                                          'Vulvar Cancer',
                                          'Waldenstrom Macroglobulinemia',
                                          'Wilms Tumor'
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontFamily: "SFProSBold",
                                                    color: color)),
                                          );
                                        }).toList()),
                                    CheckboxListTile(
                                        value: false,
                                        onChanged: (value) => !value!,
                                        title: Text("Prior Surgery")),
                                    CheckboxListTile(
                                      value: false,
                                      onChanged: (value) => !value!,
                                      title: Text("Chemo"),
                                    ),
                                    CheckboxListTile(
                                      value: false,
                                      onChanged: (value) => !value!,
                                      title: Text("Radiation"),
                                    ),
                                  ],
                                )
                              : Container()
                        ])
                  ],
                )),
          ]),
        ),
        Step(
            state: currentStep > 7 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 7,
            title: Container(),
            content: Form(
                key: _formKey2,
                child: Column(children: [
                  /*Padding(
                      padding:
                          const EdgeInsets.only(right: 20, left: 20, top: 15),
                      child: Material(
                          elevation: 5,
                          shadowColor: Colors.black26,
                          child: TextFormField(
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Please enter mothers name';
                                }
                                return null;
                              },
                              controller: motherName,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    )),
                                hintText: "Mother's Full Name",
                              )))), */
                  Column(children: [
                    StickyHeader(
                        header: Center(
                          child: Container(
                            padding: EdgeInsets.only(left: 40, right: 40),
                            color: Colors.grey.shade300,
                            child: Column(
                              children: [
                                Text("Medical History",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 10),
                                Text("Please select ALL that are applicable",
                                    style: TextStyle(fontSize: 16)),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                        content: Column(
                          children: [
                            ListView(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: motherHxt.keys.map((String key) {
                                  return new CheckboxListTile(
                                      title: Text(key),
                                      value: motherHxt[key],
                                      onChanged: (bool? val) {
                                        setState(() {
                                          motherHxt[key] = val!;
                                        });
                                      });
                                }).toList()),
                            SizedBox(height: 20)
                          ],
                        )),
                  ]),
                  /*Padding(
                      padding: const EdgeInsets.only(
                          right: 20, left: 20, top: 20, bottom: 15),
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
                              controller: fatherName,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                          width: 0, style: BorderStyle.none)),
                                  hintText: "Father's Full Name")))), */
                  Column(children: [
                    StickyHeader(
                        header: Center(
                          child: Container(
                            padding: EdgeInsets.only(left: 40, right: 40),
                            color: Colors.grey.shade300,
                            child: Column(
                              children: [
                                Text("Medical History",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 10),
                                Text("Select applicable alternatives",
                                    style: TextStyle(fontSize: 16)),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                        content: Column(
                          children: [
                            ListView(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: fatherHxt.keys.map((String key) {
                                  return new CheckboxListTile(
                                      title: Text(key),
                                      value: fatherHxt[key],
                                      onChanged: (bool? val) {
                                        setState(() {
                                          fatherHxt[key] = val!;
                                        });
                                      });
                                }).toList()),
                            SizedBox(height: 20)
                          ],
                        )),
                  ]),
                ]))),
        Step(
            state: currentStep > 8 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 8,
            title: Container(),
            content: Column(children: [
              StickyHeader(
                header: Center(
                  child: Container(
                    padding: EdgeInsets.only(left: 40, right: 40),
                    color: Colors.grey.shade300,
                    child: Column(
                      children: [
                        Text("BioBank Consent", style: TextStyle(fontSize: 16)),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                content: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      /*Text("Consent to Be Included in the BioBank",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      Text("Description",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(
                          "As part of your medical care, you may undergo medical procedures that involve the removal or collection of biological specimens (such as blood,urine and other fluids or tissues).We are asking your permission to add your specimens and/or your medical information to the UPMC Breast Disease Research Repository (BDRR). No additional tissue will be removed surgically or collected for the purpose of including a sample in BDRR. If you agree to this request, all testing of your specimens that are required for your medical care will be completed before they are deposited into the BDRR. We may also ask for small additional blood samples and/or for additional samples of urine or other fluids. If possible, those would be obtained at a time when you are having specimens collected as part of your clinical care",
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 20),
                      Text(
                          "Biological specimens placed in this Research Repository will be used for research studies.",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      Text(
                          "These specimens may also be used to produce genetic material (like DNA and RNA) that will be stored for an indefinite period of time for future studies.",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      Text(
                          "In order to use your biological specimens effectively for research, it is necessary that your medical information is available for review.",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                    
                      Text(
                          "When your specimens, data (genotype and phenotype) derived from your specimens, and medical information are made available for actual use in research studies,they will be provided to the researchers without personal identifiers so they cannot easily connect your identity with the specimens or medical information, unless they have legitimate access to your records,as in the case of your doctor. Your de-identified specimens,results(genotype and phenotype) from specimens, and medical information may also be shared with other scientists and researchers at other universities, government, hospitals, health related commercial entities, tissue banks, and shared databases (both unrestricted- or controlled-access repositories), to be used for future research purposes and to be shared broadly.",
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 20),
                      */
                      Text(
                          "You will receive no direct benefit by giving samples of your biological specimens. There are few risks associated with participation.",
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      Text(
                          "There will be no additional costs to you or your insurance company. You will not receive any money.",
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      Text(
                          "If you agree to give specimens and medical information to the BDRR, you may also withdraw your permission at any time.",
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PDFViewerPage()));
                          },
                          child: Text("View PDF")),
                      SizedBox(height: 20),
                      Text(
                          "By clicking on the button below, I agree to give samples of my biological specimens to the Research Repository for use in research studies directed at any disease or condition, and I agree to allow the use and disclosure of my medical record information, as described above.",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                    ]),
              ),
            ]))
      ];
}

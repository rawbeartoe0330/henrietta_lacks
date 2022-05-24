import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:nft_flutter/blockchain_connection/sampleListModel.dart';
import 'package:nft_flutter/main.dart';
import 'package:provider/provider.dart';

class AddSample extends StatefulWidget {
  const AddSample({Key? key}) : super(key: key);

  @override
  _AddSampleState createState() => _AddSampleState();
}

class _AddSampleState extends State<AddSample> {
  final auth = FirebaseAuth.instance;
  late User user;
  TextEditingController name = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? sampleType = "Blood";
  String? location = "UPMC Shadyside 5230 Centre Ave";
  String? units = "1 unit";
  String _date = "Set";
  String _time = "Set";
  @override
  Widget build(BuildContext context) {
    user = auth.currentUser!;
    var listModel = Provider.of<SampleListModel>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Add Sample"), elevation: 0.0),
      body: Padding(
          padding: EdgeInsets.only(top: 15, right: 40, left: 40),
          child: Column(children: [
            Text("Please enter the following details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 50),
            Align(
              alignment: Alignment.topLeft,
              child: Text("Sample Type:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            DropdownButton<String>(
                isExpanded: true,
                value: sampleType,
                icon: Icon(Icons.arrow_drop_down_outlined, color: color),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(
                    color: color, fontSize: 15, fontFamily: "SFProSBold"),
                underline: Container(height: 2, color: color),
                onChanged: (String? newValue) {
                  setState(() {
                    sampleType = newValue;
                  });
                },
                items: <String>[
                  'Blood',
                  'Tissue',
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
            SizedBox(height: 20),
            Align(
              alignment: Alignment.topLeft,
              child: Text("Date & Time",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            Row(
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all<double>(0.0),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.grey.shade300)),
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                        theme: DatePickerTheme(
                          containerHeight: 210.0,
                        ),
                        showTitleActions: true,
                        minTime: DateTime(2000, 1, 1),
                        maxTime: DateTime(2025, 12, 31), onConfirm: (date) {
                      print('confirm $date');
                      _date = '${date.month}/${date.day}/${date.year}';
                      setState(() {});
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.date_range,
                                size: 18.0,
                                color: color,
                              ),
                              Text(
                                " $_date",
                                style: TextStyle(color: color, fontSize: 18.0),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all<double>(0.0),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.grey.shade300)),
                  onPressed: () {
                    DatePicker.showTimePicker(context,
                        theme: DatePickerTheme(
                          containerHeight: 210.0,
                        ),
                        showTitleActions: true, onConfirm: (time) {
                      print('confirm $time');
                      _time = '${time.hour}:${time.minute}';
                      setState(() {});
                    },
                        showSecondsColumn: false,
                        currentTime: DateTime.now(),
                        locale: LocaleType.en);
                    setState(() {});
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.access_time,
                                size: 18.0,
                                color: color,
                              ),
                              Text(
                                " $_time",
                                style: TextStyle(color: color, fontSize: 18.0),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Align(
              alignment: Alignment.topLeft,
              child: Text("Location:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            DropdownButton<String>(
                isExpanded: true,
                value: location,
                icon: Icon(Icons.arrow_drop_down_outlined, color: color),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(
                    color: color, fontSize: 15, fontFamily: "SFProSBold"),
                underline: Container(height: 2, color: color),
                onChanged: (String? newValue) {
                  setState(() {
                    location = newValue;
                  });
                },
                items: <String>[
                  'UPMC Shadyside 5230 Centre Ave',
                  'UPMC Magee-Womens Hospital 300 Halket St.',
                  'UPMC St. Margaret 815 Freeport Rd.',
                  'UPMC Passavant–McCandless 9100 Babcock Blvd.',
                  'UPMC Passavant–Cranberry 1 St. Francis Way'
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
            SizedBox(height: 20),
            Align(
              alignment: Alignment.topLeft,
              child: Text("Units Given:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            DropdownButton<String>(
                isExpanded: true,
                value: units,
                icon: Icon(Icons.arrow_drop_down_outlined, color: color),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(
                    color: color, fontSize: 15, fontFamily: "SFProSBold"),
                underline: Container(height: 2, color: color),
                onChanged: (String? newValue) {
                  setState(() {
                    units = newValue;
                  });
                },
                items: <String>[
                  '1 unit',
                  '2 units',
                  '3 units',
                  '4 units',
                  '5 units'
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
            SizedBox(height: 20),
            ElevatedButton(
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(0.0)),
                onPressed: () async {
                  if (_date != "Set" && _time != "Set") {
                    listModel.addSample(user.uid, sampleType.toString(), _date,
                        _time, location.toString(), units.toString());
                    await FirebaseFirestore.instance
                        .collection("userData")
                        .doc(user.uid)
                        .collection("samples")
                        .doc()
                        .set({
                      "sampleType": sampleType.toString(),
                      "sampleDate": _date,
                      "sampleTime": _time,
                      "samLoc": location.toString(),
                      "samUnits": units.toString()
                    });
                  }
                },
                child: Text("Add Sample"))
          ])),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nft_flutter/main.dart';

class SearchStudies extends StatefulWidget {
  const SearchStudies({Key? key}) : super(key: key);

  @override
  _SearchStudiesState createState() => _SearchStudiesState();
}

class _SearchStudiesState extends State<SearchStudies> {
  Map<String, bool> categories = {
    'American Indian/Alaska Native': false,
    'Asian': false,
    'Black/African American': false,
    'Native Hawaiian/Pacific Islander': false,
    'White': false,
    'Other/Unknown': false,
    'Prefer not to answer': false
  };
  TextEditingController date = TextEditingController();
  TextEditingController month = TextEditingController();
  TextEditingController year = TextEditingController();
  String? dropdownValue = "Female";
  String? ethinicity = "Hispanic or Latino";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Search Study"),
        ),
        body: Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: ListView(shrinkWrap: true, children: [
              Text("Please tell us a little about yourself",
                  style: TextStyle(fontSize: 18)),
              Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                  child: Text("Date of Birth",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Row(children: [
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(right: 20, left: 20),
                        child: Material(
                            elevation: 5,
                            shadowColor: Colors.black26,
                            child: TextFormField(
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return 'Please enter some text';
                                  } else if (int.parse(val) > 12 ||
                                      int.parse(val) < 1) {
                                    return "Invalid";
                                  }
                                  return null;
                                },
                                controller: month,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.numberWithOptions(),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      )),
                                  hintText: "MM",
                                ))))),
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
                                  } else if (int.parse(val) > 31 ||
                                      int.parse(val) < 1) {
                                    return "Invalid";
                                  }
                                  return null;
                                },
                                controller: date,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.numberWithOptions(),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      )),
                                  hintText: "DD",
                                ))))),
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
                                controller: year,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.numberWithOptions(),
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            width: 0, style: BorderStyle.none)),
                                    hintText: "YYYY")))))
              ]),
              SizedBox(height: 20),
              Text("Gender:", style: TextStyle(fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: DropdownButton<String>(
                    isExpanded: true,
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_drop_down_outlined, color: color),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(
                        color: color, fontSize: 15, fontFamily: "SFProSBold"),
                    underline: Container(height: 2, color: color),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    items: <String>[
                      'Female',
                      'Male',
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
              SizedBox(height: 20),
              Text("Which categories describe you?",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              GridView.count(
                  childAspectRatio: 2.4,
                  crossAxisCount: 2,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: categories.keys.map((String key) {
                    return new CheckboxListTile(
                        title: Text(key),
                        value: categories[key],
                        onChanged: (bool? val) {
                          setState(() {
                            categories[key] = val!;
                          });
                        });
                  }).toList()),
              Text("What is your ethnicity?",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: DropdownButton<String>(
                    isExpanded: true,
                    value: ethinicity,
                    icon: Icon(Icons.arrow_drop_down_outlined, color: color),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(
                        color: color, fontSize: 15, fontFamily: "SFProSBold"),
                    underline: Container(height: 2, color: color),
                    onChanged: (String? newValue) {
                      setState(() {
                        ethinicity = newValue;
                      });
                    },
                    items: <String>[
                      'Hispanic or Latino',
                      'Not Hispanic or Latino',
                      'Prefer not to say'
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
              SizedBox(height: 20),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(color)),
                  onPressed: () {},
                  child: Text("Search"))
            ])));
  }
}

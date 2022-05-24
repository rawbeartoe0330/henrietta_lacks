import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nft_flutter/patient_screens/add_sample.dart';
import 'package:nft_flutter/patient_screens/organoids.dart';

class Samples extends StatefulWidget {
  final bool organoid;
  final String docID;
  const Samples({Key? key, required this.organoid, required this.docID})
      : super(key: key);

  @override
  _SamplesState createState() => _SamplesState();
}

class _SamplesState extends State<Samples> {
  bool organoid = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(elevation: 0.0),
        body: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: ListView(children: [
            SizedBox(height: 20),
            Card(
                elevation: 5,
                color: Colors.grey.shade300,
                child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10, top: 20, bottom: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Organoids",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Organoids(docID: widget.docID),
                      ],
                    ))),
            Card(
                elevation: 5,
                color: Colors.grey.shade300,
                child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 30, bottom: 30),
                    child: Table(children: [
                      TableRow(children: [
                        Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Text("Biosample",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold))),
                        Text("Date/Time",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Text("Location",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold))
                      ]),
                      TableRow(children: [
                        Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 15),
                            child: Row(children: [
                              Text("Blood", style: TextStyle(fontSize: 16)),
                              Icon(Icons.thermostat,
                                  color: Colors.red.shade900),
                              Icon(Icons.thermostat,
                                  color: Colors.red.shade900),
                              Icon(Icons.thermostat, color: Colors.red.shade900)
                            ])),
                        Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 15),
                            child: Text("09/10/2021 12:55pm",
                                style: TextStyle(fontSize: 18))),
                        Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 15),
                            child: Text("UPMC Shadyside 5230 Centre Ave",
                                style: TextStyle(fontSize: 18)))
                      ]),
                      TableRow(children: [
                        Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Row(children: [
                              Text("Tissue", style: TextStyle(fontSize: 16)),
                              Icon(CupertinoIcons.scissors_alt,
                                  color: Colors.blue.shade900),
                              Icon(CupertinoIcons.scissors_alt,
                                  color: Colors.blue.shade900),
                            ])),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text("08/20/2021 09:45am",
                              style: TextStyle(fontSize: 18)),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 15),
                            child: Text(
                                "UPMC Passavant-McCandless 9100 Babcock Blvd.",
                                style: TextStyle(fontSize: 18)))
                      ]),
                      TableRow(children: [
                        Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Row(children: [
                              Text("Steps", style: TextStyle(fontSize: 16)),
                              SizedBox(width: 5),
                              Text("9823",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue.shade900))
                            ])),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text("10/29/2021 11:45pm",
                              style: TextStyle(fontSize: 18)),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 15),
                            child:
                                Icon(Icons.watch, color: Colors.blue.shade900))
                      ])
                    ]))),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AddSample()));
                },
                child: Text("Add a sample", style: TextStyle(fontSize: 18))),
          ]),
        ));
  }
}

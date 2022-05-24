import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nft_flutter/auth_files/prov.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:nft_flutter/main.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

class AddOrganoid extends StatefulWidget {
  final String name;
  final String puid;
  const AddOrganoid({Key? key, required this.name, required this.puid})
      : super(key: key);

  @override
  _AddOrganoidState createState() => _AddOrganoidState();
}

class _AddOrganoidState extends State<AddOrganoid> {
  TextEditingController tpno = TextEditingController();
  TextEditingController ipmno = TextEditingController();
  String her2 = "Pos";
  String er = "Pos";
  String pr = "Pos";
  final ImagePicker _picker = ImagePicker();
  late File _image;
  late String url;
  var imageUrl;
  bool show = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Organoid Details"),
        ),
        body: Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: ListView(children: [
              Material(
                  elevation: 5,
                  shadowColor: Colors.black26,
                  child: TextFormField(
                      style: TextStyle(fontSize: 20),
                      enabled: false,
                      initialValue: widget.name,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            )),
                      ))),
              SizedBox(height: 20),
              Text("TP No.", style: TextStyle(fontSize: 20)),
              Row(
                children: [
                  Text("TP-", style: TextStyle(fontSize: 20)),
                  Expanded(
                    child: Material(
                        elevation: 5,
                        shadowColor: Colors.black26,
                        child: TextFormField(
                            controller: tpno,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  )),
                            ))),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text("Organoid No.", style: TextStyle(fontSize: 20)),
              Row(
                children: [
                  Text("IPM-", style: TextStyle(fontSize: 20)),
                  Expanded(
                    child: Material(
                        elevation: 5,
                        shadowColor: Colors.black26,
                        child: TextFormField(
                            controller: ipmno,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  )),
                            ))),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Text("ER", style: TextStyle(fontSize: 20)),
                Text("PR", style: TextStyle(fontSize: 20)),
                Text("HER2", style: TextStyle(fontSize: 20))
              ]),
              Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                        isExpanded: true,
                        value: er,
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
                            er = newValue!;
                          });
                        },
                        items: <String>['Pos', 'Neg']
                            .map<DropdownMenuItem<String>>((String value) {
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
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButton<String>(
                        isExpanded: true,
                        value: pr,
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
                            pr = newValue!;
                          });
                        },
                        items: <String>['Pos', 'Neg']
                            .map<DropdownMenuItem<String>>((String value) {
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
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButton<String>(
                        isExpanded: true,
                        value: her2,
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
                            her2 = newValue!;
                          });
                        },
                        items: <String>['Pos', 'Neg']
                            .map<DropdownMenuItem<String>>((String value) {
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
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    getImage();
                  },
                  child: Text("Add Image")),
              //Card(child: setImage()),
              ElevatedButton(
                  onPressed: () async {
                    await uploadImage(_image);
                    String tp = "TP-" + tpno.text;
                    String docID;
                    final uid = await Prov.of(context)!.auth.getCurrentUID();
                    await FirebaseFirestore.instance
                        .collection("images")
                        .doc()
                        .set({"image": imageUrl});
                  },
                  child: Text("Add Organoid"))
            ])));
  }

  Widget setImage() {
    if (_image.length() == 0) {
      return Container(child: Image.file(_image));
    }
    return Container();
  }

  uploadImage(File locImage) async {
    final uid = await Prov.of(context)!.auth.getCurrentUID();
    if (locImage != null) {
      var fileExtension = p.extension(locImage.path);
      var uuid = Uuid().v4();
      firebase_storage.UploadTask uploadTask = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('organoids/$uuid$fileExtension')
          .putFile(locImage);

      firebase_storage.Reference firebaseStorage = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('$uuid$fileExtension');
      await firebaseStorage.putFile(locImage);
      imageUrl = await (await uploadTask).ref.getDownloadURL();
    }
  }

  Future getImage() async {
    final image = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image!.path);
    });
  }
}

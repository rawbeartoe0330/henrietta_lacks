import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nft_flutter/landing.dart';
import 'package:nft_flutter/imgModel.dart';
import 'package:nft_flutter/main.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: ListView(
            padding: EdgeInsets.only(top: 180),
            children: [
              // Icon(CupertinoIcons.lab_flask, size: 200, color: color),
              Image.asset(
                "assets/image.png",
                scale: 2,
              ),

              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.only(left: 60, right: 60),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => Landing()));
                  },
                  child: Text(
                    "Get Started",
                    style: TextStyle(
                      color: Color(0xFF93278F),
                      fontSize: 22,
                    ),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 255, 255, 255))),
                ),
              )
            ],
          ),
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFF93278F), Color(0xff9B2C9B)],
          ))),
    );
  }
}

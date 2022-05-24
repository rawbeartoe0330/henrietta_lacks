import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nft_flutter/auth_files/auth.dart';
import 'package:nft_flutter/blockchain_connection/researcherListModel.dart';
import 'package:nft_flutter/blockchain_connection/sampleListModel.dart';
import 'package:nft_flutter/blockchain_connection/studyListModel.dart';
import 'package:nft_flutter/main_page.dart';
import 'package:nft_flutter/blockchain_connection/patientListModel.dart';
import 'package:nft_flutter/auth_files/prov.dart';
import 'package:provider/provider.dart';

const MaterialColor color = const MaterialColor(
  0xFF93278F,
  const <int, Color>{
    50: const Color(0xffb95471), //10%
    100: const Color(0xffa44a64), //20%
    200: const Color(0xff904158), //30%
    300: const Color(0xff7b384b), //40%
    400: const Color(0xff672f3f), //50%
    500: const Color(0xff522532), //60%
    600: const Color(0xff3d1c25), //70%
    700: const Color(0xff291319), //80%
    800: const Color(0xff14090c), //90%
    900: const Color(0xff000000), //100%
  },
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => PatientListModel()),
          ChangeNotifierProvider(create: (context) => ResearcherListModel()),
          ChangeNotifierProvider(create: (context) => SampleListModel()),
          ChangeNotifierProvider(create: (context) => StudyListModel())
        ],
        child: Prov(
            auth: AuthService(),
            child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Biobank | Specimen Research',
                theme: ThemeData(
                    fontFamily: 'Karla',
                    primarySwatch: color,
                    canvasColor: Colors.grey.shade300),
                home: HomeController())));
  }
}

class HomeController extends StatefulWidget {
  const HomeController({Key? key}) : super(key: key);

  @override
  _HomeControllerState createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  // updateData() async {
  //   WriteBatch batch = FirebaseFirestore.instance.batch();
  //   await FirebaseFirestore.instance
  //       .collection("patients")
  //       .where("age", isGreaterThan: 0)
  //       .get()
  //       .then((value) {
  //     value.docs.forEach((element) {
  //       batch.update(element.reference, {
  //         "primary": "",
  //         "radiologist": "",
  //         "pathologist": "",
  //         "surgeon": "",
  //         "moncologist": "",
  //         "roncologist": ""
  //       });
  //     });
  //   });
  //   return batch.commit();
  // }

  @override
  Widget build(BuildContext context) {
    //updateData();
    final AuthService auth = Prov.of(context)!.auth;
    return MainPage();
    // StreamBuilder(
    //     stream: auth.authStateChange,
    //     builder: (context, AsyncSnapshot snapshot) {
    //       if (snapshot.connectionState == ConnectionState.active) {
    //         final bool signedIn = snapshot.hasData;
    //         return signedIn ? Landing() : Landing();
    //       }
    //       return Container(height: 0.0, width: 0.0);
    //     });
  }
}

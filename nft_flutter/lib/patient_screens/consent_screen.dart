import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nft_flutter/biobank/organoidModel.dart';
import 'package:nft_flutter/blockchain_connection/studyListModel.dart';
import 'package:nft_flutter/patient_screens/view_consent_PDF.dart';
import 'package:provider/provider.dart';

class ConsentPage extends StatefulWidget {
  final String title;
  final String resID;
  const ConsentPage({Key? key, required this.title, required this.resID})
      : super(key: key);

  @override
  _ConsentPageState createState() => _ConsentPageState();
}

class _ConsentPageState extends State<ConsentPage> {
  final auth = FirebaseAuth.instance;
  late User user;
  String? pat1;
  String? pat2;
  String? pat3;
  String? pat4;
  String? pat5;
  bool orgVal = false;
  @override
  Widget build(BuildContext context) {
    user = auth.currentUser!;
    var listModel = Provider.of<StudyListModel>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Consent Form"), elevation: 0.0),
      body: Container(
          padding: EdgeInsets.only(top: 20, right: 20, left: 20),
          child: ListView(children: [
            Text("Consent to Be Included in the",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(widget.title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text("Overview:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(
                "Our lab team seeks to study living models of breast cancer created from patients’ leftover tumor samples from their original surgery, together with models created from biopsies of cancer after it spread outside of the breast. Our goal is to study individuals’ breast cancers over time, to learn how they change after treatment with chemotherapy or radiation, and to better understand how to prevent cancer from coming back and to make it easier to treat if it comes back.",
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text(
                "This will help us to better understand the process of developing advanced cancer and how to best treat and monitor each patient’s unique cancer. Depending on what we learn, we may also use the tissue models to develop new tools for detecting, treating or preventing cancer.",
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text("Who can participate:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text(
                "We want to study breast cancer models from patients who had cancer in one or both breasts, who received treatment with chemotherapy and/or radiation, and who later experienced a recurrence of their cancer. To learn as much as possible, we seek individuals from a wide range of backgrounds, genetic profiles, body types, ages, races and medical histories. Patients with a model of their original cancer and model of a cancer recurrence that has spread to lymph nodes, bone, brain, liver, or other sites outside of the breast (also known as metastatic breast cancer) are able to participate. Patients who have models of their primary (breast) and metastatic (outside the breast) cancer created at the same time are also able to participate in this study. ",
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text("If you participate in this study, we will provide: ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text(
                "1. One-of-a-kind images of your tissue model that we create during research. Other patients and researchers will be able to see these images, and will be able to tell they belong to your account, but they will not be able to see your name or contact information -unless you want them to\n\n2. Regularly updated information about research studies on your tissue model, including general findings and related scientific publications (research articles). You will be able to access any publications created from our research on your tissue. You will receive a summary card of each study (like a digital baseball card) that includes the main points of the study, and where to go for more information.\n\n3. Access to an annual results report from research on your tissue model. These results might matter for your clinical care, or could become significant for your clinical care as we learn more about them in the future. This information may or may not be useful for your medical care, but it is not the same as medical care because it comes from a research laboratory that is not approved to provide official, clinically validated results. ",
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text(
                "You will have access to the information we learn about your tissue model, but looking at this information is voluntary. Some people may prefer not to look at this information, however there may be times when it could be useful for helping you and your doctors to make informed decisions about further medical testing or treatments.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text(
                "Many times, the practical value of the information will be unclear. Since the state of research knowledge is growing over time, we may not realize that some findings could be relevant until a later date. We will update the report annually, and will flag the inbox results as unlikely, possibly, likely or highly likely to be clinically important to help you decide if you want to view the results or discuss them with the research team or your doctor.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text("Terms of use:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text(
                "1) Your biobank will share a copy of your tissue model with our research team. We can grow the model in our lab and use it for research studies. The exact focus of our research may change over time. We will keep you informed of how we use your tissue model by providing a unique research study token for each study we do using your tissue model\n\n2) We can contact you through this app, but we will not be able to see your name or other contact information. We will use a secret, computer-generated code name to track your tissue model and to communicate with you. You can also initiate contact with our research team through this app. You will also be able to find and connect with other patients who are participating in our research on this platform.\n\n3) We will have access to a copy of your health records at the time of this agreement, but we will not see your name or other contact information. We will track your health records by the same computer-generated code name we use to track your tissue model. In the future, we may ask you (or your representatives) for access to your updated health records to help with the research on your tissue model.\n\n4) You may also update us on your health status through this app. Any major health issues or changes you experience (for example, a new diagnosis of high blood pressure) will be very helpful for our research team to know about, and will help us learn as much as possible from your tissue model. You will receive research participation tokens for providing these updates, and other researchers and patients will be able to see your token collection (but not the health information, unless you decide to share it).\n\n5) In the future, we may ask for access to other biosamples (like tissue and blood) that were created during your clinical care, or we may ask you to provide new biosamples as part of future research. You will be able to track our requests to the biobank to access your leftover biosamples and you (or your representatives) will be able to control whether we get to use them. Providing any additional biosamples will be voluntary, and you can earn extra participation tokens to display on your account to represent your additional contributions to our research program.",
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text("Term Limits:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text(
                "Permission to use your tissue model as above will automatically renew every year for the next 5 years, unless you request new terms within 60 days of the beginning of the next yearly term. After 5 years, your permission or the permission of a representative that you identify (like a spouse or adult child or patient advocate) will be required if we are going to continue to use your tissue model. If we are no longer using your tissue model, we may continue to analyze data or publish research findings from research performed during the 5 year permissioned-use period.\n\nWe can not share or sell access to a copy of your tissue model without asking you first. You will have 30 days to respond to a request to share or sell access to your tissue model. If we do not hear from you within 30 days, we will negotiate terms with outside parties with patient representatives acting on your behalf. Final terms will be proposed with the agreement of patient representatives and there will be an opportunity to vote on final terms. If you or your representative do not respond within 90 days of the original request, we may confirm terms for sharing or selling access to your tissue model with others. If you provide an email and contact information for reaching you outside of this app system, we will also attempt to contact you via email before making any decisions without your vote. You will receive special tokens to show that access to your tissue model was provided to others.\n\nYou will always be able to log in to our system and see what happens to your tissue model and any relevant information, even if you do not participate in the negotiations noted above. Your account will receive special tokens to demonstrate the value of your tissue model whether or not you play an active role in the decision process. Our system will provide a transparent record of all transactions, transfers of tissue models, other biosamples and your health-related information. Your name and contact information will remain private and all tracking will use the same computer-generated code name described above.",
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text(
                "By clicking on the button below, I agree to allow Dr. Rachel Zane and team to use my normal breast tissue model for up to 5 years for relevant research. I agree to allow the use and disclosure of my medical records and communications, as described above. ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            StreamBuilder(
                stream: getStream(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else if (snapshot.data.docs.length == 0) {
                    return Center(
                      child: Text(
                        "You currently aren't involved in any studies",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  } else {
                    return Card(
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (BuildContext context, int index) =>
                              buildCard(
                                  context, snapshot.data.docs[index], index)),
                    );
                  }
                }),
            ElevatedButton(
                onPressed: () {
                  listModel.addStudy(
                      widget.resID, widget.title, user.uid, "", "", "", "");
                  // listModel.studies.forEach((element) {
                  //   if (element.patientUID1 != "") {
                  //     setState(() {
                  //       pat1 = element.patientUID1;
                  //     });
                  //     if (element.patientUID2 != "") {
                  //       setState(() {
                  //         pat2 = element.patientUID2;
                  //       });
                  //       if (element.patientUID3 != "") {
                  //         setState(() {
                  //           pat3 = element.patientUID3;
                  //         });
                  //         if (element.patientUID4 != "") {
                  //           setState(() {
                  //             pat4 = element.patientUID4;
                  //           });
                  //         } else if (element.patientUID4 == "") {
                  //           listModel.addStudy(widget.resID, widget.title,
                  //               pat1!, pat2!, pat3!, user.uid, "");
                  //         }
                  //       } else if (element.patientUID3 == "") {
                  //         listModel.addStudy(widget.resID, widget.title, pat1!,
                  //             pat2!, user.uid, "", "");
                  //       }
                  //     } else if (element.patientUID2 == "") {
                  //       listModel.addStudy(widget.resID, widget.title, pat1!,
                  //           user.uid, "", "", "");
                  //     }
                  //   } else if (element.patientUID1 == "") {
                  //     listModel.addStudy(
                  //         widget.resID, widget.title, user.uid, "", "", "", "");
                  //   } else {
                  //     listModel.addStudy(widget.resID, widget.title, pat1!,
                  //         pat2!, pat3!, pat4!, user.uid);
                  //   }
                  // });
                },
                child: Text("Consent",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            SizedBox(height: 30),
          ])),
    );
  }

  getStream() async* {
    yield* FirebaseFirestore.instance
        .collection("organoids")
        .where("organoidID", isEqualTo: "IPM-06")
        .snapshots();
  }

  buildCard(BuildContext context, DocumentSnapshot snapshot, index) {
    final org = OrganoidModel.fromSnapshot(snapshot);
    return CheckboxListTile(
      contentPadding: EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10),
      title: Text("ipm0012834xecrjbsv"),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("ER: " + org.er),
          Text("PR: " + org.pr),
          Text("HER2: " + org.her2)
        ],
      ),
      onChanged: (value) {
        setState(() {
          orgVal = value!;
        });
      },
      value: orgVal,
      secondary: org.image != ""
          ? Image.network(org.image)
          : Container(
              height: 100,
              width: 60,
              child: Text("No image available", textAlign: TextAlign.center)),
    );
  }
}

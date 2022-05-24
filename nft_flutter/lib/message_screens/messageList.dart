import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nft_flutter/message_screens/messageModel.dart';
import 'package:nft_flutter/message_screens/messages.dart';
import 'package:nft_flutter/auth_files/prov.dart';

class MessageList extends StatefulWidget {
  const MessageList({Key? key}) : super(key: key);

  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final auth = FirebaseAuth.instance;
  late User user;
  String name = '';
  @override
  Widget build(BuildContext context) {
    user = auth.currentUser!;
    return Scaffold(
      appBar: AppBar(elevation: 0.0, title: Text("Message")),
      body: StreamBuilder(
          stream: getMessages(context),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Container();
            } else if (snapshot.data.docs.length == 0) {
              return Center(child: Text("No Message"));
            } else {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) =>
                      buildMessages(context, snapshot.data.docs[index]));
            }
          }),
    );
  }

  Stream<QuerySnapshot> getMessages(BuildContext context) async* {
    String uid = await Prov.of(context)!.auth.getCurrentUID();

    yield* FirebaseFirestore.instance
        .collection("messages")
        .where("participants", arrayContains: uid)
        .snapshots();
  }

  getName(uid) async {
    await FirebaseFirestore.instance
        .collection("researcher")
        .where("uid", isEqualTo: uid)
        .get()
        .then((value) {
      setState(() {
        name = (value.docs[0].data()['name']);
      });
    });
  }

  Widget buildMessages(BuildContext context, DocumentSnapshot snapshot) {
    String toUID = "";
    final messages = MessageModel.fromSnapshot(snapshot);
    for (int i = 0; i < messages.participants.length; i++) {
      if (messages.participants[i] != user.uid) {
        getName(messages.participants[i]);
        toUID = messages.participants[i];
      }
    }
    return InkWell(
      child: ListTile(
        title: Text(name),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => UserMessages(
                pre_messg: false,
                name: name,
                docID: messages.docID,
                toUID: toUID)));
      },
    );
  }
}

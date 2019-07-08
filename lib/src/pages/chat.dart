import 'package:chat_app/src/pages/widgets/message.dart';
import 'package:chat_app/src/pages/widgets/send_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat extends StatefulWidget {
  final FirebaseUser user;

  Chat({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ChatState();
  }
}

class _ChatState extends State<Chat> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final Firestore fireStore = Firestore.instance;

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  Future<void> callback() async {
    if (messageController.text.length > 0) {
      await fireStore.collection('messages').add({
        'text': messageController.text,
        'from': widget.user.email,
      }).catchError((onError) {
        print("error : " + onError);
      });
      messageController.clear();
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(microseconds: 300), curve: Curves.easeOut);
    }
  }

  @override
  void initState() {
    print("Email : " + widget.user.email.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Hero(
          tag: 'logo',
          child: Container(
            height: 40,
            child: Image.asset('images/logo.png'),
          ),
        ),
        title: Text("Diesel Chat"),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: fireStore.collection('messages').snapshots(),
                builder: (context, snapshots) {
                  if (!snapshots.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  List<DocumentSnapshot> docs = snapshots.data.documents;

                  List<Widget> messages = docs
                      .map((doc) => Message(
                            from: doc.data['from'],
                            text: doc.data['text'],
                            me: widget.user.email == doc.data['from'],
                          ))
                      .toList();
                  return ListView(
                    controller: scrollController,
                    children: <Widget>[...messages],
                  );
                },
              ),
            ),
            Container(
                child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "enter message",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    onSubmitted: (value) => callback,
                  ),
                ),
                SendButton(
                  text: "Send",
                  callback: callback,
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}

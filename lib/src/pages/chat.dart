import 'package:chat_app/src/pages/widgets/message.dart';
import 'package:chat_app/src/pages/widgets/send_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Chat extends StatefulWidget {
  final FirebaseUser user;
  final String accountType;

  Chat({Key key, this.user, this.accountType}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ChatState();
  }
}

class _ChatState extends State<Chat> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final Firestore fireStore = Firestore.instance;

  static final FacebookLogin facebookSignIn = new FacebookLogin();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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

  Future<Null> _logOut() async {
    switch (widget.accountType) {
      case 'facebook':
        await facebookSignIn.logOut().then((onValue) {
          Navigator.pop(context);
        }).catchError((onError) {
          print(onError);
        });
        break;

      case 'email':
        _auth.signOut().then((onValue) {
          Navigator.pop(context);
        }).catchError((onError) {
          print(onError);
        });
        break;
      case 'google':
        _googleSignIn.signOut().then((onValue) {
          Navigator.pop(context);
        }).catchError((onError) {
          print(onError);
        });
        break;
    }

    print('Logged out.');
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
        title: Row(
          children: <Widget>[
            Text("Diesel Chat"),
            SizedBox(
              width: 80,
            ),
            InkWell(child: Text("Sign Out"), onTap: _logOut),
          ],
        ),
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

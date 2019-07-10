import 'package:chat_app/src/pages/widgets/custom_utton.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'chat.dart';

class Regiest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegiestStat();
  }
}

class _RegiestStat extends State<Regiest> {
  String email;
  String pass;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registUser() async {
    FirebaseUser user = await _auth
        .createUserWithEmailAndPassword(email: email, password: pass)
        .then((onValue) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Chat(
                  user: onValue,
                  accountType: 'email',
                )),
      );
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diesel Chat'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Hero(
              tag: 'logo',
              child: Container(
                child: Image.asset('images/logo.png'),
              ),
            ),
          ),
          TextField(
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => email = value,
            decoration: InputDecoration(
              hintText: "Enter your Email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.text,
            onChanged: (value) => pass = value,
            decoration: InputDecoration(
              hintText: "Enter your password..",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          CustomButton(
            text: 'Rereste',
            callback: () async {
              await registUser();
            },
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

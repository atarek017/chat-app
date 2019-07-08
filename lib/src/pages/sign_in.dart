import 'package:chat_app/src/pages/widgets/custom_utton.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'chat.dart';

class SignIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignInStat();
  }
}

class _SignInStat extends State<SignIn> {
  String email;
  String pass;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registUser() async {
    FirebaseUser userRegest = await _auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((value) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Chat(
                  user: value,
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
            text: 'Sign IN',
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

import 'package:chat_app/src/pages/chat.dart';
import 'package:chat_app/src/pages/regest.dart';
import 'package:chat_app/src/pages/sign_in.dart';
import 'package:chat_app/src/pages/widgets/custom_utton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  width: 100,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              Text(
                ''
                'Diesel Chat',
                style: TextStyle(fontSize: 40),
              ),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          CustomButton(
            text: "Log IN",
            callback: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignIn()),
              );
            },
          ),
          SizedBox(
            height: 15,
          ),
          CustomButton(
            text: "Regiest",
            callback: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Regiest()),
              );
            },
          ),
          SizedBox(
            height: 15,
          ),
          CustomButton(
            text: "Google Sign in",
            callback: () {
              signInGoogle(context);
            },
          ),
          SizedBox(
            height: 10,
          ),
          CustomButton(
            text: "FaceBook Sign in",
            callback: () async {
              await signInFacebook(context);
            },
          ),
        ],
      ),
    );
  }

  void signInGoogle(context) async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    final GoogleSignInAccount account = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _auth = await account.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: _auth.accessToken, idToken: _auth.idToken);
    await _firebaseAuth.signInWithCredential(credential).then((onValue) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Chat(
                user: onValue,
              ),
        ),
      );
    });
  }

  Future<Null> signInFacebook(context) async {
    final FacebookLogin facebookSignIn = new FacebookLogin();
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final FacebookLoginResult result =
        await facebookSignIn.logInWithReadPermissions(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;

        final AuthCredential credential =
            FacebookAuthProvider.getCredential(accessToken: accessToken.token);

        await _firebaseAuth.signInWithCredential(credential).then((onValue) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Chat(
                    user: onValue,
                  ),
            ),
          );
        }).catchError((onError) {
          print(onError);
        });

        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        print('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }
}

import 'package:chat_app/src/pages/regest.dart';
import 'package:chat_app/src/pages/sign_in.dart';
import 'package:chat_app/src/pages/widgets/custom_utton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
              Navigator.push(context, MaterialPageRoute(builder: (context) =>SignIn()),);

            },
          ),

          SizedBox(
            height: 15,
          ),

          CustomButton(
            text: "Regiest",
            callback: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>Regiest()),);
            },
          ),

        ],
      ),
    );
  }
}

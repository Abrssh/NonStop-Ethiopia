// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth_ui/firebase_auth_ui.dart';
// import 'package:firebase_auth_ui/providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nonstop_ethiopia/Screen/homePage.dart';
import 'package:nonstop_ethiopia/Util/loading.dart';

class SignInPage extends StatefulWidget {
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String err = "";
  bool loaded = false;

  Future<User?> _checkLoginState() async {
    try {
      print("Called");
      await Firebase.initializeApp();
      return FirebaseAuth.instance.currentUser;
    } catch (e) {
      print("Error My: " + e.toString());
      return null;
    }
  }

  void logIn() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      FirebaseAuth.instance.signInAnonymously().then((userVal) {
        // FirebaseAuthUi.instance()
        //     .launchAuth([AuthProvider.google()]).then((userVal) {
        // log("User Val: " + userVal.email + " ");
        setState(() {
          loaded = false;
        });
      }).catchError((e) {
        setState(() {
          loaded = true;
          err = "Unknown Error";
        });
      });
    }
  }

  @override
  void initState() {
    _checkLoginState().then((value) {
      print("Check Login ");
      if (value != null) {
        setState(() {
          loaded = true;
          err = "Logged In";
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyHomePage(
                      title: "NonStop Ethiopia",
                    )));
      } else {
        setState(() {
          loaded = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final deviceHeight = deviceSize.height;
    final deviceWidth = deviceSize.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
        centerTitle: true,
      ),
      body: Center(
        child: loaded
            ? Column(
                children: [
                  Text(
                    "STATUS",
                    style: TextStyle(
                        fontSize: deviceWidth * 0.08,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      err,
                      style: TextStyle(
                          fontSize: deviceWidth * 0.07,
                          fontWeight: FontWeight.w300,
                          color: Colors.red),
                    ),
                  ),
                  SizedBox(
                    height: deviceHeight * 0.01,
                  ),
                  Text(
                    "Tap the button below to login",
                    style: TextStyle(
                        fontSize: deviceWidth * 0.06,
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    height: deviceHeight * 0.01,
                  ),
                  ElevatedButton(
                      onPressed: logIn,
                      child: Text(
                        "Login",
                        style: TextStyle(fontSize: deviceWidth * 0.06),
                      )),
                ],
              )
            : Loading(),
      ),
    );
  }
}

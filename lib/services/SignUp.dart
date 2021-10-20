import 'dart:convert';
import 'dart:io';

import 'package:books_app/main.dart';
import 'package:books_app/services/Authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:path_provider/path_provider.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SignupState();
  }
}

class SignupState extends State<SignUpPage> {
  final EmailController = TextEditingController();
  final PasswordController = TextEditingController();

  String SignUpStatus = "";

  Future<File> getpath() async {
    final directory = await getApplicationDocumentsDirectory();
    String directoryPath = directory.path;
    return File('$directoryPath/userdata.json');
  }

  void SaveUserData(String name, String email, String image) async {
    String JsonString;
    Map<String, dynamic> json = {'name': name, 'email': email, 'image': image};
    JsonString = jsonEncode(json);

    File file = await getpath();
    file.create();
    file.writeAsString(JsonString);
  }

  void facebookSignIn() async {
    try {
      final result = await FacebookAuth.instance.login();
      final userData = await FacebookAuth.instance.getUserData();

      final facebookCredential =
          FacebookAuthProvider.credential(result.accessToken!.token);

      await FirebaseAuth.instance.signInWithCredential(facebookCredential);

      await FirebaseFirestore.instance.collection('user').add({
        'email': userData['email'],
        'imageurl': userData['picture']['data']['url'],
        'name': userData['name']
      });
      SaveUserData(userData['name'], userData['email'],
          userData['picture']['data']['url']);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(
                  userData['name'],
                  userData['email'] == null
                      ? "mail not found"
                      : userData['email'],
                  userData['picture']['data']['url'])));
    } on FirebaseAuthException catch (e) {
      setState(() {
        SignUpStatus = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                ),
                Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.blueGrey[50],
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  height: 40,
                  width: 300,
                  child: TextField(
                    style: TextStyle(fontSize: 15),
                    controller: EmailController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20, bottom: 5),
                        hintText: "Email",
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.blueGrey[50],
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  height: 40,
                  width: 300,
                  child: TextField(
                    obscureText: true,
                    obscuringCharacter: '*',
                    style: TextStyle(fontSize: 15),
                    controller: PasswordController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20, bottom: 5),
                        hintText: "Password",
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  SignUpStatus,
                  style: TextStyle(color: Colors.red, fontSize: 11),
                ),
                SizedBox(
                  height: 40,
                ),
                TextButton(
                    onPressed: () {
                      AuthenticationHelper()
                          .signUp(EmailController.text, PasswordController.text)
                          .then((result) {
                        if (result == null) {
                          SaveUserData(
                              EmailController.text.split('@')[0],
                              EmailController.text,
                              "https://th.bing.com/th/id/OIP.qd-FmnNIgg7JhWtnZCss5gHaFK?pid=ImgDet&rs=1");
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyHomePage(
                                      EmailController.text.split('@')[0],
                                      EmailController.text,
                                      "https://th.bing.com/th/id/OIP.qd-FmnNIgg7JhWtnZCss5gHaFK?pid=ImgDet&rs=1")));
                        } else
                          setState(() {
                            SignUpStatus = result;
                          });
                      });
                    },
                    child: Text("SignUp")),
                SizedBox(
                  height: 100,
                ),
                GestureDetector(
                    onTap: () {
                      facebookSignIn();
                    },
                    child: Container(
                        color: Colors.grey[200],
                        width: 300,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Sign in with FaceBook"),
                            Image.asset(
                              'assets/Images/facebook.png',
                              height: 30,
                              width: 30,
                            )
                          ],
                        ))),
              ],
            ),
          )),
    );
  }
}

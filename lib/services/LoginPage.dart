import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../main.dart';
import 'Authentication.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  final EmailController = TextEditingController();
  final PasswordController = TextEditingController();

  String LoginStatus = "";
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
                  "Login",
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
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Text(
                    LoginStatus,
                    style: TextStyle(color: Colors.red, fontSize: 11),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                TextButton(
                    onPressed: () {
                      AuthenticationHelper()
                          .signIn(EmailController.text, PasswordController.text)
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
                                      EmailController.text
                                          .toString()
                                          .split('@')[0],
                                      EmailController.text,
                                      "https://th.bing.com/th/id/OIP.qd-FmnNIgg7JhWtnZCss5gHaFK?pid=ImgDet&rs=1")));
                        } else
                          setState(() {
                            LoginStatus = result.toString();
                          });
                      });
                    },
                    child: Text("Login")),
                SizedBox(
                  height: 100,
                ),
                Container(
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
                    ))
              ],
            ),
          )),
    );
  }
}

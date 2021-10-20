import 'dart:convert';
import 'dart:io';

import 'package:books_app/Components/AccountPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../main.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checksignup();
  }

  Future<File> getpath() async {
    final directory = await getApplicationDocumentsDirectory();
    String directoryPath = directory.path;
    return File('$directoryPath/userdata.json');
  }

  void checksignup() async {
    File file = await getpath();

    if (await file.exists()) {
      print("afasfasffasfasfasfasfasf");
      Map<String, dynamic> userdata = await getjson();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(
                  userdata['name'], userdata['email'], userdata['image'])),
          (route) => false);

      // ScaffoldMessenger.of(context)
      //   .showSnackBar(SnackBar(content: Text("file found")));
    } else
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AccountPage()));
  }

  Future<Map<String, dynamic>> getjson() async {
    File file = await getpath();
    String jsonstring = await file.readAsString();

    Map<String, dynamic> userjson = jsonDecode(jsonstring);
    return userjson;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
          child: AnimatedContainer(
        duration: Duration(seconds: 1),
        height: 100,
      )),
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:books_app/Components/BookCard.dart';
import 'package:books_app/Models/BookModel.dart';
import 'package:books_app/Screens/SplashScreen.dart';
import 'package:books_app/services/DatabaseHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../main.dart';

class FavoritesPage extends StatefulWidget {
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    print("namerrrrrrrrrrrr");
    super.initState();

    GetFavList();
  }

  void GetFavList() async {
    DatabaseHelper db = DatabaseHelper.constructor();
    setState(() {});
    FavoritesBoookList = await db.getFav();
    setState(() {});
    print("name=========" + FavoritesBoookList[0].name);
  }

  Future<Map<String, dynamic>> getjson() async {
    File file = await getpath();
    String jsonstring = await file.readAsString();

    Map<String, dynamic> userjson = jsonDecode(jsonstring);
    return userjson;
  }

  Future<File> getpath() async {
    final directory = await getApplicationDocumentsDirectory();
    String directoryPath = directory.path;
    return File('$directoryPath/userdata.json');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () async {
                  Map<String, dynamic> userdata = await getjson();

                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyHomePage(
                              userdata['name'].toString().split('@')[0],
                              userdata['email'],
                              userdata['image'] == null
                                  ? "https://th.bing.com/th/id/OIP.qd-FmnNIgg7JhWtnZCss5gHaFK?pid=ImgDet&rs=1"
                                  : userdata['image'])),
                      (route) => false);
                },
                child: Icon(
                  Icons.home,
                  color: Colors.blueGrey[100],
                  size: 30,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.favorite,
                  color: Colors.black,
                  size: 30,
                ),
              )
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Text(
            "Favorites",
            style: TextStyle(fontSize: 26),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                  itemCount: FavoritesBoookList.length,
                  itemBuilder: (context, index) {
                    print("Asdfasadfs");
                    return BookCard(
                        FavoritesBoookList[index].id,
                        FavoritesBoookList[index].author,
                        FavoritesBoookList[index].name,
                        FavoritesBoookList[index].rating,
                        FavoritesBoookList[index].type,
                        FavoritesBoookList[index].image,
                        true,
                        true);
                  }),
            ),
          )
        ],
      ),
    );
  }
}

List<BookModel> FavoritesBoookList = [];

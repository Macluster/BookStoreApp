import 'dart:convert';
import 'dart:ffi';

import 'package:books_app/services/DatabaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookInfoPage extends StatefulWidget {
  String image = "";
  String name = "";
  String id = "";
  bool favBtnClicked = false;
  BookInfoPage(this.id, this.name, this.image, this.favBtnClicked);
  @override
  State<BookInfoPage> createState() =>
      _BookInfoPageState(id, name, image, favBtnClicked);
}

class _BookInfoPageState extends State<BookInfoPage> {
  String id = "";
  String name = "";
  String image = "";
  String author = "";
  String rating = "";
  String review = "";
  String Discription = "";
  String Categories = "";
  String Average = "";

  bool favBtnClicked = false;

  void GetDetails() async {
    final res = await http
        .get(Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$name'));

    final jsonMap = await json.decode(res.body);
    int numberOfBooks = jsonMap['totalItems'];

    for (int i = 0; i < numberOfBooks; i++) {
      if (jsonMap['items'][i]['id'].toString() == id) {
        setState(() {
          author = jsonMap['items'][i]['volumeInfo']['authors'][0].toString();

          Categories =
              jsonMap['items'][i]['volumeInfo']['categories'][0].toString();
        });

        setState(() {
          if (jsonMap['items'][i]['volumeInfo']['description'] != null ||
              jsonMap['items'][i]['volumeInfo']['description'] != "") {
            Discription =
                jsonMap['items'][i]['volumeInfo']['description'].toString();
          } else {
            Discription = "No information avalable";
          }
        });

        if (jsonMap['items'][i]['volumeInfo']['averageRating'] == null)
          setState(() {
            rating = "0";
            review = "0";
          });
        else
          setState(() {
            rating =
                jsonMap['items'][i]['volumeInfo']['averageRating'].toString();
            review =
                jsonMap['items'][i]['volumeInfo']['ratingsCount'].toString();
          });

        break;
      }
    }
  }

  _BookInfoPageState(this.id, this.name, this.image, this.favBtnClicked);

  @override
  void initState() {
    super.initState();
    GetDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[50],
        elevation: 0,
        actions: [
          Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  DatabaseHelper db = DatabaseHelper.constructor();
                  db.InsertToFav(
                      id, author, name, rating.toString(), Categories, image);
                  if (favBtnClicked == false)
                    setState(() {
                      favBtnClicked = true;
                    });
                  else
                    setState(() {
                      favBtnClicked = false;
                    });
                },
                child: Container(
                    margin: EdgeInsets.only(top: 5, right: 20),
                    child: Icon(
                      Icons.favorite,
                      color: favBtnClicked == false
                          ? Colors.blueGrey[200]
                          : Colors.red,
                      size: 35,
                    )),
              )),
        ],
      ),
      backgroundColor: Colors.cyan[50],
      body: Container(
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.only(top: 150),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 20,
                                  spreadRadius: 1 / 5,
                                  color: Colors.grey)
                            ],
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30))),
                        height: 300,
                        child: Container(
                          margin: EdgeInsets.only(top: 120),
                          child: SingleChildScrollView(
                              child: Column(
                            children: [
                              Container(
                                  alignment: Alignment.center,
                                  width: 300,
                                  margin: EdgeInsets.only(top: 20),
                                  child: Text(
                                    name,
                                    style: TextStyle(fontSize: 19),
                                  )),
                              Text(
                                "By " + author,
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow[700],
                                        size: 30,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(rating)
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.people,
                                        color: Colors.yellow[700],
                                        size: 28,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(review)
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                width: 300,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Categories",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(top: 10),
                                  width: 300,
                                  child: Text(
                                    Categories,
                                    style: TextStyle(fontSize: 11),
                                  )),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                width: 300,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Description",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(top: 10),
                                  width: 300,
                                  child: Text(
                                    Discription,
                                    style: TextStyle(fontSize: 11),
                                  )),
                            ],
                          )),
                        )),
                  )
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Container(
                height: 300,
                child: Image.network(
                  image,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

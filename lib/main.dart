import 'dart:convert';

import 'package:books_app/Components/AccountPage.dart';
import 'package:books_app/Components/BookCard.dart';
import 'package:books_app/Components/CustomeAppBar.dart';
import 'package:books_app/Models/BookModel.dart';
import 'package:books_app/Screens/FavoritesPage.dart';
import 'package:books_app/Screens/SplashScreen.dart';
import 'package:books_app/services/DatabaseHelper.dart';
import 'package:books_app/services/LoginPage.dart';
import 'package:books_app/services/SignUp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  String profileImg = "";
  String Name = "";
  String Email = "";

  MyHomePage(this.Name, this.Email, this.profileImg);

  @override
  _MyHomePageState createState() => _MyHomePageState(Name, Email, profileImg);
}

class _MyHomePageState extends State<MyHomePage> {
  String profileImg = "";
  String Name = "";
  String Email = "";
  String url = "https://www.googleapis.com/books/v1/volumes?q=Programming";
  _MyHomePageState(this.Name, this.Email, this.profileImg);

  void _fetchPotterBooks() async {
    final res = await http.get(Uri.parse(url));

    _parseBookJson(res.body);
  }

  Future<List<BookModel>> GetFavList() async {
    DatabaseHelper db = DatabaseHelper.constructor();

    return await db.getFav();
  }

  void _parseBookJson(String jsonStr) async {
    final jsonMap = await json.decode(jsonStr);
    //final jsonList = (jsonMap['items'] as List);

    //  print("items=" + jsonMap['items'][0]['volumeInfo']['title']);

    int numberOfBooks = jsonMap['totalItems'];
    String tempImageUrl = "";
    List<BookModel> list = [];
    FamousBookList.clear();

    FavoritesBoookList = await GetFavList();
    String rating = "";
    for (int i = 0; i < numberOfBooks; i++)
      setState(() {
        List tempImageUrlSplitter = jsonMap['items'][i]['volumeInfo']
                ['imageLinks']['thumbnail']
            .toString()
            .split(':');
        tempImageUrl = tempImageUrlSplitter[0] + "s:" + tempImageUrlSplitter[1];

        if (jsonMap['items'][i]['volumeInfo']['averageRating'] == null)
          setState(() {
            rating = "0";
          });
        else
          setState(() {
            rating =
                jsonMap['items'][i]['volumeInfo']['averageRating'].toString();
          });

        FamousBookList.add(BookModel(
            jsonMap['items'][i]['id'].toString(),
            jsonMap['items'][i]['volumeInfo']['authors'][0].toString(),
            jsonMap['items'][i]['volumeInfo']['title'].toString(),
            double.parse(rating),
            jsonMap['items'][i]['volumeInfo']['categories'][0].toString(),
            tempImageUrl));
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    get();
    super.initState();
  }

  void get() {
    initialise();
  }

  void initialise() async {
    _fetchPotterBooks();
  }

  final SearhController = TextEditingController();

  @override
  void dispose() {
    SearhController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLarge = false;
    if (MediaQuery.of(context).size.width > 600) {
      isLarge = true;
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
          title: Text("BookApp"),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(profileImg),
                radius: 15,
              ),
            )
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FavoritesPage()));
                  },
                  child: Icon(
                    Icons.home,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FavoritesPage()));
                  },
                  child: Icon(
                    Icons.favorite,
                    color: Colors.blueGrey[100],
                    size: 30,
                  ),
                )
              ],
            ),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              color: Colors.white,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: isLarge == false ? 350 : 550,
                      child: Text(
                        "Looking for any books !",
                        style: TextStyle(
                            fontSize: isLarge == false ? 23 : 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      height: 50,
                      width: isLarge == false ? 350 : 600,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 0,
                                color: Colors.grey,
                                blurRadius: 5)
                          ]),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.search_rounded,
                            color: Colors.grey,
                            size: 35,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Container(
                                width: 250,
                                height: 50,
                                child: TextField(
                                  controller: SearhController,
                                  onChanged: (text) {
                                    setState(() {
                                      url =
                                          "https://www.googleapis.com/books/v1/volumes?q=" +
                                              SearhController.text;
                                    });
                                    get();
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Search",
                                      hintStyle: TextStyle(color: Colors.grey)),
                                )),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      width: isLarge == false ? 350 : 700,
                      child: Text(
                        SearhController.text == ""
                            ? "Famous Books"
                            : "Search Results",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          width: 400,
                          child: ListView.builder(
                              itemCount: FamousBookList.length,
                              itemBuilder: (context, index) {
                                print("ASdfasfd");

                                for (int i = 0;
                                    i < FavoritesBoookList.length;
                                    i++) {
                                  if (FamousBookList[index].id ==
                                      FavoritesBoookList[i].id) {
                                    return BookCard(
                                        FamousBookList[index].id,
                                        FamousBookList[index].author,
                                        FamousBookList[index].name,
                                        FamousBookList[index].rating,
                                        FamousBookList[index].type,
                                        FamousBookList[index].image,
                                        true,
                                        false);
                                  }
                                }
                                return BookCard(
                                    FamousBookList[index].id,
                                    FamousBookList[index].author,
                                    FamousBookList[index].name,
                                    FamousBookList[index].rating,
                                    FamousBookList[index].type,
                                    FamousBookList[index].image,
                                    false,
                                    false);
                              }),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

List<BookModel> FamousBookList = [];

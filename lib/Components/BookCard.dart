import 'package:books_app/Screens/BookInfoPage.dart';
import 'package:books_app/Screens/FavoritesPage.dart';
import 'package:books_app/services/DatabaseHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BookCard extends StatefulWidget {
  String id = "";
  String author = "";
  String name = "";
  double rating = 0.0;
  String type = "";
  String image = '';
  bool state = false;
  bool isInFavPage = false;
  BookCard(this.id, this.author, this.name, this.rating, this.type, this.image,
      this.state, this.isInFavPage);
  @override
  State<StatefulWidget> createState() {
    return BookCardState(
        id, author, name, rating, type, image, state, isInFavPage, this);
  }
}

class BookCardState extends State<BookCard> {
  String id;
  String author = "";
  String name = "";
  double rating = 0.0;
  String type = "";
  String image = "";
  bool state = false;
  bool ratingBtnClicked = false;
  bool isInFavPage = false;
  BookCard BookCardObj;
  BookCardState(this.id, this.author, this.name, this.rating, this.type,
      this.image, this.ratingBtnClicked, this.isInFavPage, this.BookCardObj);

  @override
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        BookInfoPage(id, name, image, ratingBtnClicked)));
          },
          child: Container(
            margin: EdgeInsets.only(
              bottom: 5,
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10)]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10, left: 2),
                          child: Container(
                            height: 130,
                            width: 80,
                            child: Image.network(
                              image,
                              height: 100,
                              width: 80,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 0),
                          width: 90,
                          height: 160,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              border:
                                  Border.all(color: Colors.white, width: 10)),
                        )
                      ],
                    ),
                    Container(
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 130,
                            child: Center(
                              child: Text(
                                author,
                                style:
                                    TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                            ),
                          ),
                          Container(
                              width: 130,
                              child: Center(
                                child: Text(
                                  name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12),
                                ),
                              )),
                          Container(
                            width: 100,
                            height: 17,
                            color: Colors.blue,
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Center(
                                child: Text(
                                  type,
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.yellow),
                    Text(rating.toString())
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    if (ratingBtnClicked == false)
                      setState(() {
                        ratingBtnClicked = true;
                        DatabaseHelper db = DatabaseHelper.constructor();
                        db.InsertToFav(
                            id, author, name, rating.toString(), type, image);
                      });
                    else {
                      setState(() {
                        ratingBtnClicked = false;
                      });
                      DatabaseHelper db = DatabaseHelper.constructor();
                      db.deleteFromfav(id);
                      setState(() {
                        FavoritesBoookList.removeWhere(
                            (element) => element.id == id);
                      });
                      setState(() {});
                    }
                  },
                  child: Icon(
                    Icons.favorite,
                    color: ratingBtnClicked == false
                        ? Colors.grey[300]
                        : Colors.red,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

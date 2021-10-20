import 'dart:io';

import 'package:books_app/Models/BookModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? db;

  DatabaseHelper.constructor();
  static final DatabaseHelper instance = DatabaseHelper.constructor();

  Future<Database?> get getdb async {
    if (db != null) {
      return db;
    }
    Directory directory = await getApplicationDocumentsDirectory();
    db = await openDatabase(join(directory.path, "Book.db"),
        onCreate: onCreate, version: 1);
    return db;
  }

  onCreate(Database db, int version) async {
    await db.execute(
        'create table favorites(id Text,author Text,name Text,rating Text,type Text,image Text)');
  }

  Future<int> InsertToFav(String id, String author, String name, String rating,
      String type, String image) async {
    Database? db = await instance.getdb;
    await db!.execute(
        "insert into favorites values('$id','$author','$name','$rating','$type','$image')");
    return 1;
  }

  Future<List<BookModel>> getFav() async {
    Database? db = await instance.getdb;
    var mapList = await db?.rawQuery('select * from favorites');
    List<BookModel> list = [];
    if (mapList != null) {
      mapList.forEach((Element) {
        BookModel book = new BookModel.fromMap(Element);
        list.add(book);
      });
    }

    return list;
  }

  Future<int> deleteFromfav(String id) async {
    Database? db = await instance.getdb;

    db!.execute("delete from favorites where id='$id'");
    return 1;
  }
}

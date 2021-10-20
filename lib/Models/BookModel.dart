class BookModel {
  String id = "";
  String author = "";
  String name = "";
  double rating = 0.0;
  String type = "";
  String image = '';

  BookModel(
      this.id, this.author, this.name, this.rating, this.type, this.image);

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(map['id'], map['author'], map['name'],
        double.parse(map['rating']), map['type'], map['image']);
  }
}

// To parse this JSON data, do
//
//     final getcollectionresponsemodel = getcollectionresponsemodelFromJson(jsonString);

import 'dart:convert';

Getcollectionresponsemodel getcollectionresponsemodelFromJson(String str) => Getcollectionresponsemodel.fromJson(json.decode(str));

String getcollectionresponsemodelToJson(Getcollectionresponsemodel data) => json.encode(data.toJson());

class Getcollectionresponsemodel {
    List<BooksList> booksList;
    int total;

    Getcollectionresponsemodel({
        required this.booksList,
        required this.total,
    });

    factory Getcollectionresponsemodel.fromJson(Map<String, dynamic> json) => Getcollectionresponsemodel(
        booksList: List<BooksList>.from(json["books_list"].map((x) => BooksList.fromJson(x))),
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "books_list": List<dynamic>.from(booksList.map((x) => x.toJson())),
        "total": total,
    };
}

class BooksList {
    String id;
    String isbn;
    String title;
    String image;
    String author;

    BooksList({
        required this.id,
        required this.isbn,
        required this.title,
        required this.image,
        required this.author,
    });

    factory BooksList.fromJson(Map<String, dynamic> json) => BooksList(
        id: json["_id"],
        isbn: json["isbn"],
        title: json["title"],
        image: json["image"],
        author: json["author"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "isbn": isbn,
        "title": title,
        "image": image,
        "author": author,
    };
}

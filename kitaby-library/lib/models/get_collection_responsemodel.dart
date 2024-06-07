// To parse this JSON data, do
//
//     final getcollectionresponsemodel = getcollectionresponsemodelFromJson(jsonString);

import 'dart:convert';

Getcollectionresponsemodel getcollectionresponsemodelFromJson(String str) => Getcollectionresponsemodel.fromJson(json.decode(str));

String getcollectionresponsemodelToJson(Getcollectionresponsemodel data) => json.encode(data.toJson());

class Getcollectionresponsemodel {
    List<BooksList> booksList;

    Getcollectionresponsemodel({
        required this.booksList,
    });

    factory Getcollectionresponsemodel.fromJson(Map<String, dynamic> json) => Getcollectionresponsemodel(
        booksList: List<BooksList>.from(json["books_list"].map((x) => BooksList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "books_list": List<dynamic>.from(booksList.map((x) => x.toJson())),
    };
}

class BooksList {
    String id;
    String title;
    String image;
    String author;

    BooksList({
        required this.id,
        required this.title,
        required this.image,
        required this.author,
    });

    factory BooksList.fromJson(Map<String, dynamic> json) => BooksList(
        id: json["_id"],
        title: json["title"],
        image: json["image"],
        author: json["author"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "image": image,
        "author": author,
    };
}

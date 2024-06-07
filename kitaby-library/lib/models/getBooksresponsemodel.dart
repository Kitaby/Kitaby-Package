// To parse this JSON data, do
//
//     final getbooksresponsemodel = getbooksresponsemodelFromJson(jsonString);

import 'dart:convert';

Getbooksresponsemodel getbooksresponsemodelFromJson(String str) => Getbooksresponsemodel.fromJson(json.decode(str));

String getbooksresponsemodelToJson(Getbooksresponsemodel data) => json.encode(data.toJson());

class Getbooksresponsemodel {
    List<AllBook> allBooks;

    Getbooksresponsemodel({
        required this.allBooks,
    });

    factory Getbooksresponsemodel.fromJson(Map<String, dynamic> json) => Getbooksresponsemodel(
        allBooks: List<AllBook>.from(json["allBooks"].map((x) => AllBook.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "allBooks": List<dynamic>.from(allBooks.map((x) => x.toJson())),
    };
}

class AllBook {
    String id;
    String title;
    String isbn;
    String image;
    String author;
    List<String> categories;
    String owner;
    String wilaya;

    AllBook({
        required this.id,
        required this.title,
        required this.isbn,
        required this.image,
        required this.author,
        required this.categories,
        required this.owner,
        required this.wilaya,
    });

    factory AllBook.fromJson(Map<String, dynamic> json) => AllBook(
        id: json["_id"],
        title: json["title"],
        isbn: json["isbn"],
        image: json["image"],
        author: json["author"],
        categories: List<String>.from(json["categories"].map((x) => x)),
        owner: json["owner"],
        wilaya: json["wilaya"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "isbn": isbn,
        "image": image,
        "author": author,
        "categories": List<dynamic>.from(categories.map((x) => x)),
        "owner": owner,
        "wilaya": wilaya,
    };
}

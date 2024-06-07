// To parse this JSON data, do
//
//     final getBooksresponsemodel = getBooksresponsemodelFromJson(jsonString);

import 'dart:convert';

GetBooksresponsemodel getBooksresponsemodelFromJson(String str) => GetBooksresponsemodel.fromJson(json.decode(str));

String getBooksresponsemodelToJson(GetBooksresponsemodel data) => json.encode(data.toJson());

class GetBooksresponsemodel {
    List<AllBook> allBooks;

    GetBooksresponsemodel({
        required this.allBooks,
    });

    factory GetBooksresponsemodel.fromJson(Map<String, dynamic> json) => GetBooksresponsemodel(
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
    String ownerId;
    String wilaya;

    AllBook({
        required this.id,
        required this.title,
        required this.isbn,
        required this.image,
        required this.author,
        required this.categories,
        required this.owner,
        required this.ownerId,
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
        ownerId: json["ownerId"],
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
        "ownerId": ownerId,
        "wilaya": wilaya,
    };
}

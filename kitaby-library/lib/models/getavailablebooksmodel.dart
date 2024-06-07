// To parse this JSON data, do
//
//     final getavailablebooksresponsemodel = getavailablebooksresponsemodelFromJson(jsonString);

import 'dart:convert';

Getavailablebooksresponsemodel getavailablebooksresponsemodelFromJson(String str) => Getavailablebooksresponsemodel.fromJson(json.decode(str));

String getavailablebooksresponsemodelToJson(Getavailablebooksresponsemodel data) => json.encode(data.toJson());

class Getavailablebooksresponsemodel {
    List<Book> availableBooks;
    int total;
    String page;

    Getavailablebooksresponsemodel({
        required this.availableBooks,
        required this.total,
        required this.page,
    });

    factory Getavailablebooksresponsemodel.fromJson(Map<String, dynamic> json) => Getavailablebooksresponsemodel(
        availableBooks: List<Book>.from(json["availableBooks"].map((x) => Book.fromJson(x))),
        total: json["total"],
        page: json["page"],
    );

    Map<String, dynamic> toJson() => {
        "availableBooks": List<dynamic>.from(availableBooks.map((x) => x.toJson())),
        "total": total,
        "page": page,
    };
}

class Book {
    String id;
    String isbn;
    String title;
    String image;
    String author;
    List<String> categories;
    List<String> bibOwners;
    List<dynamic> owners;
    int v;
    int quantity;

    Book({
        required this.id,
        required this.isbn,
        required this.title,
        required this.image,
        required this.author,
        required this.categories,
        required this.bibOwners,
        required this.owners,
        required this.v,
        required this.quantity,
    });

    factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json["_id"],
        isbn: json["isbn"],
        title: json["title"],
        image: json["image"],
        author: json["author"],
        categories: List<String>.from(json["categories"].map((x) => x)),
        bibOwners: List<String>.from(json["bibOwners"].map((x) => x)),
        owners: List<dynamic>.from(json["owners"].map((x) => x)),
        v: json["__v"],
        quantity: json["quantity"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "isbn": isbn,
        "title": title,
        "image": image,
        "author": author,
        "categories": List<dynamic>.from(categories.map((x) => x)),
        "bibOwners": List<dynamic>.from(bibOwners.map((x) => x)),
        "owners": List<dynamic>.from(owners.map((x) => x)),
        "__v": v,
        "quantity": quantity,
    };
}

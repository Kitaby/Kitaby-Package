import 'dart:convert';

Getallbooksresponse getallbooksresponseFromJson(String str) => Getallbooksresponse.fromJson(json.decode(str));

String getallbooksresponseToJson(Getallbooksresponse data) => json.encode(data.toJson());

class Getallbooksresponse {
    List<AllBook> allBooks;

    Getallbooksresponse({
        required this.allBooks,
    });

    factory Getallbooksresponse.fromJson(Map<String, dynamic> json) => Getallbooksresponse(
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

    AllBook({
        required this.id,
        required this.title,
        required this.isbn,
        required this.image,
        required this.author,
        required this.categories,
        required this.owner,
    });

    factory AllBook.fromJson(Map<String, dynamic> json) => AllBook(
        id: json["_id"],
        title: json["title"],
        isbn: json["isbn"],
        image: json["image"],
        author: json["author"],
        categories: List<String>.from(json["categories"].map((x) => x)),
        owner: json["owner"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "isbn": isbn,
        "image": image,
        "author": author,
        "categories": List<dynamic>.from(categories.map((x) => x)),
        "owner": owner,
    };
}


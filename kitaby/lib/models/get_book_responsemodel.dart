
import 'dart:convert';

Getbookresponse getbookresponseFromJson(String str) => Getbookresponse.fromJson(json.decode(str));

String getbookresponseToJson(Getbookresponse data) => json.encode(data.toJson());

class Getbookresponse {
    String id;
    String isbn;
    String title;
    String image;
    String author;
    List<String> categories;
    List<String> owners;
    int v;

    Getbookresponse({
        required this.id,
        required this.isbn,
        required this.title,
        required this.image,
        required this.author,
        required this.categories,
        required this.owners,
        required this.v,
    });

    factory Getbookresponse.fromJson(Map<String, dynamic> json) => Getbookresponse(
        id: json["_id"],
        isbn: json["isbn"],
        title: json["title"],
        image: json["image"],
        author: json["author"],
        categories: List<String>.from(json["categories"].map((x) => x)),
        owners: List<String>.from(json["owners"].map((x) => x)),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "isbn": isbn,
        "title": title,
        "image": image,
        "author": author,
        "categories": List<dynamic>.from(categories.map((x) => x)),
        "owners": List<dynamic>.from(owners.map((x) => x)),
        "__v": v,
    };
}

// To parse this JSON data, do
//
//     final postBookInCollection = postBookInCollectionFromJson(jsonString);

import 'dart:convert';

PostBookInCollection postBookInCollectionFromJson(String str) => PostBookInCollection.fromJson(json.decode(str));

String postBookInCollectionToJson(PostBookInCollection data) => json.encode(data.toJson());

class PostBookInCollection {
    String isbn;

    PostBookInCollection({
        required this.isbn,
    });

    factory PostBookInCollection.fromJson(Map<String, dynamic> json) => PostBookInCollection(
        isbn: json["isbn"],
    );

    Map<String, dynamic> toJson() => {
        "isbn": isbn,
    };
}

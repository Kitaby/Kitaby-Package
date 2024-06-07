// To parse this JSON data, do
//
//     final postBookInCollection = postBookInCollectionFromJson(jsonString);

import 'dart:convert';

PostBookInCollection postBookInCollectionFromJson(String str) =>
    PostBookInCollection.fromJson(json.decode(str));

String postBookInCollectionToJson(PostBookInCollection data) =>
    json.encode(data.toJson());

class PostBookInCollection {
  String id;
  String isbn;

  PostBookInCollection({
    required this.id,
    required this.isbn,
  });

  factory PostBookInCollection.fromJson(Map<String, dynamic> json) =>
      PostBookInCollection(
        id: json["_id"],
        isbn: json["isbn"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "isbn": isbn,
      };
}

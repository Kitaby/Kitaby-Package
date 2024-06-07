// To parse this JSON data, do
//
//     final getbookResponseModel = getbookResponseModelFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

GetbookResponseModel getbookResponseModelFromJson(String str) =>
    GetbookResponseModel.fromJson(json.decode(str));

String getbookResponseModelToJson(GetbookResponseModel data) =>
    json.encode(data.toJson());

class GetbookResponseModel {
  String id;
  String isbn;
  String title;
  String image;
  String author;
  List<String> categories;
  List<dynamic> owners;
  int v;
  List<dynamic> bibOwners;

  GetbookResponseModel({
    required this.id,
    required this.isbn,
    required this.title,
    required this.image,
    required this.author,
    required this.categories,
    required this.owners,
    required this.v,
    required this.bibOwners,
  });

  factory GetbookResponseModel.fromJson(Map<String, dynamic> json) =>
      GetbookResponseModel(
        id: json["_id"],
        isbn: json["isbn"],
        title: json["title"],
        image: json["image"],
        author: json["author"],
        categories: List<String>.from(json["categories"].map((x) => x)),
        owners: List<dynamic>.from(json["owners"].map((x) => x)),
        v: json["__v"],
        bibOwners: List<dynamic>.from(json["bibOwners"].map((x) => x)),
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
        "bibOwners": List<dynamic>.from(bibOwners.map((x) => x)),
      };
}

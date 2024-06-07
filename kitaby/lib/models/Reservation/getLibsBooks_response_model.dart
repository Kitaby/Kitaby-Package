// To parse this JSON data, do
//
//     final getLibsBooksResponseModel = getLibsBooksResponseModelFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

GetLibsBooksResponseModel getLibsBooksResponseModelFromJson(String str) =>
    GetLibsBooksResponseModel.fromJson(json.decode(str));

String getLibsBooksResponseModelToJson(GetLibsBooksResponseModel data) =>
    json.encode(data.toJson());

class GetLibsBooksResponseModel {
  List<AllBook> allBooks;

  GetLibsBooksResponseModel({
    required this.allBooks,
  });

  factory GetLibsBooksResponseModel.fromJson(Map<String, dynamic> json) =>
      GetLibsBooksResponseModel(
        allBooks: List<AllBook>.from(
            json["allBooks"].map((x) => AllBook.fromJson(x))),
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
  String bib;
  String bibId;
  String wilaya;

  AllBook({
    required this.id,
    required this.title,
    required this.isbn,
    required this.image,
    required this.author,
    required this.categories,
    required this.bib,
    required this.bibId,
    required this.wilaya,
  });

  factory AllBook.fromJson(Map<String, dynamic> json) => AllBook(
        id: json["_id"],
        title: json["title"],
        isbn: json["isbn"],
        image: json["image"],
        author: json["author"],
        categories: List<String>.from(json["categories"].map((x) => x)),
        bib: json["bib"],
        bibId: json["bibId"],
        wilaya: json["wilaya"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "isbn": isbn,
        "image": image,
        "author": author,
        "categories": List<dynamic>.from(categories.map((x) => x)),
        "bib": bib,
        "bibId": bibId,
        "wilaya": wilaya,
      };
}

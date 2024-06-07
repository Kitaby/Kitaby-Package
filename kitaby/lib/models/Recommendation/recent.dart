// To parse this JSON data, do
//
//     final recentResponseModel = recentResponseModelFromJson(jsonString);

import 'dart:convert';

RecentResponseModel recentResponseModelFromJson(String str) =>
    RecentResponseModel.fromJson(json.decode(str));

String recentResponseModelToJson(RecentResponseModel data) =>
    json.encode(data.toJson());

class RecentResponseModel {
  List<Recent> recent;

  RecentResponseModel({
    required this.recent,
  });

  factory RecentResponseModel.fromJson(Map<String, dynamic> json) =>
      RecentResponseModel(
        recent:
            List<Recent>.from(json["recent"].map((x) => Recent.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "recent": List<dynamic>.from(recent.map((x) => x.toJson())),
      };
}

class Recent {
  String id;
  String isbn;
  String title;
  String image;
  String author;
  String? description;
  List<String> categories;
  List<String> bibOwners;
  List<dynamic> owners;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  List<dynamic> reviews;

  Recent({
    required this.id,
    required this.isbn,
    required this.title,
    required this.image,
    required this.author,
    this.description,
    required this.categories,
    required this.bibOwners,
    required this.owners,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.reviews,
  });

  factory Recent.fromJson(Map<String, dynamic> json) => Recent(
        id: json["_id"],
        isbn: json["isbn"],
        title: json["title"],
        image: json["image"],
        author: json["author"],
        description: json["description"],
        categories: List<String>.from(json["categories"].map((x) => x)),
        bibOwners: List<String>.from(json["bibOwners"].map((x) => x)),
        owners: List<dynamic>.from(json["owners"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        reviews: List<dynamic>.from(json["reviews"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "isbn": isbn,
        "title": title,
        "image": image,
        "author": author,
        "description": description,
        "categories": List<dynamic>.from(categories.map((x) => x)),
        "bibOwners": List<dynamic>.from(bibOwners.map((x) => x)),
        "owners": List<dynamic>.from(owners.map((x) => x)),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "reviews": List<dynamic>.from(reviews.map((x) => x)),
      };
}

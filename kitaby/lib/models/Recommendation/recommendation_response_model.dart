// To parse this JSON data, do
//
//     final recommendationResponseModel = recommendationResponseModelFromJson(jsonString);

import 'dart:convert';

RecommendationResponseModel recommendationResponseModelFromJson(String str) =>
    RecommendationResponseModel.fromJson(json.decode(str));

String recommendationResponseModelToJson(RecommendationResponseModel data) =>
    json.encode(data.toJson());

class RecommendationResponseModel {
  List<Rec>? rec;

  RecommendationResponseModel({
    required this.rec,
  });

  factory RecommendationResponseModel.fromJson(Map<String, dynamic> json) =>
      RecommendationResponseModel(
        rec: List<Rec>.from(json["rec"].map((x) => Rec.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "rec": List<dynamic>.from(rec!.map((x) => x.toJson())),
      };
}

class Rec {
  String isbn;
  String title;
  String author;
  String image;

  Rec({
    required this.isbn,
    required this.title,
    required this.author,
    required this.image,
  });

  factory Rec.fromJson(Map<String, dynamic> json) => Rec(
        isbn: json["isbn"],
        title: json["title"],
        author: json["author"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "isbn": isbn,
        "title": title,
        "author": author,
        "image": image,
      };
}

// To parse this JSON data, do
//
//     final addRatingRequestModel = addRatingRequestModelFromJson(jsonString);

import 'dart:convert';

AddRatingRequestModel addRatingRequestModelFromJson(String str) =>
    AddRatingRequestModel.fromJson(json.decode(str));

String addRatingRequestModelToJson(AddRatingRequestModel data) =>
    json.encode(data.toJson());

class AddRatingRequestModel {
  String isbn;
  double rating;
  String comment;

  AddRatingRequestModel({
    required this.isbn,
    required this.rating,
    required this.comment,
  });

  factory AddRatingRequestModel.fromJson(Map<String, dynamic> json) =>
      AddRatingRequestModel(
        isbn: json["isbn"],
        rating: json["rating"]?.toDouble(),
        comment: json["comment"],
      );

  Map<String, dynamic> toJson() => {
        "isbn": isbn,
        "rating": rating,
        "comment": comment,
      };
}

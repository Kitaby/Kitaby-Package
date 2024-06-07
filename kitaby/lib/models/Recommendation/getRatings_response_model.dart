// To parse this JSON data, do
//
//     final getRatingsResponseModel = getRatingsResponseModelFromJson(jsonString);

import 'dart:convert';

GetRatingsResponseModel getRatingsResponseModelFromJson(String str) =>
    GetRatingsResponseModel.fromJson(json.decode(str));

String getRatingsResponseModelToJson(GetRatingsResponseModel data) =>
    json.encode(data.toJson());

class GetRatingsResponseModel {
  List<Rating> ratings;

  GetRatingsResponseModel({
    required this.ratings,
  });

  factory GetRatingsResponseModel.fromJson(Map<String, dynamic> json) =>
      GetRatingsResponseModel(
        ratings:
            List<Rating>.from(json["ratings"].map((x) => Rating.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ratings": List<dynamic>.from(ratings.map((x) => x.toJson())),
      };
}

class Rating {
  Review review;
  String pp;

  Rating({
    required this.review,
    required this.pp,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        review: Review.fromJson(json["review"]),
        pp: json["pp"],
      );

  Map<String, dynamic> toJson() => {
        "review": review.toJson(),
        "pp": pp,
      };
}

class Review {
  String username;
  int rating;
  String comment;
  String id;

  Review({
    required this.username,
    required this.rating,
    required this.comment,
    required this.id,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        username: json["username"],
        rating: json["rating"],
        comment: json["comment"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "rating": rating,
        "comment": comment,
        "_id": id,
      };
}

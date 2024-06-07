// To parse this JSON data, do
//
//     final getRatingResponseModel = getRatingResponseModelFromJson(jsonString);

import 'dart:convert';

GetRatingResponseModel getRatingResponseModelFromJson(String str) =>
    GetRatingResponseModel.fromJson(json.decode(str));

String getRatingResponseModelToJson(GetRatingResponseModel data) =>
    json.encode(data.toJson());

class GetRatingResponseModel {
  double averageRating;

  GetRatingResponseModel({
    required this.averageRating,
  });

  factory GetRatingResponseModel.fromJson(Map<String, dynamic> json) =>
      GetRatingResponseModel(
        averageRating: json["averageRating"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "averageRating": averageRating,
      };
}

// To parse this JSON data, do
//
//     final isBookAvailableResponseModel = isBookAvailableResponseModelFromJson(jsonString);

import 'dart:convert';

IsBookAvailableResponseModel isBookAvailableResponseModelFromJson(String str) =>
    IsBookAvailableResponseModel.fromJson(json.decode(str));

String isBookAvailableResponseModelToJson(IsBookAvailableResponseModel data) =>
    json.encode(data.toJson());

class IsBookAvailableResponseModel {
  bool isAvailableExchange;
  bool isAvailableLoan;

  IsBookAvailableResponseModel({
    required this.isAvailableExchange,
    required this.isAvailableLoan,
  });

  factory IsBookAvailableResponseModel.fromJson(Map<String, dynamic> json) =>
      IsBookAvailableResponseModel(
        isAvailableExchange: json["isAvailableExchange"],
        isAvailableLoan: json["isAvailableLoan"],
      );

  Map<String, dynamic> toJson() => {
        "isAvailableExchange": isAvailableExchange,
        "isAvailableLoan": isAvailableLoan,
      };
}

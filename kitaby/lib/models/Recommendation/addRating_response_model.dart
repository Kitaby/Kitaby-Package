// To parse this JSON data, do
//
//     final addRatingResponseModel = addRatingResponseModelFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

AddRatingResponseModel addRatingResponseModelFromJson(String str) =>
    AddRatingResponseModel.fromJson(json.decode(str));

String addRatingResponseModelToJson(AddRatingResponseModel data) =>
    json.encode(data.toJson());

class AddRatingResponseModel {
  String message;

  AddRatingResponseModel({
    required this.message,
  });

  factory AddRatingResponseModel.fromJson(Map<String, dynamic> json) =>
      AddRatingResponseModel(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}

// To parse this JSON data, do
//
//     final changeprofileRequestModel = changeprofileRequestModelFromJson(jsonString);

import 'dart:convert';

ChangeprofileRequestModel changeprofileRequestModelFromJson(String str) =>
    ChangeprofileRequestModel.fromJson(json.decode(str));

String changeprofileRequestModelToJson(ChangeprofileRequestModel data) =>
    json.encode(data.toJson());

class ChangeprofileRequestModel {
  String wilaya;
  List<String> categories;

  ChangeprofileRequestModel({
    required this.wilaya,
    required this.categories,
  });

  factory ChangeprofileRequestModel.fromJson(Map<String, dynamic> json) =>
      ChangeprofileRequestModel(
        wilaya: json["wilaya"],
        categories: List<String>.from(json["categories"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "wilaya": wilaya,
        "categories": List<dynamic>.from(categories.map((x) => x)),
      };
}

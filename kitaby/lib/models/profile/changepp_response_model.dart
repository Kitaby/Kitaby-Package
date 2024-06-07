// To parse this JSON data, do
//
//     final changeppResponseModel = changeppResponseModelFromJson(jsonString);

import 'dart:convert';

ChangeppResponseModel changeppResponseModelFromJson(String str) =>
    ChangeppResponseModel.fromJson(json.decode(str));

String changeppResponseModelToJson(ChangeppResponseModel data) =>
    json.encode(data.toJson());

class ChangeppResponseModel {
  String message;

  ChangeppResponseModel({
    required this.message,
  });

  factory ChangeppResponseModel.fromJson(Map<String, dynamic> json) =>
      ChangeppResponseModel(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}

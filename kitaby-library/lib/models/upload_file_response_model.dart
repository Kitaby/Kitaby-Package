// To parse this JSON data, do
//
//     final uploadFileResponseModel = uploadFileResponseModelFromJson(jsonString);

import 'dart:convert';

UploadFileResponseModel uploadFileResponseModelFromJson(String str) =>
    UploadFileResponseModel.fromJson(json.decode(str));

String uploadFileResponseModelToJson(UploadFileResponseModel data) =>
    json.encode(data.toJson());

class UploadFileResponseModel {
  String message;

  UploadFileResponseModel({
    required this.message,
  });

  factory UploadFileResponseModel.fromJson(Map<String, dynamic> json) =>
      UploadFileResponseModel(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}

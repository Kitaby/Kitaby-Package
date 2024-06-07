// To parse this JSON data, do
//
//     final updateMessageResponseModel = updateMessageResponseModelFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

UpdateMessageResponseModel updateMessageResponseModelFromJson(String str) =>
    UpdateMessageResponseModel.fromJson(json.decode(str));

String updateMessageResponseModelToJson(UpdateMessageResponseModel data) =>
    json.encode(data.toJson());

class UpdateMessageResponseModel {
  UpdateMessageResponseModel();

  factory UpdateMessageResponseModel.fromJson(Map<String, dynamic> json) =>
      UpdateMessageResponseModel();

  Map<String, dynamic> toJson() => {};
}

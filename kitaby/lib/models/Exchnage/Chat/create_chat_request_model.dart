// To parse this JSON data, do
//
//     final createChatRequestModel = createChatRequestModelFromJson(jsonString);

import 'dart:convert';

CreateChatRequestModel createChatRequestModelFromJson(String str) =>
    CreateChatRequestModel.fromJson(json.decode(str));

String createChatRequestModelToJson(CreateChatRequestModel data) =>
    json.encode(data.toJson());

class CreateChatRequestModel {
  String firstId;
  String secondId;

  CreateChatRequestModel({
    required this.firstId,
    required this.secondId,
  });

  factory CreateChatRequestModel.fromJson(Map<String, dynamic> json) =>
      CreateChatRequestModel(
        firstId: json["firstId"],
        secondId: json["secondId"],
      );

  Map<String, dynamic> toJson() => {
        "firstId": firstId,
        "secondId": secondId,
      };
}

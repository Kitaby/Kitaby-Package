// To parse this JSON data, do
//
//     final createChatResponseModel = createChatResponseModelFromJson(jsonString);

import 'dart:convert';

CreateChatResponseModel createChatResponseModelFromJson(String str) =>
    CreateChatResponseModel.fromJson(json.decode(str));

String createChatResponseModelToJson(CreateChatResponseModel data) =>
    json.encode(data.toJson());

class CreateChatResponseModel {
  List<String> members;
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  CreateChatResponseModel({
    required this.members,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory CreateChatResponseModel.fromJson(Map<String, dynamic> json) =>
      CreateChatResponseModel(
        members: List<String>.from(json["members"].map((x) => x)),
        id: json["_id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "members": List<dynamic>.from(members.map((x) => x)),
        "_id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}

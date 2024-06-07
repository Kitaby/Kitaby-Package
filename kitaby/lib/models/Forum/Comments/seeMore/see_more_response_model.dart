// To parse this JSON data, do
//
//     final seeMoreReplyRequestModel = seeMoreReplyRequestModelFromJson(jsonString);

import 'dart:convert';

import 'package:kitaby/models/Forum/Comments/GetComments/get_comments_response_model.dart';

SeeMoreReplyRequestModel seeMoreReplyRequestModelFromJson(String str) =>
    SeeMoreReplyRequestModel.fromJson(json.decode(str));

String seeMoreReplyRequestModelToJson(SeeMoreReplyRequestModel data) =>
    json.encode(data.toJson());

class SeeMoreReplyRequestModel {
  String message;
  List<Somereply> repliesArray;

  SeeMoreReplyRequestModel({
    required this.message,
    required this.repliesArray,
  });

  factory SeeMoreReplyRequestModel.fromJson(Map<String, dynamic> json) =>
      SeeMoreReplyRequestModel(
        message: json["message"],
        repliesArray: List<Somereply>.from(
            json["replies_array"].map((x) => Somereply.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "replies_array":
            List<dynamic>.from(repliesArray.map((x) => x.toJson())),
      };
}

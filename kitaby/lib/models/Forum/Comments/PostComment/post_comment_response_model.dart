// To parse this JSON data, do
//
//     final postCommentResponseModel = postCommentResponseModelFromJson(jsonString);

import 'dart:convert';

PostCommentResponseModel postCommentResponseModelFromJson(String str) =>
    PostCommentResponseModel.fromJson(json.decode(str));

String postCommentResponseModelToJson(PostCommentResponseModel data) =>
    json.encode(data.toJson());

class PostCommentResponseModel {
  String message;

  PostCommentResponseModel({
    required this.message,
  });

  factory PostCommentResponseModel.fromJson(Map<String, dynamic> json) =>
      PostCommentResponseModel(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}

// To parse this JSON data, do
//
//     final postCommentRequestModel = postCommentRequestModelFromJson(jsonString);

import 'dart:convert';

PostCommentRequestModel postCommentRequestModelFromJson(String str) =>
    PostCommentRequestModel.fromJson(json.decode(str));

String postCommentRequestModelToJson(PostCommentRequestModel data) =>
    json.encode(data.toJson());

class PostCommentRequestModel {
  String content;
  String thread;

  PostCommentRequestModel({
    required this.content,
    required this.thread,
  });

  factory PostCommentRequestModel.fromJson(Map<String, dynamic> json) =>
      PostCommentRequestModel(
        content: json["content"],
        thread: json["thread"],
      );

  Map<String, dynamic> toJson() => {
        "content": content,
        "thread": thread,
      };
}

import 'dart:convert';

PostReplyRequestModel postReplyRequestModelFromJson(String str) =>
    PostReplyRequestModel.fromJson(json.decode(str));

String postReplyRequestModelToJson(PostReplyRequestModel data) =>
    json.encode(data.toJson());

class PostReplyRequestModel {
  String content;
  String comment;
  String reply;

  PostReplyRequestModel({
    required this.content,
    required this.comment,
    required this.reply,
  });

  factory PostReplyRequestModel.fromJson(Map<String, dynamic> json) =>
      PostReplyRequestModel(
        content: json["content"],
        comment: json["comment"],
        reply: json["reply"],
      );

  Map<String, dynamic> toJson() => {
        "content": content,
        "comment": comment,
        "reply": reply,
      };
}

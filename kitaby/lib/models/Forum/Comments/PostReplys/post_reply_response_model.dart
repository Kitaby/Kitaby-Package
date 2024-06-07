import 'dart:convert';

PostReplyResponseModel postReplyResponseModelFromJson(String str) =>
    PostReplyResponseModel.fromJson(json.decode(str));

String postReplyResponseModelToJson(PostReplyResponseModel data) =>
    json.encode(data.toJson());

class PostReplyResponseModel {
  String message;
  String id;

  PostReplyResponseModel({
    required this.message,
    required this.id,
  });

  factory PostReplyResponseModel.fromJson(Map<String, dynamic> json) =>
      PostReplyResponseModel(
        message: json["message"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "id": id,
      };
}

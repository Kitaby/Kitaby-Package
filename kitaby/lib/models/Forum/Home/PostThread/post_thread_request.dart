import 'dart:convert';

PostThreadRequestModel postThreadRequestModelFromJson(String str) =>
    PostThreadRequestModel.fromJson(json.decode(str));

String postThreadRequestModelToJson(PostThreadRequestModel data) =>
    json.encode(data.toJson());

class PostThreadRequestModel {
  String title;
  String content;
  String categorie;

  PostThreadRequestModel({
    required this.title,
    required this.content,
    required this.categorie,
  });

  factory PostThreadRequestModel.fromJson(Map<String, dynamic> json) =>
      PostThreadRequestModel(
        title: json["title"],
        content: json["content"],
        categorie: json["categorie"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "content": content,
        "categorie": categorie,
      };
}

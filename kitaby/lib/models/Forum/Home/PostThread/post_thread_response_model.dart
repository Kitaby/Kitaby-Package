import 'dart:convert';

PostThreadResponseModel postThreadResponseModelFromJson(String str) =>
    PostThreadResponseModel.fromJson(json.decode(str));

String postThreadResponseModelToJson(PostThreadResponseModel data) =>
    json.encode(data.toJson());

class PostThreadResponseModel {
  String message;
  String id;

  PostThreadResponseModel({
    required this.message,
    required this.id,
  });

  factory PostThreadResponseModel.fromJson(Map<String, dynamic> json) =>
      PostThreadResponseModel(
        message: json["message"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "id": id,
      };
}

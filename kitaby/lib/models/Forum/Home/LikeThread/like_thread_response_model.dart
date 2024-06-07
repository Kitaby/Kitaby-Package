import 'dart:convert';

LikeThreadResponseModel likeThreadResponseModelFromJson(String str) =>
    LikeThreadResponseModel.fromJson(json.decode(str));

String likeThreadResponseModelToJson(LikeThreadResponseModel data) =>
    json.encode(data.toJson());

class LikeThreadResponseModel {
  String message;

  LikeThreadResponseModel({
    required this.message,
  });

  factory LikeThreadResponseModel.fromJson(Map<String, dynamic> json) =>
      LikeThreadResponseModel(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}

import 'dart:convert';

GetPostResponseModel getPostResponseModelFromJson(String str) =>
    GetPostResponseModel.fromJson(json.decode(str));

String getPostResponseModelToJson(GetPostResponseModel data) =>
    json.encode(data.toJson());

class GetPostResponseModel {
  String message;
  String pp;
  String name;

  GetPostResponseModel({
    required this.message,
    required this.pp,
    required this.name,
  });

  factory GetPostResponseModel.fromJson(Map<String, dynamic> json) =>
      GetPostResponseModel(
        message: json["message"],
        pp: json["pp"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "pp": pp,
        "name": name,
      };
}

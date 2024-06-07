// To parse this JSON data, do
//
//     final getProfileResponseModel = getProfileResponseModelFromJson(jsonString);

import 'dart:convert';

GetProfileResponseModel getProfileResponseModelFromJson(String str) =>
    GetProfileResponseModel.fromJson(json.decode(str));

String getProfileResponseModelToJson(GetProfileResponseModel data) =>
    json.encode(data.toJson());

class GetProfileResponseModel {
  String message;
  Info info;

  GetProfileResponseModel({
    required this.message,
    required this.info,
  });

  factory GetProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      GetProfileResponseModel(
        message: json["message"],
        info: Info.fromJson(json["info"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "info": info.toJson(),
      };
}

class Info {
  String email;
  String name;
  String phone;
  List<String> categories;
  String photo;
  int exchanges;
  int books;
  String wilaya;

  Info({
    required this.email,
    required this.name,
    required this.phone,
    required this.categories,
    required this.photo,
    required this.exchanges,
    required this.books,
    required this.wilaya,
  });

  factory Info.fromJson(Map<String, dynamic> json) => Info(
        email: json["email"],
        name: json["name"],
        phone: json["phone"],
        categories: List<String>.from(json["categories"].map((x) => x)),
        photo: json["photo"],
        exchanges: json["exchanges"],
        books: json["books"],
        wilaya: json["wilaya"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "name": name,
        "phone": phone,
        "categories": List<dynamic>.from(categories.map((x) => x)),
        "photo": photo,
        "exchanges": exchanges,
        "books": books,
        "wilaya": wilaya,
      };
}

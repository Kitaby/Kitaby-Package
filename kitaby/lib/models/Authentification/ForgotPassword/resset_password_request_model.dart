// To parse this JSON data, do
//
//     final ressetPasswordRequestModel = ressetPasswordRequestModelFromJson(jsonString);

import 'dart:convert';

RessetPasswordRequestModel ressetPasswordRequestModelFromJson(String str) =>
    RessetPasswordRequestModel.fromJson(json.decode(str));

String ressetPasswordRequestModelToJson(RessetPasswordRequestModel data) =>
    json.encode(data.toJson());

class RessetPasswordRequestModel {
  String email;
  String otp;
  String password;

  RessetPasswordRequestModel({
    required this.email,
    required this.otp,
    required this.password,
  });

  factory RessetPasswordRequestModel.fromJson(Map<String, dynamic> json) =>
      RessetPasswordRequestModel(
        email: json["email"],
        otp: json["otp"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "otp": otp,
        "password": password,
      };
}

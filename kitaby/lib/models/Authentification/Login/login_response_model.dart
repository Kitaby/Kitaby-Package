import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) =>
    json.encode(data.toJson());

class LoginResponseModel {
  String message;
  String? username;
  String? userpp;
  String? token;

  LoginResponseModel({
    required this.message,
    required this.username,
    required this.userpp,
    required this.token,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        message: json["message"],
        username: json["username"],
        userpp: json["userpp"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "username": username,
        "userpp": userpp,
        "token": token,
      };
}

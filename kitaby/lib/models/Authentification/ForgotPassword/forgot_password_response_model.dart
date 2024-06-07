import 'dart:convert';

ForgotRessetpasswordResponseModel forgotRessetpasswordResponseModelFromJson(
        String str) =>
    ForgotRessetpasswordResponseModel.fromJson(json.decode(str));

String forgotRessetpasswordResponseModelToJson(
        ForgotRessetpasswordResponseModel data) =>
    json.encode(data.toJson());

class ForgotRessetpasswordResponseModel {
  String message;

  ForgotRessetpasswordResponseModel({
    required this.message,
  });

  factory ForgotRessetpasswordResponseModel.fromJson(
          Map<String, dynamic> json) =>
      ForgotRessetpasswordResponseModel(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}

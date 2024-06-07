import 'dart:convert';

SendOtpResponseModel sendOtpResponseModelFromJson(String str) =>
    SendOtpResponseModel.fromJson(json.decode(str));

String sendOtpResponseModelToJson(SendOtpResponseModel data) =>
    json.encode(data.toJson());

class SendOtpResponseModel {
  String message;
  String? data;

  SendOtpResponseModel({
    required this.message,
    required this.data,
  });

  factory SendOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      SendOtpResponseModel(
        message: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data,
      };
}

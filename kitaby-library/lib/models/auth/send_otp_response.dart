// To parse this JSON data, do
//
//     final sendOtpResponse = sendOtpResponseFromJson(jsonString);

import 'dart:convert';

SendOtpResponse sendOtpResponseFromJson(String str) => SendOtpResponse.fromJson(json.decode(str));

String sendOtpResponseToJson(SendOtpResponse data) => json.encode(data.toJson());

class SendOtpResponse {
    String? message;
    String? data;

    SendOtpResponse({
      required this.message,
      required this.data,
    });

    factory SendOtpResponse.fromJson(Map<String, dynamic> json) => SendOtpResponse(
      message: json["message"],
      data: json["data"],
    );

    Map<String, dynamic> toJson() => {
      "message": message,
      "data": data,
    };
}

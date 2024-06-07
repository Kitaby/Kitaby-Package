// To parse this JSON data, do
//
//     final verifyOtpRequest = verifyOtpRequestFromJson(jsonString);

import 'dart:convert';

VerifyOtpRequest verifyOtpRequestFromJson(String str) => VerifyOtpRequest.fromJson(json.decode(str));

String verifyOtpRequestToJson(VerifyOtpRequest data) => json.encode(data.toJson());

class VerifyOtpRequest {
    String phone;
    String otp;
    String data;

    VerifyOtpRequest({
        required this.phone,
        required this.otp,
        required this.data,
    });

    factory VerifyOtpRequest.fromJson(Map<String, dynamic> json) => VerifyOtpRequest(
        phone: json["phone"],
        otp: json["otp"],
        data: json["data"],
    );

    Map<String, dynamic> toJson() => {
        "phone": phone,
        "otp": otp,
        "data": data,
    };
}

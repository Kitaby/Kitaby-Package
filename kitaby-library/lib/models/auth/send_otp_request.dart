// To parse this JSON data, do
//
//     final sendOtpRequest = sendOtpRequestFromJson(jsonString);

import 'dart:convert';

SendOtpRequest sendOtpRequestFromJson(String str) => SendOtpRequest.fromJson(json.decode(str));

String sendOtpRequestToJson(SendOtpRequest data) => json.encode(data.toJson());

class SendOtpRequest {
    String phone;

    SendOtpRequest({
        required this.phone,
    });

    factory SendOtpRequest.fromJson(Map<String, dynamic> json) => SendOtpRequest(
        phone: json["phone"],
    );

    Map<String, dynamic> toJson() => {
        "phone": phone,
    };
}

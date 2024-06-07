import 'dart:convert';

PhoneVerifyOtpRequestModel phoneVerifyOtpRequestModelFromJson(String str) =>
    PhoneVerifyOtpRequestModel.fromJson(json.decode(str));

String phoneVerifyOtpRequestModelToJson(PhoneVerifyOtpRequestModel data) =>
    json.encode(data.toJson());

class PhoneVerifyOtpRequestModel {
  String phone;
  String otp;
  String data;

  PhoneVerifyOtpRequestModel({
    required this.phone,
    required this.otp,
    required this.data,
  });

  factory PhoneVerifyOtpRequestModel.fromJson(Map<String, dynamic> json) =>
      PhoneVerifyOtpRequestModel(
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

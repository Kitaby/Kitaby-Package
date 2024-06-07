import 'dart:convert';

PhoneOtpRequestModel phoneOtpRequestModelFromJson(String str) =>
    PhoneOtpRequestModel.fromJson(json.decode(str));

String phoneOtpRequestModelToJson(PhoneOtpRequestModel data) =>
    json.encode(data.toJson());

class PhoneOtpRequestModel {
  String phone;

  PhoneOtpRequestModel({
    required this.phone,
  });

  factory PhoneOtpRequestModel.fromJson(Map<String, dynamic> json) =>
      PhoneOtpRequestModel(
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "phone": phone,
      };
}

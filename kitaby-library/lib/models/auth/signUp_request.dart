// To parse this JSON data, do
//
//     final signupRequest = signupRequestFromJson(jsonString);

import 'dart:convert';

SignupRequest signupRequestFromJson(String str) => SignupRequest.fromJson(json.decode(str));

String signupRequestToJson(SignupRequest data) => json.encode(data.toJson());

class SignupRequest {
    String phone;
    String email;
    String password;
    String name;
    String comRegNum;
    String address;

    SignupRequest({
        required this.phone,
        required this.email,
        required this.password,
        required this.name,
        required this.comRegNum,
        required this.address,
    });

    factory SignupRequest.fromJson(Map<String, dynamic> json) => SignupRequest(
        phone: json["phone"],
        email: json["email"],
        password: json["password"],
        name: json["name"],
        comRegNum: json["com_reg_num"],
        address: json["address"],
      );

    Map<String, dynamic> toJson() => {
        "phone": phone,
        "email": email,
        "password": password,
        "name": name,
        "com_reg_num": comRegNum,
        "address": address,
    };
}

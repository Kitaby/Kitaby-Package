import 'dart:convert';

RegisterRequestModel registerRequestModelFromJson(String str) =>
    RegisterRequestModel.fromJson(json.decode(str));

String registerRequestModelToJson(RegisterRequestModel data) =>
    json.encode(data.toJson());

class RegisterRequestModel {
  String phone;
  String email;
  String password;
  String name;
  List<String>? categories;

  RegisterRequestModel({
    required this.phone,
    required this.email,
    required this.password,
    required this.name,
    required this.categories,
  });

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) =>
      RegisterRequestModel(
        phone: json["phone"],
        email: json["email"],
        password: json["password"],
        name: json["name"],
        categories: json["categories"] != null
            ? List<String>.from(json["categories"]!.map((x) => x))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "phone": phone,
        "email": email,
        "password": password,
        "name": name,
        "categories": List<dynamic>.from(categories!.map((x) => x)),
      };
}

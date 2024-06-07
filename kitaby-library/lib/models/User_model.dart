// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  User user;
  String token;

  UserModel({
    required this.user,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        user: User.fromJson(json["user"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "token": token,
      };
}

class User {
  String id;
  String email;
  String password;
  String name;
  String phone;
  List<String> categories;
  bool verified;
  String verifyLink;
  List<dynamic> ownedbooks;
  List<dynamic> cart;
  List<dynamic> wishlist;
  List<dynamic> offersA;
  List<dynamic> offersB;
  String photo;
  int v;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
    required this.categories,
    required this.verified,
    required this.verifyLink,
    required this.ownedbooks,
    required this.cart,
    required this.wishlist,
    required this.offersA,
    required this.offersB,
    required this.photo,
    required this.v,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        email: json["email"],
        password: json["password"],
        name: json["name"],
        phone: json["phone"],
        categories: List<String>.from(json["categories"].map((x) => x)),
        verified: json["verified"],
        verifyLink: json["verifyLink"],
        ownedbooks: List<dynamic>.from(json["ownedbooks"].map((x) => x)),
        cart: List<dynamic>.from(json["cart"].map((x) => x)),
        wishlist: List<dynamic>.from(json["wishlist"].map((x) => x)),
        offersA: List<dynamic>.from(json["offers_a"].map((x) => x)),
        offersB: List<dynamic>.from(json["offers_b"].map((x) => x)),
        photo: json["photo"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "email": email,
        "password": password,
        "name": name,
        "phone": phone,
        "categories": List<dynamic>.from(categories.map((x) => x)),
        "verified": verified,
        "verifyLink": verifyLink,
        "ownedbooks": List<dynamic>.from(ownedbooks.map((x) => x)),
        "cart": List<dynamic>.from(cart.map((x) => x)),
        "wishlist": List<dynamic>.from(wishlist.map((x) => x)),
        "offers_a": List<dynamic>.from(offersA.map((x) => x)),
        "offers_b": List<dynamic>.from(offersB.map((x) => x)),
        "photo": photo,
        "__v": v,
      };
}

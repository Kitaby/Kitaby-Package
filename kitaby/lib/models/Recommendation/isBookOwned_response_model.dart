// To parse this JSON data, do
//
//     final isBookOwnedResponseModel = isBookOwnedResponseModelFromJson(jsonString);

import 'dart:convert';

IsBookOwnedResponseModel isBookOwnedResponseModelFromJson(String str) =>
    IsBookOwnedResponseModel.fromJson(json.decode(str));

String isBookOwnedResponseModelToJson(IsBookOwnedResponseModel data) =>
    json.encode(data.toJson());

class IsBookOwnedResponseModel {
  bool collection;
  bool wishlist;
  Reservation reservation;

  IsBookOwnedResponseModel({
    required this.collection,
    required this.wishlist,
    required this.reservation,
  });

  factory IsBookOwnedResponseModel.fromJson(Map<String, dynamic> json) =>
      IsBookOwnedResponseModel(
        collection: json["collection"],
        wishlist: json["wishlist"],
        reservation: Reservation.fromJson(json["reservation"]),
      );

  Map<String, dynamic> toJson() => {
        "collection": collection,
        "wishlist": wishlist,
        "reservation": reservation.toJson(),
      };
}

class Reservation {
  bool exists;
  String date;
  String status;

  Reservation({
    required this.exists,
    required this.date,
    required this.status,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) => Reservation(
        exists: json["exists"],
        date: json["date"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "exists": exists,
        "date": date,
        "status": status,
      };
}

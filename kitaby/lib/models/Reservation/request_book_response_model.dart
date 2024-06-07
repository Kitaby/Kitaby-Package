// To parse this JSON data, do
//
//     final requestbookResponseModel = requestbookResponseModelFromJson(jsonString);

import 'dart:convert';

RequestbookResponseModel requestbookResponseModelFromJson(String str) =>
    RequestbookResponseModel.fromJson(json.decode(str));

String requestbookResponseModelToJson(RequestbookResponseModel data) =>
    json.encode(data.toJson());

class RequestbookResponseModel {
  Reservation reservation;

  RequestbookResponseModel({
    required this.reservation,
  });

  factory RequestbookResponseModel.fromJson(Map<String, dynamic> json) =>
      RequestbookResponseModel(
        reservation: Reservation.fromJson(json["reservation"]),
      );

  Map<String, dynamic> toJson() => {
        "reservation": reservation.toJson(),
      };
}

class Reservation {
  String reserver;
  String bib;
  String isbn;
  DateTime date;
  String status;
  String id;
  int v;

  Reservation({
    required this.reserver,
    required this.bib,
    required this.isbn,
    required this.date,
    required this.status,
    required this.id,
    required this.v,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) => Reservation(
        reserver: json["reserver"],
        bib: json["bib"],
        isbn: json["isbn"],
        date: DateTime.parse(json["date"]),
        status: json["status"],
        id: json["_id"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "reserver": reserver,
        "bib": bib,
        "isbn": isbn,
        "date": date.toIso8601String(),
        "status": status,
        "_id": id,
        "__v": v,
      };
}

// To parse this JSON data, do
//
//     final getReservationsResponseModel = getReservationsResponseModelFromJson(jsonString);

import 'dart:convert';

GetReservationsResponseModel getReservationsResponseModelFromJson(String str) =>
    GetReservationsResponseModel.fromJson(json.decode(str));

String getReservationsResponseModelToJson(GetReservationsResponseModel data) =>
    json.encode(data.toJson());

class GetReservationsResponseModel {
  List<R>? rs;

  GetReservationsResponseModel({
    required this.rs,
  });

  factory GetReservationsResponseModel.fromJson(Map<String, dynamic> json) =>
      GetReservationsResponseModel(
        rs: List<R>.from(json["rs"].map((x) => R.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "rs": List<dynamic>.from(rs!.map((x) => x.toJson())),
      };
}

class R {
  String id;
  String bibName;
  String isbn;
  String bookName;
  String bookImage;
  DateTime date;
  String status;
  String author;

  R({
    required this.id,
    required this.bibName,
    required this.isbn,
    required this.bookName,
    required this.bookImage,
    required this.date,
    required this.status,
    required this.author,
  });

  factory R.fromJson(Map<String, dynamic> json) => R(
        id: json["_id"],
        bibName: json["bibName"],
        isbn: json["isbn"],
        bookName: json["bookName"],
        bookImage: json["bookImage"],
        date: DateTime.parse(json["date"]),
        status: json["status"],
        author: json["author"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "bibName": bibName,
        "isbn": isbn,
        "bookName": bookName,
        "bookImage": bookImage,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "status": status,
        "author": author,
      };
}

// To parse this JSON data, do
//
//     final renewRequestResponseModel = renewRequestResponseModelFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

RenewRequestResponseModel renewRequestResponseModelFromJson(String str) => RenewRequestResponseModel.fromJson(json.decode(str));

String renewRequestResponseModelToJson(RenewRequestResponseModel data) => json.encode(data.toJson());

class RenewRequestResponseModel {
    R? r;

    RenewRequestResponseModel({
        required this.r,
    });

    factory RenewRequestResponseModel.fromJson(Map<String, dynamic> json) => RenewRequestResponseModel(
        r: R.fromJson(json["r"]),
    );

    Map<String, dynamic> toJson() => {
        "r": r!.toJson(),
    };
}

class R {
    String id;
    String reserver;
    String bib;
    String isbn;
    DateTime date;
    String status;
    int v;

    R({
        required this.id,
        required this.reserver,
        required this.bib,
        required this.isbn,
        required this.date,
        required this.status,
        required this.v,
    });

    factory R.fromJson(Map<String, dynamic> json) => R(
        id: json["_id"],
        reserver: json["reserver"],
        bib: json["bib"],
        isbn: json["isbn"],
        date: DateTime.parse(json["date"]),
        status: json["status"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "reserver": reserver,
        "bib": bib,
        "isbn": isbn,
        "date": date.toIso8601String(),
        "status": status,
        "__v": v,
    };
}

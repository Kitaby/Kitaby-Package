// To parse this JSON data, do
//
//     final getRenewRequestResponseModel = getRenewRequestResponseModelFromJson(jsonString);

import 'dart:convert';

GetRenewRequestResponseModel getRenewRequestResponseModelFromJson(String str) => GetRenewRequestResponseModel.fromJson(json.decode(str));

String getRenewRequestResponseModelToJson(GetRenewRequestResponseModel data) => json.encode(data.toJson());

class GetRenewRequestResponseModel {
    List<RenewRequest> renewRequests;
    int total;
    String page;

    GetRenewRequestResponseModel({
        required this.renewRequests,
        required this.total,
        required this.page,
    });

    factory GetRenewRequestResponseModel.fromJson(Map<String, dynamic> json) => GetRenewRequestResponseModel(
        renewRequests: List<RenewRequest>.from(json["renewRequests"].map((x) => RenewRequest.fromJson(x))),
        total: json["total"],
        page: json["page"],
    );

    Map<String, dynamic> toJson() => {
        "renewRequests": List<dynamic>.from(renewRequests.map((x) => x.toJson())),
        "total": total,
        "page": page,
    };
}

class RenewRequest {
    String id;
    String reserver;
    String reserverName;
    String isbn;
    String bookName;
    String bookImage;
    DateTime date;
    String status;
    String author;

    RenewRequest({
        required this.id,
        required this.reserver,
        required this.reserverName,
        required this.isbn,
        required this.bookName,
        required this.bookImage,
        required this.date,
        required this.status,
        required this.author,
    });

    factory RenewRequest.fromJson(Map<String, dynamic> json) => RenewRequest(
        id: json["_id"],
        reserver: json["reserver"],
        reserverName: json["reserverName"],
        isbn: json["isbn"],
        bookName: json["bookName"],
        bookImage: json["bookImage"],
        date: DateTime.parse(json["date"]),
        status: json["status"],
        author: json["author"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "reserver": reserver,
        "reserverName": reserverName,
        "isbn": isbn,
        "bookName": bookName,
        "bookImage": bookImage,
        "date": date.toIso8601String(),
        "status": status,
        "author": author,
    };
}

// To parse this JSON data, do
//
//     final getOnHoldBooksResponseModel = getOnHoldBooksResponseModelFromJson(jsonString);

import 'dart:convert';

GetOnHoldBooksResponseModel getOnHoldBooksResponseModelFromJson(String str) => GetOnHoldBooksResponseModel.fromJson(json.decode(str));

String getOnHoldBooksResponseModelToJson(GetOnHoldBooksResponseModel data) => json.encode(data.toJson());

class GetOnHoldBooksResponseModel {
    List<OnHoldBook> onHoldBooks;
    int total;
    String page;

    GetOnHoldBooksResponseModel({
        required this.onHoldBooks,
        required this.total,
        required this.page,
    });

    factory GetOnHoldBooksResponseModel.fromJson(Map<String, dynamic> json) => GetOnHoldBooksResponseModel(
        onHoldBooks: List<OnHoldBook>.from(json["onHoldBooks"].map((x) => OnHoldBook.fromJson(x))),
        total: json["total"],
        page: json["page"],
    );

    Map<String, dynamic> toJson() => {
        "onHoldBooks": List<dynamic>.from(onHoldBooks.map((x) => x.toJson())),
        "total": total,
        "page": page,
    };
}

class OnHoldBook {
    String id;
    String reserver;
    String reserverName;
    String isbn;
    String bookName;
    String bookImage;
    DateTime date;
    String status;
    String author;

    OnHoldBook({
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

    factory OnHoldBook.fromJson(Map<String, dynamic> json) => OnHoldBook(
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

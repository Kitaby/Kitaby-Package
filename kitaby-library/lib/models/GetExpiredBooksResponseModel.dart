// To parse this JSON data, do
//
//     final getExpiredBooksResponseModel = getExpiredBooksResponseModelFromJson(jsonString);

import 'dart:convert';

GetExpiredBooksResponseModel getExpiredBooksResponseModelFromJson(String str) => GetExpiredBooksResponseModel.fromJson(json.decode(str));

String getExpiredBooksResponseModelToJson(GetExpiredBooksResponseModel data) => json.encode(data.toJson());

class GetExpiredBooksResponseModel {
    List<ExpiredBook> expiredBooks;
    int total;
    String page;

    GetExpiredBooksResponseModel({
        required this.expiredBooks,
        required this.total,
        required this.page,
    });

    factory GetExpiredBooksResponseModel.fromJson(Map<String, dynamic> json) => GetExpiredBooksResponseModel(
        expiredBooks: List<ExpiredBook>.from(json["expiredBooks"].map((x) => ExpiredBook.fromJson(x))),
        total: json["total"],
        page: json["page"],
    );

    Map<String, dynamic> toJson() => {
        "expiredBooks": List<dynamic>.from(expiredBooks.map((x) => x.toJson())),
        "total": total,
        "page": page,
    };
}

class ExpiredBook {
    String id;
    String reserver;
    String reserverName;
    String isbn;
    String bookName;
    String bookImage;
    DateTime date;
    String status;
    String author;

    ExpiredBook({
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

    factory ExpiredBook.fromJson(Map<String, dynamic> json) => ExpiredBook(
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

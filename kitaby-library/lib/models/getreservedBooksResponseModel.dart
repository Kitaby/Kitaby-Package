// To parse this JSON data, do
//
//     final getReservedBooksResponseModel = getReservedBooksResponseModelFromJson(jsonString);

import 'dart:convert';

GetReservedBooksResponseModel getReservedBooksResponseModelFromJson(String str) => GetReservedBooksResponseModel.fromJson(json.decode(str));

String getReservedBooksResponseModelToJson(GetReservedBooksResponseModel data) => json.encode(data.toJson());

class GetReservedBooksResponseModel {
    List<ReservedBook> reservedBooks;
    int total;
    String page;

    GetReservedBooksResponseModel({
        required this.reservedBooks,
        required this.total,
        required this.page,
    });

    factory GetReservedBooksResponseModel.fromJson(Map<String, dynamic> json) => GetReservedBooksResponseModel(
        reservedBooks: List<ReservedBook>.from(json["reservedBooks"].map((x) => ReservedBook.fromJson(x))),
        total: json["total"],
        page: json["page"],
    );

    Map<String, dynamic> toJson() => {
        "reservedBooks": List<dynamic>.from(reservedBooks.map((x) => x.toJson())),
        "total": total,
        "page": page,
    };
}

class ReservedBook {
    String id;
    String reserver;
    String reserverName;
    String isbn;
    String bookName;
    String bookImage;
    DateTime date;
    String status;
    String author;

    ReservedBook({
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

    factory ReservedBook.fromJson(Map<String, dynamic> json) => ReservedBook(
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

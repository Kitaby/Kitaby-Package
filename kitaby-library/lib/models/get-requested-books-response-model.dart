// To parse this JSON data, do
//
//     final getRequestedBooksResponseModel = getRequestedBooksResponseModelFromJson(jsonString);

import 'dart:convert';

GetRequestedBooksResponseModel getRequestedBooksResponseModelFromJson(String str) => GetRequestedBooksResponseModel.fromJson(json.decode(str));

String getRequestedBooksResponseModelToJson(GetRequestedBooksResponseModel data) => json.encode(data.toJson());

class GetRequestedBooksResponseModel {
    List<RequestedBook> requestedBooks;
    int total;
    String page;

    GetRequestedBooksResponseModel({
        required this.requestedBooks,
        required this.total,
        required this.page,
    });

    factory GetRequestedBooksResponseModel.fromJson(Map<String, dynamic> json) => GetRequestedBooksResponseModel(
        requestedBooks: List<RequestedBook>.from(json["requestedBooks"].map((x) => RequestedBook.fromJson(x))),
        total: json["total"],
        page: json["page"],
    );

    Map<String, dynamic> toJson() => {
        "requestedBooks": List<dynamic>.from(requestedBooks.map((x) => x.toJson())),
        "total": total,
        "page": page,
    };
}

class RequestedBook {
    String id;
    String reserver;
    String reserverName;
    String isbn;
    String bookName;
    String bookImage;
    DateTime date;
    String status;
    String author;

    RequestedBook({
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

    factory RequestedBook.fromJson(Map<String, dynamic> json) => RequestedBook(
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

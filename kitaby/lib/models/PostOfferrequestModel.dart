// To parse this JSON data, do
//
//     final postOfferrequestModel = postOfferrequestModelFromJson(jsonString);

import 'dart:convert';

PostOfferrequestModel postOfferrequestModelFromJson(String str) => PostOfferrequestModel.fromJson(json.decode(str));

String postOfferrequestModelToJson(PostOfferrequestModel data) => json.encode(data.toJson());

class PostOfferrequestModel {
    String bookOwner;
    String demandedBook;
    List<String> proposedBooks;

    PostOfferrequestModel({
        required this.bookOwner,
        required this.demandedBook,
        required this.proposedBooks,
    });

    factory PostOfferrequestModel.fromJson(Map<String, dynamic> json) => PostOfferrequestModel(
        bookOwner: json["bookOwner"],
        demandedBook: json["demandedBook"],
        proposedBooks: List<String>.from(json["proposedBooks"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "bookOwner": bookOwner,
        "demandedBook": demandedBook,
        "proposedBooks": List<dynamic>.from(proposedBooks.map((x) => x)),
    };
}

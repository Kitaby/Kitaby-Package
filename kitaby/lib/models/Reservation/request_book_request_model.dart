// To parse this JSON data, do
//
//     final requestbookRequestModel = requestbookRequestModelFromJson(jsonString);

import 'dart:convert';

RequestbookRequestModel requestbookRequestModelFromJson(String str) =>
    RequestbookRequestModel.fromJson(json.decode(str));

String requestbookRequestModelToJson(RequestbookRequestModel data) =>
    json.encode(data.toJson());

class RequestbookRequestModel {
  String bibId;
  String bookIsbn;

  RequestbookRequestModel({
    required this.bibId,
    required this.bookIsbn,
  });

  factory RequestbookRequestModel.fromJson(Map<String, dynamic> json) =>
      RequestbookRequestModel(
        bibId: json["bibId"],
        bookIsbn: json["bookIsbn"],
      );

  Map<String, dynamic> toJson() => {
        "bibId": bibId,
        "bookIsbn": bookIsbn,
      };
}

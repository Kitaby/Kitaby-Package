// To parse this JSON data, do
//
//     final addbooklibresponsemodel = addbooklibresponsemodelFromJson(jsonString);

import 'dart:convert';

import 'package:kitabylib/models/getavailablebooksmodel.dart';

Addbooklibresponsemodel addbooklibresponsemodelFromJson(String str) => Addbooklibresponsemodel.fromJson(json.decode(str));

String addbooklibresponsemodelToJson(Addbooklibresponsemodel data) => json.encode(data.toJson());

class Addbooklibresponsemodel {
    Book book;

    Addbooklibresponsemodel({
        required this.book,
    });

    factory Addbooklibresponsemodel.fromJson(Map<String, dynamic> json) => Addbooklibresponsemodel(
        book: Book.fromJson(json["book"]),
    );

    Map<String, dynamic> toJson() => {
        "book": book.toJson(),
    };
}


// To parse this JSON data, do
//
//     final addbooklibrequestmodel = addbooklibrequestmodelFromJson(jsonString);

import 'dart:convert';

Addbooklibrequestmodel addbooklibrequestmodelFromJson(String str) => Addbooklibrequestmodel.fromJson(json.decode(str));

String addbooklibrequestmodelToJson(Addbooklibrequestmodel data) => json.encode(data.toJson());

class Addbooklibrequestmodel {
    String isbn;
    String quantity;

    Addbooklibrequestmodel({
        required this.isbn,
        required this.quantity,
    });

    factory Addbooklibrequestmodel.fromJson(Map<String, dynamic> json) => Addbooklibrequestmodel(
        isbn: json["isbn"],
        quantity: json["quantity"],
    );

    Map<String, dynamic> toJson() => {
        "isbn": isbn,
        "quantity": quantity,
    };
}

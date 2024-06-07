// To parse this JSON data, do
//
//     final acceptofferrequestModel = acceptofferrequestModelFromJson(jsonString);

import 'dart:convert';

AcceptofferrequestModel acceptofferrequestModelFromJson(String str) => AcceptofferrequestModel.fromJson(json.decode(str));

String acceptofferrequestModelToJson(AcceptofferrequestModel data) => json.encode(data.toJson());

class AcceptofferrequestModel {
    String offerId;
    String acceptedBookIsbn;

    AcceptofferrequestModel({
        required this.offerId,
        required this.acceptedBookIsbn,
    });

    factory AcceptofferrequestModel.fromJson(Map<String, dynamic> json) => AcceptofferrequestModel(
        offerId: json["offerId"],
        acceptedBookIsbn: json["acceptedBookIsbn"],
    );

    Map<String, dynamic> toJson() => {
        "offerId": offerId,
        "acceptedBookIsbn": acceptedBookIsbn,
    };
}

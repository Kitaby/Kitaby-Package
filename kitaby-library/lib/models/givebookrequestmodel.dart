// To parse this JSON data, do
//
//     final givebookrequestmodel = givebookrequestmodelFromJson(jsonString);

import 'dart:convert';

Givebookrequestmodel givebookrequestmodelFromJson(String str) => Givebookrequestmodel.fromJson(json.decode(str));

String givebookrequestmodelToJson(Givebookrequestmodel data) => json.encode(data.toJson());

class Givebookrequestmodel {
    String reservationId;
    String code;

    Givebookrequestmodel({
        required this.reservationId,
        required this.code,
    });

    factory Givebookrequestmodel.fromJson(Map<String, dynamic> json) => Givebookrequestmodel(
        reservationId: json["reservationId"],
        code: json["code"],
    );

    Map<String, dynamic> toJson() => {
        "reservationId": reservationId,
        "code": code,
    };
}

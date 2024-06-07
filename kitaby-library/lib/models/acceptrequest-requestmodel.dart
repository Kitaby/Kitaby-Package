// To parse this JSON data, do
//
//     final acceptrequestRequestModel = acceptrequestRequestModelFromJson(jsonString);

import 'dart:convert';

AcceptrequestRequestModel acceptrequestRequestModelFromJson(String str) => AcceptrequestRequestModel.fromJson(json.decode(str));

String acceptrequestRequestModelToJson(AcceptrequestRequestModel data) => json.encode(data.toJson());

class AcceptrequestRequestModel {
    String reservationId;

    AcceptrequestRequestModel({
        required this.reservationId,
    });

    factory AcceptrequestRequestModel.fromJson(Map<String, dynamic> json) => AcceptrequestRequestModel(
        reservationId: json["reservationId"],
    );

    Map<String, dynamic> toJson() => {
        "reservationId": reservationId,
    };
}

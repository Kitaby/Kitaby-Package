// To parse this JSON data, do
//
//     final cancelReservationRequestModel = cancelReservationRequestModelFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

CancelReservationRequestModel cancelReservationRequestModelFromJson(
        String str) =>
    CancelReservationRequestModel.fromJson(json.decode(str));

String cancelReservationRequestModelToJson(
        CancelReservationRequestModel data) =>
    json.encode(data.toJson());

class CancelReservationRequestModel {
  String reservationId;

  CancelReservationRequestModel({
    required this.reservationId,
  });

  factory CancelReservationRequestModel.fromJson(Map<String, dynamic> json) =>
      CancelReservationRequestModel(
        reservationId: json["reservationId"],
      );

  Map<String, dynamic> toJson() => {
        "reservationId": reservationId,
      };
}

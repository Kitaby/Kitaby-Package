// To parse this JSON data, do
//
//     final cancelReservationResponseModel = cancelReservationResponseModelFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

CancelReservationResponseModel cancelReservationResponseModelFromJson(
        String str) =>
    CancelReservationResponseModel.fromJson(json.decode(str));

String cancelReservationResponseModelToJson(
        CancelReservationResponseModel data) =>
    json.encode(data.toJson());

class CancelReservationResponseModel {
  String message;

  CancelReservationResponseModel({
    required this.message,
  });

  factory CancelReservationResponseModel.fromJson(Map<String, dynamic> json) =>
      CancelReservationResponseModel(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}

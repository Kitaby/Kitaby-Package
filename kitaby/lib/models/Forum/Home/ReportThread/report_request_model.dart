import 'dart:convert';

ReportRequestModel reportRequestModelFromJson(String str) =>
    ReportRequestModel.fromJson(json.decode(str));

String reportRequestModelToJson(ReportRequestModel data) =>
    json.encode(data.toJson());

class ReportRequestModel {
  String reported;
  String description;
  String model;

  ReportRequestModel({
    required this.reported,
    required this.description,
    required this.model,
  });

  factory ReportRequestModel.fromJson(Map<String, dynamic> json) =>
      ReportRequestModel(
        reported: json["reported"],
        description: json["description"],
        model: json["model"],
      );

  Map<String, dynamic> toJson() => {
        "reported": reported,
        "description": description,
        "model": model,
      };
}

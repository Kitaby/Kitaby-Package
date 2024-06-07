// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:kitaby/models/Forum/Home/GetThreads/get_categories_response_model.dart';

GetThreadCategoriesRequestModel getThreadCategoriesRequestModelFromJson(
        String str) =>
    GetThreadCategoriesRequestModel.fromJson(json.decode(str));

String getThreadCategoriesRequestModelToJson(
        GetThreadCategoriesRequestModel data) =>
    json.encode(data.toJson());

class GetThreadCategoriesRequestModel {
  List<String> categories;
  List<Datum> data;

  GetThreadCategoriesRequestModel({
    required this.categories,
    required this.data,
  });

  factory GetThreadCategoriesRequestModel.fromJson(Map<String, dynamic> json) =>
      GetThreadCategoriesRequestModel(
        categories: List<String>.from(json["categories"].map((x) => x)),
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "categories": List<dynamic>.from(categories.map((x) => x)),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

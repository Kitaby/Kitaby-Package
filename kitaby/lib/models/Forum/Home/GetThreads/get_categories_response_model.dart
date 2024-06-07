// To parse this JSON data, do
//
//     final getCategoriesResponseModel = getCategoriesResponseModelFromJson(jsonString);

import 'dart:convert';

GetCategoriesResponseModel getCategoriesResponseModelFromJson(String str) =>
    GetCategoriesResponseModel.fromJson(json.decode(str));

String getCategoriesResponseModelToJson(GetCategoriesResponseModel data) =>
    json.encode(data.toJson());

class GetCategoriesResponseModel {
  String message;
  List<Catdatum>? catdata;
  List<Datum>? data;

  GetCategoriesResponseModel({
    required this.message,
    required this.catdata,
    required this.data,
  });

  factory GetCategoriesResponseModel.fromJson(Map<String, dynamic> json) =>
      GetCategoriesResponseModel(
        message: json["message"],
        catdata: List<Catdatum>.from(
            json["catdata"].map((x) => Catdatum.fromJson(x))),
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "catdata": List<dynamic>.from(catdata!.map((x) => x.toJson())),
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Catdatum {
  String categorie;
  int categorieFollows;

  Catdatum({
    required this.categorie,
    required this.categorieFollows,
  });

  factory Catdatum.fromJson(Map<String, dynamic> json) => Catdatum(
        categorie: json["categorie"],
        categorieFollows: json["categorie_follows"],
      );

  Map<String, dynamic> toJson() => {
        "categorie": categorie,
        "categorie_follows": categorieFollows,
      };
}

class Datum {
  String id;
  int mark;
  String cat;

  Datum({
    required this.id,
    required this.mark,
    required this.cat,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        mark: json["mark"],
        cat: json["cat"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "mark": mark,
        "cat": cat,
      };
}

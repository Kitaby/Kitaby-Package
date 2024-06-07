import 'dart:convert';

DeleteThreadRequestModel deleteThreadRequestModelFromJson(String str) =>
    DeleteThreadRequestModel.fromJson(json.decode(str));

String deleteThreadRequestModelToJson(DeleteThreadRequestModel data) =>
    json.encode(data.toJson());

class DeleteThreadRequestModel {
  String id;

  DeleteThreadRequestModel({
    required this.id,
  });

  factory DeleteThreadRequestModel.fromJson(Map<String, dynamic> json) =>
      DeleteThreadRequestModel(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}

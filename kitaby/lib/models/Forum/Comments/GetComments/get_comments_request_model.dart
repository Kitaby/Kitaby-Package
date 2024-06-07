import 'dart:convert';

GetCommentsRequestModel getCommentsRequestModelFromJson(String str) =>
    GetCommentsRequestModel.fromJson(json.decode(str));

String getCommentsRequestModelToJson(GetCommentsRequestModel data) =>
    json.encode(data.toJson());

class GetCommentsRequestModel {
  List<String> commentsArray;

  GetCommentsRequestModel({
    required this.commentsArray,
  });

  factory GetCommentsRequestModel.fromJson(Map<String, dynamic> json) =>
      GetCommentsRequestModel(
        commentsArray: List<String>.from(json["comments_array"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "comments_array": List<dynamic>.from(commentsArray.map((x) => x)),
      };
}

import 'dart:convert';

import 'package:kitaby/models/Forum/Home/GetThreads/get_threads_categories_response_model.dart';

GetThreadResponseModel getThreadResponseModelFromJson(String str) =>
    GetThreadResponseModel.fromJson(json.decode(str));

String getThreadResponseModelToJson(GetThreadResponseModel data) =>
    json.encode(data.toJson());

class GetThreadResponseModel {
  String message;
  DataR? thread;
  List<String>? commentsArray;

  GetThreadResponseModel({
    required this.message,
    required this.thread,
    required this.commentsArray,
  });

  factory GetThreadResponseModel.fromJson(Map<String, dynamic> json) =>
      GetThreadResponseModel(
        message: json["message"],
        thread: DataR.fromJson(json["thread"]),
        commentsArray: List<String>.from(json["comments_array"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "thread": thread!.toJson(),
        "comments_array": List<dynamic>.from(commentsArray!.map((x) => x)),
      };
}

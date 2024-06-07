// To parse this JSON data, do
//
//     final getMessagesResponseModel = getMessagesResponseModelFromJson(jsonString);

import 'dart:convert';

GetMessagesResponseModel getMessagesResponseModelFromJson(String str) =>
    GetMessagesResponseModel.fromJson(json.decode(str));

String getMessagesResponseModelToJson(GetMessagesResponseModel data) =>
    json.encode(data.toJson());

class GetMessagesResponseModel {
  List<Msg>? msgs;

  GetMessagesResponseModel({
    required this.msgs,
  });

  factory GetMessagesResponseModel.fromJson(Map<String, dynamic> json) =>
      GetMessagesResponseModel(
        msgs: List<Msg>.from(json["msgs"].map((x) => Msg.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "msgs": List<dynamic>.from(msgs!.map((x) => x.toJson())),
      };
}

class Msg {
  String id;
  String chatId;
  String text;
  String status;
  bool byMe;
  DateTime createdAt;

  Msg({
    required this.id,
    required this.chatId,
    required this.text,
    required this.status,
    required this.byMe,
    required this.createdAt,
  });

  factory Msg.fromJson(Map<String, dynamic> json) => Msg(
        id: json["_id"],
        chatId: json["chatId"],
        text: json["text"],
        status: json["status"],
        byMe: json["byMe"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "chatId": chatId,
        "text": text,
        "status": status,
        "byMe": byMe,
        "createdAt": createdAt.toIso8601String(),
      };
}

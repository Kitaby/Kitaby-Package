// To parse this JSON data, do
//
//     final sendMessageRequestModel = sendMessageRequestModelFromJson(jsonString);

import 'dart:convert';

SendMessageRequestModel sendMessageRequestModelFromJson(String str) =>
    SendMessageRequestModel.fromJson(json.decode(str));

String sendMessageRequestModelToJson(SendMessageRequestModel data) =>
    json.encode(data.toJson());

class SendMessageRequestModel {
  String chatId;
  String text;

  SendMessageRequestModel({
    required this.chatId,
    required this.text,
  });

  factory SendMessageRequestModel.fromJson(Map<String, dynamic> json) =>
      SendMessageRequestModel(
        chatId: json["chatId"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "chatId": chatId,
        "text": text,
      };
}

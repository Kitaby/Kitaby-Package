// To parse this JSON data, do
//
//     final sendMessageResponseModel = sendMessageResponseModelFromJson(jsonString);

import 'dart:convert';

SendMessageResponseModel sendMessageResponseModelFromJson(String str) => SendMessageResponseModel.fromJson(json.decode(str));

String sendMessageResponseModelToJson(SendMessageResponseModel data) => json.encode(data.toJson());

class SendMessageResponseModel {
    String chatId;
    String senderId;
    String text;
    String status;
    String id;
    DateTime createdAt;
    DateTime updatedAt;
    int v;

    SendMessageResponseModel({
        required this.chatId,
        required this.senderId,
        required this.text,
        required this.status,
        required this.id,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    factory SendMessageResponseModel.fromJson(Map<String, dynamic> json) => SendMessageResponseModel(
        chatId: json["chatId"],
        senderId: json["senderId"],
        text: json["text"],
        status: json["status"],
        id: json["_id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "chatId": chatId,
        "senderId": senderId,
        "text": text,
        "status": status,
        "_id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
    };
}

// To parse this JSON data, do
//
//     final getUserchatsResponseModel = getUserchatsResponseModelFromJson(jsonString);

import 'dart:convert';

GetUserchatsResponseModel getUserchatsResponseModelFromJson(String str) =>
    GetUserchatsResponseModel.fromJson(json.decode(str));

String getUserchatsResponseModelToJson(GetUserchatsResponseModel data) =>
    json.encode(data.toJson());

class GetUserchatsResponseModel {
  List<Chat> chats;

  GetUserchatsResponseModel({
    required this.chats,
  });

  factory GetUserchatsResponseModel.fromJson(Map<String, dynamic> json) =>
      GetUserchatsResponseModel(
        chats: List<Chat>.from(json["chats"].map((x) => Chat.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "chats": List<dynamic>.from(chats.map((x) => x.toJson())),
      };
}

class Chat {
  C c;
  Recipient recipient;
  LastMessage? lastMessage;

  Chat({
    required this.c,
    required this.recipient,
    this.lastMessage,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        c: C.fromJson(json["c"]),
        recipient: Recipient.fromJson(json["recipient"]),
        lastMessage: json["lastMessage"] == null
            ? null
            : LastMessage.fromJson(json["lastMessage"]),
      );

  Map<String, dynamic> toJson() => {
        "c": c.toJson(),
        "recipient": recipient.toJson(),
        "lastMessage": lastMessage?.toJson(),
      };
}

class C {
  String id;
  List<String> members;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  C({
    required this.id,
    required this.members,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory C.fromJson(Map<String, dynamic> json) => C(
        id: json["_id"],
        members: List<String>.from(json["members"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "members": List<dynamic>.from(members.map((x) => x)),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}

class LastMessage {
  String id;
  String senderId;
  String text;
  DateTime createdAt;

  LastMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.createdAt,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) => LastMessage(
        id: json["_id"],
        senderId: json["senderId"],
        text: json["text"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "senderId": senderId,
        "text": text,
        "createdAt": createdAt.toIso8601String(),
      };
}

class Recipient {
  String id;
  String name;
  String photo;

  Recipient({
    required this.id,
    required this.name,
    required this.photo,
  });

  factory Recipient.fromJson(Map<String, dynamic> json) => Recipient(
        id: json["_id"],
        name: json["name"],
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "photo": photo,
      };
}

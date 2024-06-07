import 'dart:convert';

GetThreadCategoriesResponseModel getThreadCategoriesResponseModelFromJson(
        String str) =>
    GetThreadCategoriesResponseModel.fromJson(json.decode(str));

String getThreadCategoriesResponseModelToJson(
        GetThreadCategoriesResponseModel data) =>
    json.encode(data.toJson());

class GetThreadCategoriesResponseModel {
  String message;
  List<DataR>? data;

  GetThreadCategoriesResponseModel({
    required this.message,
    required this.data,
  });

  factory GetThreadCategoriesResponseModel.fromJson(
          Map<String, dynamic> json) =>
      GetThreadCategoriesResponseModel(
        message: json["message"],
        data: List<DataR>.from(json["data"].map((x) => DataR.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DataR {
  String id;
  int shares;
  bool isAuthor;
  bool alreadyLiked;
  int upvotes;
  int numreplies;
  String authorName;
  String authorPhoto;
  String content;
  String title;
  DateTime createdAt;
  String replyTo;
  int mark;

  DataR({
    required this.id,
    required this.shares,
    required this.isAuthor,
    required this.alreadyLiked,
    required this.upvotes,
    required this.numreplies,
    required this.authorName,
    required this.authorPhoto,
    required this.content,
    required this.title,
    required this.createdAt,
    required this.replyTo,
    required this.mark,
  });

  factory DataR.fromJson(Map<String, dynamic> json) => DataR(
        id: json["id"],
        shares: json["shares"],
        isAuthor: json["is_author"],
        alreadyLiked: json["already_liked"],
        upvotes: json["upvotes"],
        numreplies: json["numreplies"],
        authorName: json["author_name"],
        authorPhoto: json["author_photo"],
        content: json["content"],
        title: json["title"],
        createdAt: DateTime.parse(json["created_at"]),
        replyTo: json["reply_to"],
        mark: json["mark"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "shares": shares,
        "is_author": isAuthor,
        "already_liked": alreadyLiked,
        "upvotes": upvotes,
        "numreplies": numreplies,
        "author_name": authorName,
        "author_photo": authorPhoto,
        "content": content,
        "title": title,
        "created_at": createdAt.toIso8601String(),
        "reply_to": replyTo,
        "mark": mark,
      };
}

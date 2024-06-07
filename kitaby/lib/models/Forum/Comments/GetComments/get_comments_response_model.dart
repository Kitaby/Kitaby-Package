import 'dart:convert';

GetCommentsResponseModel getCommentsResponseModelFromJson(String str) =>
    GetCommentsResponseModel.fromJson(json.decode(str));

String getCommentsResponseModelToJson(GetCommentsResponseModel data) =>
    json.encode(data.toJson());

class GetCommentsResponseModel {
  String message;
  List<Comment> comments;

  GetCommentsResponseModel({
    required this.message,
    required this.comments,
  });

  factory GetCommentsResponseModel.fromJson(Map<String, dynamic> json) =>
      GetCommentsResponseModel(
        message: json["message"],
        comments: List<Comment>.from(
            json["comments"].map((x) => Comment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
      };
}

class Comment {
  String id;
  bool isAuthor;
  bool alreadyLiked;
  int upvotes;
  int numreplies;
  String authorName;
  String authorPhoto;
  String content;
  DateTime createdAt;
  int shares;
  String replyTo;
  List<Somereply> somereplies;

  Comment({
    required this.id,
    required this.isAuthor,
    required this.alreadyLiked,
    required this.upvotes,
    required this.numreplies,
    required this.authorName,
    required this.authorPhoto,
    required this.content,
    required this.createdAt,
    required this.shares,
    required this.replyTo,
    required this.somereplies,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        isAuthor: json["is_author"],
        alreadyLiked: json["already_liked"],
        upvotes: json["upvotes"],
        numreplies: json["numreplies"],
        authorName: json["author_name"],
        authorPhoto: json["author_photo"],
        content: json["content"],
        createdAt: DateTime.parse(json["created_at"]),
        shares: json["shares"],
        replyTo: json["reply_to"],
        somereplies: List<Somereply>.from(
            json["somereplies"].map((x) => Somereply.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_author": isAuthor,
        "already_liked": alreadyLiked,
        "upvotes": upvotes,
        "numreplies": numreplies,
        "author_name": authorName,
        "author_photo": authorPhoto,
        "content": content,
        "created_at": createdAt.toIso8601String(),
        "shares": shares,
        "reply_to": replyTo,
        "somereplies": List<dynamic>.from(somereplies.map((x) => x.toJson())),
      };
}

class Somereply {
  String id;
  bool isAuthor;
  bool alreadyLiked;
  int upvotes;
  String authorName;
  String authorPhoto;
  String content;
  DateTime createdAt;
  ReplyTo replyTo;

  Somereply({
    required this.id,
    required this.isAuthor,
    required this.alreadyLiked,
    required this.upvotes,
    required this.authorName,
    required this.authorPhoto,
    required this.content,
    required this.createdAt,
    required this.replyTo,
  });

  factory Somereply.fromJson(Map<String, dynamic> json) => Somereply(
        id: json["id"],
        isAuthor: json["is_author"],
        alreadyLiked: json["already_liked"],
        upvotes: json["upvotes"],
        authorName: json["author_name"],
        authorPhoto: json["author_photo"],
        content: json["content"],
        createdAt: DateTime.parse(json["created_at"]),
        replyTo: ReplyTo.fromJson(json["reply_to"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_author": isAuthor,
        "already_liked": alreadyLiked,
        "upvotes": upvotes,
        "author_name": authorName,
        "author_photo": authorPhoto,
        "content": content,
        "created_at": createdAt.toIso8601String(),
        "reply_to": replyTo.toJson(),
      };
}

class ReplyTo {
  String id;
  String kind;
  String username;

  ReplyTo({
    required this.id,
    required this.kind,
    required this.username,
  });

  factory ReplyTo.fromJson(Map<String, dynamic> json) => ReplyTo(
        id: json["id"],
        kind: json["kind"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kind": kind,
        "username": username,
      };
}

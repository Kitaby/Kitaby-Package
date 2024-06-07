import 'dart:convert';

LikeThreadRequestModel likeThreadRequestModelFromJson(String str) => LikeThreadRequestModel.fromJson(json.decode(str));

String likeThreadRequestModelToJson(LikeThreadRequestModel data) => json.encode(data.toJson());

class LikeThreadRequestModel {
    String id;

    LikeThreadRequestModel({
        required this.id,
    });

    factory LikeThreadRequestModel.fromJson(Map<String, dynamic> json) => LikeThreadRequestModel(
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
    };
}
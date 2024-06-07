// To parse this JSON data, do
//
//     final getsentoffersResponseModel = getsentoffersResponseModelFromJson(jsonString);

import 'dart:convert';

GetsentoffersResponseModel getsentoffersResponseModelFromJson(String str) =>
    GetsentoffersResponseModel.fromJson(json.decode(str));

String getsentoffersResponseModelToJson(GetsentoffersResponseModel data) =>
    json.encode(data.toJson());

class GetsentoffersResponseModel {
  List<OfferElement> offers;

  GetsentoffersResponseModel({
    required this.offers,
  });

  factory GetsentoffersResponseModel.fromJson(Map<String, dynamic> json) =>
      GetsentoffersResponseModel(
        offers: List<OfferElement>.from(
            json["offers"].map((x) => OfferElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "offers": List<dynamic>.from(offers.map((x) => x.toJson())),
      };
}

class OfferElement {
  OfferOffer offer;
  List<EdBook> proposedBooks;
  EdBook demandedBook;
  Owner owner;
  String buyer;
  String wilaya;

  OfferElement({
    required this.offer,
    required this.proposedBooks,
    required this.demandedBook,
    required this.owner,
    required this.buyer,
    required this.wilaya,
  });

  factory OfferElement.fromJson(Map<String, dynamic> json) => OfferElement(
        offer: OfferOffer.fromJson(json["offer"]),
        proposedBooks: List<EdBook>.from(
            json["proposedBooks"].map((x) => EdBook.fromJson(x))),
        demandedBook: EdBook.fromJson(json["demandedBook"]),
        owner: Owner.fromJson(json["owner"]),
        buyer: json["buyer"],
        wilaya: json["wilaya"],
      );

  Map<String, dynamic> toJson() => {
        "offer": offer.toJson(),
        "proposedBooks":
            List<dynamic>.from(proposedBooks.map((x) => x.toJson())),
        "demandedBook": demandedBook.toJson(),
        "owner": owner.toJson(),
        "buyer": buyer,
        "wilaya": wilaya,
      };
}

class EdBook {
  String id;
  String isbn;
  String title;
  String image;
  String author;
  String description;
  List<String> categories;
  List<dynamic> bibOwners;
  List<String> owners;
  List<dynamic> reviews;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  EdBook({
    required this.id,
    required this.isbn,
    required this.title,
    required this.image,
    required this.author,
    required this.description,
    required this.categories,
    required this.bibOwners,
    required this.owners,
    required this.reviews,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory EdBook.fromJson(Map<String, dynamic> json) => EdBook(
        id: json["_id"],
        isbn: json["isbn"],
        title: json["title"],
        image: json["image"],
        author: json["author"],
        description: json["description"],
        categories: List<String>.from(json["categories"].map((x) => x)),
        bibOwners: List<dynamic>.from(json["bibOwners"].map((x) => x)),
        owners: List<String>.from(json["owners"].map((x) => x)),
        reviews: List<dynamic>.from(json["reviews"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "isbn": isbn,
        "title": title,
        "image": image,
        "author": author,
        "description": description,
        "categories": List<dynamic>.from(categories.map((x) => x)),
        "bibOwners": List<dynamic>.from(bibOwners.map((x) => x)),
        "owners": List<dynamic>.from(owners.map((x) => x)),
        "reviews": List<dynamic>.from(reviews.map((x) => x)),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}

class OfferOffer {
  String id;
  String bookOwner;
  String bookBuyer;
  String demandedBook;
  List<String> proposedBooks;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  OfferOffer({
    required this.id,
    required this.bookOwner,
    required this.bookBuyer,
    required this.demandedBook,
    required this.proposedBooks,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory OfferOffer.fromJson(Map<String, dynamic> json) => OfferOffer(
        id: json["_id"],
        bookOwner: json["bookOwner"],
        bookBuyer: json["bookBuyer"],
        demandedBook: json["demandedBook"],
        proposedBooks: List<String>.from(json["proposedBooks"].map((x) => x)),
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "bookOwner": bookOwner,
        "bookBuyer": bookBuyer,
        "demandedBook": demandedBook,
        "proposedBooks": List<dynamic>.from(proposedBooks.map((x) => x)),
        "status": status,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}

class Owner {
  String id;
  String name;

  Owner({
    required this.id,
    required this.name,
  });

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}

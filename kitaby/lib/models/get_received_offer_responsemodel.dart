import 'dart:convert';

ReceivedOffersResponseModel receivedOffersResponseModelFromJson(String str) => ReceivedOffersResponseModel.fromJson(json.decode(str));

String receivedOffersResponseModelToJson(ReceivedOffersResponseModel data) => json.encode(data.toJson());

class ReceivedOffersResponseModel {
    List<OfferElement> offers;

    ReceivedOffersResponseModel({
        required this.offers,
    });

    factory ReceivedOffersResponseModel.fromJson(Map<String, dynamic> json) => ReceivedOffersResponseModel(
        offers: List<OfferElement>.from(json["offers"].map((x) => OfferElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "offers": List<dynamic>.from(offers.map((x) => x.toJson())),
    };
}

class OfferElement {
    OfferOffer offer;
    EdBook demandedBook;
    List<EdBook> proposedBooks;
    String buyer;

    OfferElement({
        required this.offer,
        required this.demandedBook,
        required this.proposedBooks,
        required this.buyer,
    });

    factory OfferElement.fromJson(Map<String, dynamic> json) => OfferElement(
        offer: OfferOffer.fromJson(json["offer"]),
        demandedBook: EdBook.fromJson(json["demandedBook"]),
        proposedBooks: List<EdBook>.from(json["proposedBooks"].map((x) => EdBook.fromJson(x))),
        buyer: json["buyer"],
    );

    Map<String, dynamic> toJson() => {
        "offer": offer.toJson(),
        "demandedBook": demandedBook.toJson(),
        "proposedBooks": List<dynamic>.from(proposedBooks.map((x) => x.toJson())),
        "buyer": buyer,
    };
}

class EdBook {
    String id;
    String isbn;
    String title;
    String image;
    String author;
    List<String> categories;
    List<String> owners;
    int v;

    EdBook({
        required this.id,
        required this.isbn,
        required this.title,
        required this.image,
        required this.author,
        required this.categories,
        required this.owners,
        required this.v,
    });

    factory EdBook.fromJson(Map<String, dynamic> json) => EdBook(
        id: json["_id"],
        isbn: json["isbn"],
        title: json["title"],
        image: json["image"],
        author: json["author"],
        categories: List<String>.from(json["categories"].map((x) => x)),
        owners: List<String>.from(json["owners"].map((x) => x)),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "isbn": isbn,
        "title": title,
        "image": image,
        "author": author,
        "categories": List<dynamic>.from(categories.map((x) => x)),
        "owners": List<dynamic>.from(owners.map((x) => x)),
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
    int v;

    OfferOffer({
        required this.id,
        required this.bookOwner,
        required this.bookBuyer,
        required this.demandedBook,
        required this.proposedBooks,
        required this.status,
        required this.v,
    });

    factory OfferOffer.fromJson(Map<String, dynamic> json) => OfferOffer(
        id: json["_id"],
        bookOwner: json["bookOwner"],
        bookBuyer: json["bookBuyer"],
        demandedBook: json["demandedBook"],
        proposedBooks: List<String>.from(json["proposedBooks"].map((x) => x)),
        status: json["status"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "bookOwner": bookOwner,
        "bookBuyer": bookBuyer,
        "demandedBook": demandedBook,
        "proposedBooks": List<dynamic>.from(proposedBooks.map((x) => x)),
        "status": status,
        "__v": v,
    };
}

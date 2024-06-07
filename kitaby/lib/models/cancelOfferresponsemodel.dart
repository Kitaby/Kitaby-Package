// To parse this JSON data, do
//
//     final cancelOfferresponsemodel = cancelOfferresponsemodelFromJson(jsonString);

import 'dart:convert';

CancelOfferresponsemodel cancelOfferresponsemodelFromJson(String str) => CancelOfferresponsemodel.fromJson(json.decode(str));

String cancelOfferresponsemodelToJson(CancelOfferresponsemodel data) => json.encode(data.toJson());

class CancelOfferresponsemodel {
    String offerId;

    CancelOfferresponsemodel({
        required this.offerId,
    });

    factory CancelOfferresponsemodel.fromJson(Map<String, dynamic> json) => CancelOfferresponsemodel(
        offerId: json["offerId"],
    );

    Map<String, dynamic> toJson() => {
        "offerId": offerId,
    };
}

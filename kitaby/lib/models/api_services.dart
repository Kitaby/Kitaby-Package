// ignore_for_file: prefer_interpolation_to_compose_strings, non_constant_identifier_names, depend_on_referenced_packages

import 'package:kitaby/models/Exchnage/Chat/Messages/SendMessages/updateMessage_response_model.dart';
import 'package:kitaby/models/Recommendation/getRating_response_model.dart';
import 'package:kitaby/models/Recommendation/isBookAvailable_response_model.dart';
import 'package:kitaby/models/Recommendation/recent.dart';
import 'package:kitaby/models/profile/change_profile_request_model.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:kitaby/models/Authentification/ForgotPassword/forgot_password_response_model.dart';
import 'package:kitaby/models/Authentification/Login/login_response_model.dart';
import 'package:kitaby/models/Authentification/Register/send_otp_response_model.dart';
import 'package:kitaby/models/Exchnage/Chat/Messages/SendMessages/send_message_request_model.dart';
import 'package:kitaby/models/Exchnage/Chat/Messages/SendMessages/send_message_rsponse_model.dart';
import 'package:kitaby/models/Exchnage/Chat/Messages/get_messages_response_model.dart';
import 'package:kitaby/models/Exchnage/Chat/get_user_chats_response_model.dart';
import 'package:kitaby/models/Forum/Comments/GetComments/get_comments_request_model.dart';
import 'package:kitaby/models/Forum/Comments/GetComments/get_comments_response_model.dart';
import 'package:kitaby/models/Forum/Comments/GetComments/get_thread_reponse_model.dart';
import 'package:kitaby/models/Forum/Comments/PostComment/post_comment_request_model.dart';
import 'package:kitaby/models/Forum/Comments/PostComment/post_comment_response_model.dart';
import 'package:kitaby/models/Forum/Comments/PostReplys/post_reply_request_model.dart';
import 'package:kitaby/models/Forum/Comments/PostReplys/post_reply_response_model.dart';
import 'package:kitaby/models/Forum/Comments/seeMore/see_more_response_model.dart';
import 'package:kitaby/models/Forum/Home/GetThreads/get_categories_response_model.dart';
import 'package:kitaby/models/Forum/Home/GetThreads/get_threads_categories_request_model.dart';
import 'package:kitaby/models/Forum/Home/GetThreads/get_threads_categories_response_model.dart';
import 'package:kitaby/models/Forum/Home/LikeThread/like_thread_request_model.dart';
import 'package:kitaby/models/Forum/Home/LikeThread/like_thread_response_model.dart';
import 'package:kitaby/models/Forum/Home/PostThread/post_thread_request.dart';
import 'package:kitaby/models/Forum/Home/PostThread/post_thread_response_model.dart';
import 'package:kitaby/models/Forum/Home/ReportThread/report_request_model.dart';
import 'package:kitaby/models/Forum/Home/deleteThread/delete_thread_request_model.dart';
import 'package:kitaby/models/Get_all_books_responsemodel.dart';
import 'package:kitaby/models/PostOfferrequestModel.dart';
import 'package:kitaby/models/Recommendation/addRating_request_model.dart';
import 'package:kitaby/models/Recommendation/addRating_response_model.dart';
import 'package:kitaby/models/Recommendation/getBook_response_model.dart';
import 'package:kitaby/models/Recommendation/getRatings_response_model.dart';
import 'package:kitaby/models/Recommendation/isBookOwned_response_model.dart';
import 'package:kitaby/models/Recommendation/recommendation_response_model.dart';
import 'package:kitaby/models/Reservation/cancelReservation_response_model.dart';
import 'package:kitaby/models/Reservation/cancelRservation_request_model.dart';
import 'package:kitaby/models/Reservation/getLibsBooks_response_model.dart';
import 'package:kitaby/models/Reservation/getReservations_response_model.dart';
import 'package:kitaby/models/Reservation/renewRequest_response_model.dart';
import 'package:kitaby/models/Reservation/request_book_request_model.dart';
import 'package:kitaby/models/acceptofferrequestModel.dart';
import 'package:kitaby/models/cancelOfferresponsemodel.dart';
import 'package:kitaby/models/config.dart';
import 'package:kitaby/models/getBooksresponsemodel.dart';
import 'package:kitaby/models/get_collection_responsemodel.dart';
import 'package:kitaby/models/get_received_offer_responsemodel.dart';
import 'package:kitaby/models/Authentification/Register/phone_otp_request_model.dart';
import 'package:kitaby/models/Authentification/Register/phone_verify_otp_request_model.dart';
import 'package:kitaby/models/Authentification/Register/register_request_model.dart';
import 'package:kitaby/models/Authentification/ForgotPassword/resset_password_request_model.dart';
import 'package:kitaby/models/profile/changepp_response_model.dart';
import 'package:kitaby/models/get_sentoffersmodel.dart';
import 'package:kitaby/models/profile/get_post_response_model.dart';
import 'package:kitaby/models/profile/get_profile_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'PostBookInCollection_request_model.dart';

import 'Authentification/ForgotPassword/forgot_password_request_model.dart';
import 'Authentification/Login/login_request_model.dart';

class APISERVICES {
  var client = http.Client();
  Map<String, String> customHeaders = {"content-type": "application/json"};
  //auth apis
  Future<LoginResponseModel> login(LoginRequestModel object) async {
    var url = Uri.parse(config.apiURL + config.loginURL);
    String codedobject = loginRequestModelToJson(object);
    var response =
        await client.post(url, headers: customHeaders, body: codedobject);
    print(response.body);
    LoginResponseModel responsebody = loginResponseModelFromJson(response.body);
    if (response.statusCode == 200) {
      setToken(responsebody.token!);
    }
    return responsebody;
  }

  Future<ForgotRessetpasswordResponseModel> signup(
      RegisterRequestModel object) async {
    var url = Uri.parse(config.apiURL + config.signUpURL);
    String codedobject = registerRequestModelToJson(object);
    print(codedobject);
    print(url);
    var response =
        await client.post(url, headers: customHeaders, body: codedobject);
    ForgotRessetpasswordResponseModel responsebody =
        forgotRessetpasswordResponseModelFromJson(response.body);
    return responsebody;
  }

  Future<SendOtpResponseModel> sendotp(PhoneOtpRequestModel object) async {
    var url = Uri.parse(config.apiURL + config.PhoneOTP);
    String codedobject = phoneOtpRequestModelToJson(object);
    var response =
        await client.post(url, headers: customHeaders, body: codedobject);
    SendOtpResponseModel responsebody =
        sendOtpResponseModelFromJson(response.body);
    return responsebody;
  }

  Future<ForgotRessetpasswordResponseModel> verifyotp(
      PhoneVerifyOtpRequestModel object) async {
    var url = Uri.parse(config.apiURL + config.VerifyOTP);
    String codedobject = phoneVerifyOtpRequestModelToJson(object);
    var response =
        await client.post(url, headers: customHeaders, body: codedobject);
    ForgotRessetpasswordResponseModel responsebody =
        forgotRessetpasswordResponseModelFromJson(response.body);
    return responsebody;
  }

  Future<ForgotRessetpasswordResponseModel> forgetPassword(
      ForgotPasswordRequestModel object) async {
    var url = Uri.parse(config.apiURL + config.ForgotPassword);
    String codedobject = forgotPasswordRequestModelToJson(object);
    var response =
        await client.post(url, headers: customHeaders, body: codedobject);
    ForgotRessetpasswordResponseModel responsebody =
        forgotRessetpasswordResponseModelFromJson(response.body);
    return responsebody;
  }

  Future<ForgotRessetpasswordResponseModel> ressetPassword(
      RessetPasswordRequestModel object) async {
    var url = Uri.parse(config.apiURL + config.RessetPassword);
    String codedobject = ressetPasswordRequestModelToJson(object);
    var response =
        await client.post(url, headers: customHeaders, body: codedobject);
    ForgotRessetpasswordResponseModel responsebody =
        forgotRessetpasswordResponseModelFromJson(response.body);
    return responsebody;
  }

  //homepage api
  Future<Getcollectionresponsemodel> getCollection(int page) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.GetCollection + "?page=$page");
    var response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    Getcollectionresponsemodel responsebody =
        getcollectionresponsemodelFromJson(response.body);
    return responsebody;
  }

  Future<RecommendationResponseModel> getRecommendation(int page) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.recommendation + "?i=$page");
    var response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    RecommendationResponseModel responsebody =
        recommendationResponseModelFromJson(response.body);
    return responsebody;
  }

  Future<GetbookResponseModel> getBookInfo(String isbn) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.getbook + "/$isbn");
    var response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    GetbookResponseModel responsebody =
        getbookResponseModelFromJson(response.body);
    return responsebody;
  }

  Future<IsBookOwnedResponseModel> isBookOwned(String isbn) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.isBookOwned + "/$isbn");
    var response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    IsBookOwnedResponseModel responsebody =
        isBookOwnedResponseModelFromJson(response.body);
    print(response.body);
    return responsebody;
  }

  Future<IsBookAvailableResponseModel> isBookAvailable(String isbn) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.isBookAvailable + "/$isbn");
    var response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    IsBookAvailableResponseModel responsebody =
        isBookAvailableResponseModelFromJson(response.body);
    return responsebody;
  }

  Future<GetRatingResponseModel> getRating(String isbn) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.getRating + "/$isbn");
    var response = await client.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    GetRatingResponseModel responsebody =
        getRatingResponseModelFromJson(response.body);
    return responsebody;
  }

  Future<RecentResponseModel> getRecent() async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.getRecent);
    print(url);
    var response = await client.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    RecentResponseModel responsebody =
        recentResponseModelFromJson(response.body);
    return responsebody;
  }

  Future<GetRatingsResponseModel> getRatings(String isbn, int page) async {
    String? token = await getToken();
    var url =
        Uri.parse(config.apiURL + config.getRatings + "/$isbn?page=$page");
    var response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    GetRatingsResponseModel responsebody =
        getRatingsResponseModelFromJson(response.body);
    return responsebody;
  }

  Future<AddRatingResponseModel> addRating(AddRatingRequestModel object) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.addRating);
    String codedobject = addRatingRequestModelToJson(object);
    var response = await client.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: codedobject);
    AddRatingResponseModel responsebody =
        addRatingResponseModelFromJson(response.body);
    return responsebody;
  }

  Future<Getcollectionresponsemodel> getWishlist(int page) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.GetWishList + "?page=$page");
    var response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    Getcollectionresponsemodel responsebody =
        getcollectionresponsemodelFromJson(response.body);
    return responsebody;
  }

//Reservation APIS
  Future<GetLibsBooksResponseModel> getLibsBooks(String name,
      List<String> Categories, List<String> willaya, int page) async {
    String categories = "";
    String wilaya = "";
    String names = "";
    if (name.isNotEmpty) {
      names = "&name=$name";
    }
    for (String cat in Categories) {
      categories += "&categorie=$cat";
    }
    for (String wi in willaya) {
      wilaya += "&wilaya=$wi";
    }
    String? token = await getToken();
    var url = Uri.parse(config.apiURL +
        config.getLibsBooks +
        "?page=$page&limit=8" +
        names +
        categories +
        wilaya);
    var response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    GetLibsBooksResponseModel responsebody =
        getLibsBooksResponseModelFromJson(response.body);
    return responsebody;
  }

  Future<CancelReservationResponseModel> requestBook(
      RequestbookRequestModel object) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.requestBook);
    String codedobject = requestbookRequestModelToJson(object);
    var response = await client.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: codedobject);
    CancelReservationResponseModel responsebody =
        cancelReservationResponseModelFromJson(response.body);
    return responsebody;
  }

  Future<GetReservationsResponseModel> getReservations(int page) async {
    String? token = await getToken();
    var url = Uri.parse(
        config.apiURL + config.getReservations + "?page=$page&limit=8");
    var response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    GetReservationsResponseModel responsebody =
        getReservationsResponseModelFromJson(response.body);
    return responsebody;
  }

  Future<CancelReservationResponseModel> cancelReservation(
      CancelReservationRequestModel object) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.cancelReservation);
    String codedobject = cancelReservationRequestModelToJson(object);
    var response = await client.put(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: codedobject);
    CancelReservationResponseModel responsebody =
        cancelReservationResponseModelFromJson(response.body);
    return responsebody;
  }

  Future<CancelReservationResponseModel> ReturnBook(
      CancelReservationRequestModel object) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.endReservation);
    String codedobject = cancelReservationRequestModelToJson(object);
    var response = await client.put(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: codedobject);
    CancelReservationResponseModel responsebody =
        cancelReservationResponseModelFromJson(response.body);
    return responsebody;
  }

  Future<RenewRequestResponseModel> renewRequest(
      CancelReservationRequestModel object) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.renewRequest);
    String codedobject = cancelReservationRequestModelToJson(object);
    var response = await client.put(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: codedobject);
    RenewRequestResponseModel responsebody =
        renewRequestResponseModelFromJson(response.body);
    return responsebody;
  }

  //profile api
  Future<dynamic> PostBookInCollectionAPI(String isbn) async {
    String? token = await getToken();
    print(token);
    PostBookInCollection object = PostBookInCollection(isbn: isbn);
    var url = Uri.parse(config.apiURL + config.PostBookInCollection);
    print(url);
    var codedobject = postBookInCollectionToJson(object);
    var response = await client.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', //benhammadi lokmane
        },
        body: codedobject);
    return response.body;
  }

  Future<dynamic> PostBookInWishlist(String isbn) async {
    String? token = await getToken();
    PostBookInCollection object = PostBookInCollection(isbn: isbn);
    var url = Uri.parse(config.apiURL + config.PostBookInWishlist);
    var codedobject = postBookInCollectionToJson(object);
    var response = await client.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', //benhammadi lokmane
        },
        body: codedobject);
    return response.body;
  }

  Future<GetProfileResponseModel> getProfile() async {
    String? token = await getToken();
    print(token);
    var url = Uri.parse(config.apiURL + config.get_profile);
    print(url);
    var response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    GetProfileResponseModel responsebody =
        getProfileResponseModelFromJson(response.body);
    return responsebody;
  }

  Future<ChangeppResponseModel> changepp(File image) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.changepp);
    var stream =
        // ignore: deprecated_member_use
        http.ByteStream(DelegatingStream.typed(image.openRead()));
    // get file length
    var length = await image.length();

    // string to uri

    // create multipart request
    var request = http.MultipartRequest("POST", url);
    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    // multipart that takes file
    var multipartFile = http.MultipartFile('image', stream, length,
        filename: basename(image.path),
        contentType: MediaType('image', 'jpeg'));

    // add file to multipart
    request.files.add(multipartFile);

    // send
    var response = await request.send();
    var responsebody = await http.Response.fromStream(response);
    ChangeppResponseModel responseModel =
        changeppResponseModelFromJson(responsebody.body);
    // listen for response
    return responseModel;
  }

  Future<ChangeppResponseModel> changeProfile(
      ChangeprofileRequestModel object) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.changeprofile);
    String codedobject = changeprofileRequestModelToJson(object);
    var response = await client.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: codedobject);
    ChangeppResponseModel responsebody =
        changeppResponseModelFromJson(response.body);
    return responsebody;
  }

  //offers api

  Future<dynamic> acceptoffer(String id, String isbn) async {
    String? token = await getToken();
    AcceptofferrequestModel object =
        AcceptofferrequestModel(offerId: id, acceptedBookIsbn: isbn);
    var url = Uri.parse(config.apiURL + config.acceptoffer);
    var codedobject = acceptofferrequestModelToJson(object);
    var response = await client.patch(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', //benhammadi lokmane
        },
        body: codedobject);
    return response.body;
  }

  Future<dynamic> canceloffer(String id) async {
    String? token = await getToken();
    CancelOfferresponsemodel object = CancelOfferresponsemodel(offerId: id);
    var url = Uri.parse(config.apiURL + config.canceloffer);
    var codedobject = cancelOfferresponsemodelToJson(object);
    var response = await client.patch(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', //benhammadi lokmane
        },
        body: codedobject);
    return response.body;
  }

  Future<dynamic> rejectoffer(String id) async {
    String? token = await getToken();
    CancelOfferresponsemodel object = CancelOfferresponsemodel(offerId: id);
    var url = Uri.parse(config.apiURL + config.rejectOffer);
    var codedobject = cancelOfferresponsemodelToJson(object);
    var response = await client.patch(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', //benhammadi lokmane
        },
        body: codedobject);
    return response.body;
  }

  Future<dynamic> PostOffer(
      List<String> proposedBooks, String demandedBook, String Bookowner) async {
    String? token = await getToken();
    PostOfferrequestModel object = PostOfferrequestModel(
        bookOwner: Bookowner,
        demandedBook: demandedBook,
        proposedBooks: proposedBooks);
    var url = Uri.parse(config.apiURL + config.postoffer);
    var codedobject = postOfferrequestModelToJson(object);
    var response = await client.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', //benhammadi lokmane
        },
        body: codedobject);
    return response.body;
  }

  Future<Getallbooksresponse> getallbooks(String page) async {
    var url =
        Uri.parse(config.apiURL + config.getallbooks + "?page=$page&limit=8");
    var response = await client.get(url);
    Getallbooksresponse responsebody =
        getallbooksresponseFromJson(response.body);
    return responsebody;
  }

  //getreceivedoffers
  Future<ReceivedOffersResponseModel?> getreceivedoffers(int page) async {
    String? token = await getToken();
    var url = Uri.parse(
        config.apiURL + config.getreceivedoffers + "?page=$page&limit=8");
    var response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token', //benhammadi lokmane
      },
    );
    ReceivedOffersResponseModel responsebody =
        receivedOffersResponseModelFromJson(response.body);
    if (response.statusCode == 200) {
      return responsebody;
    } else {
      return null;
    }
  }

  Future<GetsentoffersResponseModel?> getsentoffers(int page) async {
    String? token = await getToken();
    print(token);
    var url =
        Uri.parse(config.apiURL + config.getsentoffers + "?page=$page&limit=8");
    print(url);
    var response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token', //benhammadi lokmane
      },
    );
    GetsentoffersResponseModel responsebody =
        getsentoffersResponseModelFromJson(response.body);
    if (response.statusCode == 200) {
      return responsebody;
    } else {
      return null;
    }
  }

  Future<GetBooksresponsemodel> getBooks(String name, List<String> Categories,
      List<String> willaya, int page) async {
    String categories = "";
    String wilaya = "";
    String names = "";
    if (name.isNotEmpty) {
      names = "&name=$name";
    }
    for (String cat in Categories) {
      categories += "&categories=$cat";
    }
    for (String wi in willaya) {
      wilaya += "&wilaya=$wi";
    }
    String? token = await getToken();
    var url = Uri.parse(config.apiURL +
        config.getbooks +
        "?page=$page&limit=8" +
        names +
        categories +
        wilaya);
    print(url);
    var response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token', //benhammadi lokmane
      },
    );
    GetBooksresponsemodel responsebody =
        getBooksresponsemodelFromJson(response.body);
    return responsebody;
  }

  //Chat
  Future<GetUserchatsResponseModel> getUserChat(String name) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.createchat + "?name=$name");
    var response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    GetUserchatsResponseModel responsebody =
        getUserchatsResponseModelFromJson(response.body);
    return responsebody;
  }

  Future<GetMessagesResponseModel> getMessages(String Chatid) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.getmessages + Chatid);
    var response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    GetMessagesResponseModel responsebody =
        getMessagesResponseModelFromJson(response.body);
    return responsebody;
  }

  Future<SendMessageResponseModel> sendMessage(
      SendMessageRequestModel Message) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.getmessages);
    print(url);
    String codedobject = sendMessageRequestModelToJson(Message);
    print(codedobject);
    var response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: codedobject,
    );
    SendMessageResponseModel responsebody =
        sendMessageResponseModelFromJson(response.body);
    return responsebody;
  }

  Future<UpdateMessageResponseModel> updateMessage(String messageid) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.getmessages + messageid);
    var response = await client.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    UpdateMessageResponseModel responsebody =
        updateMessageResponseModelFromJson(response.body);
    return responsebody;
  }
  //forum

  Future<GetCategoriesResponseModel> getcategories() async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.getcategories);
    var response = await client.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    GetCategoriesResponseModel responsebody =
        getCategoriesResponseModelFromJson(response.body);
    return responsebody;
  }

  Future<GetThreadCategoriesResponseModel> getThreads(
      GetThreadCategoriesRequestModel object, int page) async {
    String? token = await getToken();
    var url =
        Uri.parse(config.apiURL + config.getthreadsofcategories + "?i=$page");
    String codedobject = getThreadCategoriesRequestModelToJson(object);
    var response = await client.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: codedobject);
    GetThreadCategoriesResponseModel responsebody =
        getThreadCategoriesResponseModelFromJson(response.body);
    return responsebody;
  }

  Future<GetPostResponseModel> getPost() async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.get_post);
    var response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    GetPostResponseModel responsebody =
        getPostResponseModelFromJson(response.body);
    return responsebody;
  }

  Future<PostThreadResponseModel> postThread(
      PostThreadRequestModel object) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.postThread);
    String codedobject = postThreadRequestModelToJson(object);
    var response = await client.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: codedobject);
    PostThreadResponseModel responsebody =
        postThreadResponseModelFromJson(response.body);
    return responsebody;
  }

  Future<LikeThreadResponseModel> likeThread(
      LikeThreadRequestModel object) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.likeThread);
    String codedobject = likeThreadRequestModelToJson(object);
    var response = await client.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: codedobject);
    LikeThreadResponseModel responsebody =
        likeThreadResponseModelFromJson(response.body);
    return responsebody;
  }

  Future<LikeThreadResponseModel> shareThread(String id) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.shareThread + "?id=$id");
    var response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    LikeThreadResponseModel responsebody =
        likeThreadResponseModelFromJson(response.body);
    return responsebody;
  }

  Future<LikeThreadResponseModel> reportThread(
      ReportRequestModel object) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.reportThread);
    String codedobject = reportRequestModelToJson(object);
    var response = await client.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: codedobject);
    LikeThreadResponseModel responsebody =
        likeThreadResponseModelFromJson(response.body);
    return responsebody;
  }

  Future<LikeThreadResponseModel> deleteThread(
      DeleteThreadRequestModel object) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.deleteThread);
    String codedobject = deleteThreadRequestModelToJson(object);
    var response = await client.delete(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: codedobject);
    LikeThreadResponseModel responsebody =
        likeThreadResponseModelFromJson(response.body);
    return responsebody;
  }

  Future<GetThreadResponseModel> getThread(String? id) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.getthread + "?id=$id");
    var response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    GetThreadResponseModel responsebody =
        getThreadResponseModelFromJson(response.body);
    return responsebody;
  }

  Future<GetCommentsResponseModel> getComments(
      GetCommentsRequestModel object, int page) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.getcomments + "?i=$page");
    String codedobject = getCommentsRequestModelToJson(object);
    var response = await client.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: codedobject);
    GetCommentsResponseModel responsebody =
        getCommentsResponseModelFromJson(response.body);
    return responsebody;
  }

  Future<PostCommentResponseModel> postComment(
      PostCommentRequestModel object) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.postcomment);
    String codedobject = postCommentRequestModelToJson(object);
    var response = await client.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: codedobject);
    PostCommentResponseModel responsebody =
        postCommentResponseModelFromJson(response.body);
    return responsebody;
  }

  Future<PostReplyResponseModel> postReply(PostReplyRequestModel object) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.postReply);
    String codedobject = postReplyRequestModelToJson(object);
    var response = await client.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: codedobject);
    PostReplyResponseModel responsebody =
        postReplyResponseModelFromJson(response.body);
    return responsebody;
  }

  Future<SeeMoreReplyRequestModel> getReplies(String id, int page) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.seemore + "?id=$id&i=$page");
    var response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    SeeMoreReplyRequestModel responsebody =
        seeMoreReplyRequestModelFromJson(response.body);
    return responsebody;
  }

  Future<LikeThreadResponseModel> likeReply(
      LikeThreadRequestModel object) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.like_reply);
    String codedobject = likeThreadRequestModelToJson(object);
    var response = await client.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: codedobject);
    LikeThreadResponseModel responsebody =
        likeThreadResponseModelFromJson(response.body);
    return responsebody;
  }

  Future<LikeThreadResponseModel> deleteComment(
      DeleteThreadRequestModel object) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.delete_comment);
    String codedobject = deleteThreadRequestModelToJson(object);
    var response = await client.delete(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: codedobject);
    LikeThreadResponseModel responsebody =
        likeThreadResponseModelFromJson(response.body);
    return responsebody;
  }

  Future<LikeThreadResponseModel> deleteReply(
      DeleteThreadRequestModel object) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.delete_reply);
    String codedobject = deleteThreadRequestModelToJson(object);
    var response = await client.delete(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: codedobject);
    LikeThreadResponseModel responsebody =
        likeThreadResponseModelFromJson(response.body);
    return responsebody;
  }
}

Future<bool> setToken(String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setString('token', value);
}

Future<String?> getToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

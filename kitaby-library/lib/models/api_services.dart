import 'dart:convert';
import 'package:kitabylib/models/auth/login_request_model.dart';
import 'package:kitabylib/models/auth/login_response_model.dart';
import 'package:kitabylib/models/auth/message_model.dart';
import 'package:kitabylib/models/auth/send_otp_request.dart';
import 'package:kitabylib/models/auth/send_otp_response.dart';
import 'package:kitabylib/models/auth/signUp_request.dart';
import 'package:kitabylib/models/auth/verify_otp_request.dart';
import 'package:kitabylib/models/auth/verify_otp_response.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http_parser/http_parser.dart';
import 'package:cross_file/cross_file.dart';
import 'package:http/http.dart' as http;
import 'package:kitabylib/models/Get-onHold-Books-Response-model.dart';
import 'package:kitabylib/models/GetExpiredBooksResponseModel.dart';
import 'package:kitabylib/models/GetRenewRequestResponseModel.dart';
import 'package:kitabylib/models/Get_all_books_responsemodel.dart';
import 'package:kitabylib/models/acceptrequest-requestmodel.dart';
import 'package:kitabylib/models/addbooklibrequestmodel.dart';
import 'package:kitabylib/models/get-requested-books-response-model.dart';
import 'package:kitabylib/models/getBooksresponsemodel.dart';
import 'package:kitabylib/models/get_collection_responsemodel.dart';
import 'package:kitabylib/models/get_received_offer_responsemodel.dart';
import 'package:kitabylib/models/getavailablebooksmodel.dart';
import 'package:kitabylib/models/getreservedBooksResponseModel.dart';
import 'package:kitabylib/models/givebookrequestmodel.dart';
import 'package:kitabylib/models/resset_password_request_model.dart';
import 'package:kitabylib/models/upload_file_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'PostBookInCollection_request_model.dart';
import 'package:kitabylib/models/config.dart';
import 'forgot_password_request_model.dart';

class APISERVICES {
  var client = http.Client();
  Map<String, String> customHeaders = {"content-type": "application/json"};
  //auth apis
  Future<LoginResponseModel> login(LoginRequestModel object) async {
    var url = Uri.parse(config.apiURL + config.loginURL);
    String codedobject = loginRequestModelToJson(object);
    var response =
        await client.post(url, headers: customHeaders, body: codedobject);
    LoginResponseModel responsebody = loginResponseModelFromJson(response.body);
    if (response.statusCode == 200) {
      setToken(responsebody.token!);
    }
    return responsebody;
  }

  Future<MessageModel> signup(SignupRequest object) async {
    var url = Uri.parse(config.apiURL + config.signUpURL);
    String codedobject = signupRequestToJson(object);
    var response =
        await client.post(url, headers: customHeaders, body: codedobject);
    MessageModel responsebody =
        messageModelFromJson(response.body);
    return responsebody;
  }

  Future<SendOtpResponse> sendotp(SendOtpRequest object) async {
    var url = Uri.parse(config.apiURL + config.PhoneOTP);
    String codedobject = sendOtpRequestToJson(object);
    var response =
        await client.post(url, headers: customHeaders, body: codedobject);
    SendOtpResponse responsebody =
        sendOtpResponseFromJson(response.body);
    return responsebody;
  }

  Future<VerifyOtpResponse> verifyotp(
      VerifyOtpRequest object) async {
    var url = Uri.parse(config.apiURL + config.VerifyOTP);
    String codedobject = verifyOtpRequestToJson(object);
    var response =
        await client.post(url, headers: customHeaders, body: codedobject);
    VerifyOtpResponse responsebody =
        verifyOtpResponseFromJson(response.body);
    return responsebody;
  }

  Future<MessageModel> forgetPassword(
      ForgotPasswordRequestModel object) async {
    var url = Uri.parse(config.apiURL + config.ForgotPassword);
    String codedobject = forgotPasswordRequestModelToJson(object);
    var response =
        await client.post(url, headers: customHeaders, body: codedobject);
    MessageModel responsebody =
        messageModelFromJson(response.body);
    return responsebody;
  }

  Future<MessageModel> ressetPassword(
      RessetPasswordRequestModel object) async {
    var url = Uri.parse(config.apiURL + config.RessetPassword);
    String codedobject = ressetPasswordRequestModelToJson(object);
    var response =
        await client.post(url, headers: customHeaders, body: codedobject);
    MessageModel responsebody =
        messageModelFromJson(response.body);
    return responsebody;
  }

  //homepage api
  Future<Getcollectionresponsemodel> getCollection(String id, int page) async {
    var url =
        Uri.parse(config.apiURL + config.GetCollection + id + "?page=$page");
    var response = await client.get(url);
    Getcollectionresponsemodel responsebody =
        getcollectionresponsemodelFromJson(response.body);
    return responsebody;
  }

  Future<Getcollectionresponsemodel> getWishlist(String id, int page) async {
    var url =
        Uri.parse(config.apiURL + config.GetWishList + id + "?page=$page");
    var response = await client.get(url);
    Getcollectionresponsemodel responsebody =
        getcollectionresponsemodelFromJson(response.body);
    return responsebody;
  }

  //profile api
  Future<dynamic> PostBookInCollectionAPI(String id, String isbn) async {
    PostBookInCollection object = PostBookInCollection(id: id, isbn: isbn);
    var url = Uri.parse(config.apiURL + config.PostBookInCollection);
    var codedobject = postBookInCollectionToJson(object);
    var response =
        await client.post(url, headers: customHeaders, body: codedobject);
    return response.body;
  }

  Future<dynamic> PostBookInWishlist(String id, String isbn) async {
    PostBookInCollection object = PostBookInCollection(id: id, isbn: isbn);
    var url = Uri.parse(config.apiURL + config.PostBookInWishlist);
    var codedobject = postBookInCollectionToJson(object);
    var response =
        await client.post(url, headers: customHeaders, body: codedobject);
    return response.body;
  }

  //offers api
  Future<Getallbooksresponse> getallbooks(String page) async {
    var url =
        Uri.parse(config.apiURL + config.getallbooks + "?page=$page&limit=8");
    var response = await client.get(url);
    Getallbooksresponse responsebody =
        getallbooksresponseFromJson(response.body);
    return responsebody;
  }

  //getreceivedoffers
  Future<ReceivedOffersResponseModel?> getreceivedoffers(
      String id, int page) async {
    var url = Uri.parse(
        config.apiURL + config.getreceivedoffers + "$id?page=$page&limit=8");
    var response = await client.get(url);
    ReceivedOffersResponseModel responsebody =
        receivedOffersResponseModelFromJson(response.body);
    if (response.statusCode == 200) {
      return responsebody;
    } else {
      return null;
    }
  }

  Future<Getbooksresponsemodel?> getBooks(String name, int page) async {
    var url = Uri.parse(
        config.apiURL + config.getbooks + "?page=$page&limit=8&name=$name");
    var response = await client.get(url);
    Getbooksresponsemodel responsebody =
        getbooksresponsemodelFromJson(response.body);
    if (response.statusCode == 200) {
      return responsebody;
    } else {
      return null;
    }
  }


   //bib api
  Future<Getavailablebooksresponsemodel> getAvalaibleBooks(int page,String name) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.getavailablebooks +"?page=$page"+"&name="+name);
    var response = await client.get(url,
    headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    Getavailablebooksresponsemodel responsebody = getavailablebooksresponsemodelFromJson(response.body);
    return responsebody;
  }


  Future<GetOnHoldBooksResponseModel> getOnholdBooks(int page,String name) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.getonholdbooks +"?page=$page"+"&name="+name);
    var response = await client.get(url,
    headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    GetOnHoldBooksResponseModel responsebody = getOnHoldBooksResponseModelFromJson(response.body);
    return responsebody;
  }

  Future<GetRequestedBooksResponseModel> getRequestedBooks(int page,String name) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.getrequestedbooks +"?page=$page"+"&name="+name);
    var response = await client.get(url,
    headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    GetRequestedBooksResponseModel responsebody = getRequestedBooksResponseModelFromJson(response.body);
    return responsebody;
  }


  Future<GetReservedBooksResponseModel> getReservedBooks(int page,String name) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.getreservedbooks +"?page=$page"+"&name="+name);
    var response = await client.get(url,
    headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },);
    GetReservedBooksResponseModel responsebody = getReservedBooksResponseModelFromJson(response.body);//response same type as requestedbooks
    return responsebody;
  }

  Future<GetExpiredBooksResponseModel> getExpiredBooks(int page,String name) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.getexpiredbooks + "?page=$page"+"&name="+name);
    var response = await client.get(url,
    headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },);
    GetExpiredBooksResponseModel responsebody = getExpiredBooksResponseModelFromJson(response.body);//response same type as requestedbooks
    return responsebody;
  }

  Future<GetRenewRequestResponseModel> getrenewRequests(int page,String name) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.getrenewrequests +"?page=$page"+"&name="+name);
    var response = await client.get(url,
    headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },);
    GetRenewRequestResponseModel responsebody = getRenewRequestResponseModelFromJson(response.body);//response same type as requestedbooks
    return responsebody;
  }

  Future<dynamic> Addbooktolib( String isbn,String quantity) async {
    String? token = await getToken();
    Addbooklibrequestmodel object =Addbooklibrequestmodel(isbn:isbn,quantity:quantity);
    var url = Uri.parse(config.apiURL + config.addbook);
    var codedobject = addbooklibrequestmodelToJson(object);
    var response = await client.post(url,
    headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',//benhammadi lokmane
      },
     body: codedobject);
    return response.body;
  }

  Future<dynamic> acceptrequest(String id) async {
    String? token = await getToken();
    AcceptrequestRequestModel object =AcceptrequestRequestModel(reservationId:id);
    var url = Uri.parse(config.apiURL + config.acceptrequest);
    var codedobject = acceptrequestRequestModelToJson(object);
    var response = await client.patch(url,headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',//benhammadi lokmane
      }, body: codedobject);
    return response.body;
  }

  Future<dynamic> cancelreservation(String id) async {
    String? token = await getToken();
    AcceptrequestRequestModel object =AcceptrequestRequestModel(reservationId:id);
    var url = Uri.parse(config.apiURL + config.cancelreservation);
    var codedobject = acceptrequestRequestModelToJson(object);
    var response = await client.put(url,headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',//benhammadi lokmane
      }, body: codedobject);
    return response.body;
  }

  Future<dynamic> refuserequest(String id) async {
    String? token = await getToken();
    AcceptrequestRequestModel object =AcceptrequestRequestModel(reservationId:id);
    var url = Uri.parse(config.apiURL + config.refuserequest);
    var codedobject = acceptrequestRequestModelToJson(object);
    var response = await client.put(url,headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',//benhammadi lokmane
      }, body: codedobject);
    return response.body;
  }

  Future<dynamic> acceptrenewrequest(String id) async {
    String? token = await getToken();
    AcceptrequestRequestModel object =AcceptrequestRequestModel(reservationId:id);
    var url = Uri.parse(config.apiURL + config.acceptrenewrequest);
    var codedobject = acceptrequestRequestModelToJson(object);//we can use acceptrequestrequestmodel because it uses reservationId
    var response = await client.put(url,headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',//benhammadi lokmane
      }, body: codedobject);
    return response.body;
  }

  Future<dynamic> refuserenewrequest(String id) async {
    String? token = await getToken();
    AcceptrequestRequestModel object =AcceptrequestRequestModel(reservationId:id);
    var url = Uri.parse(config.apiURL + config.refuserenewrequest);//we can use acceptrequestrequestmodel because it uses reservationId
    var codedobject = acceptrequestRequestModelToJson(object);
    var response = await client.put(url,headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',//benhammadi lokmane
      }, body: codedobject);
    return response.body;
  }

  Future<dynamic> Reportuser(String id) async {
String? token = await getToken();
    AcceptrequestRequestModel object =AcceptrequestRequestModel(reservationId:id); //we can use acceptrequestrequestmodel because it uses reservationId
    var url = Uri.parse(config.apiURL + config.Reportuser);
    var codedobject = acceptrequestRequestModelToJson(object);
    var response = await client.post(url,headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',//benhammadi lokmane
      }, body: codedobject);
    return response.body;
  }

  Future<dynamic> givebook(String id,String code) async {
    String? token = await getToken();
    Givebookrequestmodel object =Givebookrequestmodel(reservationId:id,code: code); //we can use acceptrequestrequestmodel because it uses reservationId
    var url = Uri.parse(config.apiURL + config.givebook);
    var codedobject = givebookrequestmodelToJson(object);
    var response = await client.put(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',//benhammadi lokmane
      }, body: codedobject);
    return response.body;
  }

  Future<dynamic> returnbook(String id,String code) async {
    String? token = await getToken();
    Givebookrequestmodel object =Givebookrequestmodel(reservationId:id,code: code); //we can use acceptrequestrequestmodel because it uses reservationId
    var url = Uri.parse(config.apiURL + config.returnbook);
    var codedobject = givebookrequestmodelToJson(object);
    var response = await client.put(url,headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',//benhammadi lokmane
      }, body: codedobject);
    return response.body;
  }

  Future<UploadFileResponseModel> UploadFile(XFile image) async {
    String? token = await getToken();
    var url = Uri.parse(config.apiURL + config.uploadFIle);
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
      'Authorization':
          'Bearer $token',
    });
    // multipart that takes file
    var multipartFile = http.MultipartFile('file', stream, length,
        filename: basename(image.path),
        contentType: MediaType('application', 'msexcel'));

    // add file to multipart
    request.files.add(multipartFile);

    // send
    var response = await request.send();
    var responsebody = await http.Response.fromStream(response);
    UploadFileResponseModel responseModel =
        uploadFileResponseModelFromJson(responsebody.body);
    // listen for response
    return responseModel;
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

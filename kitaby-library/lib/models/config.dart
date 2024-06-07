class config {
  static String apiURL = "http://192.168.2.106:3000/api";
  //auth liks
  static String loginURL = "/bib/auth/login";
  static String signUpURL = "/bib/auth/signup";
  static String PhoneOTP = "/bib/auth/send_otp";
  static String VerifyOTP = "/bib/auth/verify_otp";
  static String VerifyEmail = "/bib/auth/verify_email";
  static String ForgotPassword = "/bib/auth/forgot_password";
  static String RessetPassword = "/bib/auth/reset_password";
  //Homepage links
  static String GetCollection = '/home/getCollection/';
  static String GetWishList = '/home/getWishlist/';
  //profil links
  static String PostBookInCollection = '/profile/postBookInCollection';
  static String PostBookInWishlist = '/profile/postInWishList';
  //offers
  static String getbook = "/home/getBook";
  static String getbooks = "/home/getBooks";
  static String getallbooks = "/home/getAllBooks";
  static String getreceivedoffers = "/offers/getReceivedOffers/";
  static String getsentoffers = "/offers//getSentOffers/";
  //bib
  static String getavailablebooks = "/bib/getAvalaibleBooks/";
  static String getonholdbooks = "/bib/getOnHoldBooks/";
  static String getrequestedbooks = "/bib/getRequestedBooks/";
  static String getreservedbooks = "/bib/getReservedBooks/";
  static String getexpiredbooks = "/bib/getExpiredBooks/";
  static String getrenewrequests = "/bib/getRenewRequests/";
  static String cancelreservation = "/bib/cancaelReservation";
  static String acceptrequest = "/bib/acceptBookRequest";
  static String refuserequest = "/bib/refuseBookRequest";
  static String acceptrenewrequest = "/bib/acceptRenewRequest";
  static String refuserenewrequest = "/bib/refuseRenewRequest";
  static String Reportuser = "/bib/reportUser";
  static String givebook = "/bib/giveBook";
  static String returnbook = "/bib/returnBook";
  static String addbook = "/bib/addBook";
  static String uploadFIle = "/bib/auth/upload_excel";
}

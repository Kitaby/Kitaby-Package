// ignore_for_file: non_constant_identifier_names, camel_case_types
class config {
  static String http = "http://192.168.2.106:3000";
  static String apiURL = "http://192.168.2.106:3000/api";
  //auth liks
  static String loginURL = "/auth/login";
  static String signUpURL = "/auth/signup";
  static String PhoneOTP = "/auth/send_otp";
  static String VerifyOTP = "/auth/verify_otp";
  static String ForgotPassword = "/auth/forgot_password";
  static String RessetPassword = "/auth/reset_password";
  //Homepage links
  static String recommendation = "/home/getRecommendations";
  static String getbook = "/home/getBook";
  static String isBookOwned = "/home/isBookOwned";
  static String getRatings = "/home/getRatings";
  static String addRating = "/home/addRating";
  static String GetCollection = '/home/getCollection/';
  static String GetWishList = '/home/getWishlist/';
  static String isBookAvailable = "/home/isBookAvailable";
  static String getRating = "/home/calculateRating";
  static String getRecent = "/home/recent";
  //Reservation Links
  static String getLibsBooks = "/home/getLibsBooks";
  static String requestBook = "/profile/requestBook";
  static String getReservations = "/profile/getReservations";
  static String cancelReservation = "/profile/cancelReservation";
  static String renewRequest = "/profile/renewRequest";
  static String endReservation = "/profile/endBookReservation";
  //profil links
  static String PostBookInCollection = '/profile/postBookInCollection';
  static String PostBookInWishlist = '/profile/postInWishList';
  static String get_post = "/profile/get_post";
  static String get_profile = "/profile/get_profile";
  static String changepp = "/profile/change_pp";
  static String changeprofile = "/profile/change_profile";
  //offers
  static String getbooks = "/home/getBooks";
  static String getallbooks = "/home/getAllBooks";
  static String getreceivedoffers = "/offers/getReceivedOffers/";
  static String getsentoffers = "/offers/getSentOffers/";
  static String acceptoffer = "/offers/acceptOffer";
  static String rejectOffer = "/offers/rejectOffer";
  static String canceloffer = "/offers/cancelOffer";
  static String postoffer = "/offers/postOffer";
  //chat
  static String createchat = "/chat/";
  static String getmessages = "/message/";
  //forum
  static String getcategories = "/forum/get_categories";
  static String getthreadsofcategories = "/forum/get_threads_of_categories";
  static String postThread = '/forum/post_thread';
  static String likeThread = "/forum/like_thread";
  static String shareThread = "/forum/share_thread";
  static String reportThread = "/forum/report";
  static String deleteThread = "/forum/delete_thread";
  static String getthread = "/forum/get_thread";
  static String getcomments = "/forum/get_comments";
  static String postcomment = "/forum/post_comment";
  static String postReply = "/forum/post_reply";
  static String seemore = "/forum/get_replies";
  static String delete_comment = "/forum/delete_comment";
  static String delete_reply = "/forum/delete_reply";
  static String like_reply = "/forum/like_reply";
}

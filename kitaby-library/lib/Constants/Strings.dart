class TextString {
  static String title = "Kitaby";
  static String loan = "Loan Books form your local libraries";
  static String skip = "Skip";
  static String next = "Next";
  static String getstarted = 'Get Started';
  static String trade = 'Exchange your books with other users';
  static String community = "Share your thoughts with other users";
  static String welcomeback = 'Welcome Back';
  static String signin = "Signin to continue";
  static String emailadress = 'Email Adress';
  static String password = "Password";
  static String forgotyourpassword = "Forgot your password?";
  static String login = "Log in";
  static String donthaveaccount = "Dont Have an account ? ";
  static String signup = " SignUp";
  static String forgotpassword = 'Forgot Password?';
  static String forgotpasswordcontent =
      "We'll email you a link to reset your password";
  static String sendrequest = 'Send Request';
  static String emailsent = "An Email is Sent";
  static String resetcode = "You can Reset your Password with the code";
  static String changepassword = 'You can change your password now ';
  static String newpassword = "New Password";
  static String confirmpassword = 'Confirm Password';
  static String codepin = "Code pin";
  static String resetpassword = 'Reset Password';
  static String resetpasswordcompleted = "Reset Password Completed";
  static String canlogin = "You can now login with your account ";
  static String welcomehere = "Welcome Here";
  static String signupc = "Signup to continue";
  static String fullName = "Full Name";
  static String phoneNumber = "Phone Number";
  static String send = "Send";
  static String ahaa = "Already have an account ?";
  static String sLogin = " Login";
  static String categorycontent1 = 'What Category of books';
  static String categorycontent2 = 'You Like the most ?';
  static String signup3 = 'Sign up';
  static String mailbox = "Please Verify your mailBox";
  static String AddBook =
      "Enter the code in the back of the book Or search it on google !";
  static List<String> category = [
    "mystery",
    "biography",
    "history",
    "drama",
    "fiction",
    "romance",
    "adventure",
    "horror",
    "comedy",
    "science",
    "philosophy",
    "religion"
  ];
  static String timeAgoSinceDate(String dateString,
      {bool numericDates = true}) {
    DateTime date = DateTime.parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(date);

    if ((difference.inDays / 365).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} years';
    } else if ((difference.inDays / 365).floor() >= 1) {
      return (numericDates) ? '1 year' : 'Last year';
    } else if ((difference.inDays / 30).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} months';
    } else if ((difference.inDays / 30).floor() >= 1) {
      return (numericDates) ? '1 month' : 'Last month';
    } else if ((difference.inDays / 7).floor() >= 2) {
      return '${(difference.inDays / 7).floor()} weeks ';
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hrs';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hrs' : 'An hrs';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} min';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 min' : 'A min';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} sec';
    } else {
      return 'now';
    }
  }
}

class Strings{
  static String appName = "dagdag";
  static const String customFont = "SFPro";
  static const String emailInvalid = "Enter a valid email address";
  static const String login = "LOGIN";
  static const String signup = "SIGN UP";
  static const String getStarted = "GET STARTED";
  static const String welcome = "welcome to dagdag";
  static const String forgot = "Forgot my password?";
  static const String join = "let's get started";
  static const String fieldReq = 'This field is required';
  static const String confirmError = 'This Your confirm password is not the same as your new password';
  static const String invalid = "Opps! The number you've entered isn't valid";
  static const String bank = "Bank";
  static const String cash = "Cash";
  static const String mobile = "Mobile";
  static const String viewPaymentCard = 'View Payment Cards';

  static String sthWentWrg = " Some thing went wronng";

  static var issueDate = "issue date";

  static var enterCard = "Enter Card";
  static var addCard = "Add Card";

  static var nameOnCard = "Name on card";

  static var cardNumber = "Card Number";

  static var expiryDate = "Expiry Date";

  static var cvv = "cvv";

  static String cards = "cards" ;
  static String addresses = "addresses" ;

  static String get numberIsInvalid => "The number you entered is invalid";



  static List<String> intToStringMonth = [
    "",
    "January",
    "Febuary",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  static List<String> intToStringDayOfWeek = [
    "",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  static String dayOfmonth(int day){
    if(day == 1 || day == 21 || day == 31){
      return "$day"+"st";
    }else if(day == 2 || day == 22){
      return "$day"+"nd";
    }else if(day == 3 || day == 23){
      return "$day"+"rd";
    }else{
      return "$day"+"th";
    }

  }
}


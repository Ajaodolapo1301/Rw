import 'dart:io';
import 'dart:math';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyUtils {
  ///
  ///Generates a positive random integer uniformly distributed on the range
  /// from [min], inclusive, to [max], exclusive.

  static String getCleanedNumber(String text) {
    if (text == null) {
      return '';
    }
    RegExp regExp = new RegExp(r"[^0-9]");
    return text.replaceAll(regExp, '');
  }

  static String getFormattedAmount(num amount) {
    String format = '${new NumberFormat('#,##0.00', 'en_GB').format(amount)}';
    var formats = format.split(new RegExp(r'(\.)'));
    return formats[1] == '00' ? formats[0] : format;
  }


  static cupertinoDark({@required BuildContext context}) {
    return CupertinoTheme(
      data: CupertinoTheme.of(context).copyWith(brightness: Brightness.light),
      child: CupertinoActivityIndicator(),
    );
  }


//
//  static Future<String> googleAPIKey() async {
//
//    return Platform.isIOS ? "AIzaSyAM-5Ejo9txM4LdIMR2nrm84HL9LXkFxj8" : "AIzaSyAM-5Ejo9txM4LdIMR2nrm84HL9LXkFxj8";
//  }

//  static String isEmailStr(String email, {String error = Strings.emailInvalid}) {
//    return isEmail(email) ? null : error;
//  }

  static bool isEmail(String email) {
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";

    return new RegExp(p).hasMatch(email);
  }



  bool validateStructure(String value){
    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }


  static const requestDuration = const Duration(seconds: 15);

//  static String validateField(String value) {
//    if (value == null || value.isEmpty) return Strings.fieldReq;
//    return null;
//  }
//
//  static String validateConfirmPassword(String value, String confirm) {
//    if (value == null || value.isEmpty) return Strings.fieldReq;
//    if (value != confirm) return Strings.confirmError;
//
//    return null;
//  }

  static String validateZip(String value) {
    if (value == null || value.length < 5) return "Zip code should not be 5 digits ";
    return null;
  }

  static String validatePhoneNumber(String value) {
    //print("num $value");
    if (value == null || value.isEmpty || value.length < 10)
      return "Enter a correct Phone Number";
    return null;
  }

  static String getObscuredNumberWithSpaces(
      {@required String string,
        String obscureValue = 'X',
        String space = ' '}) {
    assert(
    !(string.length < 8),
    'Card Number $string must be more than 8 '
        'characters and above');
    assert(obscureValue != null && obscureValue.length == 1);
    var length = string.length;
    var buffer = new StringBuffer();
    for (int i = 0; i < string.length; i++) {
      if (i < (length - 4)) {
        // The numbers before the last digits is changed to X
        buffer.write(obscureValue);
      } else {
        // The last four numbers are spared
        buffer.write(string[i]);
      }
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != string.length) {
        buffer.write(space);
      }
    }
    return buffer.toString();
  }

  static String getObscuredNumberWithSpacesv2(
      {@required String string,
        String obscureValue = 'X',
        String space = ' '}) {
    assert(
    !(string.length < 8),
    'Card Number $string must be more than 8 '
        'characters and above');
    assert(obscureValue != null && obscureValue.length == 1);
    var length = string.length;
    var buffer = new StringBuffer();
    for (int i = 0; i < string.length; i++) {
      if (i < 4) {
        buffer.write(string[i]);
      } else if (i < (length - 4)) {
        // The numbers before the last digits is changed to X
        buffer.write(obscureValue);
      } else {
        // The last four numbers are spared
        buffer.write(string[i]);
      }
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != string.length) {
        buffer.write(space);
      }
    }
    return buffer.toString();
  }


  static int autoCompleteTimes = 0;

  static String getMonth(int i) {
    var months = [
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
    return months[0];
  }

  static String getRemainingTime(Duration remainingDuration) {
    return new DateFormat('mm:ss').format(
        new DateTime.fromMillisecondsSinceEpoch(remainingDuration.inMilliseconds));
  }

//  static Future<Duration> getRemainingDuration(String key, int secs) async {
//    var preferences = await SharedPreferences.getInstance();
//    int savedTimeStamp = preferences.getInt(key) ?? 0;
//
//    var now = DateTime.now();
//
//    if (savedTimeStamp == 0) {
//      preferences.setInt(key, now.millisecondsSinceEpoch);
//    }
//
//    var savedTime =
//    savedTimeStamp == 0 ? now : DateTime.fromMillisecondsSinceEpoch(savedTimeStamp);
//    Duration timeDiff = now.difference(savedTime);
//    return (Duration(seconds: secs) - timeDiff);
//  }

  static isEmpty(String value) {
    return value == null || value.isEmpty;
  }

  static Map getCountryCodesFromCountryName() {}

  static getCommission(String amount, double commission){
//    print("amount111111: $amount");
//    print("comission11111: $commission");

    return double.parse(amount) - commission ;
  }

//  String _printDuration(Duration duration) {
//    String twoDigits(int n) {
//      if (n >= 10) return "$n";
//      return "0$n";
//    }
//
//    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
//  }





 static formatDate(String date) {
    if (date == null) {
      return date ?? "";
    }

    var fmtDate = DateFormat.yMMMd().format(DateTime.parse(date));
//    String fmtDate = DateFormat('dd-MM-yyyy').format(DateTime.parse(date));
    String fmtTime =DateFormat('kk:mm:a').format(DateTime.parse(date));
    return "${fmtDate.toString()} - ${fmtTime.toString()}";
  }


  static formatTime(String date) {
    if (date == null) {
      return date ?? "";
    }

    var fmtDate = DateFormat.yMMMd().format(DateTime.parse(date));
//    String fmtDate = DateFormat('dd-MM-yyyy').format(DateTime.parse(date));
    String fmtTime =DateFormat('kk:mm:a').format(DateTime.parse(date));
    return "${fmtDate.toString()} - ${fmtTime.toString()}";
  }








  static String formatDuration(Duration d) {
    var seconds = d.inSeconds;
    final days = seconds~/Duration.secondsPerDay;
    seconds -= days*Duration.secondsPerDay;
    final hours = seconds~/Duration.secondsPerHour;
    seconds -= hours*Duration.secondsPerHour;
    final minutes = seconds~/Duration.secondsPerMinute;
    seconds -= minutes*Duration.secondsPerMinute;

    final List<String> tokens = [];
    if (days != 0) {
      tokens.add('${days}d');
    }
    if (tokens.isNotEmpty || hours != 0){
      tokens.add('${hours}h');
    }
    if (tokens.isNotEmpty || minutes != 0) {
      tokens.add('${minutes}m');
    }
    tokens.add('${seconds}s');

    return tokens.join(':');
  }


  static double convertAmount(
      String amount, double commission, double exchangeRate) {
//    print("amount: $amount");
//    print("comission: $commission");
//    print("ex: $exchangeRate");


    var percentageOfCommission = double.parse(amount) * (commission / 100);
    //print("percentage of commission: $percentageOfCommission");

    //

    var amountWithCommissionTaken =double.parse(amount)  - percentageOfCommission;
    //print("amount with commision taken: $amountWithCommissionTaken");
    double amountConverted = (amountWithCommissionTaken * exchangeRate);

    //print("recie: $amountConverted");
    return amountConverted;
  }

  static double convertAmountForModal(
      String amount, double commission, double exchangeRate) {
    var percentageOfCommission = double.parse(amount) * (commission / 100);

    var amountWithCommissionTaken =double.parse(amount)  - percentageOfCommission;

    double amountConverted = (amountWithCommissionTaken * exchangeRate);

    if(amountConverted.isInfinite || amountConverted.isNaN){
      return 0.0;
    }

    return amountConverted;
  }

//
//  static double convertReverseAmount(
//      String amount, double commission, double exchangeRate) {
//
//
//    print("reverse amount $amount");
//    var percentageOfCommission = double.parse(amount) * (commission / 100);
//
//    var amountConverted = ( double.parse(amount) * exchangeRate ) / (1 - (commission/100));
//    print("convetttt amount $amountConverted");
//    return (double.parse(amount) /exchangeRate) / (1-(commission/100));
//  }

//  static String getReadableDate(DateTime date) {
//    String month = Strings.intToStringMonth[date.month];
//    String dayOfWeek = Strings.intToStringDayOfWeek[date.weekday];
//    String dayOfMonth = Strings.dayOfmonth(date.day);
//
//    return "$dayOfWeek, $dayOfMonth $month";
//  }


  static Color getAvatarColor() {
    final _random = new math.Random();
    return _userAvatarColors[_random.nextInt(_userAvatarColors.length)];
  }

  static String getAvatarText2(String name) {
    var strings = name.split(RegExp(' '));
    if (strings.isEmpty) {
      return '';
    }

    if (strings.length == 1) {
      return strings[0][0];
    }

    return '${strings[0][0]}${strings[1][0]}';
  }

  static String getTime(DateTime time) {

    String _addLeadingZeroIfNeeded(int value) {
      if (value < 10)
        return '0$value';
      return value.toString();
    }
    TimeOfDay day = TimeOfDay.fromDateTime(time);
    String result = "${_addLeadingZeroIfNeeded(day.hourOfPeriod)}:${_addLeadingZeroIfNeeded(day.minute)} ${day.period == DayPeriod.am ? "AM":"PM"}";

    return result;
  }


  static String getAvatarText(String name) {
    var strings = name.split(RegExp(' '));
    print("this is the cause of an issue $strings ---- ${strings.length}");
    if (strings.isEmpty) {
      return '';
    }

    if (strings.length >= 1) {
      return strings[0][0];
    }else{
      return 'T';
    }

  }


}

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

var _userAvatarColors = [Colors.red, Colors.purple[900], Colors.black, Colors.green[900]];
List<String> codes = ['VA','IS','LI','NO', 'AT','BE','BG','HR','CY','CZ','DK','EE','FR','DE',
  'GR','HU','IE','IT','LV','LT','LU','MT', 'NL','PL','PT','RO','SK',
  'SI','ES','SE','UK','AD','IL','MC'];
List<String> countries = ["""Iceland,Liechenstein,Norway.

  Austria,
  Belgium,
  Bulgaria,
  Croatia,
  Cyprus,
  Czech Republic,
  Denmark,
  Estonia,
  Finland,
  France,
  Germany,
  Greece,
  Hungary,
  Ireland,
  Italy,
  Latvia,
  Lithuania,
  Luxembourg,
  Malta,
  Netherlands,
  Poland,
  Portugal,
  Romania,
  Slovakia,
  Slovenia,
  Spain,
  Swedan,
  UK
  Andorra,
  Israel,
  Guernsey,
  Isle of Man,
  Jersey,
  Monaco,
  San Marino,
  Switzerland,
  Turkey
  Vatican City"""];
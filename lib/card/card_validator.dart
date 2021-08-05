
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rex_money/constants/stringsConstants.dart';
import 'package:rex_money/models/cardInfo.dart';

class CardValidator {
  static String validateCVV(String value) {
    if (value.isEmpty) {
      return Strings.fieldReq;
    }

    if (value.length < 3 || value.length > 4) {
      return "CVV is invalid";
    }
    return null;
  }

  static String validateDate(String value) {
    if (value.isEmpty) {
      return Strings.fieldReq;
    }

    int year;
    int month;
    if (value.contains(new RegExp(r'(\/)'))) {
      var split = value.split(new RegExp(r'(\/)'));
      month = int.parse(split[0]);
      year = int.tryParse(split[1]);
    } else {
      month = int.parse(value.substring(0, (value.length)));
      year = -1;
    }

    if ((month < 1) || (month > 12)) {
      return 'Expiry month is invalid';
    }

    var normalizeY = normalizeYear(year);
    if ((normalizeY < 1) || (normalizeY > 2099)) {
      return 'Expiry year is invalid';
    }

    if (!validExpiryDate(month, year)) {
      return "Card has expired";
    }
    return null;
  }

  static String getEnteredNumLength(String text) {
    String numbers = getCleanedNumber(text);
    return '${numbers.length}/19';
  }

  static bool hasMonthPassed(int year, int month) {
    var now = DateTime.now();
    return hasYearPassed(year) ||
        normalizeYear(year) == now.year && (month < now.month + 1);
  }

  static bool hasYearPassed(int year) {
    int normalizedYear = normalizeYear(year);
    var now = DateTime.now();
    return normalizedYear < now.year;
  }

  // Convert two-digit year to full year if necessary
  static int normalizeYear(int year) {
    if (year == null) {
      return 0;
    }
    if (year < 100 && year >= 0) {
      var now = DateTime.now();
      String currentYear = now.year.toString();
      String prefix = currentYear.substring(0, currentYear.length - 2);
      year = int.parse('$prefix${year.toString().padLeft(2, '0')}');
    }
    return year;
  }

  static bool isNotExpired(int year, int month) {
    return !hasYearPassed(year) && !hasMonthPassed(year, month);
  }

  static bool validExpiryDate(int month, int year) {
    // I am supposed to check for a valid month but I have already done that
    return !(month == null || year == null) && isNotExpired(year, month);
  }

  static List<int> getExpiryDate(String value) {
    var split = value.split(new RegExp(r'(\/)'));
    return [int.parse(split[0]), int.parse(split[1])];
  }

  static String getCleanedNumber(String text) {
    RegExp regExp = new RegExp(r"[^0-9]");
    return text.replaceAll(regExp, '');
  }

  static bool _validCVV(String value) {
    if (value.isEmpty) {
      return false;
    }

    if (value.length < 3 || value.length > 4) {
      return false;
    }
    return true;
  }

  static bool validCardNumWithLuhnAlgorithm(String value) {
    if (value.isEmpty) {
      return false;
    }

    String input = getCleanedNumber(value);

    int sum = 0;
    int length = input.length;
    for (var i = 0; i < length; i++) {
      // get digits in reverse order
      int digit = int.parse(input[length - i - 1]);

      // every 2nd number multiply with 2
      if (i % 2 == 1) {
        digit *= 2;
      }
      sum += digit > 9 ? (digit - 9) : digit;
    }

    if (sum % 10 == 0) {
      return true;
    }

    return false;
  }

  static List<String> getIssuesWithCard(CardInfo cardInfo) {
    List<String> issues = [];
    if (!validCardNumWithLuhnAlgorithm(cardInfo.number)) {
      issues.add('Card number is not complete or invalid');
    }

    if (!validExpiryDate(cardInfo.month, cardInfo.year)) {
      issues.add('Expiry date is invalid or expired');
    }

    if (!_validCVV(cardInfo.cvv.toString())) {
      issues.add('CVV is incomplete');
    }

    return issues;
  }

  static List<Color> getColorsFrmCardType(CardType cardType) {
    List<Color> colors = [];
    switch (cardType) {
      case CardType.Master:
        colors.add(Colors.deepPurple[800]);
        colors.add(Colors.deepPurple[900]);
        break;
      case CardType.Visa:
        colors.add(Colors.grey[300]);
        colors.add(Colors.grey[400]);
        break;
      case CardType.AmericanExpress:
        colors.add(Colors.red[700]);
        colors.add(Colors.red[900]);
        break;
      case CardType.Discover:
        colors.add(Colors.grey[900]);
        colors.add(Colors.grey[800]);
        break;
      case CardType.Verve:
        colors.add(Colors.grey[400]);
        colors.add(Colors.grey[600]);
        break;
      case CardType.Others:
        colors.add(Colors.black);
        colors.add(Colors.grey[900]);
        break;
      case CardType.Invalid:
        colors.add(Colors.brown[400]);
        colors.add(Colors.brown[600]);
        break;
      case CardType.DinersClub:
        colors.add(Colors.grey[100]);
        colors.add(Colors.grey[500]);
        break;
      case CardType.Jcb:
        colors.add(Colors.green[600]);
        colors.add(Colors.green[800]);
        break;
    }
    return colors;
  }

  static Color getTextColorFrmCardType(CardType cardType) {
    Color color;
    switch (cardType) {
      case CardType.Master:
        color = Colors.white;
        break;
      case CardType.Visa:
        color = Colors.grey[850];
        break;
      case CardType.AmericanExpress:
        color = Colors.grey[300];
        break;
      case CardType.Discover:
        color = Colors.white;
        break;
      case CardType.Verve:
        color = Colors.black;
        break;
      case CardType.Others:
        color = Colors.white;
        break;
      case CardType.Invalid:
        color = Colors.white;
        break;
      case CardType.DinersClub:
        color = Colors.black;
        break;
      case CardType.Jcb:
        color = Colors.grey[200];
        break;
    }
    return color;
  }

  static Widget getCardIcon(CardType cardType,
      [bool addPadding = true, double size = 40]) {
    String img;
    Color color;
    switch (cardType) {
      case CardType.Master:
        img = 'mastercard';
        break;
      case CardType.Visa:
        img = 'visa_card';
        break;
      case CardType.Verve:
        img = 'verve_card';
        break;
      case CardType.AmericanExpress:
        img = 'american_express_card';
        break;
      case CardType.Discover:
        img = 'discover_card';
        break;
      case CardType.DinersClub:
        img = 'diners_club_card';
        break;
      case CardType.Jcb:
        img = 'jcb_card';
        break;
      case CardType.Others:
        img = 'generic_card';
        break;
      case CardType.Invalid:
        img = 'error';
        color = Colors.red[600];
        size = 20;
        break;
    }
    var picture = new SvgPicture.asset(
      'assets/images/$img.svg',
      width: size,
      color: color,
    );
    return addPadding
        ? Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: picture,
    )
        : picture;
  }

  static String getCardTypeStr(CardType cardType) {
    String type;
    switch (cardType) {
      case CardType.Master:
        type = 'Mastercard';
        break;
      case CardType.Visa:
        type = 'Visa';
        break;
      case CardType.Verve:
        type = 'Verve';
        break;
      case CardType.AmericanExpress:
        type = 'American Express';
        break;
      case CardType.Discover:
        type = 'Discover';
        break;
      case CardType.DinersClub:
        type = 'Diners Club International';
        break;
      case CardType.Jcb:
        type = 'JCB';
        break;
      default:
        type = 'Unkwnown';
        break;
    }
    return type;
  }

  static String getObscuredNumberWithSpaces(String string) {
    assert(
    !(string.length < 8),
    'Card Number $string must be more than 8 '
        'characters and above');
    var length = string.length;
    var buffer = new StringBuffer();
    for (int i = 0; i < string.length; i++) {
      if (i < (length - 4)) {
        // The numbers before the last digits is changed to X
        buffer.write('\u002A');
      } else {
        // The last four numbers are spared
        buffer.write(string[i]);
      }
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != string.length) {
        buffer.write(' ');
      }
    }
    return buffer.toString();
  }

  static String getObscuredCVV(String cvv) {
    var buffer = new StringBuffer();
    for (var i = 0; i < cvv.length; i++) {
      buffer.write('x');
    }
    return buffer.toString();
  }

  static CardType getCardTypeFrmNumber(String input) {
    CardType cardType;
    if (input.startsWith(new RegExp(
        r'((5[1-5])|(222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720))'))) {
      cardType = CardType.Master;
    } else if (input.startsWith(new RegExp(r'[4]'))) {
      cardType = CardType.Visa;
    } else if (input.startsWith(new RegExp(r'((506(0|1))|(507(8|9))|(6500))'))) {
      cardType = CardType.Verve;
    } else if (input.startsWith(new RegExp(r'((34)|(37))'))) {
      cardType = CardType.AmericanExpress;
    } else if (input.startsWith(new RegExp(r'((6[45])|(6011))'))) {
      cardType = CardType.Discover;
    } else if (input.startsWith(new RegExp(r'((30[0-5])|(3[89])|(36)|(3095))'))) {
      cardType = CardType.DinersClub;
    } else if (input.startsWith(new RegExp(r'(352[89]|35[3-8][0-9])'))) {
      cardType = CardType.Jcb;
    } else if (input.length <= 8) {
      cardType = CardType.Others;
    } else {
      cardType = CardType.Invalid;
    }
    return cardType;
  }
}

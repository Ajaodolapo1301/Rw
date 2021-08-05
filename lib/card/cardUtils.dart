

import 'package:rex_money/models/paymentCard.dart';

class CardUtils {
  static CardIssuer getTypeForIIN(String value) {
    var input = getCleanedNumber(value);
    var number = input.trim();
    if (number.isEmpty) {
      return CardIssuer.unknown;
    }

    if (number.startsWith(startingPatternVisa)) {
      return CardIssuer.visa;
    } else if (number.startsWith(startingPatternMaster)) {
      return CardIssuer.master;
    } else if (number.startsWith(startingPatternAmex)) {
      return CardIssuer.amex;
    } else if (number.startsWith(startingPatternDiners)) {
      return CardIssuer.diners;
    } else if (number.startsWith(startingPatternJCB)) {
      return CardIssuer.jcb;
    } else if (number.startsWith(startingPatternVerve)) {
      return CardIssuer.verve;
    } else if (number.startsWith(startingPatternDiscover)) {
      return CardIssuer.discover;
    }
    return CardIssuer.unknown;
  }

  static CardType getTypeForIIN2(String value) {
    var input = getCleanedNumber(value);
    var number = input.trim();
    if (number.isEmpty) {
      return CardType.Invalid;
    }

    if (number.startsWith(startingPatternVisa)) {
      return CardType.Visa;
    } else if (number.startsWith(startingPatternMaster)) {
      return CardType.Master;
    } else if (number.startsWith(startingPatternAmex)) {
      return CardType.AmericanExpress;
    } else if (number.startsWith(startingPatternDiners)) {
      return CardType.DinersClub;
    } else if (number.startsWith(startingPatternJCB)) {
      return CardType.Jcb;
    } else if (number.startsWith(startingPatternVerve)) {
      return CardType.Verve;
    } else if (number.startsWith(startingPatternDiscover)) {
      return CardType.Discover;
    }
    return CardType.Invalid;
  }

  /// Convert the two-digit year to four-digit year if necessary
  static int convertYearTo4Digits(int year) {
    if (year < 100 && year >= 0) {
      var now = DateTime.now();
      String currentYear = now.year.toString();
      String prefix = currentYear.substring(0, currentYear.length - 2);
      year = int.parse('$prefix${year.toString().padLeft(2, '0')}');
    }
    return year;
  }

  static String getCleanedNumber(String text) {
    if (text == null) {
      return '';
    }
    RegExp regExp = new RegExp(r"[^0-9]");
    return text.replaceAll(regExp, '');
  }

  static String getCardIcon(CardIssuer type) {
    String img = "";
    switch (type) {
      case CardIssuer.master:
        img = 'mastercard';
        break;
      case CardIssuer.visa:
        img = 'visa';
        break;
      case CardIssuer.verve:
        img = 'verve';
        break;
      case CardIssuer.amex:
        img = 'amex';
        break;
      case CardIssuer.discover:
        img = 'discover.png';
        break;
      case CardIssuer.diners:
        img = 'diners.png';
        break;
      case CardIssuer.jcb:
        img = 'jcb';
        break;
      case CardIssuer.unknown:
        img = 'generic_card';
        break;
    }
    return img;
  }

  static List<String> getExpiryDate(String value) {
    var split = value.split(new RegExp(r'(\/)'));
    return [split[0], split[1]];
  }
}

final startingPatternVisa = RegExp(r'[4]');
final startingPatternMaster =
RegExp(r'((5[1-5])|(222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720))');
final startingPatternAmex = RegExp(r'((34)|(37))');
final startingPatternDiners = RegExp(r'((30[0-5])|(3[89])|(36)|(3095))');
final startingPatternJCB = RegExp(r'(352[89]|35[3-8][0-9])');
final startingPatternVerve = RegExp(r'((506(0|1))|(507(8|9))|(6500))');
final startingPatternDiscover = RegExp(r'((6[45])|(6011))');

enum CardType {
  Master,
  Visa,
  Verve,
  Discover,
  AmericanExpress,
  DinersClub,
  Jcb,
  Others,
  Invalid
}
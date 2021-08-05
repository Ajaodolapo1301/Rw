
import 'package:rex_money/card/cardUtils.dart';
import 'package:rex_money/utils/utils.dart';

class CardInfo {
  CardType cardType;
  String number;
  String name;
  int month;
  int year;
  String cvv;

  CardInfo({this.cardType = CardType.Master, this.number, this.name, this.month, this.year, this.cvv});

  @override
  String toString() {
    return '[Type: $cardType, Number: $number, Name: $name, Month: $month, Year: $year, CVV: $cvv]';
  }
  assignIssuer() {
    this.cardType = getTypeForIIN2(number);
  }

  CardType getTypeForIIN2(String value) {
    var input = CardUtils.getCleanedNumber(value);
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CardInfo &&
              runtimeType == other.runtimeType &&
              cardType == other.cardType &&
              number == other.number &&
              name == other.name &&
              month == other.month &&
              year == other.year &&
              cvv == other.cvv;

  @override
  int get hashCode =>
      cardType.hashCode ^
      number.hashCode ^
      name.hashCode ^
      month.hashCode ^
      year.hashCode ^
      cvv.hashCode;
}

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

enum PaymentMethod { card, bank, wallet }

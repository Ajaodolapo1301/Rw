import 'package:flutter/material.dart';
import 'package:rex_money/card/cardUtils.dart';
import 'package:rex_money/utils/card_utils.dart';
import 'dart:math' as math;
class PaymentCard {

  CardIssuer issuer = CardIssuer.unknown;
  String number;
  String name;
  String month;
  String year;
  String cvv;
  List<Color> gradient;

  PaymentCard();

  PaymentCard.dummy({
    this.issuer = CardIssuer.amex,
    this.number = '340000000000009',
    this.name = 'Wilberforce Uwadiegwu',
    this.month = '12',
    this.year = '02',
    this.cvv = '123',
    this.gradient,
  });

  factory PaymentCard.fromJson(Map<String, dynamic> json) => new PaymentCard.dummy(
      name: json["card_name"],
      number: json["card_number"],
      month: json["exp_month"],
      year: json["exp_year"],
      cvv: json["cvv"],
      gradient: _gradients[math.Random().nextInt(_gradients.length)]
  );

  Map<String, dynamic> toJson() => {
    "card_name": name,
    "card_number": number,
    "exp_month": month,
    "exp_year": year,
    "cvv": cvv,
  };

  static List<PaymentCard> getDummyCards() {
    return [
      PaymentCard.dummy(
          name: 'Chuks Ugwuh',
          gradient: _gradients[math.Random().nextInt(_gradients.length)]),
      PaymentCard.dummy(
          issuer: CardIssuer.master,
          number: '5500000000000004',
          gradient: _gradients[math.Random().nextInt(_gradients.length)]),
      PaymentCard.dummy(
          issuer: CardIssuer.visa,
          number: '4111111111111111',
          gradient: _gradients[math.Random().nextInt(_gradients.length)]),
      PaymentCard.dummy(
          number: 'Lois Genesis',
          gradient: _gradients[math.Random().nextInt(_gradients.length)]),
    ];
  }

  assignColor() {
    gradient = _gradients[math.Random().nextInt(_gradients.length)];
  }

  assignIssuer() {
    issuer = CardUtils.getTypeForIIN(number);
  }
}

enum CardIssuer { visa, master, amex, diners, discover, jcb, verve, unknown }

List<List<Color>> _gradients = [
  [Color(0xFFC17AFC), Color(0xFFF42E78)],
  [Color(0xFFFF8993), Color(0xFFFEC180)],
  [Color(0xFF7E43AA), Color(0xFF6681EA)],
  [Color(0xFF53AAB1), Color(0xFF10C06D)],
  [Color(0xFFFFC8A9), Color(0xFF3B41C5)],
  [Color(0xFF48C6EF), Color(0xFF6F86D6)],
  [Color(0xFF6F86D6), Color(0xFF0B3067)],
  [Color(0xFF4A5055), Color(0xFF111318)],
];
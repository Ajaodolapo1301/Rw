

import 'package:rex_money/models/banks.dart';

class BanksSingleton{
  static final BanksSingleton _banksSingleton = BanksSingleton._createInstance();

  BanksSingleton._createInstance();

  factory BanksSingleton(){
    return _banksSingleton;
  }

  List<Banks> banks = [];


}
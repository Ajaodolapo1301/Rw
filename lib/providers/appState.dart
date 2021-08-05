import 'package:camera/camera.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:rex_money/models/countryField.dart';
import 'package:rex_money/models/history.dart';
import 'package:rex_money/models/aSingleVirtualCardModel.dart';

class AppState with ChangeNotifier {
  var firstname;
  var lastname;
  var address;
  var email;
  var phone;
  var password;
  var state;
  var selectMeansOfId;
  var imagesSelectedType;

  AnimationController controller;
String cardType;
  var country;
  var zipcode;
  var city;
  var cardAddress;
  var cardState;

  TextEditingController bvn = TextEditingController();

  var countryHint = "Select your country";


  var myDeviceToken;
  var deviceId;

  List<CameraDescription> camera;

  List<String> numbersToSend = [];




  List<Contact> _contacts = [];
  List<Contact> get contacts => _contacts;
  set contacts(List<Contact> contacts1) {
    _contacts = contacts1;
    notifyListeners();
  }





  bool _moneyRequest = false;
  bool get moneyRequest => _moneyRequest;

  set moneyRequest(bool moneyRequest1) {
    _moneyRequest = moneyRequest1;
    notifyListeners();
  }


//
//  String _cardType = "";
//  String get cardType1 => _cardType;
//
//  set cardType(String cardType1) {
//    _cardType = cardType1;
//    notifyListeners();
//  }




//  List<VirtualCardModel> virtualcard = [
//    VirtualCardModel(num: "468588*******2130", date: "2023-06", active: true),
//    VirtualCardModel(num: "468588*******2130", date: "2023-06", active: true),
//    VirtualCardModel(num: "468588*******2130", date: "2023-06", active: false),
//  ];

//  List<HistoryModel> allHistory = [
//    HistoryModel(
//        text: "Transfer to Naira Account",
//        type: "debit",
//        currencyType: "NGN",
//        amount: "124,000.44",
//        date: "Tuesday, March 31st, 2020"),
//    HistoryModel(
//        text: "University of Calgary...",
//        type: "credit",
//        currencyType: "CAD",
//        amount: "1,200.00",
//        date: "Wednesday, March 31st, 2020"),
//    HistoryModel(
//        text: "West Minchester Bank...",
//        type: "credit",
//        currencyType: "EUR",
//        amount: "900,000.44",
//        date: "Wednesday, March 31st, 2020"),
//    HistoryModel(
//        text: "Transfer to Naira Account",
//        type: "debit",
//        currencyType: "NGN",
//        amount: "124,000.44",
//        date: "Tuesday, March 31st, 2020"),
//    HistoryModel(
//        text: "Transfer to Naira Account",
//        type: "debit",
//        currencyType: "NGN",
//        amount: "124,000.44",
//        date: "Tuesday, March 31st, 2020"),
//  ];
}

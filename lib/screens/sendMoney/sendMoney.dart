import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/constants/colorConstants.dart';

import 'package:rex_money/models/banks.dart';

import 'package:rex_money/models/flags.dart';
import 'package:rex_money/models/rateModel.dart';
import 'package:rex_money/models/receiveTrans.dart';
import 'package:rex_money/models/resolveAccModel.dart';
import 'package:rex_money/models/tagFetch.dart';
import 'package:rex_money/providers/appState.dart';
import 'package:rex_money/providers/conversionState.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/providers/transferState.dart';
import 'package:rex_money/reusables/bankSingleton.dart';

import 'package:rex_money/reusables/dialoPopup.dart';
import 'package:rex_money/reusables/form.dart';


import 'package:rex_money/screens/auth/login.dart';
import 'package:rex_money/screens/fundAccount/mobileMoney.dart';

import 'package:rex_money/screens/sendMoney/RexSend.dart';


import 'MobileMoney.dart';
import 'bankSend.dart';

class SendMoney extends StatefulWidget {
  @override
  _SendMoneyState createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney>
    with AfterLayoutMixin<SendMoney> {
//  TextEditingController _amount = TextEditingController();
  var amount;



//  TextEditingController _amount2 = TextEditingController();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  StreamController<String> streamController = StreamController();
  StreamController<String> streamController3 = StreamController();
  StreamController<String> streamController2 = StreamController();
  BanksSingleton banksSingleton = BanksSingleton();
  final _formKey = GlobalKey<FormState>();
  String _errortext;
  Flag _dropDownValue1;
  Flag _dropDownValue2;
  List<Banks> banks = [];
  List<Flag> flagList = [];
  LoginState loginState;
  ConversionState conversionState;
  TransferState transferState;
  bool isLoading = false;
  bool loading = false;
  TagFetch tagFetch;
  bool error = false;
  bool userTagLoading = false;
  bool isCheckingRate = false;
  bool paymentLoading = false;
  var flagImage = "";
  var flagImage2 = "";
  var totalAmount;
  var realAmount;
  ResolveAccountModel resolveAccountModel;
  var accountNum;
  var clear = false;
  RateModel rateModel;
  FocusNode _focus = new FocusNode();
  FocusNode _focus2 = new FocusNode();
  TextEditingController _tagName = TextEditingController();
  TextEditingController _accountName = TextEditingController();
  MoneyMaskedTextController _amountController =
      MoneyMaskedTextController(decimalSeparator: ".", thousandSeparator: ",");
  MoneyMaskedTextController _amountController2 =
      MoneyMaskedTextController(decimalSeparator: ".", thousandSeparator: ",");
  TextEditingController _accountNum = TextEditingController();
  TextEditingController _narration = TextEditingController();
  String _dropDownValue;

  Banks _dropDownValueForBank;
  ReceiveTransfer _dropDownValueForCountry;

  List<ReceiveTransfer> receiverCountry = [];

  var _currencies = [
    "RexWire",
    "Bank Account",
    "Mobile Money"
  ];

  @override
  void initState() {
    getCurrentAppTheme();

//get conversion rate
//    streamController.stream
//        .transform(debounce(Duration(milliseconds: 1000)))
//        .listen((s) => _validatetext());
//
////get tag name
//    streamController2.stream
//        .transform(debounce(Duration(milliseconds: 1000)))
//        .listen((s) => _validateTag());
//
//
//
////bank name resolve
//    streamController3.stream.transform(debounce(Duration(milliseconds: 700)))
//        .listen((s) => _validateBankname());

    _focus.addListener(_onFocusChange);
    super.initState();
  }

  void _onFocusChange() {
    debugPrint("Focus: " + _focus.hasFocus.toString());
  }

  _validateBankname() {
    if (_accountNum.text.length > 5) {
      resolveBankName();
    } else {
      // some other code here
    }
  }

  _validatetext() {
    setState(() {
      isLoading = false;
    });
    String s = amount.toString().replaceAll(RegExp(r"([.]*000)(?!.*\d)"), "");
    var cleanAmount = s.trim().replaceAll(",", "");
    print("cleanAmount$cleanAmount");
    setState(() {
      realAmount = cleanAmount;
    });
    if (_amountController.text != "0.0" ||
        _amountController.text.length > 0 ||
        _amountController2.text.length > 0) {
      _focus.hasFocus
          ? getConversion(amount: cleanAmount)
          : getConversionreverse(amount: cleanAmount);
    } else {
      // some other code here
    }
  }

  _validateTag() {
    if (_tagName.text.length > 3) {
      getUserTag();
    } else {
      // some other code here
    }
  }

  AppState appState;

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

//  kevelaravel

  @override
  Widget build(BuildContext context) {
    themeChangeProvider = Provider.of<DarkThemeProvider>(context);
    loginState = Provider.of<LoginState>(context);
    appState = Provider.of<AppState>(context);
    conversionState = Provider.of<ConversionState>(context);
    transferState = Provider.of<TransferState>(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor:
          themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor:
            themeChangeProvider.darkTheme ? kPrimaryDark : Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: kprimaryYellow,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Send Money",
          style: GoogleFonts.mavenPro(
              color:
                  themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
              fontSize: 20),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                      key: _formKey,
                      child: Column(children: [
                        //selectType
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Select type",
                                style: GoogleFonts.mavenPro(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: themeChangeProvider.darkTheme
                                      ? Colors.white
                                      : kPrimaryColor,
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              FormField(
                                builder: (FormFieldStatestate) {
                                  return DropdownButtonHideUnderline(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      InputDecorator(
                                        decoration: InputDecoration(


                                          contentPadding:EdgeInsets.fromLTRB(10,0,10,0),
                                          border:  FormBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(5.0)),

                                          ),
//                                          focusedBorder: InputBorder.none,
//                                          enabledBorder: InputBorder.none,
//                                          errorBorder: InputBorder.none,
//                                          disabledBorder: InputBorder.none,
//

                                          fillColor: themeChangeProvider
                                                  .darkTheme
                                              ? kPrimaryDarkTextField
                                              : kPrimaryColor.withOpacity(0.1),

                                          filled: true,

                                          labelStyle: TextStyle(
                                            color: themeChangeProvider.darkTheme
                                                ? Colors.white
                                                : Colors
                                                    .black, //This is an example of a change
                                          ),
//                                                                  labelText: _dropDownValue == null ? "Select Monthly transaction volume " : " Select Monthly transaction volume",
                                          errorText: _errortext,
                                        ),
                                        isEmpty: _dropDownValue == null,
                                        child: DropdownButton<String>(
                                          dropdownColor:
                                              themeChangeProvider.darkTheme
                                                  ? kPrimaryDarkTextField
                                                  : Colors.white,
                                          value: _dropDownValue,
                                          isDense: true,
                                          onChanged: (String newValue) {
                                            setState(() {
                                              _dropDownValue = newValue;
                                            });
                                          },
                                          items:
                                              _currencies.map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value,
                                                  style: GoogleFonts.raleway(
                                                      fontSize: 14,
                                                      color: themeChangeProvider
                                                              .darkTheme
                                                          ? Colors.white
                                                          : kPrimaryColor)),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ));
                                },
                              ),
                            ],
                          ),
                        ),

//            Recipient tag / amount
                        _dropDownValue == "RexWire"
                            ? RexTransfer(
                                scaf: _scaffoldKey,
                              )
                            : _dropDownValue == "Bank Account" ? BankAccountTransfer(

                                receiverCountry: transferState.receiverList,
                                scaf: _scaffoldKey,
                              ) : MobileMoneyTransfer(
//                          receiverCountry: transferState.receiverListMobileMoney,
                          scaf: _scaffoldKey,
                        ),

//if bankTransfer the
//                  Column(
//                    children: [
//
////select Country
//                      Container(
//                        margin: EdgeInsets.symmetric(
//                            horizontal: 20,
//                            vertical: 12),
//                        child: Column(
//                          crossAxisAlignment:
//                          CrossAxisAlignment.start,
//                          children: [
//                            Text(
//                              "Select Country",
//                              style: GoogleFonts.raleway(
//                                fontWeight:
//                                FontWeight.w500,
//                                fontSize: 12,
//                                color: themeChangeProvider.darkTheme
//                                    ? Colors.white
//                                    : kPrimaryColor,
//                              ),
//                            ),
//                            SizedBox(
//                              height: 4,
//                            ),
//                            FormField(builder: (
//                                FormFieldStatestate) {
//                              return DropdownButtonHideUnderline(
//
//                                  child: Column(
//                                    crossAxisAlignment: CrossAxisAlignment
//                                        .stretch,
//                                    children: <Widget>[
//                                      InputDecorator(
//
//                                        decoration:
//                                        InputDecoration(
//                                          hintText: "Select recipient Country ",
//
//                                          hintStyle:  GoogleFonts
//                                              .raleway(
//                                              fontSize: 12,
//                                              color: themeChangeProvider.darkTheme
//                                                  ? Colors
//                                                  .white
//                                                  : kPrimaryColor),
//                                          border: InputBorder
//                                              .none,
////                                                                focusedBorder: OutlineInputBorder(
////                                                                    borderSide:
////                                                                        BorderSide(
////                                                                            color:
////                                                                                Color(0xffFFC844))),
////                                                                enabledBorder:
////                                                                    OutlineInputBorder(
////                                                                  borderSide: BorderSide(
////                                                                      color: Colors
////                                                                              .grey[
////                                                                          300]),
////                                                                ),
//
//                                          fillColor: themeChangeProvider.darkTheme
//                                              ? kPrimaryDarkTextField
//                                              : kPrimaryColor.withOpacity(0.1),
//
//                                          filled: true,
//
//                                          labelStyle:
//                                          TextStyle(
//                                            color: themeChangeProvider.darkTheme
//                                                ? Colors
//                                                .white
//                                                : Colors
//                                                .black, //This is an example of a change
//                                          ),
////                                                                  labelText: _dropDownValue == null ? "Select Monthly transaction volume " : " Select Monthly transaction volume",
//                                          errorText:
//                                          _errortext,
//                                        ),
//                                        isEmpty:
//                                        _dropDownValueForCountry ==
//                                            null,
//                                        child:
//                                        DropdownButton<ReceiveTransfer>(
//                                          dropdownColor: themeChangeProvider.darkTheme
//                                              ? kPrimaryDarkTextField
//                                              : Colors
//                                              .white,
//
//                                          value: _dropDownValueForCountry,
//                                          isDense: true,
//                                          onChanged: (
//                                              ReceiveTransfer newValue) {
//                                            setState(() {
//                                              _dropDownValueForCountry = newValue;
//                                            });
//                                          },
//
//                                          items: receiverCountry.map((
//                                              ReceiveTransfer value) {
//                                            return DropdownMenuItem<
//                                                ReceiveTransfer>(
//                                              value: value,
//                                              child: Text(
//                                                  value.country.country ,
//                                                  style: GoogleFonts
//                                                      .raleway(
//                                                      fontSize: 12,
//                                                      color: themeChangeProvider.darkTheme
//                                                          ? Colors
//                                                          .white
//                                                          : kPrimaryColor)),
//                                            );
//                                          }).toList(),
//                                        ),
//                                      ),
//                                    ],
//                                  ));
//                            },
//                            ),
//                          ],
//                        ),
//                      ),
//
//
////select Bank
//  _dropDownValueForCountry != null ?  _dropDownValueForCountry.country.country == "Nigeria" ?
//    Column(
//          children: [
//            Container(
//              margin: EdgeInsets.symmetric(
//                  horizontal: 20,
//                  vertical: 12),
//              child: Column(
//                crossAxisAlignment:
//                CrossAxisAlignment.start,
//                children: [
//                  Text(
//                    "Select Bank",
//                    style: GoogleFonts.raleway(
//                      fontWeight:
//                      FontWeight.w500,
//                      fontSize: 12,
//                      color: themeChangeProvider.darkTheme
//                          ? Colors.white
//                          : kPrimaryColor,
//                    ),
//                  ),
//                  SizedBox(
//                    height: 4,
//                  ),
//                  FormField(builder: (
//                      FormFieldStatestate) {
//                    return DropdownButtonHideUnderline(
//
//                        child: Column(
//                          crossAxisAlignment: CrossAxisAlignment
//                              .stretch,
//                          children: <Widget>[
//                            InputDecorator(
//
//                              decoration:
//                              InputDecoration(
//                                hintText: "Select recipient bank ",
//
//                                hintStyle:  GoogleFonts
//                                    .raleway(
//                                    fontSize: 12,
//                                    color: themeChangeProvider.darkTheme
//                                        ? Colors
//                                        .white
//                                        : kPrimaryColor),
//                                border: InputBorder
//                                    .none,
////
//
//                                fillColor: themeChangeProvider.darkTheme
//                                    ? kPrimaryDarkTextField
//                                    : kPrimaryColor.withOpacity(0.1),
//
//                                filled: true,
//
//                                labelStyle:
//                                TextStyle(
//                                  color: themeChangeProvider.darkTheme
//                                      ? Colors
//                                      .white
//                                      : Colors
//                                      .black, //This is an example of a change
//                                ),
////                                                                  labelText: _dropDownValue == null ? "Select Monthly transaction volume " : " Select Monthly transaction volume",
//                                errorText:
//                                _errortext,
//                              ),
//                              isEmpty:
//                              _dropDownValueForBank ==
//                                  null,
//                              child:
//                              DropdownButton<Banks>(
//                                icon: Icon(Icons.arrow_drop_down_rounded),
//                                dropdownColor: themeChangeProvider.darkTheme
//                                    ? kPrimaryDarkTextField
//                                    : Colors
//                                    .white,
//
//                                value: _dropDownValueForBank,
//                                isDense: true,
//                                onChanged: (
//                                    Banks newValue) {
//                                  setState(() {
//                                    _dropDownValueForBank = newValue;
//                                  });
//                                },
//
//                                items: resultBank.map((
//                                    Banks value) {
//                                  return DropdownMenuItem<
//                                      Banks>(
//                                    value: value,
//                                    child: Text(
//                                        value.bankName,
//                                        style: GoogleFonts
//                                            .raleway(
//                                            fontSize: 12,
//                                            color: themeChangeProvider.darkTheme
//                                                ? Colors
//                                                .white
//                                                : kPrimaryColor)),
//                                  );
//                                }).toList(),
//                              ),
//                            ),
//                          ],
//                        ));
//                  },
//                  ),
//                ],
//              ),
//            ),
//
//
//            //Account num
//            CustomTextField(
////                        color: kPrimaryColor.withOpacity(0.1),
//              header: "Enter Account Number",
//              hint: "0120112233",
//              type: FieldType.number,
//
//
//              onChanged: (v) {
//                if (v.length < 10) {
//                  _accountName.text = "";
//                } else if (v.length == 10 ) {
//                  resolveBankName();
//                }
//
////                  setState(() {
////                    accountNum = v;
////
////                  });
//              },
//              controller: _accountNum,
//              validator: (value) {
//                if (value.isEmpty) {
//                  return "field is required";
//                }
//
//                if (value.length < 10) {
//                  return "Invalid Account number";
//                }
//
//                return null;
//              },
//            ),
//
//
//            //ACCOUNT NAME
//          Row(
//            children: [
//
//              Expanded(
//                child: CustomTextField(
//                  color: kPrimaryColor.withOpacity(0.1),
//                  header: "Beneficiary Name",
//                  hint: "Sumaila Finidi",
//                  type: FieldType.text,
//                  onChanged: (value) {
//                    print(value);
//
//                  },
//                  controller: _accountName,
//                  validator: (value) {
//                    if (value.isEmpty) {
//                      return "Field is required";
//                    }
//
//                    return null;
//                  },
//                ),
//              ),
//              if(loading)Row(
//                children: [
//                  CupertinoActivityIndicator(),
//                  SizedBox(width: 20),
//                ],
//              ),
//            ],
//          ),
//
//
//
////                  You Send
//            tagFetch != null  || userTagLoading   ?            Column(
//              children: [
//                Row(
//                  children: [
//                    Expanded(
//                      child: CustomTextField(
//                        focusNode: _focus,
//                        suffix: Padding(
//                          padding: const EdgeInsets.all(15),
//                          child: Text(loginState.user.currency),
//                        ),
//                        controller: _amountController,
//                        type: FieldType.number,
//                        onChanged: (value) {
//                          streamController.add(value);
//                          setState(() {
//                            amount = value;
//
//
//                          });
//
//                          print("amount $amount");
//                        },
//                        prefixText: loginState.user.symbol,
//                        header: "You Send",
//                        hint: "1000",
//                      ),
//                    ),
//
//                    if(isCheckingRate)Row(
//                      children: [
//                        CupertinoActivityIndicator(),
//                        SizedBox(width: 20),
//                      ],
//                    ),
//                  ],
//                ),
//
//
////                      Reciepient get
//                tagFetch != null  ?              CustomTextField(
//                  readOnly: true,
//                  focusNode: _focus2,
//                  suffix: Padding(
//                    padding: const EdgeInsets.all(15),
//                    child: Text(tagFetch.symbol),
//                  ),
//                  controller: _amountController2,
//                  type: FieldType.number,
//                  onChanged: (value) {
//                    streamController.add(value);
//                    setState(() {
//                      amount = value;
//
//
//                    });
//                  },
//                  prefixText: tagFetch.symbol,
//                  header: "Recipient Get",
//                  hint: "1000",
//                ) :Container()
//              ],
//            ) : Container(),
//          ],
//        )
//        : Text("Not available") : Container(),
//
//
//
//
//
//
//
//
//
//                ],
//              ),
//            ]
//              ),

//                  You Send
//         tagFetch != null  || userTagLoading  ||     _dropDownValueForCountry != null  ? _dropDownValueForCountry.country.country == "Nigeria"  ?            Column(
//                    children: [
//                      Row(
//                        children: [
//                          Expanded(
//                            child: CustomTextField(
//                              focusNode: _focus,
//                              suffix: Padding(
//                                padding: const EdgeInsets.all(15),
//                                child: Text(loginState.user.currency),
//                              ),
//                              controller: _amountController,
//                              type: FieldType.number,
//                              onChanged: (value) {
//                                streamController.add(value);
//                                setState(() {
//                                  amount = value;
//
//
//                                });
//
//                                print("amount $amount");
//                              },
//                              prefixText: loginState.user.symbol,
//                              header: "You Send",
//                              hint: "1000",
//                            ),
//                          ),
//
//                          if(isCheckingRate)Row(
//                            children: [
//                              CupertinoActivityIndicator(),
//                              SizedBox(width: 20),
//                            ],
//                          ),
//                        ],
//                      ),
//
//
////                      Reciepient get
//                      tagFetch != null  || _dropDownValueForCountry.country.country == "Nigeria"  ?              CustomTextField(
//                        readOnly: true,
//                        focusNode: _focus2,
//                        suffix: Padding(
//                          padding: const EdgeInsets.all(15),
//                          child: Text( ""),
//                        ),
//                        controller: _amountController2,
//                        type: FieldType.number,
//                        onChanged: (value) {
//                          streamController.add(value);
//                          setState(() {
//                            amount = value;
////                            tagFetch.symbol != null ? tagFetch.symbol :
//
//                          });
//                        },
////                        prefixText: tagFetch.symbol,
//                        header: "Recipient Get",
//                        hint: "1000",
//                      ) :Container()
//                    ],
//                  ) : Container() : Container(),

//                  NARRATION
//                  Container(
//                    margin: EdgeInsets.symmetric(
//                        horizontal: 20,
//                        vertical: 12),
//                    child: Column(
//                      crossAxisAlignment:
//                      CrossAxisAlignment.start,
//                      children: [
//                        Text(
//                          "Narration",
//                          style: GoogleFonts.raleway(
//                            fontWeight:
//                            FontWeight.w500,
//                            fontSize: 13,
//                            color: themeChangeProvider.darkTheme
//                                ? Colors.white
//                                : kPrimaryColor,
//                          ),
//                        ),
//                        SizedBox(
//                          height: 4,
//                        ),
//
//
//
//                        TextFormField(
//
//                          style: TextStyle(
//                              color: themeChangeProvider.darkTheme ? Colors
//                                  .white : Colors
//                                  .black),
//                          controller:
//                          _narration,
//                          decoration:
//                          InputDecoration(
//                            border: FormBorder(
//                              borderRadius: BorderRadius.circular(5),
//                            ),
//                            contentPadding:
//                            const EdgeInsets.only(
//                                left: 14.0,
//                                bottom: 12.0,
//                                top: 10.0),
//                            fillColor: themeChangeProvider.darkTheme
//                                ?kPrimaryDarkTextField
//                                : kPrimaryColor.withOpacity(0.1),
//                            filled: true,
//                          ),
//                          keyboardType:
//                          TextInputType
//                              .multiline,
//                          maxLines: 5,
////                  maxLength: 100,
//                        )
//                      ],
//                    ),
//                  ),
//
//
//
//                  Padding(
//                    padding: const EdgeInsets.only(right: 20, left: 20, top: 10),
//                    child: Column(
//
//
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: [
//                        Text("Funds should arrive in minutes", style: GoogleFonts.raleway(
//                          color: themeChangeProvider.darkTheme ? Colors.white: kPrimaryColor,
//
//                          fontSize: 11,
//                        )),
//                        SizedBox(height: 10,),
//                        Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: [
//                            Text("Exchange rate",       style: GoogleFonts.raleway(
//                              color: themeChangeProvider.darkTheme ? Colors.white:  kPrimaryColor,
//
//                              fontSize: 9,
//                            )),
//
//                            Text.rich(TextSpan(children: [
//                              TextSpan(
//                                  text: "1 EUR = ",
//                                  style: GoogleFonts.raleway(
//                                    color: themeChangeProvider.darkTheme ? Colors.white:  kPrimaryColor,
//
//                                    fontSize: 9,
//                                  )),
//                              TextSpan(
//                                  text: "510 NGN",
//                                  style: GoogleFonts.raleway(
//                                      color: kprimaryGreen,
//
//
//                                      fontSize: 9,
//                                      fontWeight: FontWeight.bold)),
//                            ])),
//                          ],
//
//                        ),
//                        SizedBox(height: 10,),
//                        Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: [
//                            Text("Fee",       style: GoogleFonts.raleway(
//                              color: themeChangeProvider.darkTheme ? Colors.white: kPrimaryColor,
//
//                              fontSize: 9,
//                            )),
//
//                            Text("0.0EUR",      style: GoogleFonts.raleway(
//                                color: kprimaryGreen,
//
//
//                                fontSize: 9,
//                                fontWeight: FontWeight.bold)),
//                          ],
//                        )
//                      ],
//                    ),
//                  ),
//            SizedBox(height: 10,),
//            Container(
//              margin: EdgeInsets.symmetric(horizontal: 20),
//              child: SizedBox(
//                width: double.maxFinite,
//                height: 50,
//                child: RaisedButton(
//                  onPressed: () {
//                    if (_formKey.currentState.validate()) {
//                      print(_dropDownValue);
//                      _dropDownValue == "Rexwire"  ?sendRexMoney() : sendBankMoney();
//                    }
//                  },
//                  child: Text(
//                    "PROCEED",
//                    style: GoogleFonts.mavenPro(
//                      fontSize: 16,
//
//
//                    ),
//                  ),
//                  color: kPrimaryColor,
//                  padding: EdgeInsets.symmetric(vertical: 15),
//                  textColor: Colors.white,
//                  shape: RoundedRectangleBorder(
//                    borderRadius: BorderRadius.circular(7),
//                  ),
//                ),
//              ),
//            ),
//
//
//
//            SizedBox(height: 30,),
                      ]))
                ],
              ),
            ),
    );
  }

//  sendRexMoney()async{
//    print("send Rex money");
//    print("called");
//    setState(() {
//      paymentLoading = true;
//    });
//
//    if (paymentLoading) {
//      showDialog(
//          context: context,
//          barrierDismissible: false,
//          builder: (BuildContext context) {
//            return Preloader();
//          });
//    }
////    String s = _amountController.text.toString().replaceAll(RegExp(r"([.]*00)(?!.*\d)"), "");
////    var amount = s.trim().replaceAll(",", "");
//    print("amount$amount");
//    var result = await transferState.walletToWalletFunding(amount:(int.parse(realAmount)*10).toString(), userTag: _tagName.text,  narration: _narration.text, token: loginState.user.token );
//    if (paymentLoading) {
//      Navigator.pop(context, true);
//    }
//    if(result["error"] == false){
//      CommonUtils.showSuccessDialog(context: context, themeChangeProvider: themeChangeProvider, text: "Transaction Successful", onClose: (){
//
//        Navigator.push(context, MaterialPageRoute(builder: (context)=> Home()));
//      });
//    }else{
//      CommonUtils.showMsg(result["message"], themeChangeProvider, context, _scaffoldKey, Colors.black12);
//    }
//  }

  getConversion({amount}) async {
//    print("called");
//    print("hhahahah$amount");
    if (amount != "0.0") {
      setState(() {
        isCheckingRate = true;
      });
      var result = await conversionState.conversion(
          firstCurrency: loginState.user.currency,
          secondCurrency: tagFetch.currency,
          firstAmount: double.parse(amount) * 10);
      if (result["error"] == false) {
        setState(() {
          rateModel = result["message"];
          isCheckingRate = false;
          _focus2.hasFocus
              ? _amountController.text = rateModel.totalAmount.toString()
              : _focus.hasFocus
                  ? _amountController2.text = rateModel.totalAmount.toString()
                  : " ";
        });
      }

//      print(result);
    }
  }

//getting coversion
  getConversionreverse({amount}) async {
    setState(() {
      isCheckingRate = true;
    });
//    print("called");
    var result = await conversionState.conversion(
      secondCurrency: tagFetch.currency,
      firstCurrency: loginState.user.currency,
      firstAmount:
          amount == null || amount == " " ? 0 : double.parse(amount) * 10,
    );
    if (result["error"] == false) {
      setState(() {
        rateModel = result["message"];
        isCheckingRate = false;
        _focus2.hasFocus
            ? _amountController.text = rateModel.totalAmount.toString()
            : _focus.hasFocus
                ? _amountController2.text = rateModel.totalAmount.toString()
                : " ";
      });
    }

//    print(result);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      _dropDownValue = _currencies[0];
    });
//    print("${transferState.receiverList.isEmpty } is em");
    if(transferState == null ||  transferState.receiverList == null || transferState.receiverList.isEmpty ){
//      print("gettin receirvr");
      getReceivingCountries();
    }





//    if(transferState.receiverListMobileMoney == null || transferState.receiverListMobileMoney.isEmpty ){
//      print("gettin  mobile receirvr");
//      getReceivingCountriesMobileMoney();
//    }


//    getBanks();
//
//      if (banksSingleton.banks.isEmpty) {
//        getBanks().then((result) {
//          setState(() {
//            resultBank = result;
//            banksSingleton.banks = result;
//            banks = banksSingleton.banks;
//          });
//        });
//      } else {
//        setState(() {
//
//          banks = banksSingleton.banks;
//        });
//      }
  }

  void getUserTag() async {
    setState(() {
      userTagLoading = true;
    });

    var result2 = await transferState.fetchToTransfer(
        token: loginState.user.token, userTag: _tagName.text);
    print(result2);
    if (result2["error"] == false) {
      setState(() {
        error = false;
        userTagLoading = false;
        tagFetch = result2["balance"];
      });
    } else {
      setState(() {
        error = true;
        userTagLoading = false;
      });
    }
  }



  void getReceivingCountries() async {
    setState(() {
      isLoading = true;
    });
    var result = await transferState.getReceivingCountries(token: loginState.user.token);
    print("result$result");
    if (result["error"] && result["message"] == "You are not authorized to make this request") {

      showDialog(
          barrierDismissible: false,
          context: context,
          child: dialogPopup(
              themeDark: themeChangeProvider.darkTheme,
              body: Text(
                result['message'],
                textAlign: TextAlign.center,
                style: TextStyle(
                    inherit: false,
                    fontSize: 18,
                    color: themeChangeProvider.darkTheme
                        ? Colors.white
                        : Colors.black),
              ),
              buttonText: "Ok",
              onPressed: () {
                final box = Hive.box("user");
                box.put('user', null);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false);
              }));
    } else if (result["error"] == false) {
      setState(() {
        receiverCountry = result['receivingCountries'];
        isLoading = false;
      });
    }
  }



//  void getReceivingCountriesMobileMoney() async {
//    setState(() {
//      isLoading = true;
//    });
//    var result = await transferState.getReceivingCountriesMobileMoney(token: loginState.user.token);
//    print("result$result");
//    if (result["error"] && result["message"] == "You are not authorized to make this request") {
//
//      showDialog(
//          barrierDismissible: false,
//          context: context,
//          child: dialogPopup(
//              themeDark: themeChangeProvider.darkTheme,
//              body: Text(
//                result['message'],
//                textAlign: TextAlign.center,
//                style: TextStyle(
//                    inherit: false,
//                    fontSize: 18,
//                    color: themeChangeProvider.darkTheme
//                        ? Colors.white
//                        : Colors.black),
//              ),
//              buttonText: "Ok",
//              onPressed: () {
//                final box = Hive.box("user");
//                box.put('user', null);
//                Navigator.pushAndRemoveUntil(
//                    context,
//                    MaterialPageRoute(builder: (context) => LoginPage()),
//                        (Route<dynamic> route) => false);
//              }));
//    } else if (result["error"] == false) {
//      setState(() {
////        receiverCountry = result['receivingCountries'];
////        isLoading = false;
//      });
//    }
//  }


  void resolveBankName() async {
    setState(() {
      loading = true;
    });
    print("resolve");
    var result = await transferState.resolveBankName(
        token: loginState.user.token,
        bank_code: _dropDownValueForBank.bankCode,
        account_number: _accountNum.text);
    if (result["error"] == false) {
      setState(() {
        loading = false;
        resolveAccountModel = result["accName"];
        _accountName.text = resolveAccountModel.account_name;
      });
    }
  }
}

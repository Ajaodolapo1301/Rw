import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/api/transactionpinService.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/models/bankBranchModel.dart';
import 'package:rex_money/models/banks.dart';

import 'package:rex_money/models/flags.dart';
import 'package:rex_money/models/rateModel.dart';

import 'package:rex_money/models/receiveTrans.dart';
import 'package:rex_money/models/resolveAccModel.dart';
import 'package:rex_money/models/tagFetch.dart';
import 'package:rex_money/models/transactionFee.dart';

import 'package:rex_money/providers/conversionState.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/providers/transferState.dart';
import 'package:rex_money/reusables/confirmationPage.dart';
import 'package:rex_money/reusables/customTextField.dart';
import 'package:rex_money/reusables/dialoPopup.dart';
import 'package:rex_money/reusables/form.dart';
import 'package:rex_money/reusables/preloader.dart';
import 'package:rex_money/screens/auth/login.dart';
import 'package:rex_money/screens/state/notifSuccess.dart';
import 'package:rex_money/utils/commonUtils.dart';
import 'package:stream_transform/stream_transform.dart';

import '../home.dart';

class BankAccountTransfer extends StatefulWidget {
  List<ReceiveTransfer> receiverCountry;
  List<Banks> resultBank;

  final GlobalKey<ScaffoldState> scaf;

  BankAccountTransfer({this.resultBank, this.receiverCountry, this.scaf});

  @override
  _BankAccountTransferState createState() => _BankAccountTransferState();
}

class _BankAccountTransferState extends State<BankAccountTransfer> with AfterLayoutMixin<BankAccountTransfer> {
  RateModel rateModel;
  FocusNode _focus = new FocusNode();
  FocusNode _focus2 = new FocusNode();

  bool loading = false;
  ReceiveTransfer _dropDownValueForCountry;
  Banks _dropDownValueForBank;
  BanksAfrica _dropDownValueForBankAfrica;
  BankBranch _dropDownValueForBankBranch;
  bool error = false;
  bool userTagLoading = false;
  bool isCheckingRate = false;
  var amount;
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  StreamController<String> streamController = StreamController();
  StreamController<String> streamController3 = StreamController();
  StreamController<String> streamController2 = StreamController();
  TextEditingController _narration = TextEditingController();
  TextEditingController bankNigeria = new TextEditingController();


  TextEditingController bankAfrica = new TextEditingController();
  TextEditingController _accountNum = TextEditingController();
  TextEditingController _accountName = TextEditingController();
  final TextEditingController textController = new TextEditingController();
  MoneyMaskedTextController _amountController = MoneyMaskedTextController(
    decimalSeparator: ".",
    thousandSeparator: ",",
  );
  MoneyMaskedTextController _amountController2 =
      MoneyMaskedTextController(decimalSeparator: ".", thousandSeparator: ",");

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String _errortext;
  Flag _dropDownValue1;
  Flag _dropDownValue2;
  List<BanksAfrica> banksAfrica = [];
  List<BankBranch> branch = [];

bool  isButtonDisaled = true;
  List<Flag> flagList = [];
  List<Banks> resultBank;
  LoginState loginState;
  ConversionState conversionState;
  TransferState transferState;
  bool isLoading = false;
  bool isBankAfricaLoading = false;

  bool isBranchLoading = false;
  var codeNigeria;

  var codeAfrica;
  var bankName;
//  bool  loading = false;
  TagFetch tagFetch;

//  bool  error = false;
//  bool userTagLoading = false;
//  bool isCheckingRate = false;
  bool paymentLoading = false;
  var flagImage = "";
  var flagImage2 = "";
  var totalAmount;
  var realAmount;
  ResolveAccountModel resolveAccountModel;
  var accountNum;
  var clear = false;
  List<Banks> _tempListofBanks;

  List<BanksAfrica> _tempListofBanksAfrica;

  TransactionFee transactionFee  ;
  _validatetext() {
    setState(() {
      isLoading = false;
    });
    String s = amount.toString().replaceAll(RegExp(r"([.]*000)(?!.*\d)"), "");
    var cleanAmount = s.trim().replaceAll(",", "");
//    print("cleanAmount$cleanAmount");
    setState(() {
      realAmount = cleanAmount;
    });
    if (_amountController.text != "0.0" ||
        _amountController.text.length > 0 ||
        _amountController2.text.length > 0) {
      _focus.hasFocus ? getConversion(amount: cleanAmount) : getConversionreverse(amount: cleanAmount);
//      getAmountCharge();
      getTransactionFee();
    } else {
      // some other code here
    }
  }

  @override
  void initState() {
    super.initState();

    //bank name resolve
//    streamController3.stream.transform(debounce(Duration(milliseconds: 700)))
//        .listen((s) => _validateBankname());

//get conversion rate
    streamController.stream
        .transform(debounce(Duration(milliseconds: 1000)))
        .listen((s) => _validatetext());
  }

  @override
  Widget build(BuildContext context) {
    conversionState = Provider.of<ConversionState>(context);
    transferState = Provider.of<TransferState>(context);
    themeChangeProvider = Provider.of<DarkThemeProvider>(context);
    loginState = Provider.of<LoginState>(context);

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(

                borderRadius: BorderRadius.circular(7)
//
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Country",
                style: GoogleFonts.raleway(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      InputDecorator(
                        decoration: InputDecoration(
                          hintText: "Select recipient Country ",

                          hintStyle: GoogleFonts.raleway(
                              fontSize: 12,
                              color: themeChangeProvider.darkTheme
                                  ? Colors.white
                                  : kPrimaryColor),

                          contentPadding:EdgeInsets.fromLTRB(10,0,10,0),
                          border:  FormBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),

                          ),

                          fillColor: themeChangeProvider.darkTheme
                              ? kPrimaryDarkTextField
                              : kPrimaryColor.withOpacity(0.1),

                          filled: true,

                          labelStyle: TextStyle(
                            color: themeChangeProvider.darkTheme
                                ? Colors.white
                                : Colors.black, //This is an example of a change
                          ),
//                                                                  labelText: _dropDownValue == null ? "Select Monthly transaction volume " : " Select Monthly transaction volume",
                          errorText: _errortext,
                        ),
                        isEmpty: _dropDownValueForCountry == null,
                        child: DropdownButton<ReceiveTransfer>(
                          dropdownColor: themeChangeProvider.darkTheme
                              ? kPrimaryDarkTextField
                              : Colors.white,
                          value: _dropDownValueForCountry,
                          isDense: true,

                          onChanged: (ReceiveTransfer newValue) {
                            setState(() {
                              _dropDownValueForCountry = newValue;

                              resultBank = [];
//                              transactionFee.transfer_fee = "0";
                              banksAfrica = [];
                              branch = [];
                              _accountNum.text  =  "";
                              _accountName.text = "" ;
                              bankNigeria.text = "";
                                _amountController.text = "0.0";
                                _amountController2.text = "0.0";
                              bankAfrica.text = "";
                               _dropDownValueForBank = null;
                              _dropDownValueForBankAfrica = null;
                              _dropDownValueForCountry.country.country == "Nigeria"  ?  getBanks(country: _dropDownValueForCountry.country.country)
                            : getBanksAfrica(country: _dropDownValueForCountry.country.country);
                            });
                          },
                          items: widget.receiverCountry
                              .map((ReceiveTransfer value) {
                            return DropdownMenuItem<ReceiveTransfer>(
                              value: value,
                              child: Text(value.country.country,
                                  style: GoogleFonts.raleway(
                                      fontSize: 13,
                                      color: themeChangeProvider.darkTheme
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






        Form(
            key: _formKey,
            child: Column(
              children: [
                _dropDownValueForCountry != null ?  _dropDownValueForCountry.country.country == "Nigeria" ?


                Column(

                            children: [
//                              Row(
//                                children: [
//                                  Expanded(
//                                    child: Container(
//                                      margin: EdgeInsets.symmetric(
//                                          horizontal: 20, vertical: 12),
//                                      child: Column(
//                                        crossAxisAlignment: CrossAxisAlignment.start,
//                                        children: [
//                                          Text(
//                                            "Select Bank",
//                                            style: GoogleFonts.raleway(
//                                              fontWeight: FontWeight.w500,
//                                              fontSize: 12,
//                                              color: themeChangeProvider.darkTheme
//                                                  ? Colors.white
//                                                  : kPrimaryColor,
//                                            ),
//                                          ),
//                                          SizedBox(
//                                            height: 4,
//                                          ),
//                                          FormField(
//                                            builder: (FormFieldStatestate) {
//                                              return DropdownButtonHideUnderline(
//                                                  child: Column(
//                                                crossAxisAlignment:
//                                                    CrossAxisAlignment.stretch,
//                                                children: <Widget>[
//                                                  InputDecorator(
//                                                    decoration: InputDecoration(
//                                                      hintText:
//                                                          "Select recipient bank ",
//                                                      border: InputBorder.none,
////
////                                                      border: OutlineInputBorder(
////                                                          borderRadius: BorderRadius.circular(8),
////                                                          borderSide: BorderSide(
////                                                            width: 0,
////                                                            style: BorderStyle.none,
////                                                          )
////
////                                                      ),
//                                                      hintStyle: GoogleFonts.raleway(
//                                                          fontSize: 12,
//                                                          color: themeChangeProvider
//                                                                  .darkTheme
//                                                              ? Colors.white
//                                                              : kPrimaryColor),
//
////
//
//                                                      fillColor: themeChangeProvider
//                                                              .darkTheme
//                                                          ? kPrimaryDarkTextField
//                                                          : kPrimaryColor
//                                                              .withOpacity(0.1),
//
//                                                      filled: true,
//
//                                                      labelStyle: TextStyle(
//                                                        color: themeChangeProvider
//                                                                .darkTheme
//                                                            ? Colors.white
//                                                            : Colors
//                                                                .black, //This is an example of a change
//                                                      ),
////                                                                  labelText: _dropDownValue == null ? "Select Monthly transaction volume " : " Select Monthly transaction volume",
//                                                      errorText: _errortext,
//                                                    ),
//                                                    isEmpty: _dropDownValueForBank == [],
//                                                    child: DropdownButton<Banks>(
//                                                      icon: Icon(Icons
//                                                          .arrow_drop_down_rounded),
//                                                      dropdownColor:
//                                                          themeChangeProvider
//                                                                  .darkTheme
//                                                              ? kPrimaryDarkTextField
//                                                              : Colors.white,
//                                                      value: _dropDownValueForBank,
//                                                      isDense: true,
//                                                      onChanged: (Banks newValue) {
//                                                        setState(() {
//                                                          _dropDownValueForBank = newValue;
//
//                                                        });
//                                                      },
//                                                      items: resultBank
//                                                          .map((Banks value) {
//
//                                                            print(value);
//                                                        return DropdownMenuItem<
//                                                            Banks>(
//                                                          value: value,
//                                                          child: Text(value.bankName ?? "",
//                                                              style: GoogleFonts.raleway(
//                                                                  fontSize: 12,
//                                                                  color: themeChangeProvider
//                                                                          .darkTheme
//                                                                      ? Colors.white
//                                                                      : kPrimaryColor)),
//                                                        );
//                                                      }).toList(),
//                                                    ),
//                                                  ),
//                                                ],
//                                              ));
//                                            },
//                                          ),
//                                        ],
//                                      ),
//                                    ),
//                                  ),
//                                  if(isLoading)Row(
//                                    children: [
//                                      CupertinoActivityIndicator(),
//                                      SizedBox(width: 20),
//                                    ],
//                                  ),
//                                ],
//                              ),

                              //Account num


                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [


                              Text(
                                "Select Bank",
                                style: GoogleFonts.raleway(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: themeChangeProvider.darkTheme
                                      ? Colors.white
                                      : kPrimaryColor,
                                ),
                              ),
                          SizedBox(height: 4,),

                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  color: themeChangeProvider.darkTheme
                                      ? kPrimaryDarkTextField
                                      : kPrimaryColor.withOpacity(0.1),

                                ),
                                child:Container(
                                  width:MediaQuery.of(context).size.width,
                                  child: TextFormField(

                                    readOnly: true,
                                    style: GoogleFonts.raleway(

                                      fontSize: 13,
                                      color: themeChangeProvider.darkTheme
                                          ? Colors.white
                                          : kPrimaryColor,
                                    ),
                                    controller: bankNigeria,
                                    onTap: () {
                                      setState(() {

                                        _accountNum.text = "";
                                        _accountName.text = ""    ;
                                      });
                                      _showModalBankNigeria(context);
                                    },
                                    autofocus: true,
//                          keyboardType: TextInputType.emailAddress,

                                    decoration: InputDecoration(
                                  suffixIcon: isLoading ?  CupertinoActivityIndicator() : Icon(Icons.arrow_drop_down, color: themeChangeProvider.darkTheme ? Colors.white :Colors.grey,),


                                      contentPadding:EdgeInsets.fromLTRB(10,0,10,0),
                                      border:  FormBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),

                                      ),
                                      hintText: "Choose your bank",
                                      hintStyle: GoogleFonts.raleway(
                                          fontSize: 12,
                                          color: themeChangeProvider.darkTheme
                                              ? Colors.white
                                              : kPrimaryColor),
//                                                    contentPadding: const EdgeInsets.only(left: 10, right: 10)

                                    ),
                                  ),
                                ),
//                                Row(
//                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                  children: <Widget>[
//
//                                   IconButton(
//                                      icon: Icon(Icons.arrow_drop_down),
//                                      onPressed: () {
////                              showSheet();
//                                      },
//                                    )
//                                  ],
//                                ),

                              ),
                            ],
                          ),
                        ),

                              CustomTextField(
//                        color: kPrimaryColor.withOpacity(0.1),
                                header: "Enter Account Number",
                                hint: "0120112233",
                                type: FieldType.number,

                                onChanged: (v) {
                                  if (v.length < 10) {
                                    _accountName.text = "";
                                  } else if (v.length == 10) {
                                    resolveBankName();
                                  }

//                  setState(() {
//                    accountNum = v;
//
//                  });
                                },
                                controller: _accountNum,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "field is required";
                                  }

                                  if (value.length < 10) {
                                    return "Invalid Account number";
                                  }

                                  return null;
                                },
                              ),

                              //ACCOUNT NAME
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      color: kPrimaryColor.withOpacity(0.1),
                                      header: "Beneficiary Name",
                                      hint: "Sumaila Finidi",
                                      type: FieldType.text,
                                      onChanged: (value) {
//                                        print(value);
                                      },
                                      controller: _accountName,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Field is required";
                                        }

                                        return null;
                                      },
                                    ),
                                  ),
                                  if (loading)
                                    Row(
                                      children: [
                                        CupertinoActivityIndicator(),
                                        SizedBox(width: 20),
                                      ],
                                    ),
                                ],
                              ),

//                  You Send
                              Column(
                                children: [
                                  CustomTextField(
                                    focusNode: _focus,
                                    suffix: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Text(loginState.user.currency, style: GoogleFonts.raleway(color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor),),
                                    ),
                                    controller: _amountController,
                                    type: FieldType.number,
                                    onChanged: (value) {
                                      streamController.add(value);
                                      setState(() {
                                        amount = value;
                                      });

//                                      print("amount $amount");
                                    },
                                    prefixText: loginState.user.symbol,
                                    header: "You Send",
                                    hint: "1000",
                                  ),

//                      if(isCheckingRate)Row(
//                        children: [
//                          CupertinoActivityIndicator(),
//                          SizedBox(width: 20),
//                        ],
//                      ),

//                      Reciepient get
                                 Row(
                                    children: [
                                      Expanded(
                                        child: CustomTextField(
                                          readOnly: true,
                                          focusNode: _focus2,
                                          suffix: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Text(_dropDownValueForCountry.country.currency,  style: GoogleFonts.raleway(color:themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor)),
                                          ),
                                          controller: _amountController2,
                                          type: FieldType.number,
                                          onChanged: (value) {
                                            streamController.add(value);
                                            setState(() {
                                              amount = value;
                                            });
                                          },
                                          prefixText: _dropDownValueForCountry
                                              .country.symbol,
                                          header: "Recipient Get",
                                          hint: "1000",
                                        ),
                                      ),
                                      if (isCheckingRate)
                                        Row(
                                          children: [
                                            CupertinoActivityIndicator(),
                                            SizedBox(width: 20),
                                          ],
                                        ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ) :












//===============================// Africa Bank Field================================================

              banksInAfrica()      : Container()
//                _dropDownValueForCountry != null ?  _dropDownValueForCountry.country.country == "Nigeria" ?
//                Row(
//                  children: [
//                    Expanded(
//                      child: Center(
//                        child: Container(
//                          width: 370,
//                          margin: EdgeInsets.only(top: 10, left: 8, right: 8),
//                          decoration: BoxDecoration(
//                            color: themeChangeProvider.darkTheme
//                                ? kPrimaryDarkTextField
//                                : kPrimaryColor.withOpacity(0.1),
////                borderRadius: BorderRadius.circular(7)
////
//                          ),
//                          child: Container(
//                            width: 300,
//                            child: Row(
//                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                              children: <Widget>[
//                                Container(
//                                  width: 300,
//                                  child: TextFormField(
//                                    style: GoogleFonts.raleway(
//                                      fontWeight: FontWeight.w500,
//                                      fontSize: 12,
//                                      color: themeChangeProvider.darkTheme
//                                          ? Colors.white
//                                          : kPrimaryColor,
//                                    ),
//                            controller: bankNigeria,
//                                    onTap: () {
//                                  _showModalBankNigeria(context);
//                                    },
//                                    autofocus: true,
////                          keyboardType: TextInputType.emailAddress,
//
//                                    decoration: InputDecoration(
//                                        border: InputBorder.none,
//                                        hintText: "Choose your bank",
//                                        hintStyle: GoogleFonts.raleway(
//                                            fontSize: 12,
//                                            color: themeChangeProvider.darkTheme
//                                                ? Colors.white
//                                                : kPrimaryColor),
//                                        contentPadding: const EdgeInsets.only(left: 10, right: 10)),
//                                  ),
//                                ),
//                                IconButton(
//                                  icon: Icon(Icons.keyboard_arrow_down),
//                                  onPressed: () {
////                              showSheet();
//                                  },
//                                )
//                              ],
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
//
//                      if(isLoading)Row(
//                        children: [
//                          CupertinoActivityIndicator(),
//                          SizedBox(width: 20),
//                        ],
//                      ),
//                  ],
//                ) :
//
//
//                Row(
//                  children: [
//                    Expanded(
//                      child: Center(
//                        child: Container(
//                          width: 370,
//                          margin: EdgeInsets.only(top: 10, left: 8, right: 8),
//                          decoration: BoxDecoration(
//                            color: themeChangeProvider.darkTheme
//                                ? kPrimaryDarkTextField
//                                : kPrimaryColor.withOpacity(0.1),
////                borderRadius: BorderRadius.circular(7)
//
//                          ),
//                          child: Container(
//                            width: 300,
//                            child: Row(
//                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                              children: <Widget>[
//                                Container(
//                                  width: 300,
//                                  child: TextFormField(
//                                    style: GoogleFonts.raleway(
//                                      fontWeight: FontWeight.w500,
//                                      fontSize: 12,
//                                      color: themeChangeProvider.darkTheme
//                                          ? Colors.white
//                                          : kPrimaryColor,
//                                    ),
//                        controller: bankAfrica,
//                                    onTap: () {
////                                showSheet();
//                                      _showModalBankAfrica(context);
//                                    },
//                                    autofocus: true,
////                          keyboardType: TextInputType.emailAddress,
//
//                                    decoration: InputDecoration(
//                                        border: InputBorder.none,
//                                        hintText: "Choose your bank",
//                                        hintStyle: GoogleFonts.raleway(
//                                            fontSize: 12,
//                                            color: themeChangeProvider.darkTheme
//                                                ? Colors.white
//                                                : kPrimaryColor),
//                                        contentPadding: const EdgeInsets.only(left: 10, right: 10)),
//                                  ),
//                                ),
//                                IconButton(
//                                  icon: Icon(Icons.keyboard_arrow_down),
//                                  onPressed: () {
//
//                                    _showModalBankAfrica(context);
//                                  },
//                                )
//                              ],
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
//                      if(isBankAfricaLoading)Row(
//                                    children: [
//                                      CupertinoActivityIndicator(),
//                                      SizedBox(width: 20),
//                                    ],
//                                  ),
//                  ],
//                ) : Container(),

              ],
            )),










       Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Narration",
                style: GoogleFonts.raleway(
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
              TextFormField(
                style: GoogleFonts.raleway(


                    color: themeChangeProvider.darkTheme
                        ? Colors.white
                        : kPrimaryColor),
                controller: _narration,
                decoration: InputDecoration(
                  border: FormBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  contentPadding: const EdgeInsets.only(
                      left: 14.0, bottom: 12.0, top: 10.0),
                  fillColor: themeChangeProvider.darkTheme
                      ? kPrimaryDarkTextField
                      : kPrimaryColor.withOpacity(0.1),
                  filled: true,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 5,
//                  maxLength: 100,
              )
            ],
          ),
        ),
     rateModel == null ? Container() :    Padding(
          padding: const EdgeInsets.only(right: 20, left: 20, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Funds should arrive in minutes",
                  style: GoogleFonts.raleway(
                    color: themeChangeProvider.darkTheme
                        ? Colors.white
                        : kPrimaryColor,
                    fontSize: 11,
                  )),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Exchange rate",
                      style: GoogleFonts.raleway(
                        color: themeChangeProvider.darkTheme
                            ? Colors.white
                            : kPrimaryColor,
                        fontSize: 9,
                      )),
                  Text.rich(TextSpan(children: [
                    TextSpan(
                        text: "1 ${loginState.user.currency} = ",
                        style: GoogleFonts.raleway(
                          color: themeChangeProvider.darkTheme
                              ? Colors.white
                              : kPrimaryColor,
                          fontSize: 9,
                        )),
                    TextSpan(
                        text: " ${rateModel.rate} ${_dropDownValueForCountry.country.currency}",
                        style: GoogleFonts.raleway(
                            color: kprimaryGreen,
                            fontSize: 9,
                            fontWeight: FontWeight.bold)),
                  ])),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Fee",
                      style: GoogleFonts.raleway(
                        color: themeChangeProvider.darkTheme
                            ? Colors.white
                            : kPrimaryColor,
                        fontSize: 9,
                      )),
                  Text(" ${transactionFee != null ?  transactionFee.transfer_fee : "0"}   ",
                      style: GoogleFonts.raleway(
                          color: kprimaryGreen,
                          fontSize: 9,
                          fontWeight: FontWeight.bold)),
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: double.maxFinite,
            height: 50,
            child: RaisedButton(
              disabledColor: isButtonDisaled ?   kprimaryLight : kPrimaryColor,
              onPressed:  isButtonDisaled ? null : () async {
                if (_formKey.currentState.validate()) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Preloader();
                    },
                  );
                  List list = await TransactionPinService.hasPin(
                    token: loginState.user.token,
                  );
//                  print(list.last);
                  Navigator.pop(context);
                  showModalBottomSheet(
                    isDismissible: true,
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => transactionPin(context, list.last,
                        continueTransaction: (validated, message) {
//                      print(validated);
//                      print(message);
                      Navigator.pop(context);
                      if (validated) {
                     _dropDownValueForCountry.country.country == "Nigeria"  ? sendBankMoney() : sendMoneyAfrica();
                      } else {
                        widget.scaf.currentState.showSnackBar(
                          SnackBar(
                            content: Text(message),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }, enablingFailed: (message) {
                      widget.scaf.currentState.showSnackBar(
                        SnackBar(
                          content: Text(message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }),
                  );
                }
              },
              child: Text(
                "PROCEED",
                style: GoogleFonts.mavenPro(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
              color: kPrimaryColor,
              padding: EdgeInsets.symmetric(vertical: 15),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }













  void resolveBankName() async {
    if (_dropDownValueForCountry.country.country == "Nigeria" && codeNigeria == null ) {
      return toast("Choose a Nigerian Bank");
    }else if(_dropDownValueForCountry.country.country != "Nigeria" && codeAfrica == null) {
      return toast("Choose a  Bank");

    }
    setState(() {
      loading = true;
    });
//    print("resolve");
    var result = await transferState.resolveBankName(
        token: loginState.user.token,
        bank_code: _dropDownValueForCountry.country.country == "Nigeria" ?  codeNigeria : codeAfrica,
        account_number: _accountNum.text);
    setState(() {
      loading = false;
    });
    if (result["error"] &&
        result["message"] == "You are not authorized to make this request") {
//      print("jdjdjdhd");
      showDialog(
          barrierDismissible: false,
          context: context,
          child: dialogPopup(
              themeDark: themeChangeProvider.darkTheme,
              body: Text(
                "Session has ended,Please Login again",
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
    }
    else  if (result["error"] == false) {
        if(result["message"] ==  "No resolve"){
          toast("Couldn't  resolve account, carefully type out the account number and account name");
        }else{
          setState(() {
            resolveAccountModel = result["accName"];
            _accountName.text = resolveAccountModel.account_name;
          });
        }

    }else{
      CommonUtils.showMsg(result["message"], themeChangeProvider, context, widget.scaf, kPrimaryColor);
    }
  }

  getConversion({amount}) async {
//    print("called");
//    print("hhahahah$amount");
    if (amount != "0.0") {
      setState(() {
        isCheckingRate = true;
      });
      var result = await conversionState.conversion(
          firstCurrency: loginState.user.currency,
          secondCurrency: _dropDownValueForCountry.country.currency,
          firstAmount: _amountController.text.trim().replaceAll(",", ""));
      if (result["error"] &&
          result["message"] == "You are not authorized to make this request") {
//        print("jdjdjdhd");
        showDialog(
            barrierDismissible: false,
            context: context,
            child: dialogPopup(
                themeDark: themeChangeProvider.darkTheme,
                body: Text(
                  "Session has ended,Please Login again",
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
          rateModel = result["message"];
          isCheckingRate = false;
          isButtonDisaled = false;
          _focus2.hasFocus
              ? _amountController.text = rateModel.formated_amount.toString()
              : _focus.hasFocus
                  ? _amountController2.text =
                      rateModel.formated_amount.toString()
                  : " ";
        });
      }else{
        CommonUtils.showMsg(result["message"], themeChangeProvider, context,
            widget.scaf, kPrimaryColor);
      }

//      print(result);
    } else {
      setState(() {
//        _amountController2.text = "0.0";
//        _amountController.text = "0.0";
      });
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
            ? _amountController.text = rateModel.formated_amount.toString()
            : _focus.hasFocus
                ? _amountController2.text =
                    (rateModel.formated_amount).toString()
                : " ";
      });
    }else{
      CommonUtils.showMsg(result["message"], themeChangeProvider, context,
          widget.scaf, kPrimaryColor);
    }

//    print(result);
  }

  Container transactionPin(
    BuildContext context,
    bool hasPin, {
    Function(bool validated, String message) continueTransaction,
    Function(String message) enablingFailed,
  }) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          Expanded(
            child: TransactionConfirmationScreen(
              isDark: themeChangeProvider.darkTheme,
              hasPin: hasPin,
              onClickContinue: (pin) async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Preloader();
                  },
                );
                if (hasPin) {
                  var list = await TransactionPinService.validatePin(
                    pin: (pin),
                    purpose:
                        "Bank transfer to $accountNum, Bank: $_dropDownValueForBank",
                    token: loginState.user.token,
                  );
                  Navigator.pop(context);
                  continueTransaction(list.first, list.last);
                } else {
                  var list = await TransactionPinService.enablePin(
                    pin: (pin),
                    token: loginState.user.token,
                  );
                  Navigator.pop(context);
                  if (list.first) {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => transactionPin(context, true,
                          continueTransaction: continueTransaction,
                          enablingFailed: enablingFailed),
                    );
                  } else {
                    Navigator.pop(context);
                    enablingFailed(list.last);
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }




//Nigeria
  sendBankMoney() async {
//    print("send Rex money");
//    print("called");
    setState(() {
      paymentLoading = true;
    });

    if (paymentLoading) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Preloader();
          });
    }
//    String s = _amountController.text.toString().replaceAll(RegExp(r"([.]*00)(?!.*\d)"), "");
//    var amount = s.trim().replaceAll(",", "");
//    print("amount$amount");
    var result = await transferState.interBankFunding(
        amount: _amountController.text.trim().replaceAll(",", ""),
        bank_code: codeNigeria,
        account_number: _accountNum.text,
        narration: _narration.text,
        token: loginState.user.token);
    if (paymentLoading) {
      Navigator.pop(context, true);
    }
    if (result["error"] &&
        result["message"] == "You are not authorized to make this request") {
//      print("jdjdjdhd");
      showDialog(
          barrierDismissible: false,
          context: context,
          child: dialogPopup(
              themeDark: themeChangeProvider.darkTheme,
              body: Text(
                "Session has ended,Please Login again",
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
    }  else if (result["error"] == false) {
//      CommonUtils.showSuccessDialog(
//          context: context,
//          themeChangeProvider: themeChangeProvider,
//          text: "Transaction Successful",
//          onClose: () {
//            Navigator.push(
//                context, MaterialPageRoute(builder: (context) => Home()));
//          });

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Notif(
            message: result["message"],
          )),
              (Route<dynamic> route) => false);
    } else {
      CommonUtils.showMsg(result["message"], themeChangeProvider, context,
          widget.scaf, kPrimaryColor);
    }
  }



//Africa
sendMoneyAfrica()async{

  setState(() {
    paymentLoading = true;
  });

  if (paymentLoading) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
  }
//    print("called africa");
   var result =  await transferState.interBankFundingAfrica(amount: _amountController.text.trim().replaceAll(",", ""),
       account_number: _accountNum.text,
       account_bank: codeAfrica,
       destination_branch_code: _dropDownValueForBankBranch != null ?  _dropDownValueForBankBranch.branch_code : "",
       beneficiary_name:_accountName.text ,
       currency: _dropDownValueForCountry.country.currency,
     narration: _narration.text,
     token: loginState.user.token
   );
  if (paymentLoading) {
    Navigator.pop(context, true);
  }
    if (result["error"] &&
        result["message"] == "You are not authorized to make this request") {
//      print("jdjdjdhd");
      showDialog(
          barrierDismissible: false,
          context: context,
          child: dialogPopup(
              themeDark: themeChangeProvider.darkTheme,
              body: Text(
                "Session has ended,Please Login again",
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
    }
    else if (result["error"] == false) {

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Notif(
            message: result["message"],
          )),
              (Route<dynamic> route) => false);
    } else {
      CommonUtils.showMsg(result["message"], themeChangeProvider, context,
          widget.scaf, kPrimaryColor);
    }

}



  Future getBanks({country}) async {
    setState(() {
      isLoading = true;
    });

    var result = await transferState.fetchBank(token: loginState.user.token, country:country );
    if (result["error"] &&
        result["message"] == "You are not authorized to make this request") {
//      print("jdjdjdhd");
      showDialog(
          barrierDismissible: false,
          context: context,
          child: dialogPopup(
              themeDark: themeChangeProvider.darkTheme,
              body: Text(
                "Session has ended,Please Login again",
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
    }

    else if (result["error"] == false) {
      setState(() {
        isLoading = false;
        resultBank = result["banks"];
      });
    }else{
      CommonUtils.showMsg(result["message"], themeChangeProvider, context,
          _scaffoldKey, kPrimaryColor);
    }
  }




  Future getBanksAfrica({country}) async {
    setState(() {
      isBankAfricaLoading = true;
    });

    var result = await transferState.fetchBankAfrica(token: loginState.user.token, country:country );
    if (result["error"] &&
        result["message"] == "You are not authorized to make this request") {
//      print("jdjdjdhd");
      showDialog(
          barrierDismissible: false,
          context: context,
          child: dialogPopup(
              themeDark: themeChangeProvider.darkTheme,
              body: Text(
                "Session has ended,Please Login again",
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
    }

    else if (result["error"] == false) {
      setState(() {
        isBankAfricaLoading = false;
        banksAfrica = result["banks"];
      });
    }else{
      CommonUtils.showMsg(result["message"], themeChangeProvider, context,
          _scaffoldKey, kPrimaryColor);
    }
  }

Future getbankBranch({id}) async{
    setState(() {
      isBranchLoading = true;
    });
    var result =  await transferState.fetchBankBranchAfrica(token: loginState.user.token, id: id);
    setState(() {
      isBranchLoading = false;
    });
    if (result["error"] &&
        result["message"] == "You are not authorized to make this request") {
//      print("jdjdjdhd");
      showDialog(
          barrierDismissible: false,
          context: context,
          child: dialogPopup(
              themeDark: themeChangeProvider.darkTheme,
              body: Text(
                "Session has ended,Please Login again",
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
    }
    else  if(result['error']== false){
        setState(() {
          branch = result["branch"];
        });
//        print(branch);
      }else{
      CommonUtils.showMsg(result["message"], themeChangeProvider, context,
          _scaffoldKey, kPrimaryColor);
    }
}



  void _showModalBankNigeria(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
        ),
        context: context,
        builder: (context) {
          //3
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return DraggableScrollableSheet(
                    expand: false,
                    builder:
                        (BuildContext context, ScrollController scrollController) {
                      return Column(children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: TextField(
                                      style: GoogleFonts.raleway(
                                        color: themeChangeProvider.darkTheme
                                            ? Colors.white
                                            : kPrimaryColor,
                                        fontSize: 12,
                                      ),

                                      controller: textController,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(8),
                                        border: new OutlineInputBorder(
                                          borderRadius:
                                          new BorderRadius.circular(15.0),
                                          borderSide: new BorderSide(),
                                        ),
                                        prefixIcon: Icon(Icons.search),
                                      ),
                                      onChanged: (value) {
                                        //4
                                        setState(() {
                                          _tempListofBanks = _buildSearchList(value);
                                        });
                                      })),
                              IconButton(
                                  icon: Icon(Icons.close),
                                  color: kPrimaryColor,
                                  onPressed: () {
                                    setState(() {
                                      textController.clear();

                                      _tempListofBanks.clear();
                                    });
                                  }),
                            ])),
                        Expanded(
                          child: ListView.separated(
                              controller: scrollController,
                              //5
                              itemCount: (_tempListofBanks != null && _tempListofBanks.length > 0) ? _tempListofBanks.length : resultBank.length,
                              separatorBuilder: (context, int) {
                                return Column(
                                  children: [
                                    SizedBox(height: 5,),
                                    Divider(color: themeChangeProvider.darkTheme ? Colors.white: Colors.grey,),
                                    SizedBox(height: 5,),
                                  ],
                                );
                              },
                              itemBuilder: (context, index) {
                                return InkWell(

                                  //6
                                    child: (_tempListofBanks != null && _tempListofBanks.length > 0) ? _showBottomSheetWithSearch(index, _tempListofBanks)
                                        : _showBottomSheetWithSearch(index, resultBank),
                                    onTap: () {
                                      //7

                                      (_tempListofBanks != null && _tempListofBanks.length > 0)  ?


                                      setState(() {
                                        bankNigeria.text = _tempListofBanks[index].bankName;
                                        codeNigeria = _tempListofBanks[index].bankCode;
                                      })


                                      :


                                      setState(() {
                                        bankNigeria.text =   resultBank[index].bankName;
                                        codeNigeria = resultBank[index].bankCode;
                                      });

//                                      print(codeNigeria);
//                                      print(bankNigeria.text);

                                      Navigator.of(context).pop();
                                    });
                              }),
                        )
                      ]);
                    });
              });
        });
  }


  Widget _showBottomSheetWithSearch(int index, List<Banks> listOfCities) {
    return Text(listOfCities[index].bankName,
        style:  GoogleFonts.raleway(color: themeChangeProvider.darkTheme ?Colors.white: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 16),textAlign: TextAlign.center);
  }

  List<Banks> _buildSearchList(String userSearchTerm) {
    List<Banks> _searchList = List();

    for (int i = 0; i < resultBank.length; i++) {
      String name = resultBank[i].bankName;
      String code = resultBank[i].bankCode;
//  print("name ${name}  code ${code}");
      if (name.toLowerCase().contains(userSearchTerm.toLowerCase())) {
        _searchList.add(resultBank[i]);
      }
    }
    return _searchList;
  }










//  Africa
  void _showModalBankAfrica(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
        ),
        context: context,
        builder: (context) {
          //3
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return DraggableScrollableSheet(
                    expand: false,
                    builder:
                        (BuildContext context, ScrollController scrollController) {
                      return Column(children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: TextField(

                                      style: GoogleFonts.raleway(
                                color: themeChangeProvider.darkTheme
                                ? Colors.white
                                    : kPrimaryColor,
                                fontSize: 12,
                                ),
                                      controller: textController,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(8),
                                        border: new OutlineInputBorder(
                                          borderRadius:
                                          new BorderRadius.circular(15.0),
                                          borderSide: new BorderSide(),
                                        ),
                                        prefixIcon: Icon(Icons.search),
                                      ),
                                      onChanged: (value) {
                                        //4
                                        setState(() {
                                          _tempListofBanksAfrica = _buildSearchListAfrica(value);
                                        });
                                      })),
                              IconButton(
                                  icon: Icon(Icons.close),
                                  color: kPrimaryColor,
                                  onPressed: () {
                                    setState(() {
                                      textController.clear();

                                      _tempListofBanksAfrica.clear();
                                    });
                                  }),
                            ])),
                        Expanded(
                          child: ListView.separated(
                              controller: scrollController,
                              //5
                              itemCount: (_tempListofBanksAfrica != null && _tempListofBanksAfrica.length > 0) ? _tempListofBanksAfrica.length : banksAfrica.length,
                              separatorBuilder: (context, int) {
                                return Column(
                                  children: [

                                    SizedBox(height: 5,),
                                    Divider(),
                                    SizedBox(height: 5,),
                                  ],
                                );
                              },
                              itemBuilder: (context, index) {
                                return InkWell(

                                  //6
                                    child: (_tempListofBanksAfrica != null && _tempListofBanksAfrica.length > 0) ? _showBottomSheetWithSearchAfrica(index, _tempListofBanksAfrica)
                                        : _showBottomSheetWithSearchAfrica(index, banksAfrica),
                                    onTap: () {
                                      //7


                                      (_tempListofBanksAfrica != null && _tempListofBanksAfrica.length > 0)  ?


                                      setState(() {

                                        bankAfrica.text = _tempListofBanksAfrica[index].name;
                                        codeAfrica = _tempListofBanksAfrica[index].code;
                                      })


                                          :


                                      setState(() {
                                        bankAfrica.text =        banksAfrica[index].name;
                                        codeAfrica = banksAfrica[index].code;
                                      });




                                      Navigator.of(context).pop();
                                    });
                              }),
                        )
                      ]);
                    });
              });
        });
  }


  Widget _showBottomSheetWithSearchAfrica(int index, List<BanksAfrica> listOfCities) {
    return Text(listOfCities[index].name,
        style:  GoogleFonts.raleway(color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 16),textAlign: TextAlign.center);
  }

  List<BanksAfrica> _buildSearchListAfrica(String userSearchTerm) {
    List<BanksAfrica> _searchList = List();

    for (int i = 0; i < banksAfrica.length; i++) {
      String name = banksAfrica[i].name;
      if (name.toLowerCase().contains(userSearchTerm.toLowerCase())) {
        _searchList.add(banksAfrica[i]);
      }
    }
    return _searchList;
  }


//  void getAmountCharge()async{
//    var result = await conversionState.getAccountCharges(amount:  _amountController.text.trim().replaceAll(",", ""), token: loginState.user.token);
//    if (result["error"] &&
//        result["message"] == "You are not authorized to make this request") {
//      print("jdjdjdhd");
//      showDialog(
//          barrierDismissible: false,
//          context: context,
//          child: dialogPopup(
//              themeDark: themeChangeProvider.darkTheme,
//              body: Text(
//                "Session has ended,Please Login again",
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
//    } else if(result["error"] == false){
//      setState(() {
//        transactionFee = result["data"].toString();
//      });
//    }
//
//  }

//FEE
  void getTransactionFee()async{
    var result = await transferState.getFees(amount:  _amountController.text.trim().replaceAll(",", ""), token: loginState.user.token, country_id: _dropDownValueForCountry.country_id);
//   print(result);
    if (result["error"] &&
        result["message"] == "You are not authorized to make this request") {
//      print("jdjdjdhd");
      showDialog(
          barrierDismissible: false,
          context: context,
          child: dialogPopup(
              themeDark: themeChangeProvider.darkTheme,
              body: Text(
                "Session has ended,Please Login again",
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
    } else if(result["error"] == false){
      setState(() {
        transactionFee = result["fee"];
//        print(        transactionFee.transfer_fee);
      });
    }else
      {}

  }





  Widget banksInAfrica(){
    return Column(


      children: [



        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Bank",
                style: GoogleFonts.raleway(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: themeChangeProvider.darkTheme
                      ? Colors.white
                      : kPrimaryColor,
                ),
              ),
              SizedBox(height: 4,),
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
//                          margin: EdgeInsets.only(top: 10, left: 8, right: 8),
                        decoration: BoxDecoration(
                          color: themeChangeProvider.darkTheme
                              ? kPrimaryDarkTextField
                              : kPrimaryColor.withOpacity(0.1),
//                borderRadius: BorderRadius.circular(7)

                        ),
                        child: Container(
                          width: 300,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: 300,
                                child: TextFormField(
                                  style: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: themeChangeProvider.darkTheme
                                        ? Colors.white
                                        : kPrimaryColor,
                                  ),
                                  controller: bankAfrica,
                                  onTap: () {

                                    _showModalBankAfrica(context);
                                  },
//                                    autofocus: true,


                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Choose your bank",
                                      hintStyle: GoogleFonts.raleway(
                                          fontSize: 12,
                                          color: themeChangeProvider.darkTheme
                                              ? Colors.white
                                              : kPrimaryColor),
                                      contentPadding: const EdgeInsets.only(left: 10, right: 10)),
                                ),
                              ),
                              isBankAfricaLoading ?   Row(
                                children: [
                                  CupertinoActivityIndicator(),
                                  SizedBox(width: 20),
                                ],
                              ):  IconButton(
                                icon: Icon(Icons.arrow_drop_down),
                                onPressed: () {
                                  _showModalBankAfrica(context);
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),





//                    Row(
//                      children: [
//                        Expanded(
//                          child: Container(
//                            margin: EdgeInsets.symmetric(
//                                horizontal: 20, vertical: 12),
//                            child: Column(
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              children: [
//                                Text(
//                                  "Select Bank",
//                                  style: GoogleFonts.raleway(
//                                    fontWeight: FontWeight.w500,
//                                    fontSize: 12,
//                                    color: themeChangeProvider.darkTheme
//                                        ? Colors.white
//                                        : kPrimaryColor,
//                                  ),
//                                ),
//                                SizedBox(
//                                  height: 4,
//                                ),
//                                FormField(
//                                  builder: (FormFieldStatestate) {
//                                    return DropdownButtonHideUnderline(
//                                        child: Column(
//                                          crossAxisAlignment:
//                                          CrossAxisAlignment.stretch,
//                                          children: <Widget>[
//                                            InputDecorator(
//                                              decoration: InputDecoration(
//                                                hintText:
//                                                "Select recipient bank",
//
//                                                border: InputBorder.none,
//                                                focusedBorder: InputBorder.none,
//                                                enabledBorder: InputBorder.none,
//                                                errorBorder: InputBorder.none,
//                                                disabledBorder: InputBorder.none,
//                                                hintStyle: GoogleFonts.raleway(
//                                                    fontSize: 12,
//                                                    color: themeChangeProvider
//                                                        .darkTheme
//                                                        ? Colors.white
//                                                        : kPrimaryColor),
//
////
//
//                                                fillColor: themeChangeProvider
//                                                    .darkTheme
//                                                    ? kPrimaryDarkTextField
//                                                    : kPrimaryColor
//                                                    .withOpacity(0.1),
//
//                                                filled: true,
//
//                                                labelStyle: TextStyle(
//                                                  color: themeChangeProvider
//                                                      .darkTheme
//                                                      ? Colors.white
//                                                      : Colors
//                                                      .black, //This is an example of a change
//                                                ),
////                                                                  labelText: _dropDownValue == null ? "Select Monthly transaction volume " : " Select Monthly transaction volume",
//                                                errorText: _errortext,
//                                              ),
//                                              isEmpty: _dropDownValueForBankAfrica == "Select Recipient bank",
//                                              child: DropdownButton<BanksAfrica>(
//                                                icon: Icon(Icons
//                                                    .arrow_drop_down_rounded),
//                                                dropdownColor:
//                                                themeChangeProvider
//                                                    .darkTheme
//                                                    ? kPrimaryDarkTextField
//                                                    : Colors.white,
//                                                value: _dropDownValueForBankAfrica,
//                                                isDense: true,
//                                                onChanged: (BanksAfrica newValue) {
//                                                  setState(() {
//                                                    _dropDownValueForBankAfrica = newValue;
//                                                        branch = [];
//                                                        _dropDownValueForBankBranch = null;
//                                                    getbankBranch(id: _dropDownValueForBankAfrica.id);
//                                                  });
//                                                },
//                                                items: banksAfrica.map((BanksAfrica value) {
//
//                                                  print(value);
//                                                  return DropdownMenuItem<
//                                                      BanksAfrica>(value: value,
//                                                    child: Text(value.name ?? "i no know",
//                                                        style: GoogleFonts.raleway(
//                                                            fontSize: 12,
//                                                            color: themeChangeProvider
//                                                                .darkTheme
//                                                                ? Colors.white
//                                                                : kPrimaryColor)),
//                                                  );
//                                                }).toList(),
//                                              ),
//                                            ),
//                                          ],
//                                        ));
//                                  },
//                                ),
//                              ],
//                            ),
//                          ),
//                        ),
//                        if(isBankAfricaLoading)Row(
//                          children: [
//                            CupertinoActivityIndicator(),
//                            SizedBox(width: 20),
//                          ],
//                        ),
//                      ],
//                    ),







        // BranchCode
        isBranchLoading ?   CupertinoActivityIndicator(): branch.length == 0 ?  Container() :Container(
          margin: EdgeInsets.symmetric(
              horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Bank Branch",
                style: GoogleFonts.raleway(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
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
                              hintText:
                              "Select Bank branch ",

                              hintStyle: GoogleFonts.raleway(
                                  fontSize: 12,
                                  color: themeChangeProvider
                                      .darkTheme
                                      ? Colors.white
                                      : kPrimaryColor),
                              border: InputBorder.none,
//

                              fillColor: themeChangeProvider
                                  .darkTheme
                                  ? kPrimaryDarkTextField
                                  : kPrimaryColor
                                  .withOpacity(0.1),

                              filled: true,

                              labelStyle: TextStyle(
                                color: themeChangeProvider
                                    .darkTheme
                                    ? Colors.white
                                    : Colors
                                    .black, //This is an example of a change
                              ),
//                                                                  labelText: _dropDownValue == null ? "Select Monthly transaction volume " : " Select Monthly transaction volume",
                              errorText: _errortext,
                            ),
                            isEmpty: _dropDownValueForBankBranch == "Select Recipient bank",
                            child: DropdownButton<BankBranch>(
                              icon: Icon(Icons
                                  .arrow_drop_down_rounded),
                              dropdownColor:
                              themeChangeProvider
                                  .darkTheme
                                  ? kPrimaryDarkTextField
                                  : Colors.white,
                              value: _dropDownValueForBankBranch,
                              isDense: true,
                              onChanged: (BankBranch newValue) {
                                setState(() {
                                  _dropDownValueForBankBranch = newValue;


                                });
                              },
                              items: branch.map((BankBranch value) {

//                                print(value);
                                return DropdownMenuItem<
                                    BankBranch>(value: value,
                                  child: Text(value.branch_name ?? "i no know",
                                      style: GoogleFonts.raleway(
                                          fontSize: 12,
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






        //Account num
        CustomTextField(
//                        color: kPrimaryColor.withOpacity(0.1),
          header: "Enter Account Number",
          hint: "0120112233",
          type: FieldType.number,

          onChanged: (v) {
            if (v.length < 7) {
              _accountName.text = "";
            } else if (v.length == 10) {
              resolveBankName();
            }

//                  setState(() {
//                    accountNum = v;
//
//                  });
          },
          controller: _accountNum,
          validator: (value) {
            if (value.isEmpty) {
              return "field is required";
            }

            if (value.length < 10) {
              return "Invalid Account number";
            }

            return null;
          },
        ),

        //ACCOUNT NAME
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                color: kPrimaryColor.withOpacity(0.1),
                header: "Beneficiary Name",
                hint: "Sumaila Finidi",
                type: FieldType.text,
                onChanged: (value) {
//                  print(value);
                },
                controller: _accountName,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Field is required";
                  }

                  return null;
                },
              ),
            ),
            if (loading)
              Row(
                children: [
                  CupertinoActivityIndicator(),
                  SizedBox(width: 20),
                ],
              ),
          ],
        ),

//                  You Send
        Column(
          children: [
            CustomTextField(
              focusNode: _focus,
              suffix: Padding(
                padding: const EdgeInsets.all(15),
                child: Text(loginState.user.currency),
              ),
              controller: _amountController,
              type: FieldType.number,
              onChanged: (value) {
                streamController.add(value);
                setState(() {
                  amount = value;
                });

//                print("amount $amount");
              },
              prefixText: loginState.user.symbol,
              header: "You Send",
              hint: "1000",
            ),

//                      if(isCheckingRate)Row(
//                        children: [
//                          CupertinoActivityIndicator(),
//                          SizedBox(width: 20),
//                        ],
//                      ),

//                      Reciepient get
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    readOnly: true,
                    focusNode: _focus2,
                    suffix: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(_dropDownValueForCountry.country.currency),
                    ),
                    controller: _amountController2,
                    type: FieldType.number,
                    onChanged: (value) {
                      streamController.add(value);
                      setState(() {
                        amount = value;
                      });
                    },
                    prefixText: _dropDownValueForCountry
                        .country.symbol,
                    header: "Recipient Get",
                    hint: "1000",
                  ),
                ),
                if (isCheckingRate)
                  Row(
                    children: [
                      CupertinoActivityIndicator(),
                      SizedBox(width: 20),
                    ],
                  ),
              ],
            )
          ],
        )
      ],
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // TODO: implement afterFirstLayout
  }

}

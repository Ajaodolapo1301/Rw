import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/api/transactionpinService.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/models/bankBranchModel.dart';
import 'package:rex_money/models/banks.dart';
import 'package:rex_money/models/flags.dart';
import 'package:rex_money/models/mobileMoneyModel.dart';
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

class MobileMoneyTransfer extends StatefulWidget {
  List<ReceiveTransfer> receiverCountry;
  List<Banks> resultBank;

  final GlobalKey<ScaffoldState> scaf;

  MobileMoneyTransfer({this.resultBank, this.receiverCountry, this.scaf});

  @override
  _MobileMoneyTransferState createState() => _MobileMoneyTransferState();
}

class _MobileMoneyTransferState extends State<MobileMoneyTransfer> with AfterLayoutMixin<MobileMoneyTransfer> {
  RateModel rateModel;
  FocusNode _focus = new FocusNode();
  FocusNode _focus2 = new FocusNode();

  bool loading = false;
  ReceiveTransfer _dropDownValueForCountry;
//  Banks _dropDownValueForBank;
  MobileMoneyModel _dropDownValueForMobileMoney;

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
  TransactionFee transactionFee ;
bool isMobileProviderLoading =false;
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
  List<MobileMoneyModel> mobileMoney = [];
  List<BankBranch> branch = [];

  bool  isButtonDisaled = true;
  List<Flag> flagList = [];
  List<Banks> resultBank;
  LoginState loginState;
  ConversionState conversionState;
  TransferState transferState;
  bool isLoading = false;
  bool isBankAfricaLoading = false;
  List <MobileMoneyModel> mobileMoneyModel  =  [];
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

  List<ReceiveTransfer> receiverCountryMobile = [];
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
      _focus.hasFocus ? getConversion(amount: cleanAmount) : getConversionreverse(amount: cleanAmount);
      getTransactionFee();
    } else {
      // some other code here
    }
  }

  @override
  void initState() {
    super.initState();



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
print(loginState.user);
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
                  fontWeight: FontWeight.bold  ,
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
                              hintText: "Select  Country ",

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
//                            suffixIcon:  isLoading ?  CupertinoActivityIndicator() : Icon(Icons.arrow_drop_down),
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
                              icon: isLoading ? Container(
                                  height: 3,
                                  child: CupertinoActivityIndicator()) : Icon(Icons.arrow_drop_down),
                              dropdownColor: themeChangeProvider.darkTheme
                                  ? kPrimaryDarkTextField
                                  : Colors.white,
                              value: _dropDownValueForCountry,
                              isDense: true,
                              onChanged: (ReceiveTransfer newValue) {
                                setState(() {
                                  _dropDownValueForCountry = newValue;

                                  rateModel = null;
                                  mobileMoney = [];
                                    isButtonDisaled = true;
                                  _accountNum.text  =  "";
                                  _accountName.text = "" ;
                                  _amountController.text = "0.00";
                                  transactionFee = null;


                                  _amountController2.text = "0.00";
                                  _dropDownValueForMobileMoney = null;
                                  getNetworksAfrica(country: _dropDownValueForCountry.country_id);
                                });
                              },
                              items:  isLoading  ? []:  receiverCountryMobile.map((ReceiveTransfer value) {
                                return DropdownMenuItem<ReceiveTransfer>(
                                  value: value,
                                  child: Text(value.country.country,
                                      style: GoogleFonts.raleway(
                                          fontSize: 12,
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




                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Select Provider",
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
                                          "Select Provider",

                                                contentPadding:EdgeInsets.fromLTRB(10,0,10,0),
                                                border:  FormBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),

                                                ),
                                          hintStyle: GoogleFonts.raleway(
                                              fontSize: 13,
                                              color: themeChangeProvider
                                                  .darkTheme
                                                  ? Colors.white
                                                  : kPrimaryColor),

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
                                        isEmpty: _dropDownValueForMobileMoney == null,
                                        child: DropdownButton<MobileMoneyModel>(
                                          iconSize: 20,
    icon: isBankAfricaLoading ?CupertinoActivityIndicator() : Icon(Icons.arrow_drop_down),
                                          dropdownColor:
                                          themeChangeProvider
                                              .darkTheme
                                              ? kPrimaryDarkTextField
                                              : Colors.white,
                                          value: _dropDownValueForMobileMoney,
                                          isDense: true,
                                          onChanged: (MobileMoneyModel newValue) {
                                            setState(() {
                                              _dropDownValueForMobileMoney = newValue;
//                                                        branch = [];
//                                                        _dropDownValueForBankBranch = null;
//                                                print("provider code ${_dropDownValueForMobileMoney.provider_code}");
                                            });
                                          },
                                          items: mobileMoney.map((MobileMoneyModel value) {

//                                            print(value);
                                            return DropdownMenuItem<
                                                MobileMoneyModel>(value: value,
                                              child: Text(value.network_provider ?? "i no know",
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
//                    if(isBankAfricaLoading)Row(
//                      children: [
//                        CupertinoActivityIndicator(),
//                        SizedBox(width: 20),
//                      ],
//                    ),



                //Account num
      _dropDownValueForMobileMoney != null ?       Column(

        children: [
          CustomTextField(
//                        color: kPrimaryColor.withOpacity(0.1),
            header: "Enter Mobile-Money Number",
            hint: "0120112233",
            type: FieldType.number,

            onChanged: (v) {
              if (v.length < 7) {
                _accountName.text = "";
              } else if (v.length == 10) {
//                resolveBankName();
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
//                    print(value);
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
                  child: Text(loginState.user.currency, style: GoogleFonts.raleway(color: kPrimaryColor)),
                ),
                controller: _amountController,
                type: FieldType.number,
                onChanged: (value) {
                  streamController.add(value);
                  setState(() {
                    amount = value;
                  });

                  print("amount $amount");
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
                        child: Text(_dropDownValueForCountry.country.currency, style: GoogleFonts.raleway(color: kPrimaryColor)),
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
      ): Container()





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
//                          print(validated);
//                          print(message);
                          Navigator.pop(context);
                          if (validated) {
                            sendMoneyAfrica();
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
      setState(() {
        isCheckingRate = false;
      });
      if (result["error"] == false) {
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
                    purpose: "Bank Transfer",
//                    "Bank transfer to $accountNum, Bank: $_dropDownValueForBank",
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

  void getTransactionFee()async{
    var result = await transferState.getFees(amount:  _amountController.text.trim().replaceAll(",", ""), token: loginState.user.token, country_id: _dropDownValueForCountry.country_id);
//    print(result);
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
    {
      CommonUtils.showMsg(result["message"], themeChangeProvider, context,
          widget.scaf, kPrimaryColor);
    }

  }


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
        account_bank: _dropDownValueForMobileMoney.provider_code,
        destination_branch_code: "",
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
            message: "Transaction Successful",
          )),
              (Route<dynamic> route) => false);

    } else {
      CommonUtils.showMsg(result["message"], themeChangeProvider, context,
          widget.scaf, kPrimaryColor);
    }

  }








  Future getNetworksAfrica({country}) async {
    setState(() {
      isBankAfricaLoading = true;
    });

    var result = await transferState.fetchNetworksAfrica(token: loginState.user.token, country:country );
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
        mobileMoney = result["mobileMoney"];
      });
    }else{

      CommonUtils.showMsg(result["message"], themeChangeProvider, context,
          widget.scaf, kPrimaryColor);
    }
  }




















  @override
  void afterFirstLayout(BuildContext context) {

    if(receiverCountryMobile == null || receiverCountryMobile.isEmpty){
      getReceivingCountries();
    }


  }
  void getReceivingCountries() async {
    setState(() {
      isLoading = true;
    });
    var result = await transferState.getReceivingCountriesMobileMoney(token: loginState.user.token);
//    print("result$result");
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
        receiverCountryMobile = result['receivingCountriesMobile'];
//        receiverCountryMobile.removeAt(0);
//        receiverCountryMobile.removeLast();
        isLoading = false;
      });
    }else{
      CommonUtils.showMsg(result["message"], themeChangeProvider, context,
          widget.scaf, kPrimaryColor);
    }
  }
}

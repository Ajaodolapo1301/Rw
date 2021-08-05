import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/api/transactionpinService.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/models/banks.dart';
import 'package:rex_money/models/contactList.dart';

import 'package:rex_money/models/flags.dart';
import 'package:rex_money/models/rateModel.dart';
import 'package:rex_money/models/receiveTrans.dart';
import 'package:rex_money/models/resolveAccModel.dart';
import 'package:rex_money/models/tagFetch.dart';

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
import 'package:rex_money/screens/home.dart';
import 'package:rex_money/screens/state/notifSuccess.dart';


import 'package:rex_money/utils/commonUtils.dart';
import 'package:rex_money/utils/myUtils.dart';
import 'package:stream_transform/stream_transform.dart';

import 'bankSend.dart';

class RexTransfer extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaf;

  RexTransfer({this.scaf});

  @override
  _RexTransferState createState() => _RexTransferState();
}

class _RexTransferState extends State<RexTransfer> {
//  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var amount;
  bool loading = false;
  TagFetch tagFetch;
  bool error = false;
  bool userTagLoading = false;
  bool isCheckingRate = false;
  FocusNode _focus = new FocusNode();
  FocusNode _focus2 = new FocusNode();
  ReceiveTransfer _dropDownValueForCountry;
  RateModel rateModel;
  MoneyMaskedTextController _amountController =
  MoneyMaskedTextController(decimalSeparator: ".", thousandSeparator: ",");
  MoneyMaskedTextController _amountController2 =
  MoneyMaskedTextController(decimalSeparator: ".", thousandSeparator: ",");
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
  bool isButtonDisaled = true;

  bool search = false;
var _tagNameCurrency;

var _tagnameSymbol;

  var transactionFee = "0" ;

  bool paymentLoading = false;
  var flagImage = "";
  var flagImage2 = "";
  var totalAmount;
  var realAmount;
  ResolveAccountModel resolveAccountModel;
  var accountNum;
  var clear = false;

  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  StreamController<String> streamController = StreamController();
  StreamController<String> streamController3 = StreamController();
  StreamController<String> streamController2 = StreamController();
  TextEditingController _narration = TextEditingController();

  TextEditingController _tagName = TextEditingController();

  List<ContactList> _tempListofContact;



  _validateTag() {
//    print("called tag");
    if (_tagName.text.length > 3) {
      getUserTag();
    } else {
      // some other code here
    }
  }

  _validatetext() {
    setState(() {
      isLoading = false;
    });
//    String s = amount.toString().replaceAll(RegExp(r"([.]*000)(?!.*\d)"), "");
//    var cleanAmount = s.trim().replaceAll(",", "");
//    print("cleanAmount$cleanAmount");
//    setState(() {
//      realAmount = cleanAmount;
//    });
    if (_amountController.text != "0.0" ||
        _amountController.text.length > 0 ||
        _amountController2.text.length > 0) {

      _focus.hasFocus ? getConversion() : getConversionreverse();
      getAmountCharge();
    } else {
      // some other code here
    }
  }

  @override
  void initState() {
    super.initState();

    getCurrentAppTheme();
    //get tag name
    streamController.stream
        .transform(debounce(Duration(milliseconds: 1000)))
        .listen((s) => _validateTag());

    //get conversion rate
    streamController2.stream
        .transform(debounce(Duration(milliseconds: 1000)))
        .listen((s) => _validatetext());
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
    await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {

    themeChangeProvider = Provider.of<DarkThemeProvider>(context);
    conversionState = Provider.of<ConversionState>(context);
    transferState = Provider.of<TransferState>(context);
    loginState = Provider.of<LoginState>(context);
    return Column(
      children: [
        Form(
            key: _formKey,
            child: Column(
              children: [
                Container(

                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text("Recipient Tag",
                        style: GoogleFonts.mavenPro(
                          fontWeight: FontWeight.bold ,
                          fontSize: 13,

                          color: themeChangeProvider.darkTheme ? Colors.white :  kPrimaryColor,

                        ),
                      ),

                      SizedBox(height: 4,),
                      TextFormField(
                        style: TextStyle(
                          color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor
                        ),
                          onChanged: (value) {
                            setState(() {
                              userTagLoading = false;
                              clear = true;
                              tagFetch = null;
                              streamController.add(value);
                            });
                          },

                          controller: _tagName,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "tag name is required";
                            }
//
//                if (value.length <= 5) {
//                  return "Invalid Amount";
//                }

                            return null;
                          },
                          decoration: InputDecoration(
                                 suffix: userTagLoading
                              ? CupertinoActivityIndicator()
                              : error
                          ? CommonUtils.checkCancel()
                          : tagFetch != null
                      ? CommonUtils.checkMArk()
                          : null,
                          prefixText: "@",
                              prefixStyle: GoogleFonts.raleway(
                                color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
                                fontSize: 15,
                              ) ,

                              suffixStyle:  GoogleFonts.raleway(
                                color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
                                fontSize: 15,
                              ) ,
                              hintText: " Enter Recipient Tag ",
                              hintStyle: GoogleFonts.raleway(
                                color: themeChangeProvider.darkTheme ? Colors.grey : smallTextColor,
                                fontSize: 15,
                              ),

//          prefix: widget.prefix,

                              fillColor: themeChangeProvider.darkTheme  ? kPrimaryDarkTextField : kPrimaryColor.withOpacity(0.1),
                              filled: true,
                              contentPadding: EdgeInsets.only(left: 10, right: 10, top: 10),
                              border: FormBorder(
                                borderRadius: BorderRadius.circular(5),
                              ))
                      ),
                      SizedBox(height: 4,),
                   transferState.contactList == null ||    transferState.contactList.length == 0 ? Container() : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap:(){
                              _showModalForRexContact(context);
                             },

                            child: Text("SELECT FROM CONTACT",                    style: GoogleFonts.mavenPro(
                              fontWeight: FontWeight.bold ,
                              fontSize: 11,

                              color: themeChangeProvider.darkTheme ? Colors.white :  kPrimaryColor,

                            ),),
                          )
                        ],
                      )
                    ],
                  ),
                ),


//                Container(
////            width: 340,
//                  child: CustomTextField(
//                    suffix: userTagLoading
//                        ? CupertinoActivityIndicator()
//                        : error
//                        ? CommonUtils.checkCancel()
//                        : tagFetch != null
//                        ? CommonUtils.checkMArk()
//                        : null,
//                    color: kPrimaryColor.withOpacity(0.1),
//                    header: "Recipient Tag",
//                    hint: "Enter Recipient Tag ",
//                    prefixText: "@",
//                    onChanged: (value) {
//                      setState(() {
//                        userTagLoading = false;
//                        clear = true;
//                          tagFetch = null;
//                        streamController.add(value);
//                      });
//                    },
//                    type: FieldType.text,
//                    controller: _tagName,
//                    validator: (value) {
//                      if (value.isEmpty) {
//                        return "tag name is required";
//                      }
////
////                if (value.length <= 5) {
////                  return "Invalid Amount";
////                }
//
//                      return null;
//                    },
//                  ),
//                ),



//             amount

                tagFetch != null || userTagLoading || _tagName.text != ""
                    ? Column(
                  children: [
                    CustomTextField(
                      focusNode: _focus,
                      suffix: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(loginState.user.currency, style: GoogleFonts.raleway(color: kPrimaryColor),),
                      ),
                      controller: _amountController,
                      type: FieldType.number,
                      onChanged: (value) {
                        streamController2.add(value);
                        setState(() {
                          amount = value;
                        });

//                        print("amount $amount");
                      },
                      prefixText: loginState.user.symbol,
                      header: "You Send",
                      hint: "1000",
                    ),

//                      Recipient get
                    (tagFetch == null  && _tagName.text == "") || _tagName.text == "" || userTagLoading || error
                        ? Container(): Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            readOnly: true,
                            focusNode: _focus2,
                            suffix: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text( tagFetch != null ?   tagFetch.currency :  _tagNameCurrency != null ? _tagNameCurrency : "", style: GoogleFonts.raleway(color: kPrimaryColor),),
                            ),
                            controller: _amountController2,
                            type: FieldType.number,
                            onChanged: (value) {
                              streamController.add(value);
                              setState(() {
                                amount = value;

//                            tagFetch.symbol != null ?  tagFetch.symboltagFetch.symbol :
                              });
                            },
                            prefixText: tagFetch != null ?   tagFetch.symbol : _tagnameSymbol  ,
                            header: "Recipient Gets",
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
                    : Container(),
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

                          fontSize: 13,
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
              ],
            )),
//        Padding(
//          padding: const EdgeInsets.only(right: 20, left: 20, top: 10),
//          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: [
//              Text("Funds should arrive in minutes",
//                  style: GoogleFonts.raleway(
//                    color: themeChangeProvider.darkTheme
//                        ? Colors.white
//                        : kPrimaryColor,
//                    fontSize: 11,
//                  )),
//              SizedBox(
//                height: 10,
//              ),
//              Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: [
//                  Text("Exchange rate",
//                      style: GoogleFonts.raleway(
//                        color: themeChangeProvider.darkTheme
//                            ? Colors.white
//                            : kPrimaryColor,
//                        fontSize: 9,
//                      )),
//                  Text.rich(TextSpan(children: [
//                    TextSpan(
//                        text: "1 EUR = ",
//                        style: GoogleFonts.raleway(
//                          color: themeChangeProvider.darkTheme
//                              ? Colors.white
//                              : kPrimaryColor,
//                          fontSize: 9,
//                        )),
//                    TextSpan(
//                        text: "510 NGN",
//                        style: GoogleFonts.raleway(
//                            color: kprimaryGreen,
//                            fontSize: 9,
//                            fontWeight: FontWeight.bold)),
//                  ])),
//                ],
//              ),
//              SizedBox(
//                height: 10,
//              ),
//              Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: [
//                  Text("Fee",
//                      style: GoogleFonts.raleway(
//                        color: themeChangeProvider.darkTheme
//                            ? Colors.white
//                            : kPrimaryColor,
//                        fontSize: 9,
//                      )),
//                  Text(" $transactionFee  ${loginState.user.currency}  ",
//                      style: GoogleFonts.raleway(
//                          color: kprimaryGreen,
//                          fontSize: 9,
//                          fontWeight: FontWeight.bold)),
//                ],
//              )
//            ],
//          ),
//        ),
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: double.maxFinite,
            height: 50,
            child: RaisedButton(
              disabledColor:  isButtonDisaled ?   kprimaryLight : kPrimaryColor,
              onPressed: isButtonDisaled ? null :  () async {
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
                  Navigator.pop(context);
                  if (list.first) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => transactionPin(context, list.last,
                          continueTransaction: (validated, message) {
                            Navigator.pop(context);
                            if (validated) {
                              sendRexMoney();
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
                  } else {
                    widget.scaf.currentState.showSnackBar(
                      SnackBar(
                        content: Text(list.last),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: Text(
                "PROCEED",
                style: GoogleFonts.mavenPro(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
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

//        SizedBox(
//          height: 10,
//        ),
      ],
    );
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
                    purpose: "Rex transfer to ${_tagName.text}",
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

  void getUserTag() async {
    setState(() {
      userTagLoading = true;
    });

    var result2 = await transferState.fetchToTransfer(token: loginState.user.token, userTag: _tagName.text);
    if (result2["error"] &&
        result2["message"] == "You are not authorized to make this request") {

      showDialog(
          barrierDismissible: false,
          context: context,
          child: dialogPopup(
              themeDark: themeChangeProvider.darkTheme,
              body: Text(
                "Session ended, Please login again",
                textAlign: TextAlign.center,
                style: TextStyle(
                    inherit: false,
                    fontSize: 18,
                    color: themeChangeProvider.darkTheme
                        ? Colors.white
                        : Colors.black),
              ),
              buttonText: "Ok",
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false)));
    }
   else if (result2["error"] == false) {
      setState(() {
        error = false;
        userTagLoading = false;
        tagFetch = result2["balance"];
      });
    } else {
      setState(() {
        error = true;
        tagFetch = null;
        userTagLoading = false;
      });
    }
  }

  getConversion() async {

    if (amount != "0.0") {
      setState(() {
        isCheckingRate = true;
      });
      var result = await conversionState.conversion(
          firstCurrency: loginState.user.currency,
          secondCurrency: tagFetch != null  ? tagFetch.currency : _tagNameCurrency,
          firstAmount: _amountController.text.trim().replaceAll(",", ""));
      if (result["error"] == false) {
        setState(() {
          rateModel = result["message"];
          isCheckingRate = false;
          isButtonDisaled = false;
          _focus2.hasFocus ? _amountController.text = rateModel.formated_amount.toString() : _focus.hasFocus
              ?
          _amountController2.text = rateModel.formated_amount: "0.0 ";
        });
      }

//      print(result);
    }
  }


  void getAmountCharge()async{
    var result = await conversionState.getAccountCharges(amount:  _amountController.text.trim().replaceAll(",", ""), token: loginState.user.token);
    if(result["error"] == false){
      setState(() {
        transactionFee = result["data"].toString();
      });
    }

  }

//getting coversion
  getConversionreverse() async {
    setState(() {
      isCheckingRate = true;
    });
//    print("called");
    var result = await conversionState.conversion(
        secondCurrency: tagFetch != null  ? tagFetch.currency : _tagNameCurrency,
        firstCurrency: loginState.user.currency,
        firstAmount: _amountController.text.trim().replaceAll(",", "")
    );
    if (result["error"] == false) {
      setState(() {
        rateModel = result["message"];
        isCheckingRate = false;
        _focus2.hasFocus ? _amountController.text = rateModel.totalAmount.toString()
            : _focus.hasFocus
            ? _amountController2.text = rateModel.totalAmount.toString()
            : " ";
      });
    }

//    print(result);
  }

  sendRexMoney() async {
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


//    print("amount$amount");
    var result = await transferState.walletToWalletFunding(
        amount: _amountController.text.trim().replaceAll(",", ""),
        userTag: _tagName.text,
        narration: _narration.text,
        token: loginState.user.token);
    if (paymentLoading) {
      Navigator.pop(context, true);
    }
    if (result["error"] == false) {
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






  void _showModalForRexContact(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
        ),
        context: context,
        builder: (context) {
          //3
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
                return DraggableScrollableSheet(
                    expand: false,
                    builder:
                        (BuildContext context, ScrollController scrollController) {
                      return Column(children: <Widget>[
                        search ?    Padding(
                            padding: EdgeInsets.all(8),
                            child:
                        Row(children: <Widget>[
                              Expanded(
                                  child: TextField(
                                      style: GoogleFonts.raleway(
                                        color: themeChangeProvider.darkTheme
                                            ? Colors.white
                                            : kPrimaryColor,
                                        fontSize: 12,
                                      ),

//                                      controller: textController,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(8),
//                                        border: new OutlineInputBorder(
//                                          borderRadius:
//                                          new BorderRadius.circular(15.0),
//                                          borderSide: new BorderSide(),
//                                        ),
//                                        prefixIcon: Icon(Icons.search),
                                      ),
                                      onChanged: (value) {
                                        //4
                                        setModalState(() {
                                          _tempListofContact = _buildSearchList(value);
                                        });
                                      })),
//                              IconButton(
//                                  icon: Icon(Icons.close),
//                                  color: Color(0xFF1F91E7),
//                                  onPressed: () {
//                                    setState(() {
////                                      textController.clear();
////
////                                      _tempListofBanks.clear();
//                                    });
//                                  }),
                            ])
                        ) :

                      GestureDetector(
                        onTap: (){
                          setState(() {
      search = true;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 20, top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                            SvgPicture.asset("images/search.svg"),
                              Text(" Search")
                            ],
                          ),
                        ),
                      ),
                        SizedBox(height: 10,),
                        Expanded(
                          child: ListView.separated(
                              controller: scrollController,
                              //5
                              itemCount: (_tempListofContact != null && _tempListofContact.length > 0) ? _tempListofContact.length : transferState.contactList.length,
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
                                    child: (_tempListofContact != null && _tempListofContact.length > 0) ? _showBottomSheetWithSearch(index, _tempListofContact)
                                        : _showBottomSheetWithSearch(index, transferState.contactList),
                                    onTap: () {
                                      //7


                                      (_tempListofContact != null && _tempListofContact.length > 0)  ?


                                      setState(() {

//                                        bankAfrica.text =
                                  _tagName.text  = _tempListofContact[index].user_tag;
                                    _tagNameCurrency = _tempListofContact[index].currency;
                                    _tagnameSymbol = _tempListofContact[index].symbol;

                                      })


                                          :


                                      setState(() {
//                                        _tagName.text =   _tempListofContact[index].full_name;
//                                               transferState.contactList[index].full_name;
                                        _tagName.text =  transferState.contactList[index].user_tag;
                                        _tagnameSymbol = transferState.contactList[index].symbol;
                                        _tagNameCurrency = transferState.contactList[index].currency;
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


  Widget _showBottomSheetWithSearch(int index, List<ContactList> listOfCities) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      decoration: BoxDecoration(
        color: themeChangeProvider.darkTheme
            ? kPrimaryDarkTextField
            : kPrimaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10)
      ),
      height: 60,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(listOfCities[index].full_name,
                style:  GoogleFonts.mavenPro(color: themeChangeProvider.darkTheme ? Colors.white: kPrimaryColor , fontSize: 14),textAlign: TextAlign.center),

            Text("@${listOfCities[index].user_tag}",
                style:  GoogleFonts.mavenPro(color:  themeChangeProvider.darkTheme ? Colors.white: kPrimaryColor,fontSize: 14),textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  List<ContactList> _buildSearchList(String userSearchTerm) {
    List<ContactList> _searchList = List();

    for (int i = 0; i < transferState.contactList.length; i++) {
      String name = transferState.contactList[i].full_name;

      if (name.toLowerCase().contains(userSearchTerm.toLowerCase())) {
        _searchList.add(transferState.contactList[i]);
      }
    }
    return _searchList;
  }




}

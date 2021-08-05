import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/animation/fadeRoute.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/models/flags.dart';
import 'package:rex_money/models/rateModel.dart';
import 'package:rex_money/providers/appState.dart';
import 'package:rex_money/providers/conversionState.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';

import 'package:rex_money/reusables/customTextField.dart';
import 'package:rex_money/screens/requestMoney/requestMoney.dart';
import 'package:rex_money/screens/sendMoney/sendMoney.dart';
import 'package:stream_transform/stream_transform.dart';

class Rate extends StatefulWidget {
  @override
  _RateState createState() => _RateState();
}

class _RateState extends State<Rate> with AfterLayoutMixin<Rate> {
  String _errortext;
  Flag _dropDownValue1;
  Flag _dropDownValue2;
  List<Flag> flagList = [];
  LoginState loginState;
  var amount;
  bool isLoading = false;
  RateModel rateModel;
  var totalAmount;
  var realAmount;
var currencyIcon;
  var real;
  bool isCheckingRate = false;
  ConversionState conversionState;
  final _formKey = GlobalKey<FormState>();
  MoneyMaskedTextController _amount =
      MoneyMaskedTextController(decimalSeparator: ".", thousandSeparator: ",");

//  TextEditingController _amount = TextEditingController();
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  FocusNode _focus = new FocusNode();
  FocusNode _focus2 = new FocusNode();
  var password;
  var confirmPass;
  var userTag;
  StreamController<String> streamController = StreamController();
  AppState appState;
  MoneyMaskedTextController _amount2 =
      MoneyMaskedTextController(decimalSeparator: ".", thousandSeparator: ",");

  @override
  void initState() {
    getCurrentAppTheme();
    streamController.stream
        .transform(debounce(Duration(milliseconds: 700)))
        .listen((s) => _validatetext());
    _focus.addListener(_onFocusChange);

    super.initState();
  }

  void _onFocusChange() {
    debugPrint("Focus: " + _focus.hasFocus.toString());
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
//      setState(() {
//         real = (double.parse(realAmount) * 10);
//      });
    if (_amount.text.length > 0 || _amount2.text.length > 0) {
      _focus.hasFocus
          ? getConversion(amount: _amount.text)
          : getConversionreverse(amount: _amount2.text);
    } else {
      // some other code here
    }
  }

  getConversion({amount}) async {
    print("called");
    print("jama$amount");
    if (amount != "0.0" || amount != null) {
      setState(() {
        isCheckingRate = true;
      });
      var result = await conversionState.conversion(
          firstCurrency: _dropDownValue1.currency,
          secondCurrency: _dropDownValue2.currency,
          firstAmount: amount.trim().replaceAll(",", ""),
      token: loginState.user.token
      );

      print(result);
      setState(() {
        isCheckingRate = false;
      });
      if (result["error"] == false) {
        setState(() {
          rateModel = result["message"];
//            totalAmount = result["message"]["data"]["total_amount"];
          isCheckingRate = false;
          _focus2.hasFocus
              ? _amount.text = rateModel.formated_amount.toString()
              : _focus.hasFocus
                  ? _amount2.text = rateModel.formated_amount.toString()
                  : " ";
        });
      }

      print(result);
    }
  }

  getConversionreverse({amount}) async {
    print("called amoi$amount");
    if (amount != "0.0") {
      setState(() {
        isCheckingRate = true;
      });
      var result = await conversionState.conversion(
          secondCurrency: _dropDownValue1.currency,
          firstCurrency: _dropDownValue2.currency,
          firstAmount:amount.trim().replaceAll(",", ""),
          token: loginState.user.token
      );
        setState(() {
          isCheckingRate = false;
        });
      if (result["error"] == false) {
        setState(() {
          rateModel = result["message"];
          isCheckingRate = false;
          _focus2.hasFocus
              ? _amount.text = rateModel.formated_amount.toString()
              : _focus.hasFocus
                  ? _amount2.text = rateModel.formated_amount.toString() : " ";
        });
      }

      print(result);
    }
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    loginState = Provider.of<LoginState>(context);
    conversionState = Provider.of<ConversionState>(context);
    appState = Provider.of<AppState>(context);
    themeChangeProvider = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor:
            themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : SafeArea(
                bottom: false,
                child: Container(
                  height: MediaQuery.of(context).size.height,
//          margin: EdgeInsets.all(20),
                  color: themeChangeProvider.darkTheme
                      ? kPrimaryDark
                      : Colors.white,
                  child: Column(children: [
                    AppBar(
                        centerTitle: true,
                        title: Text(
                          "Rate",
                          style: GoogleFonts.mavenPro(
                            color: themeChangeProvider.darkTheme
                                ? Colors.white
                                : kPrimaryColor,
                            fontSize: 17,
                          ),
                        ),
                        backgroundColor: themeChangeProvider.darkTheme
                            ? Color(0xff1F1A21)
                            : Colors.transparent,
                        leading: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: kprimaryYellow,
                          ),
                          onPressed: () => Navigator.pop(context),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Row(children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: CustomTextField(
                            controller: _amount,
                            prefixText: _dropDownValue1 != null  ? _dropDownValue1.symbol
                                : currencyIcon,
                            focusNode: _focus,
                            header: "Amount",
                            type: FieldType.number,
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return " Field is required";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              streamController.add(value);
                              setState(() {
                                amount = value;
                                print("$amount from on change");
                              });
                            },
                            hint: "0000111",
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(),
                          margin: EdgeInsets.only(right: 20),
                          child: Column(
                            children: [
                              Text(
                                " ",
                                style: GoogleFonts.raleway(
//                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: themeChangeProvider.darkTheme
                                      ? Colors.white
                                      : kPrimaryColor,
                                ),
                              ),
                              SizedBox(height: 4),
                              FormField(
                                builder: (FormFieldStatestate) {
                                  return DropdownButtonHideUnderline(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      InputDecorator(

                                        decoration: InputDecoration(
                                          contentPadding:EdgeInsets.fromLTRB(10,6,14,0),
                                          border: new OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                          const Radius.circular(5.0),
                                  )

                                          ),

                                          fillColor:
                                              themeChangeProvider.darkTheme
                                                  ? kPrimaryColor
                                                  : kPrimaryColor,

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
                                        isEmpty: _dropDownValue1 == null,
                                        child: DropdownButton<Flag>(
                                          dropdownColor:
                                              themeChangeProvider.darkTheme
                                                  ? Color(0xff191D20)
                                                  : kPrimaryColor,
                                          style: TextStyle(
                                              color:
                                                  themeChangeProvider.darkTheme
                                                      ? Colors.white
                                                      : Colors.black),
                                          icon: Icon(
                                            Icons.keyboard_arrow_down_sharp,
                                            color: Colors.white,
                                          ),
                                          value: _dropDownValue1,
                                          isDense: true,
                                          onChanged: (Flag newValue) {
                                            setState(() {
                                              _dropDownValue1 = newValue;
                                              currencyIcon = newValue.currency;
                                              _amount.text = "0.0";
                                              _amount2.text = "0.0";
                                              rateModel = null;
                                            });
//                                            getConversion(amount: realAmount);
                                          },
                                          items: flagList.map((Flag value) {
                                            return DropdownMenuItem<Flag>(
                                              value: value,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 16,
                                                    width: 25,
                                                    child: SvgPicture.network(
                                                        value.flag),
                                                    decoration: BoxDecoration(),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(value.currency,
                                                      style: GoogleFonts.raleway(
                                                          fontSize: 14,
                                                          color:
                                                              themeChangeProvider
                                                                      .darkTheme
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .white)),
                                                ],
                                              ),
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
                      )
                    ]),

                    SizedBox(
                      height: 10,
                    ),

                    Row(children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: CustomTextField(
                            focusNode: _focus2,
                            controller: _amount2,
                            prefixText: _dropDownValue2.symbol,
                            header: "Converted to",
                            type: FieldType.text,
                            onChanged: (value) {
                              streamController.add(value);
                              setState(() {
                                amount = value;
                              });

                              print("$amount from on change");
                            },
                            hint: "02222222",
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(),
                          margin: EdgeInsets.only(right: 20),
                          child: Column(
                            children: [
                              Text(
                                " ",
                                style: GoogleFonts.karla(
//                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: themeChangeProvider.darkTheme
                                      ? Colors.white
                                      : kPrimaryColor,
                                ),
                              ),
                              SizedBox(height: 4),
                              FormField(
                                builder: (FormFieldStatestate) {
                                  return DropdownButtonHideUnderline(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      InputDecorator(
                                        decoration: InputDecoration(

                                          contentPadding:EdgeInsets.fromLTRB(10,6,14,0),
                                    border: new OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(5.0),
                                        )

                                    ),

                                          fillColor:
                                              themeChangeProvider.darkTheme
                                                  ? kPrimaryColor
                                                  : kPrimaryColor,

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
                                        isEmpty: _dropDownValue2 == null,
                                        child: DropdownButton<Flag>(
                                          dropdownColor:
                                              themeChangeProvider.darkTheme
                                                  ? Color(0xff191D20)
                                                  : kPrimaryColor,
                                          style: TextStyle(
                                              color:
                                                  themeChangeProvider.darkTheme
                                                      ? Colors.white
                                                      : Colors.black),
                                          icon: Icon(
                                            Icons.keyboard_arrow_down_sharp,
                                            color: Colors.white,
                                          ),
                                          value: _dropDownValue2,
                                          isDense: true,
                                          onChanged: (Flag newValue) {
                                            setState(() {
                                              _dropDownValue2 = newValue;
                                              _amount.text  = "0.0";
                                              _amount2.text  = "0.0";
//                                              rateModel.rate = "";
                                            });

//                                            getConversion(amount: realAmount);
                                          },
                                          items: flagList.map((Flag value) {
                                            return DropdownMenuItem<Flag>(
                                              value: value,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 16,
                                                    width: 25,
                                                    child: SvgPicture.network(
                                                        value.flag),
                                                    decoration: BoxDecoration(),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(value.currency,
                                                      style: GoogleFonts.karla(
                                                          fontSize: 14,
                                                          color:
                                                              themeChangeProvider
                                                                      .darkTheme
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .white)),
                                                ],
                                              ),
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
                      )
                    ]),

                    SizedBox(
                      height: 30,
                    ),
                    isCheckingRate ? CupertinoActivityIndicator() : Container(),

                    rateModel == null ? Container() :     Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  _focus.hasFocus
                                      ? Text(
                                          "1 ${_dropDownValue1.currency == null ? " " : _dropDownValue1.currency} = ",
                                          style: GoogleFonts.mavenPro(
                                              fontSize: 18,
                                              color: kPrimaryColor,
                                              fontWeight: FontWeight.bold))
                                      : Text(
                                          "1 ${_dropDownValue2.currency == null ? " " : _dropDownValue2.currency} = ",
                                          style: GoogleFonts.mavenPro(
                                              fontSize: 18,
                                              color: kPrimaryColor,
                                              fontWeight: FontWeight.bold)),
                                  Text.rich(TextSpan(
                                    children: [
                                      TextSpan(
                                          text:
                                              "${rateModel != null ? rateModel.rate : " "}",
                                          style: GoogleFonts.mavenPro(
                                              fontSize: 18,
                                              color: kDarkgreen,
                                              fontWeight: FontWeight.bold)),
                                 _focus.hasFocus ?     TextSpan(
                                          text:
                                              " ${_dropDownValue2.currency == null ? " " : _dropDownValue2.currency}",
                                          style: GoogleFonts.mavenPro(
                                              fontSize: 18,
                                              color: kPrimaryColor,
                                              fontWeight: FontWeight.bold))
                                      :

                                 TextSpan(
                                     text:
                                     " ${_dropDownValue1.currency == null ? " " : _dropDownValue1.currency}",
                                     style: GoogleFonts.mavenPro(
                                         fontSize: 18,
                                         color: kPrimaryColor,
                                         fontWeight: FontWeight.bold))

//                                 Text(
//                                      "1 ${_dropDownValue1.currency == null ? " " : _dropDownValue1.currency} = ",
//                                      style: GoogleFonts.mavenPro(
//                                          fontSize: 18,
//                                          color: kPrimaryColor,
//                                          fontWeight: FontWeight.bold)),

                                    ],
                                  ))
                                ],
                              ),
                              Text("Mid-market exchange rate at ${DateTime.now()}",
                                  style: GoogleFonts.mavenPro(
                                    fontSize: 11,
                                    color: themeChangeProvider.darkTheme
                                        ? Colors.white
                                        : kprimaryLight,
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),

                    Spacer(),
//SendMoney
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: double.maxFinite,
                        height: 50,
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.push(
                                context, FadeRoute(page: SendMoney()));
                          },
                          child: Text(
                            "Send Money",
                            style: GoogleFonts.mavenPro(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          color: kprimaryYellow,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),

                    //Receivemoney

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: double.maxFinite,
                        height: 50,
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.push(
                                context, FadeRoute(page: ReceiveMoney()));
                          },
                          child: Text(
                            "Request Money",
                            style: GoogleFonts.mavenPro(
                                fontSize: 16, fontWeight: FontWeight.bold),
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
                    SizedBox(height: 35),
                  ]),
                ),
              ));
  }

  @override
  void afterFirstLayout(BuildContext context) {
    getCountries();


  }



  getCountries() async {
    setState(() {
      isLoading = true;
    });
    var result = await loginState.getflag();
    if (result["error"] == false) {
      setState(() {
        flagList = result['flags'];

        setState(() {
          for (var i = 0; i < flagList.length; i++) {
            if (flagList[i].country == loginState.user.country) {
              print(flagList[i].country);
              print(loginState.user.country);
              _dropDownValue1 = flagList[i];
            }
          }



          _dropDownValue2 = flagList[0];
        });
        isLoading = false;
      });
    }
  }
}

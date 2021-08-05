

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/api/stripeService.dart';
import 'package:rex_money/card/card_validator.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/models/cardInfo.dart';
import 'package:rex_money/models/fundAccountKeys.dart';
import 'package:rex_money/models/localCardFundModel.dart';
import 'package:rex_money/providers/conversionState.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/providers/transferState.dart';
import 'package:rex_money/reusables/CardTokenScreen.dart';
import 'package:rex_money/reusables/confirmationPage.dart';
import 'package:rex_money/reusables/customTextField.dart';
import 'package:rex_money/reusables/dialoPopup.dart';
import 'package:rex_money/reusables/fundLocalTransferModal.dart';
import 'package:rex_money/reusables/noAuth.dart';
import 'package:rex_money/reusables/preloader.dart';
import 'package:rex_money/reusables/primarybutton.dart';
import 'package:rex_money/screens/auth/login.dart';
import 'package:rex_money/screens/fundAccount/webView.dart';
import 'package:rex_money/screens/home.dart';
import 'package:rex_money/utils/commonUtils.dart';
import 'package:rex_money/utils/monthFormatter.dart';
import 'package:stripe_payment/stripe_payment.dart';
import '';
class FundWalletLocal extends StatefulWidget {
  @override
  _FundWalletLocalState createState() => _FundWalletLocalState();
}

class _FundWalletLocalState extends State<FundWalletLocal> with AfterLayoutMixin<FundWalletLocal> {
  DarkThemeProvider darkThemeProvider;
  LoginState loginState;
  String _dropDownValue;
  String _errortext;
  ConversionState conversionState;
  bool isLoading = false;
  bool isStep2Loading = false;
  bool isStep4Loading = false;
  bool isStepLoading = false;
    TransferState transferState;
  FundAccountKey key;
  LocalCardFund localCardFund;

  LocalCardFund2 localCardFund2;


  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  CardInfo _cardInfo = CardInfo();
  var _currencies = [
    "Card",
    "Mobile Money",
  ];
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _formKey = new GlobalKey<FormState>();
  var numberController = new TextEditingController();


  var cardname = new TextEditingController();
  var cardNum = new TextEditingController();


  var expMonth = new TextEditingController();
  var cvv = new TextEditingController();





  MoneyMaskedTextController _amountController = MoneyMaskedTextController(decimalSeparator: ".", thousandSeparator: ",");

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    numberController.removeListener(_getCardTypeFrmNumber);
    numberController.dispose();
    super.dispose();
  }
  bool saveCard =  false;

  var cardImage;
  @override
  void initState() {
    getCurrentAppTheme();
    _cardInfo.cardType = CardType.Others;
    numberController.addListener(_getCardTypeFrmNumber);


    super.initState();
  }


  void _getCardTypeFrmNumber() {
    String input = CardValidator.getCleanedNumber(numberController.text);
    CardType cardType = CardValidator.getCardTypeFrmNumber(input);
    setState(() {
      this._cardInfo.cardType = cardType;
    });
  }


  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
    await themeChangeProvider.darkThemePreference.getTheme();
  }




  @override
  Widget build(BuildContext context) {
    themeChangeProvider = Provider.of<DarkThemeProvider>(context);
    loginState = Provider.of<LoginState>(context);
    conversionState = Provider.of<ConversionState>(context);
   transferState = Provider.of<TransferState>(context);
    _getCardIcon();

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Fund Account", style: GoogleFonts.mavenPro(color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,fontSize: 17,),),
          backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: kprimaryYellow,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),


        body : SingleChildScrollView(
          child: Container(
//          height: MediaQuery.of(context).size.height,
            child: Column(
              children: [

                Form(
                  key:_formKey ,
                  child: Column(
                    children: [
//                      CustomTextField(
//
////                      color: kPrimaryColor.withOpacity(0.1),
//                        type: FieldType.card,
//                        header: "Card Name",
//                        hint: "Sumaila Doe",
//                        validator: (value) {
//                          if(value.trim().isEmpty){
//                            return "Name is required";
//                          }
//                          if(!value.trim().contains(" ")){
//                            return "Add space then add the last name";
//                          }
//                          return null;
//                        },
//                        onChanged: (String value) {
//                          _cardInfo.name = value;
//                        },
//
//                        controller: cardname,
//                      ),


                      CustomTextField(
                        textInputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          new LengthLimitingTextInputFormatter(19),
                          CardNumberInputFormatter()
                        ],
                        controller: numberController,
                        color: kPrimaryColor.withOpacity(0.1),
                        type: FieldType.cardNum,
                        header: "Card Number",
                        hint: "5532-1233-2121-4321",


//                        validator: CardValidator.validCardNumWithLuhnAlgorithm
                        validator: _validateCardNumWithLuhnAlgorithm,
                        onChanged: (String value) {
                          setState(() {
                            _cardInfo.number = CardValidator.getCleanedNumber(numberController.text);
                          });


                        },
                      ),



                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(

                              controller: expMonth,
                              color: kPrimaryColor.withOpacity(0.1),
                              header: "Valid date",
                              hint:"MM/YY",
                              textInputFormatters: [
                                WhitelistingTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                                MonthInputFormatter()
                              ],
                              validator: CardValidator.validateDate,
                              type: FieldType.cardNum,
                              onChanged: (value) {
                                List<int> expiryDate =
                                CardValidator.getExpiryDate(value);
                                setState(() {
                                  _cardInfo.month = expiryDate[0];
                                  _cardInfo.year = expiryDate[1];

                                });
                              },
                            ),
                          ),


                          Expanded(
                            child: CustomTextField(
                              textInputFormatters: [
                                WhitelistingTextInputFormatter.digitsOnly,
                                new LengthLimitingTextInputFormatter(4),
                              ],
                              controller: cvv,
                              color: kPrimaryColor.withOpacity(0.1),
                              header: "CVV",
                              hint: "000",
                              type: FieldType.cardNum,
                              validator: CardValidator.validateCVV,
                              onChanged: (value) {
                                _cardInfo.cvv = value;
                              },
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20,),

                      Container(
                        decoration: BoxDecoration(
                            color: themeChangeProvider.darkTheme ? kPrimaryDarkTextField: kPrimaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(7)
                        ),
                        margin: EdgeInsets.only(left: 20, right: 20),
                        height: 77,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              cardImage == "mastercard.png" ?    _getCardIcon() :     Image.asset(
                                'images/masterB.png',
                                height: 30.0,
                                width: 50.0,
                              ),
                              cardImage == "visa.png" ?  _getCardIcon() :   Image.asset(
                                'images/visaB.png',
                                height: 30.0,
                                width: 50.0,
                              ),
                              Image.asset(
                                'images/americ.png',
                                height: 30.0,
                                width: 50.0,
                              ),


                            ],
                          ),
                        ),
                      ),






                      CustomTextField(
                        prefixText: loginState.user.symbol,
                        color: kPrimaryColor.withOpacity(0.1),
                        header: "Amount",
                        hint: "",
                        type: FieldType.cardNum,
                        prefix: Container(
                          margin:
                          EdgeInsets.only(right: 5),
                          child: Text(
                            loginState.user.currency,
                            style: GoogleFonts.workSans(
                                color: themeChangeProvider.darkTheme
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),

                        onChanged: (value) {
                          print(value);
                        },
                        controller: _amountController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Amount is required";
                          }

                          if (value.length <= 4) {
                            return "Invalid Amount";
                          }

                          return null;
                        },
                      ),



                    ],
                  ),
                ),

                SizedBox(height: 20,),



                SizedBox(height: 20,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.maxFinite,
                    height: 50,
                    child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
//                          fetchKeysAndMakingPayment();
//                          fundAccountStep1();
                          fundAccount();
                        }
                      },
                      child: Text(
                        "FUND ACCOUNT",
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


                SizedBox(height: 30,),
              ],
            ),
          ),
        )
    );
  }

  String _validateCardNumWithLuhnAlgorithm(String value) {
    if (value.isEmpty) {
      return "Field is required";
    }
  }





fundAccount() async{
  setState(() {
    isLoading = true;
  });
  if (isLoading) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
  }
  var result = await transferState.fundWalletWithCardAfrican(token: loginState.user.token, amount: _amountController.text.trim().replaceAll(",", ""), card_no:_cardInfo.number.toString(), card_security: _cardInfo.cvv.toString(), expiry_year: _cardInfo.year.toString(), expiry_month: _cardInfo.month.toString().length  == 1 ? "0${_cardInfo.month.toString()}"  :  _cardInfo.month.toString() );
  if (isLoading) {
    Navigator.pop(context, true);
  }
  if (result["error"] && result["message"] == "You are not authorized to make this request") {
    print("jdjdjdhd");
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
  }
  else if(result["error"] == false){
    setState(() {
      localCardFund = result["card"];

    });

// Pin Auth and Token
    if(localCardFund.auth_mode == "pin"){
      final pin = await  _getAuthValue(localCardFund.auth_mode);
      print(pin);
        if(pin != null){
        setState(() {
          isStepLoading = true;
        });

        if (isStepLoading) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return Preloader();
              });
        }
//          Pass the pin to the second endpoint
        var response  = await transferState.fundWalletWithCardAfricanStep2(token: loginState.user.token, amount: _amountController.text.trim().replaceAll(",", ""),card_no:_cardInfo.number.toString(), card_security: _cardInfo.cvv.toString(), expiry_year: _cardInfo.year.toString(), expiry_month: _cardInfo.month.toString().length  == 1 ? "0${_cardInfo.month.toString()}"  :  _cardInfo.month.toString(), transaction_ref: localCardFund.transaction_ref, auth_type: localCardFund.auth_mode, card_pin: pin );
        if (isStepLoading) {
          Navigator.pop(context, true);
        }
        print("response$response");
        if(response['error'] == false){

          if(response["message"]["auth_mode"] == "otp") {


//              takes the OTP
            final otp = await _getAuthValue(response["message"]["auth_mode"]);
            print("otp $otp");
            if(otp!= null){
              setState(() {
                isStep2Loading = true;
              });
              if (isStep2Loading) {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Preloader();
                    });
              }
// pass to the Third endpoint
              var response3  = await transferState.fundWalletWithCardAfricanStep3(token: loginState.user.token, transaction_ref:response["message"]["flutterwave_ref"] , otp: otp);


              if (isStep2Loading) {
                Navigator.pop(context, true);
              }
              if (response3["error"] == false) {
//                    Fourth Step

                setState(() {
                  isStep4Loading = true;
                });

                if (isStep4Loading) {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return Preloader();
                      });
                }

                var response4 = await transferState.fundWalletWithCardAfricanStep4(token: loginState.user.token, transaction_id:response3["message"]["transaction_id"] );
                if(response4["error"] == false){
                  CommonUtils.showSuccessDialog(
                      context: context,
                      themeChangeProvider: themeChangeProvider,
                      text: "Transaction Successful",
                      onClose: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => Home()));
                      });
                }else{
                  CommonUtils.showMsg(response4["message"], themeChangeProvider, context, _scaffoldKey, kPrimaryColor  );
                }
              }

            }
          }

        }



      }

    }


//    No auth, just transactionID
    else if(localCardFund.auth_mode  == "" && localCardFund.transaction_id != ""){
      setState(() {
        isStep4Loading = true;
      });

      if (isStep4Loading) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Preloader();
            });
      }

      var response = await transferState.fundWalletWithCardAfricanStep4(token: loginState.user.token, transaction_id: localCardFund.transaction_id);
      print(response);
      if (isLoading) {
        Navigator.pop(context, true);
      }
      if(response["error"] == false){
        CommonUtils.showSuccessDialog(
            context: context,
            themeChangeProvider: themeChangeProvider,
            text: "Transaction Successful",
            onClose: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home()));
            });
      }else{
        CommonUtils.showMsg(response["message"], themeChangeProvider, context, _scaffoldKey, kPrimaryColor  );
      }

//      Address Auth
    }else if(localCardFund.auth_mode == "avs_noauth"){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>NoAuth(
       cardNum: _cardInfo.number.toString(),
       expMonth: _cardInfo.month.toString(),
        expYear: _cardInfo.year.toString(),
        cvv: _cardInfo.cvv,
        amount: _amountController.text.trim().replaceAll(",", ""),
        transRef: localCardFund.transaction_ref,
        auth_mode: localCardFund.auth_mode,
      )));



    }

  }else{
    CommonUtils.showMsg(result["message"], themeChangeProvider, context, _scaffoldKey, kPrimaryColor  );

  }


  }












  fundAccountStep1()async{
    setState(() {
      isLoading = true;
    });

    if (isLoading) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Preloader();
          });
    }

    var result = await transferState.fundWalletWithCardAfrican(token: loginState.user.token, amount: _amountController.text.trim().replaceAll(",", ""), card_no:_cardInfo.number.toString(), card_security: _cardInfo.cvv.toString(), expiry_year: _cardInfo.year.toString(), expiry_month: _cardInfo.month.toString().length  == 1 ? "0${_cardInfo.month.toString()}"  :  _cardInfo.month.toString() );
    if (isLoading) {
      Navigator.pop(context, true);
    }
    if (result["error"] &&
        result["message"] == "You are not authorized to make this request") {
      print("jdjdjdhd");
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
    }
   else if (result["error"] == false ){
      setState(() {
    localCardFund = result["card"];

      });
print("${localCardFund.auth_mode} jndhdb");
      if(localCardFund.auth_mode != "" && localCardFund.auth_mode != "redirect"){

//        first step checks the type of auth mode
      final pin = await  _getAuthValue(localCardFund.auth_mode);
      print("pin$pin");
        if(pin != null){
          setState(() {
            isStepLoading = true;
          });

          if (isStepLoading) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return Preloader();
                });
          }



//          Pass the pin to the second endpoint
        var response  = await transferState.fundWalletWithCardAfricanStep2(token: loginState.user.token, amount: _amountController.text.trim().replaceAll(",", ""),card_no:_cardInfo.number.toString(), card_security: _cardInfo.cvv.toString(), expiry_year: _cardInfo.year.toString(), expiry_month: _cardInfo.month.toString().length  == 1 ? "0${_cardInfo.month.toString()}"  :  _cardInfo.month.toString(), transaction_ref: localCardFund.transaction_ref, auth_type: localCardFund.auth_mode, card_pin: pin );
          if (isStepLoading) {
            Navigator.pop(context, true);
          }
          print("response$response");
          if(response['error'] == false){

            if(response["message"]["auth_mode"] == "otp") {


//              takes the OTP
              final otp = await _getAuthValue(response["message"]["auth_mode"]);
                print("otp $otp");
                if(otp!= null){
                  setState(() {
                    isStep2Loading = true;
                  });
                  if (isStep2Loading) {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return Preloader();
                        });
                  }
// pass to the Third endpoint
                  var response3  = await transferState.fundWalletWithCardAfricanStep3(token: loginState.user.token, transaction_ref:response["message"]["flutterwave_ref"] , otp: otp);


                  if (isStep2Loading) {
                    Navigator.pop(context, true);
                  }
                  if (response3["error"] == false) {
//                    Fourth Step

                    setState(() {
                      isStep4Loading = true;
                    });

                    if (isStep4Loading) {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Preloader();
                          });
                    }

                    var response4 = await transferState.fundWalletWithCardAfricanStep4(token: loginState.user.token, transaction_id:response3["message"]["transaction_id"] );
                    if(response4["error"] == false){
                      CommonUtils.showSuccessDialog(
                          context: context,
                          themeChangeProvider: themeChangeProvider,
                          text: "Transaction Successful",
                          onClose: () {
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => Home()));
                          });
                    }else{
                      CommonUtils.showMsg(response4["message"], themeChangeProvider, context, _scaffoldKey, kPrimaryColor  );
                    }
                  }

                }
            }

//            else if (response["message"]["auth_mode"] == "redirect"){
//              Navigator.push(context, MaterialPageRoute(builder: (context)=> WebViewContainer(response["message"]["link"])));
////              CommonUtils.showSuccessDialog(context: context, buttonText: "Validate payment", themeChangeProvider: themeChangeProvider, text: "Charge initiated, click 'validate' to validate payment  ", onClose: (){
////
////
////              });
//            }

          }



        }



      }else if(localCardFund.auth_mode == "redirect" ){
        print("No redirect url");
      }
      else if(localCardFund.auth_mode == ""){


      setState(() {
        isStep4Loading = true;
      });

      if (isStep4Loading) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Preloader();
            });
      }

      var response = await transferState.fundWalletWithCardAfricanStep4(token: loginState.user.token, transaction_id: localCardFund.transaction_id);
      print(response);
      if (isLoading) {
        Navigator.pop(context, true);
      }
      if(response["error"] == false){
        CommonUtils.showSuccessDialog(
            context: context,
            themeChangeProvider: themeChangeProvider,
            text: "Transaction Successful",
            onClose: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home()));
            });
      }else{
        CommonUtils.showMsg(response["message"], themeChangeProvider, context, _scaffoldKey, kPrimaryColor  );
      }

//              takes the OTP
//        final otp = await _getAuthValue("token");
//
//        if(otp!= null){
//          setState(() {
//            isStep2Loading = true;
//          });
//          if (isStep2Loading) {
//            showDialog(
//                context: context,
//                barrierDismissible: false,
//                builder: (BuildContext context) {
//                  return Preloader();
//                });
//          }
//// pass to the Thrid endpoint
//          var response2  = await transferState.fundWalletWithCardAfricanStep3(token: loginState.user.token, transaction_ref:localCardFund.flw_ref , otp: otp);
//          print("hbdhbdhbddbhdb");
//          if (isStep2Loading) {
//            Navigator.pop(context, true);
//          }
//          if (response2["error"] == false) {
//            CommonUtils.showSuccessDialog(
//                context: context,
//                themeChangeProvider: themeChangeProvider,
//                text: "Transaction Successful",
//                onClose: () {
//                  Navigator.push(
//                      context, MaterialPageRoute(builder: (context) => Home()));
//                });
//          } else {
//
//            CommonUtils.showFlushBar(context: context, title: "Error", message: response2["message"], backgroundColor: kPrimaryColor );
////                    CommonUtils.showMsg(response["message"], themeChangeProvider, context,
////                        _scaffoldKey , kPrimaryColor);
//          }
//
//        }
      }
      }else{
      CommonUtils.showMsg(result["message"], themeChangeProvider, context, _scaffoldKey, kPrimaryColor  );
    }

  }



























  Future<String> _getAuthValue(String response, [String message]) async {
    final _value = await _showValueModal(
      title: response,
      message: message ?? "Please provide your $response",
    );

    return _value;
  }




  Future<String> _showValueModal({String title, String message}) async {
    String value = await showModalBottomSheet<String>(
//      barrierDismissible: false,


      context: context,
      builder: (c) {
        return ValueCollectorComponent(
            title: title,
            message: message,
            onValueCollected: (value) {


              Navigator.of(
                c,
                rootNavigator: true,
              ).pop(value);
            });
      },
    );

    return value;
  }



  Widget _getCardIcon() {
    String img = "";
    Widget icon;
    switch (_cardInfo.cardType) {
      case CardType.Master:
        img = 'mastercard.png';
        break;
      case CardType.Visa:
        img = 'visa.png';
        break;
      case CardType.Verve:
        img = 'verve.png';
        break;
      case CardType.AmericanExpress:
        img = 'american_express.png';
        break;
      case CardType.Discover:
        img = 'discover.png';
        break;
      case CardType.DinersClub:
        img = 'dinners_club.png';
        break;
      case CardType.Jcb:
        img = 'jcb.png';
        break;
      case CardType.Others:
        icon =  Container();
        break;
//      case CardType.Invalid:
//        icon = new Icon(
//          Icons.warning,
//          size: 30.0,
//          color: Colors.red,
//        );
//        break;
    }
    Widget widget;
    if (img.isNotEmpty) {
      setState(() {
        cardImage = img;
      });
      widget = new Image.asset(
        'images/$img',
        height: 30.0,
        width: 50.0,
      );
    }else{
      widget =  Container();
    }

    print(img);
    return widget;
  }




//  void showSuccessDialog() {
//    showDialog(
//      barrierDismissible: false,
//      context: context,
//      builder: (context) {
//        return SimpleDialog(
//          contentPadding: EdgeInsets.symmetric(vertical: 40, horizontal: 25),
//          shape:
//          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//          children: <Widget>[
//            Container(
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  SvgPicture.asset(
//                    "images/yes.svg",
//                    height: 100,
//                  ),
//                  SizedBox(height: 10),
//                  Text(
//                    "Success!",
//                    textAlign: TextAlign.center,
//                    style: GoogleFonts.raleway(
//                      fontSize: 25,
//                      fontWeight: FontWeight.w600,
//                      color: themeChangeProvider.darkTheme? Colors.white : headerColor,
//                    ),
//                  ),
//                  SizedBox(height: 20),
//                  Text(
//                    "Transaction Successful ",
//                    textAlign: TextAlign.center,
//                    style:
//                    GoogleFonts.karla(color: themeChangeProvider.darkTheme? Colors.white : smallTextColor, fontSize: 15),
//                  ),
//                  SizedBox(height: 20),
//
//                  SizedBox(
//                    width: double.maxFinite,
//                    height: 50,
//                    child: RaisedButton(
//                      onPressed: () {
//                    setState(() {
//                      numberController.text = " ";
//                      _amountController.text = " ";
//                      cvv.text = "";
//                      cardname.text = " ";
//                      expMonth.text = " ";
//                    });
//                        Navigator.pop(context);
//                      },
//                      child: Text(
//                        "Okay",
//                        style: GoogleFonts.karla(
//                          fontSize: 16,
//                          fontWeight: FontWeight.w900,
//                        ),
//                      ),
//                      color: kPrimaryColor,
//                      padding: EdgeInsets.symmetric(vertical: 15),
//                      textColor: Colors.white,
//                      shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.circular(7),
//                      ),
//                    ),
//                  ),
//                ],
//              ),
//            )
//          ],
//        );
//      },
//    );
//  }
  @override
  void afterFirstLayout(BuildContext context) {
    _dropDownValue = _currencies[0];
  }


  void _showMsg(body) {
    final snackBar = SnackBar(
      backgroundColor: themeChangeProvider.darkTheme ? kprimaryYellow : Colors.red,
      content: Text(body),
      action: SnackBarAction(
        label: "Close",
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

}



class ValueCollectorComponent extends StatefulWidget {
  final String title;
  final String message;
  final Function(String) onValueCollected;

  const ValueCollectorComponent({
    Key key,
    this.title,
    this.message,
    this.onValueCollected,
  }) : super(key: key);

  @override
  _ValueCollectorComponentState createState() =>
      _ValueCollectorComponentState();
}

class _ValueCollectorComponentState extends State<ValueCollectorComponent> {
  String value;

  @override
  Widget build(BuildContext context) {

    return   widget.title == "pin"  ?    CardPinScreen(
      isDark: false,
//        hasPin: true,
//        onClickContinue: (pin) async {
//          showDialog(
//            context: context,
//            barrierDismissible: false,
//            builder: (BuildContext context) {
//              return Preloader();
//            },
//          );
//
//        },
    ) : widget.title == "otp"  ? CardTokenScreen(
      isDark: false,
    ) : NoAuth() ;
  }
}




//else {
//
//CommonUtils.showFlushBar(context: context, title: "Error", message: response2["message"], backgroundColor: kPrimaryColor );
////                    CommonUtils.showMsg(response["message"], themeChangeProvider, context,
////                        _scaffoldKey , kPrimaryColor);
//}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = new StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write('  '); // Add double spaces.
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: new TextSelection.collapsed(offset: string.length));
  }
}
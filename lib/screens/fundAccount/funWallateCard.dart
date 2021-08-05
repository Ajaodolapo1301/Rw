

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/api/stripeService.dart';
import 'package:rex_money/card/card_validator.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/flutterWave/core/flutterwave.dart';
import 'package:rex_money/flutterWave/models/responses/charge_response.dart';
import 'package:rex_money/flutterWave/utils/flutterwave_constants.dart';
import 'package:rex_money/flutterWave/utils/flutterwave_currency.dart';
import 'package:rex_money/models/cardInfo.dart';
import 'package:rex_money/models/fundAccountKeys.dart';
import 'package:rex_money/providers/conversionState.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/reusables/customTextField.dart';
import 'package:rex_money/reusables/preloader.dart';
import 'package:rex_money/reusables/primarybutton.dart';
import 'package:rex_money/screens/fundAccount/fundAccountLOcal.dart';
import 'package:rex_money/screens/home.dart';
import 'package:rex_money/screens/state/notifSuccess.dart';
import 'package:rex_money/utils/commonUtils.dart';
import 'package:rex_money/utils/monthFormatter.dart';
import 'package:stripe_payment/stripe_payment.dart';
import '';
class FundWalletCard extends StatefulWidget {
  @override
  _FundWalletCardState createState() => _FundWalletCardState();
}

class _FundWalletCardState extends State<FundWalletCard> with AfterLayoutMixin<FundWalletCard> {
  DarkThemeProvider darkThemeProvider;
  LoginState loginState;
  String _dropDownValue;
  String _errortext;
ConversionState conversionState;
  bool isLoading = false;

  FundAccountKey key;

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

  var txRef = "rexWire-${DateTime.now().millisecondsSinceEpoch}";
  final String amount = "200";
  String currency;




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
    conversionState = Provider.of<ConversionState>(context);_getCardIcon();

    return Scaffold(
      key: _scaffoldKey,
        backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Fund Account", style: GoogleFonts.mavenPro(color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,fontSize: 17,),),
        backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(18.0),
          child: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: SvgPicture.asset("images/leftIcon.svg")),
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
                    CustomTextField(

//                      color: kPrimaryColor.withOpacity(0.1),
                      type: FieldType.card,
                      header: "Card Name",
                      hint: "Sumaila Doe",
                      validator: (value) {
                        if(value.trim().isEmpty){
                          return "Name is required";
                        }
                        if(!value.trim().contains(" ")){
                          return "Add space then add the last name";
                        }
                        return null;
                      },
                      onChanged: (String value) {
                        _cardInfo.name = value;
                      },

                     controller: cardname,
                    ),


                    CustomTextField(
                      controller: numberController,
                      color: kPrimaryColor.withOpacity(0.1),
                      type: FieldType.cardNum,
                      header: "Card Number",
                      hint: "5532-1233-2121-4321",
                      validator: _validateCardNumWithLuhnAlgorithm,
                      textInputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        new LengthLimitingTextInputFormatter(19),
                        CardNumberInputFormatter()
                      ],
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

          Container(

            margin: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 0),
            child: Row(
              children: [
                Text("Save card?", style: GoogleFonts.raleway(fontWeight: FontWeight.bold, color: kPrimaryColor), ),


                Spacer(),

                Transform.scale(
                  scale: 0.5,
                  child: CupertinoSwitch(

                      activeColor: kPrimaryColor,
                      trackColor: kprimaryYellow,
                      value: saveCard,
                      onChanged: (value){
                        setState(() {
                          saveCard = value;

                        });



                      print(saveCard);

                      }),
                )
              ],
            ),
          ),

              SizedBox(height: 20,),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.maxFinite,
              height: 50,
              child: RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
fetchKeysAndMakingPayment();


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





//
//  payWithCard() async{
//        print("called");
//    setState(() {
//      isLoading = true;
//    });
//
//    if (isLoading) {
//      showDialog(
//          context: context,
//          barrierDismissible: false,
//          builder: (BuildContext context) {
//            return Preloader();
//          });
//    }
//
//
//
//   String s = _amountController.text.toString().replaceAll(RegExp(r"([.]*00)(?!.*\d)"), "");
//   var amount = s.trim().replaceAll(",", "");
//
//       CreditCard  stripCard = CreditCard(
//       number: _cardInfo.number,
//       expMonth: _cardInfo.month,
//       expYear: _cardInfo.year
//   );
//
//       print("amount$amount");
//var response = await  StripeService.payViaExistingCard(amount: amount, token: loginState.user.token, userMid: loginState.user.user_mid,  card: stripCard);
//print(response);
//            if (isLoading) {
//              Navigator.pop(context, true);
//            }
//  }



// the payment code
  Future<dynamic> fetchKeysAndMakingPayment() async {

    print("called");
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

//    cleaning the amount
//   String s = _amountController.text.toString().replaceAll(RegExp(r"([.]*00)(?!.*\d)"), "");
//   var amount = s.trim().replaceAll(",", "");
//    var realAmmount = amount

//print("sending amount $amount");
//    creating a stripe card from the inputText
   CreditCard  stripCard = CreditCard(
       number: _cardInfo.number,
       expMonth: _cardInfo.month,
       expYear: _cardInfo.year
   );
    try{

       var result = await conversionState.fundAccount(amount: _amountController.text.trim().replaceAll(",", ""), token: loginState.user.token,  );
          if(result["error"] == false){
            setState(() {
           key = result["keys"];
            });


            print(key.publishableKey);
            StripeService.init(pubKey: key.publishableKey);
            var response = await StripeService.payViaCard(
                amount: amount ,
                fetchkeys: key ,
                card: stripCard,
                token: loginState.user.token,
//                paymentMethod:  paymentMethod.id

            );





  print(response);

            if(response.message == "Transaction successful"){
              var result = await conversionState.confirmWalletFunding(paymentIntent: response.paymentIntentId,  token: loginState.user.token, paymentMethod: saveCard ?  response.paymentMethodId :"");
              print(result);
              if (isLoading) {
                Navigator.pop(context, true);
              }
                if(result["error"] == false){
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Notif(

                        message: result["message"],
                        fundwithcardnonAfrican: true,
                      )),
                          (Route<dynamic> route) => false);
                }else{

                }

            }else{

            }
          }else{
            if (isLoading) {
              Navigator.pop(context, true);
            }
            CommonUtils.showMsg(result["message"], themeChangeProvider, context, _scaffoldKey, Colors.black12);
          }
      }catch(e){
        print(e);

      }

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


    if(loginState.user.country == "Ghana"){
      print("na me");
      currency  = FlutterwaveCurrency.GHS;
    }else if(loginState.user.country == "Rwanda"){
      setState(() {
        currency  = FlutterwaveCurrency.RWF;
      });
    }else if(loginState.user.country == "Kenya"){
      setState(() {
        currency  = FlutterwaveCurrency.KES;
      });
    }else if(loginState.user.country == "Rwanda"){
      setState(() {
        currency  = FlutterwaveCurrency.RWF;
      });
    }else if(loginState.user.country == "Uganda"){
      setState(() {
        currency  = FlutterwaveCurrency.UGX;
      });
    }else if(loginState.user.country == "Zambia"){
      setState(() {
        currency  = FlutterwaveCurrency.ZMW;
      });
    }else{
      return;

    }





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
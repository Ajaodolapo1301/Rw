

import 'dart:convert';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/animation/fadeRoute.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/providers/virtualCardState.dart';
import 'package:rex_money/reusables/customTextField.dart';
import 'package:rex_money/reusables/preloader.dart';
import 'package:rex_money/reusables/primarybutton.dart';
import 'package:rex_money/screens/state/notifSuccess.dart';
import 'package:rex_money/utils/Dimens.dart';
import 'package:rex_money/utils/commonUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cards.dart';



class FundVirtualcard extends StatefulWidget {
  final id;

  FundVirtualcard({this.id});
  @override
  _FundVirtualcardState createState() => _FundVirtualcardState();
}

class _FundVirtualcardState extends State<FundVirtualcard> with AfterLayoutMixin<FundVirtualcard> {
  Dimens dimens;
  final formKey = GlobalKey<FormState>();
//  final fillColor = HexColor('#F7F7F7');
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _dropDownValueforcurrency;
  bool isLoading = false;
  VirtualCardState virtualCardState;
  LoginState loginState;
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  String _errortext;
  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
//    selectedCurrency = currencies.first;
    // 200 = successful, has funds in wallet 400 - failed, no funds in da wallet
  }



  List<String> currencies = ["NGN", "USD"];

  MoneyMaskedTextController amountController =
  MoneyMaskedTextController(decimalSeparator: ".", thousandSeparator: ",");

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
    await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    virtualCardState = Provider.of<VirtualCardState>(context);
    themeChangeProvider = Provider.of(context);
    loginState = Provider.of<LoginState>(context);


    dimens = Dimens(context);
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Fund Card",
            style: GoogleFonts.mavenPro(
              color:
              themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
              fontSize: 17,
            ),
          ),
          backgroundColor:
          themeChangeProvider.darkTheme ? kPrimaryDark : Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: kprimaryYellow,
            ),
            onPressed: () => Navigator.pop(context),
          )),
      key: _scaffoldKey,
      backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
      body: SafeArea(bottom: false,
        child: Container(
          color: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Form(
                      key: formKey,
                      child: Column(
//                      physics: BouncingScrollPhysics(),
                        children: <Widget>[
                          SizedBox(
                            width: 5,
                          ),


                          SizedBox(
                            height:10,
                          ),
                          CustomTextField(
//                              headerLess: true,
                            header: "How much do you want to fund?",
                            controller: amountController,
                            validator: (v) {
                              amountController.text.replaceAll(",", "");
                              print(amountController.text
                                  .replaceAll(",", "")
                                  .split(".")[0]);
                              if (v.isEmpty) {
                                return ("Amount required");
                              }
                              if (v.length <= 4) {
                                return "Invalid Amount";
                              }
                              return null;
                            },
                          ),

                          primaryButton(text: "Fund Card", onPress: () {

                            createVCard();


                          }),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }




  void createVCard()async{

    print("called");
    setState(() {
      isLoading = true;
    });

    if (isLoading) {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return Preloader();
          });
    }

    print(amountController.text.replaceAll(",", "").split(".")[0]);

    var result = await virtualCardState.fundCard(id: widget.id,  token: loginState.user.token, amount: amountController.text.replaceAll(",", "").split(".")[0]);
    if (isLoading) {
      Navigator.pop(context, true);
    }
    if(result["error"] == false){



      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Notif(
            message: result["message"],
            fromFundCard: true,
            card: false,
          )),
              (Route<dynamic> route) => false);

//      CommonUtils.showSuccessDialog(text: result["message"], buttonText: "Okay", themeChangeProvider: themeChangeProvider, context: context, onClose: (){
//        Navigator.pop(context);
//
//        Navigator.push(context, FadeRoute(page: Cards()));
//      });
    }else{

      CommonUtils.showMsg(result["message"], themeChangeProvider, context, _scaffoldKey, Colors.red);

//      CommonUtils.showFlushBar(message: result["message"], title: "Alert", context: context, backgroundColor: themeChangeProvider.darkTheme ? kprimaryYellow : kPrimaryColor);
    }

  }

//  result["message"], themeChangeProvider, context, _scaffoldKey, Colors.grey
  @override
  void afterFirstLayout(BuildContext context) {
//    _dropDownValueforcurrency = currencies[0];
  }
}
import 'dart:convert';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/animation/fadeRoute.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/providers/appState.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/providers/virtualCardState.dart';
import 'package:rex_money/reusables/customTextField.dart';
import 'package:rex_money/reusables/dialoPopup.dart';
import 'package:rex_money/reusables/preloader.dart';
import 'package:rex_money/reusables/primarybutton.dart';
import 'package:rex_money/screens/auth/login.dart';
import 'package:rex_money/screens/state/notifSuccess.dart';
import 'package:rex_money/utils/Dimens.dart';
import 'package:rex_money/utils/commonUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cards.dart';



class CreateVirtualCard extends StatefulWidget {
  final cardtitle;
  final designCode;
  CreateVirtualCard({this.cardtitle, this.designCode});
  @override
  _CreateVirtualCardState createState() => _CreateVirtualCardState();
}

class _CreateVirtualCardState extends State<CreateVirtualCard> with AfterLayoutMixin<CreateVirtualCard> {
  Dimens dimens;
  final formKey = GlobalKey<FormState>();
//  final fillColor = HexColor('#F7F7F7');
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _dropDownValueforcurrency;
  bool isLoading = false;
  VirtualCardState virtualCardState;
LoginState loginState;
AppState appState;
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
    appState = Provider.of<AppState>(context);

    dimens = Dimens(context);
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Create Card",
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
//                    margin: EdgeInsets.only(left: 5, right: 5),
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

                          primaryButton(text: "Create Card", onPress: () {

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
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Preloader();
        });
  }
   print(widget.designCode);
   print(widget.cardtitle);
   print(amountController.text.replaceAll(",", "").split(".")[0]);

 var result = await virtualCardState.createVirtualCard(card_title:widget.cardtitle, token: loginState.user.token, amount: amountController.text.replaceAll(",", "").split(".")[0], design_code: widget.designCode, card_type: appState.cardType);
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
 else if(result["error"] == false){

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Notif(
          message: result["message"],
          card: true,

        )),
            (Route<dynamic> route) => false);

//  CommonUtils.showSuccessDialog(text: result["message"], buttonText: "Okay", themeChangeProvider: themeChangeProvider, context: context, onClose: (){
//  Navigator.pop(context);

//    Navigator.push(context, FadeRoute(page: Cards()));
//  });
  }else{
   CommonUtils.showMsg(result["message"], themeChangeProvider, context, _scaffoldKey, Colors.red);
 }

  }

//  result["message"], themeChangeProvider, context, _scaffoldKey, Colors.grey
  @override
  void afterFirstLayout(BuildContext context) {
    _dropDownValueforcurrency = currencies[0];
  }
}
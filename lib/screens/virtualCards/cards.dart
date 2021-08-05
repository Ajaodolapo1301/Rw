 import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/animation/fadeRoute.dart';
import 'package:rex_money/animation/sizeRoute.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/models/virtualDollarCard.dart';
import 'package:rex_money/providers/appState.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/providers/virtualCardState.dart';
import 'package:rex_money/reusables/button.dart';
import 'package:rex_money/reusables/confirmationPage.dart';

import 'package:rex_money/reusables/primarybutton.dart';
import 'package:rex_money/reusables/virtualcard.dart';
import 'package:rex_money/screens/virtualCards/cardDetails.dart';
import 'package:rex_money/screens/virtualCards/newCard.dart';
import 'package:rex_money/screens/virtualCards/newVirtualCard.dart';

import 'cardCarol.dart';

class Cards extends StatefulWidget {
  @override
  _CardsState createState() => _CardsState();
}

class _CardsState extends State<Cards> with AfterLayoutMixin<Cards> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AppState appState;
  List<VirtualCardModel> virtualCardModel = [];
  DarkThemeProvider darkThemeProvider;
  LoginState loginState;
  VirtualCardState virtualCardState;
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  bool isLoading = false;

  @override
  void initState() {
    getCurrentAppTheme();

    super.initState();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    virtualCardState = Provider.of<VirtualCardState>(context);
    themeChangeProvider = Provider.of(context, listen: false);
    loginState = Provider.of<LoginState>(context);
    appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor:
          themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Cards",
          style: GoogleFonts.mavenPro(
            color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
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
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
//                GestureDetector(
//                    onTap: () {
////                      Navigator.push(context, SizeRoute(page: CardDetails(
////
////
////                      )));
//                    },
//                    child: Text(
//                      "+ NEW CARD",
//                      style: GoogleFonts.mavenPro(
//                          fontWeight: FontWeight.bold,
//                          fontSize: 13,
//                          color: kprimaryYellow),
//                    ))
              ],
            ),
          ),
      virtualCardState.virtualModel != null ?     virtualCardState.virtualModel.length == 0 ? SizedBox(height: MediaQuery.of(context).size.height / 4)
              : SizedBox(height: 0,) : Container() ,
          isLoading ||   virtualCardState.virtualModel == null ? CircularProgressIndicator() :        virtualCardState.virtualModel.length == 0
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          SvgPicture.asset("images/creditVcard.svg",
                              color: themeChangeProvider.darkTheme
                                  ? kprimaryYellow
                                  : null),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "No Virtual card found",
                            style: GoogleFonts.raleway(
                                color: themeChangeProvider.darkTheme
                                    ? kprimaryYellow
                                    : kPrimaryColor,
                                fontSize: 12),
                          )
                        ])
                  : Column(
                      children: virtualCardState.virtualModel.map((e) {
                      print(e.is_active);
                      return e.is_active == "1"
                          ? VirtualCardActive(
                              themeChangeProvider: themeChangeProvider,
                              singleCard: e,
                            )
                          : VirtualCardInActive(
                              singleCard: e,
                              themeChangeProvider: themeChangeProvider,
                            );
                    }).toList()) ,
          Spacer(),
          isLoading ||   virtualCardState.virtualModel == null ? Container() :           Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.maxFinite,
              height: 50,
              child: RaisedButton(
                disabledColor:  kPrimaryColor,
                onPressed: () {

                  Navigator.push(context, FadeRoute(page: CardCarolScreen()));
                },
                child: Text(
                  "Create Card",
                  style: GoogleFonts.mavenPro(
                      fontSize: 16,
                      fontWeight: FontWeight.bold

                  ),
                ),
                color: kPrimaryColor,
                padding: EdgeInsets.symmetric(vertical: 15),
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),


//          primaryButton(
//              text: "Create Card",
//              onPress: () {
//
//
//
//              }),
          SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }

//transaction pin
  Container transactionPin(BuildContext context) {
    return Container(
//     height: MediaQuery.of(context).size.height* 0.6 ,
      height: 556.0,
      color: Colors.transparent,

      child: Column(
        children: [
          Expanded(
            child: TransactionConfirmationScreen(
              isDark: themeChangeProvider.darkTheme,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) async {
//    if(virtualCardState.virtualModel == null ){
      fetchVcards();
//    }

  }


  fetchVcards()async{
    setState(() {
      isLoading = true;
    });
    var result =
    await virtualCardState.listAllDollarCard(token: loginState.user.token);
//    print(result);
    setState(() {
      isLoading = false;
    });

  }
}

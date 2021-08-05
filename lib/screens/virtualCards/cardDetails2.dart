
import 'dart:math';

import 'package:after_layout/after_layout.dart';
//import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/animation/fadeRoute.dart';
import 'package:rex_money/animation/flipAnim.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/models/aSingleVirtualCardModel.dart';
import 'package:rex_money/models/cardTrans.dart';
import 'package:rex_money/models/virtualDollarCard.dart';
import 'package:rex_money/providers/appState.dart';
import 'package:rex_money/providers/conversionState.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/providers/virtualCardState.dart';
import 'package:rex_money/reusables/amountDialog.dart';
import 'package:rex_money/reusables/backVcard.dart';
import 'package:rex_money/reusables/dialoPopup.dart';
import 'package:rex_money/reusables/frontVcard.dart';
import 'package:rex_money/reusables/history.dart';
import 'package:rex_money/reusables/preloader.dart';
import 'package:rex_money/reusables/vCardWidget.dart';
import 'package:rex_money/screens/auth/login.dart';
import 'package:rex_money/screens/virtualCards/cardTransaction.dart';
import 'package:rex_money/screens/virtualCards/fundCard.dart';
import 'package:rex_money/screens/virtualCards/newCard.dart';
import 'package:rex_money/utils/commonUtils.dart';
import 'package:rex_money/utils/systemUtils.dart';

import '../transactions/transactions.dart';


class CardDetails22 extends StatefulWidget {
  final  VirtualCardModel singleCard ;
  CardDetails22({this.singleCard});
  @override
  _CardDetails22State createState() => _CardDetails22State();
}

class _CardDetails22State extends State<CardDetails22> with SingleTickerProviderStateMixin ,AfterLayoutMixin<CardDetails22> {
// animation


  AnimationController _animationController;
  Animation<double> _animation;
  Animation<double> _animationBack;
  AnimationStatus _animationStatus = AnimationStatus.dismissed;



  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _formKey = new GlobalKey<FormState>();
  AppState appState;
  DarkThemeProvider darkThemeProvider;
  LoginState loginState;
  ConversionState conversionState;
  ASingleVirtualCardModel aSingleVirtualCardModel;

  List<CardTransaction> cardTransaction = [];
  bool freezingLoading = false;
  bool isFetchingLoading = false;
  VirtualCardState virtualCardState;
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  AnimationController _controller;
  Animation<double> _frontScale;
  Animation<double> _backScale;
  bool isTerminating = false;
  bool isWithdrawing = false;
 var _amount;
   String _dropDownButtonValue;
  @override
  void initState() {
    getCurrentAppTheme();

    _controller = AnimationController(duration: Duration(milliseconds: 600), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
    await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {

    var colorCode = widget.singleCard.designCode.substring(1);
    // SizeConfig().init(context);
    themeChangeProvider = Provider.of<DarkThemeProvider>(context);
    loginState = Provider.of<LoginState>(context);
    conversionState = Provider.of<ConversionState>(context);
    virtualCardState = Provider.of<VirtualCardState>(context);
    appState = Provider.of<AppState>(context);
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Colors
            .white,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Cards", style: GoogleFonts.mavenPro(
            color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
            fontSize: 17,),),
          backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Colors
              .transparent,
          leading:  IconButton(icon: Icon(Icons.arrow_back, color: kprimaryYellow,),onPressed: ()=>Navigator.pop(context),),
        ),

        body: isFetchingLoading
            ? Center(child: CupertinoActivityIndicator())
            : SingleChildScrollView(
          child: Container(

            child: Column(
              children: [

                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text( aSingleVirtualCardModel == null ? ""  : aSingleVirtualCardModel.is_active == true ? "Active" :"Inactive", style: GoogleFonts.mavenPro(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color:   aSingleVirtualCardModel == null ? Colors.white :  aSingleVirtualCardModel.is_active == true ? kprimaryGreen :kPrimaryColor),)

                    ],
                  ),


                ),

                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(aSingleVirtualCardModel == null ? " " : aSingleVirtualCardModel.name_on_card,
                            style: GoogleFonts.mavenPro(fontWeight: FontWeight
                                .bold, fontSize: 13, color: themeChangeProvider
                                .darkTheme ? Colors.white : kPrimaryColor),),
                          Text(widget.singleCard.card_title,
                            style: GoogleFonts.raleway(fontWeight: FontWeight
                                .bold, fontSize: 9, color: themeChangeProvider
                                .darkTheme ? Colors.white : kPrimaryColor),)
                        ],
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(aSingleVirtualCardModel == null ? " " :   aSingleVirtualCardModel.amount,
                            style: GoogleFonts.mavenPro(fontWeight: FontWeight
                                .bold, fontSize: 14, color: kPrimaryColor),),
                          Text("Balance",
                            style: GoogleFonts.mavenPro(fontWeight: FontWeight
                                .bold, fontSize: 9, color: kPrimaryColor),)
                        ],

                      )
                    ],
                  ),
                ),

                SizedBox(height: 20,),





          AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget child) {
              bool isFront = _controller.value < .5;
              return InkWell(
                onTap: () {
                  if (_animation.isDismissed) {
                    _controller.forward();
                  } else if (_animation.isCompleted) {
                    _controller.reverse();
                  }
                },
                child: Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.002)
                    ..rotateY(pi * _animation.value + (isFront ? 0 : pi)),
                  alignment: FractionalOffset.center,
                  child: isFront ? VirtualCardWidget(
//                      height: 200,
//                      height: SizeConfig.safeBlockVertical * 28 ,
                      child: Front(

                        color: colorCode,
                        virtualCardModel: widget.singleCard,
                        aSingleVirtualCardModel: aSingleVirtualCardModel,
                      ),
                      color: Color(int.parse("0xff$colorCode"))
                  )

                      :
                  VirtualCardWidget(
//                    height: 200,
                    color: Color(int.parse("0xff$colorCode")),

                    child: Back(
                      virtualCardModel: widget.singleCard,
                      aSingleVirtualCardModel: aSingleVirtualCardModel,
                    ),
                  ),
                ),
              );

            }
            ),








                SizedBox(height: 20),

//                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: (){

                          setState(() {
                            if (_controller.isCompleted || _controller.velocity > 0)
                              _controller.reverse();
                            else
                              _controller.forward();
                          });

                        },
                        child: Container(
                          child: Row(

                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset("images/view.svg",
                                  color: themeChangeProvider.darkTheme
                                      ? kprimaryYellow
                                      : null),
                              SizedBox(width: 5,),
                              Text("Show",
                                  style: GoogleFonts.mavenPro(fontWeight: FontWeight
                                      .w500,
                                      fontSize: 13,
                                      color: themeChangeProvider.darkTheme ? Colors
                                          .white : kPrimaryColor)),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>FundVirtualcard(

                            id: widget.singleCard.card_id,
                          )));
                        },
                        child: Container(
                          child: Row(
                            children: [
                              SvgPicture.asset("images/fundV.svg",
                                color: themeChangeProvider.darkTheme
                                    ? kprimaryYellow
                                    : null,),
                              SizedBox(width: 5,),
                              Text("Fund",
                                  style: GoogleFonts.mavenPro(fontWeight: FontWeight
                                      .w500,
                                      fontSize: 13,
                                      color: themeChangeProvider.darkTheme ? Colors
                                          .white : kPrimaryColor))

                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showAlertDialog(context);
                        },

                        child: Container(
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "images/freeze.svg", color: themeChangeProvider
                                  .darkTheme ? kprimaryYellow : null,),
                              SizedBox(width: 5,),
                              Text( aSingleVirtualCardModel == null ? " " :  aSingleVirtualCardModel.is_active == true ? "Freeze"
                                  : "Unfreeze", style: GoogleFonts.mavenPro(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: themeChangeProvider.darkTheme ? Colors
                                      .white : kPrimaryColor))

                            ],
                          ),
                        ),
                      ),


                      Container(
                        child: Row(
                          children: [

                            DropdownButtonHideUnderline(
                            child: DropdownButton(

                                icon: Icon(Icons.keyboard_arrow_down, color: Colors.white,),
                                hint: Row(
                                  children: [
                                    SvgPicture.asset("images/more.svg",
                                      color: themeChangeProvider.darkTheme
                                          ? kprimaryYellow
                                          : null,),
                                    SizedBox(width: 5,),
                                    Text('More', overflow: TextOverflow.ellipsis, style: GoogleFonts.mavenPro(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                        color: themeChangeProvider.darkTheme ? Colors
                                            .white : kPrimaryColor)),
                                    Icon(Icons.arrow_drop_down)
                                  ],
                                ), //text shown on the button (optional)
                                elevation: 0,
                                items: <String>['Terminate ', "Withdraw"]
                                    .map((String val) => DropdownMenuItem<String>(

                                  value: val,
                                  child: Text(val,style: GoogleFonts.mavenPro(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: themeChangeProvider.darkTheme ? Colors
                                          .white : kPrimaryColor)),
                                ))
                                    .toList(),
                                onChanged: (value) {

//                          _dropDownButtonValue == "Terminate" ?       showAlertDialogTerminate(context) : print("withdrw");
                                  setState(() {

                                  _dropDownButtonValue = value;

                               value != "Withdraw" ?   showAlertDialogTerminate(context) : showAmountDialog(0);
                                  });
                                  print(value);
//                                print(_dropDownButtonValue);


                                }),
                          )
                              ],
                        ),
                      )
                    ],
                  ),
                ),
//                SizedBox(height: 30,),
                SizedBox(height:20,),
                Column(
                  children: [
                    Container(
                      color: kPrimaryColor.withOpacity(0.2),
                      height: 36,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20, left: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("RECENT ACTIVITY", style: GoogleFonts.mavenPro(
                                fontSize: 14,
                                color: themeChangeProvider.darkTheme
                                    ? kPrimaryDarkText
                                    : kPrimaryColor,
                                letterSpacing: 1.0),),
//                          GestureDetector(
//                              onTap: (){
//                                Navigator.push(context, SizeRoute(page: Transaction()));
//                              },
//
//                              child: Text("see more", style: GoogleFonts.mavenPro(fontSize: 14, color: themeChangeProvider.darkTheme ? kPrimaryDarkText: kPrimaryColor, fontWeight: FontWeight.bold ),)),
                          ],
                        ),
                      ),
                    ),


                    SizedBox(height: 10,),
        cardTransaction != null && cardTransaction.length == 0  ? Container() :         Container(
                    margin: EdgeInsets.only(right: 10, left: 10),
               height: 30,
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
//                      physics: NeverScrollableScrollPhysics(),
                        itemCount: cardTransaction != null ?   cardTransaction.length >= 3 ? 3 :  cardTransaction.length:0,
                        itemBuilder: (BuildContext context, index){

                          var e = cardTransaction[index];
                          return   HistoryCredit(
                            colorSub: themeChangeProvider.darkTheme  ? Colors.white : kPrimaryColor,
                            color:themeChangeProvider.darkTheme  ? kPrimaryDarkText : kprimaryLight,
                            date: e.created_at,
                            text: e.response_message,
                            currencyType: e.currency,
                            amount: e.amount,

                          ) ;

//                              : HistoryDebit(
//                            colorSub: themeChangeProvider.darkTheme  ? Colors.white : kPrimaryColor,
//                            color:themeChangeProvider.darkTheme  ? kPrimaryDarkText : kprimaryLight,
//                            date: e.date,
//                            text: e.text,
//                            currencyType: e.currencyType,
//                            amount: e.amount,
//                          );

                        },

                      ),
                    ),
                  ),

                    cardTransaction == null || cardTransaction.length == 0  ? Container() :           GestureDetector(
           onTap: (){
             Navigator.push(context, FadeRoute(page: CardTransactionsHistory(
               transactionHistory: cardTransaction,
               loading: false ,
             )));
           },

              child: Text("SEE MORE", style: GoogleFonts.mavenPro(fontSize: 12, color: themeChangeProvider.darkTheme ? Colors.white: kPrimaryColor, letterSpacing: 1.0),))

                  ],
                )

              ],
            ),
          ),
        )
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        Navigator.pop(context);
        freezeCard();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(aSingleVirtualCardModel.is_active == true
          ? "Freeze card"
          : "Unfreeze card"),
      content: Text(aSingleVirtualCardModel.is_active ?
      "Are you sure you want to Freeze this card?"
          : "Are you sure you want to Unfreeze this card?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }







  showAlertDialogTerminate(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel", style: GoogleFonts.mavenPro(color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor, fontSize: 12, fontWeight: FontWeight.bold),),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Yes", style: GoogleFonts.mavenPro(color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
      onPressed: () {
        Navigator.pop(context);
        terminate();

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
          "Terminate card", style: GoogleFonts.mavenPro(color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor, fontSize: 20, fontWeight: FontWeight.bold)),

      content: Text(
      "Are you sure you want to terminate this card?", style: GoogleFonts.mavenPro(color:themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor, fontSize: 14)),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }



  void freezeCard() async {
    print("called");
    setState(() {
      freezingLoading = true;
    });

    if (freezingLoading) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Preloader();
          });
    }


    var result = await virtualCardState.freezeCard(token: loginState.user.token, id: aSingleVirtualCardModel.id, type: aSingleVirtualCardModel.is_active ? "1" : "0");
    if (freezingLoading) {
      Navigator.pop(context, true);
    }
    if (result["error"] == false) {
      setState(() {
        CommonUtils.showMsg(result["message"], themeChangeProvider, context, _scaffoldKey, kPrimaryColor);
//        CommonUtils.showFlushBar(message: result["message"], title: "Title", context: context, backgroundColor: themeChangeProvider.darkTheme ? kprimaryYellow :kPrimaryColor);
      });
      getSinglecardDetails();
      fetchVcards();


    }else{
      CommonUtils.showMsg(result["message"], themeChangeProvider, context, _scaffoldKey, Colors.red);
    }
    var resultCards = await virtualCardState.listAllDollarCard(token: loginState.user.token);
    print(result);
    print(resultCards);
  }












  @override
  void afterFirstLayout(BuildContext context) async {

    getSinglecardDetails();
    getHistory();

  }



  fetchVcards()async{
    setState(() {
//      isLoading = true;
    });
    var result =
    await virtualCardState.listAllDollarCard(token: loginState.user.token);
//    print(result);
    setState(() {
//      isLoading = false;
    });

  }





  void getSinglecardDetails()async{
    setState(() {
      isFetchingLoading = true;
    });
    var result = await virtualCardState.aVirtualCard(
        token: loginState.user.token, id: widget.singleCard.card_id);
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
    } else  if (result["error"] == false) {
      setState(() {
        isFetchingLoading = false;
        aSingleVirtualCardModel = result["card"];
      });
    }
  }







  void showAmountDialog(double currentBalance) async {
    var amount = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            content: new AmountInputSheet(themeProvider: themeChangeProvider,),
          );
        });

    if (amount != null) {
      setState(() {
        _amount = amount;
      });
      withdraw();
      return;
    }
  }


  void getHistory() async {

    var result = await virtualCardState.getcardTransaction(
        to_date: "",
        from_date: "",
        token: loginState.user.token,
        id: widget.singleCard.card_id);
    if (result["error"] == false) {
      setState(() {
        isFetchingLoading = false;
        cardTransaction = result["cardTransaction"];
      });
    }
  }

  void terminate() async{
    setState(() {
      isTerminating = true;

    });

    if (isTerminating) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Preloader();
          });
    }


    var result = await virtualCardState.terminateCard(token: loginState.user.token, id: widget.singleCard.card_id);

    if (isTerminating) {
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
    else if (result["error"] == false){
      setState(() {
        CommonUtils.showMsg(result["message"], themeChangeProvider, context, _scaffoldKey, kPrimaryColor);


      });
    }else{
      CommonUtils.showMsg(result["message"], themeChangeProvider, context, _scaffoldKey, kPrimaryColor);
    }
  }



  void withdraw()async{
    setState(() {
      isWithdrawing = true;

    });

    if (isWithdrawing) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Preloader();
          });
    }


    var result = await virtualCardState.withdrawCard(token: loginState.user.token, id: widget.singleCard.card_id, amount: _amount);

    if (isWithdrawing) {
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
    else if (result["error"] == false){
      setState(() {
        CommonUtils.showMsg(result["message"], themeChangeProvider, context, _scaffoldKey, kPrimaryColor);
        getSinglecardDetails();
      });
    }else{
      CommonUtils.showMsg(result["message"], themeChangeProvider, context, _scaffoldKey, kPrimaryColor);
    }

  }

}











//
//import 'dart:math';
//
//import 'package:after_layout/after_layout.dart';
////import 'package:flip_card/flip_card.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_svg/svg.dart';
//import 'package:google_fonts/google_fonts.dart';
//import 'package:provider/provider.dart';
//import 'package:rex_money/animation/flipAnim.dart';
//import 'package:rex_money/constants/colorConstants.dart';
//import 'package:rex_money/models/aSingleVirtualCardModel.dart';
//import 'package:rex_money/models/virtualDollarCard.dart';
//import 'package:rex_money/providers/appState.dart';
//import 'package:rex_money/providers/conversionState.dart';
//import 'package:rex_money/providers/darkmode.dart';
//import 'package:rex_money/providers/loginState.dart';
//import 'package:rex_money/providers/virtualCardState.dart';
//import 'package:rex_money/reusables/history.dart';
//import 'package:rex_money/reusables/preloader.dart';
//import 'package:rex_money/screens/virtualCards/fundCard.dart';
//import 'package:rex_money/screens/virtualCards/newCard.dart';
//import 'package:rex_money/utils/commonUtils.dart';
//
//import '../transactions/transactions.dart';
//
//
//class CardDetails extends StatefulWidget {
//  final  VirtualCardModel singleCard ;
//  CardDetails({this.singleCard});
//  @override
//  _CardDetailsState createState() => _CardDetailsState();
//}
//
//class _CardDetailsState extends State<CardDetails> with SingleTickerProviderStateMixin ,AfterLayoutMixin<CardDetails> {
//// animation
//
//
//  AnimationController _animationController;
//  Animation<double> _animation;
//  Animation<double> _animationBack;
//  AnimationStatus _animationStatus = AnimationStatus.dismissed;
//
//
//
//  final _scaffoldKey = GlobalKey<ScaffoldState>();
//  var _formKey = new GlobalKey<FormState>();
//  AppState appState;
//  DarkThemeProvider darkThemeProvider;
//  LoginState loginState;
//  ConversionState conversionState;
//  ASingleVirtualCardModel aSingleVirtualCardModel;
//  bool freezingLoading = false;
//  bool isFetchingLoading = false;
//  VirtualCardState virtualCardState;
//  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
//bool  forward = true;
//  bool _displayFront;
//
//  FlipCard flipCard = FlipCard(front: null, back: null);
//  bool _flipXAxis;
//  @override
//  void initState() {
//    getCurrentAppTheme();
//
//    _animationController =  AnimationController(vsync: this, duration:  Duration(milliseconds:500 ));
//
//    _animation = Tween<double>(end: 1, begin: 0).animate(_animationController)
//      ..addListener(() {
//        setState(() {});
//      })
//
//      ..addStatusListener((status) {
//        _animationStatus = status;
//      });
//
//
//    _animationBack = Tween<double>(begin: -pi / 2, end: 0.0).animate(_animationController)
//      ..addListener(() {
//        setState(() {});
//      })
//
//      ..addStatusListener((status) {
//        _animationStatus = status;
//      });
//
//    _displayFront = true;
//    _flipXAxis = true;
//
//
//    super.initState();
//  }
//
//  void getCurrentAppTheme() async {
//    themeChangeProvider.darkTheme =
//    await themeChangeProvider.darkThemePreference.getTheme();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//
//    var colorCode = widget.singleCard.designCode.substring(1);
//    print(colorCode);
//    themeChangeProvider = Provider.of<DarkThemeProvider>(context);
//    loginState = Provider.of<LoginState>(context);
//    conversionState = Provider.of<ConversionState>(context);
//    virtualCardState = Provider.of<VirtualCardState>(context);
//    appState = Provider.of<AppState>(context);
//    return Scaffold(
//        key: _scaffoldKey,
//        backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Colors
//            .white,
//        appBar: AppBar(
//          centerTitle: true,
//          title: Text("Cards", style: GoogleFonts.mavenPro(
//            color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
//            fontSize: 17,),),
//          backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Colors
//              .transparent,
//          leading:  IconButton(icon: Icon(Icons.arrow_back, color: kprimaryYellow,),onPressed: ()=>Navigator.pop(context),),
//        ),
//
//        body: isFetchingLoading
//            ? Center(child: CupertinoActivityIndicator())
//            : SingleChildScrollView(
//          child: Container(
//
//            child: Column(
//              children: [
//
//                Container(
//                  margin: EdgeInsets.symmetric(
//                    horizontal: 20,
//                  ),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.end,
//                    children: [
//                      Text( aSingleVirtualCardModel == null ? ""  : aSingleVirtualCardModel.is_active == true ? "Active" :"Inactive", style: GoogleFonts.mavenPro(
//                          fontWeight: FontWeight.bold,
//                          fontSize: 13,
//                          color:   aSingleVirtualCardModel == null ? Colors.white :  aSingleVirtualCardModel.is_active == true ? kprimaryGreen :kPrimaryColor),)
//
//                    ],
//                  ),
//
//
//                ),
//
//                Container(
//                  margin: EdgeInsets.symmetric(
//                      horizontal: 20,
//                      vertical: 10),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: [
//                      Column(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: [
//                          Text(aSingleVirtualCardModel == null ? " " : aSingleVirtualCardModel.name_on_card,
//                            style: GoogleFonts.mavenPro(fontWeight: FontWeight
//                                .bold, fontSize: 13, color: themeChangeProvider
//                                .darkTheme ? Colors.white : kPrimaryColor),),
//                          Text(widget.singleCard.card_title,
//                            style: GoogleFonts.raleway(fontWeight: FontWeight
//                                .bold, fontSize: 9, color: themeChangeProvider
//                                .darkTheme ? Colors.white : kPrimaryColor),)
//                        ],
//                      ),
//
//                      Column(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: [
//                          Text(aSingleVirtualCardModel == null ? " " :   aSingleVirtualCardModel.amount,
//                            style: GoogleFonts.mavenPro(fontWeight: FontWeight
//                                .bold, fontSize: 14, color: kPrimaryColor),),
//                          Text("Balance",
//                            style: GoogleFonts.mavenPro(fontWeight: FontWeight
//                                .bold, fontSize: 9, color: kPrimaryColor),)
//                        ],
//
//                      )
//                    ],
//                  ),
//                ),
//
//                SizedBox(height: 20,),
//
//
////                FlipCard(
////
////                  direction: FlipDirection.HORIZONTAL, // default
////                  front: VirtualCardWidget(
////                      child: Front(
////                        color: colorCode,
////                        virtualCardModel: widget.singleCard,
////                        aSingleVirtualCardModel: aSingleVirtualCardModel,
////                      ),
////                      color: Color(int.parse("0xff$colorCode"))
////                  ),
////                  back: VirtualCardWidget(
////                      color: Color(int.parse("0xff$colorCode")),
////
////                    child: Back(
////                      virtualCardModel: widget.singleCard,
////                      aSingleVirtualCardModel:  aSingleVirtualCardModel,
////                    ),
////                  ),
////                ),
//
//
//
//
//
//
//
//
//                SizedBox(height: 30,),
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceAround,
//                  children: [
//                    GestureDetector(
//                      onTap: (){
//
//
//                      },
//                      child: Container(
//                        child: Row(
//
//                          mainAxisAlignment: MainAxisAlignment.start,
//                          children: [
//                            SvgPicture.asset("images/view.svg",
//                                color: themeChangeProvider.darkTheme
//                                    ? kprimaryYellow
//                                    : null),
//                            SizedBox(width: 5,),
//                            Text("Show",
//                                style: GoogleFonts.mavenPro(fontWeight: FontWeight
//                                    .w500,
//                                    fontSize: 13,
//                                    color: themeChangeProvider.darkTheme ? Colors
//                                        .white : kPrimaryColor)),
//                          ],
//                        ),
//                      ),
//                    ),
//                    GestureDetector(
//                      onTap: () {
//   Navigator.push(context, MaterialPageRoute(builder: (context)=>FundVirtualcard(
//
//     id: widget.singleCard.card_id,
//   )));
//                      },
//                      child: Container(
//                        child: Row(
//                          children: [
//                            SvgPicture.asset("images/fundV.svg",
//                              color: themeChangeProvider.darkTheme
//                                  ? kprimaryYellow
//                                  : null,),
//                            SizedBox(width: 5,),
//                            Text("Fund",
//                                style: GoogleFonts.mavenPro(fontWeight: FontWeight
//                                    .w500,
//                                    fontSize: 13,
//                                    color: themeChangeProvider.darkTheme ? Colors
//                                        .white : kPrimaryColor))
//
//                          ],
//                        ),
//                      ),
//                    ),
//                    GestureDetector(
//                      onTap: () {
//                        showAlertDialog(context);
//                      },
//
//                      child: Container(
//                        child: Row(
//                          children: [
//                            SvgPicture.asset(
//                              "images/freeze.svg", color: themeChangeProvider
//                                .darkTheme ? kprimaryYellow : null,),
//                            SizedBox(width: 5,),
//                            Text( aSingleVirtualCardModel == null ? " " :  aSingleVirtualCardModel.is_active == true ? "Freeze"
//                                : "Unfreeze", style: GoogleFonts.mavenPro(
//                                fontWeight: FontWeight.w500,
//                                fontSize: 13,
//                                color: themeChangeProvider.darkTheme ? Colors
//                                    .white : kPrimaryColor))
//
//                          ],
//                        ),
//                      ),
//                    ),
//                    Container(
//                      child: Row(
//                        children: [
//                          SvgPicture.asset("images/more.svg",
//                            color: themeChangeProvider.darkTheme
//                                ? kprimaryYellow
//                                : null,),
//                          SizedBox(width: 5,),
//                          Text("More")
//
//                        ],
//                      ),
//                    )
//                  ],
//                ),
//                SizedBox(height: 30,),
//
//                Column(
//                  children: [
//                    Container(
//                      color: kPrimaryColor.withOpacity(0.2),
//                      height: 36,
//                      child: Padding(
//                        padding: const EdgeInsets.only(right: 20, left: 20),
//                        child: Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: [
//                            Text("RECENT ACTIVITY", style: GoogleFonts.mavenPro(
//                                fontSize: 14,
//                                color: themeChangeProvider.darkTheme
//                                    ? kPrimaryDarkText
//                                    : kPrimaryColor,
//                                letterSpacing: 1.0),),
////                          GestureDetector(
////                              onTap: (){
////                                Navigator.push(context, SizeRoute(page: Transaction()));
////                              },
////
////                              child: Text("see more", style: GoogleFonts.mavenPro(fontSize: 14, color: themeChangeProvider.darkTheme ? kPrimaryDarkText: kPrimaryColor, fontWeight: FontWeight.bold ),)),
//                          ],
//                        ),
//                      ),
//                    ),
//
//
//                    SizedBox(height: 10,),
////                  Container(
////                    margin: EdgeInsets.only(right: 10, left: 10),
////                    height: 240,
////                    child: MediaQuery.removePadding(
////                      context: context,
////                      removeTop: true,
////                      child: ListView.builder(
//////                      physics: NeverScrollableScrollPhysics(),
////                        itemCount: appState.allHistory.length >= 3 ? 3 :  appState.allHistory.length,
////                        itemBuilder: (BuildContext context, index){
////
////                          var e = appState.allHistory[index];
////                          return  appState.allHistory[index].type == "credit"? HistoryCredit(
////                            colorSub: themeChangeProvider.darkTheme  ? Colors.white : kPrimaryColor,
////                            color:themeChangeProvider.darkTheme  ? kPrimaryDarkText : kprimaryLight,
////                            date: e.date,
////                            text: e.text,
////                            currencyType: e.currencyType,
////                            amount: e.amount,
////
////                          ) : HistoryDebit(
////                            colorSub: themeChangeProvider.darkTheme  ? Colors.white : kPrimaryColor,
////                            color:themeChangeProvider.darkTheme  ? kPrimaryDarkText : kprimaryLight,
////                            date: e.date,
////                            text: e.text,
////                            currencyType: e.currencyType,
////                            amount: e.amount,
////                          );
////
////                        },
////
////                      ),
////                    ),
////                  ),
//
////          GestureDetector(
////           onTap: (){
////             Navigator.push(context, FadeRoute(page: NewCard()));
////           },
////
////              child: Text("SEE MORE", style: GoogleFonts.mavenPro(fontSize: 12, color: themeChangeProvider.darkTheme ? Colors.white: kPrimaryColor, letterSpacing: 1.0),))
//
//                  ],
//                )
//
//              ],
//            ),
//          ),
//        )
//    );
//  }
//
//  showAlertDialog(BuildContext context) {
//    // set up the buttons
//    Widget cancelButton = FlatButton(
//      child: Text("Cancel"),
//      onPressed: () {
//        Navigator.pop(context);
//      },
//    );
//    Widget continueButton = FlatButton(
//      child: Text("Yes"),
//      onPressed: () {
//        Navigator.pop(context);
//        freezeCard();
//      },
//    );
//
//    // set up the AlertDialog
//    AlertDialog alert = AlertDialog(
//      title: Text(aSingleVirtualCardModel.is_active == true
//          ? "Freeze card"
//          : "Unfreeze card"),
//      content: Text(aSingleVirtualCardModel.is_active ?
//          "Are you sure you want to Freeze this card?"
//          : "Are you sure you want to Unfreeze this card?"),
//      actions: [
//        cancelButton,
//        continueButton,
//      ],
//    );
//
//    // show the dialog
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        return alert;
//      },
//    );
//  }
//
//
//  void freezeCard() async {
//    print("called");
//    setState(() {
//      freezingLoading = true;
//    });
//
//    if (freezingLoading) {
//      showDialog(
//          context: context,
//          barrierDismissible: false,
//          builder: (BuildContext context) {
//            return Preloader();
//          });
//    }
//
//
//    var result = await virtualCardState.freezeCard(token: loginState.user.token, id: aSingleVirtualCardModel.id, type: aSingleVirtualCardModel.is_active ? "1" : "0");
//    if (freezingLoading) {
//      Navigator.pop(context, true);
//    }
//    if (result["error"] == false) {
//      setState(() {
//        CommonUtils.showFlushBar(message: result["message"], title: "Title", context: context, backgroundColor: themeChangeProvider.darkTheme ? kprimaryYellow :kPrimaryColor);
//      });
//      getSinglecardDetails();
//
//
//    }else{
//      CommonUtils.showMsg(result["message"], themeChangeProvider, context, _scaffoldKey, Colors.red);
//    }
//    var resultCards = await virtualCardState.listAllDollarCard(token: loginState.user.token);
//    print(result);
//    print(resultCards);
//  }
//  Widget __buildLayout({Key key, String faceName, Color backgroundColor}) {
//    return Container(
//      key: key,
//      decoration: BoxDecoration(
//        shape: BoxShape.rectangle,
//        borderRadius: BorderRadius.circular(20.0),
//        color: backgroundColor,
//      ),
//      child: Center(
//        child: Text(faceName.substring(0, 1), style: TextStyle(fontSize: 80.0)),
//      ),
//    );
//  }
//
//
//
//
//
//
//
//
//  @override
//  void afterFirstLayout(BuildContext context) async {
//
//getSinglecardDetails();
//    getHistory();
//
//  }
//
//
//
//
//
//
//
//
//
// void getSinglecardDetails()async{
//   setState(() {
//     isFetchingLoading = true;
//   });
//   var result = await virtualCardState.aVirtualCard(
//       token: loginState.user.token, id: widget.singleCard.card_id);
//   if (result["error"] == false) {
//     setState(() {
//       isFetchingLoading = false;
//       aSingleVirtualCardModel = result["card"];
//     });
//   }
// }
//
//
//
//  void getHistory() async {
//    var result = await virtualCardState.getcardTransaction(
//        to_date: "2020-12-01",
//        from_date: "2020-12-01",
//        token: loginState.user.token,
//        id: widget.singleCard.card_id);
//    if (result["error"] == false) {
//      setState(() {
//        isFetchingLoading = false;
////        aSingleVirtualCardModel = result["card"];
//      });
//    }
//  }
//
//}
//
//class VirtualCardWidget extends StatelessWidget {
//    final Widget child;
//    final Color color;
//    VirtualCardWidget({this.child, this.color});
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      height: MediaQuery.of(context).size.height * 0.23,
//                width: double.infinity,
//                margin: EdgeInsets.symmetric(
//                    horizontal: 30,
//                    vertical: 0),
//                child: Material(
//                  borderRadius: BorderRadius.circular(15),
//                  color: color,
//                  elevation: 1,
//                  child: child,
//                ),
//              );
//  }
//}
//
//
//class Front extends StatelessWidget {
//  final VirtualCardModel virtualCardModel;
//  final String color;
//  final ASingleVirtualCardModel aSingleVirtualCardModel;
//  Front({this.virtualCardModel, this.aSingleVirtualCardModel, this.color});
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//
//      margin: EdgeInsets.symmetric(
//          horizontal: 20,
//          vertical: 10),
//      child: Column(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        children: [
//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: [
//              Text("VIRTUAL USD CARD", style: GoogleFonts.mavenPro(fontWeight: FontWeight.bold, fontSize: 9, color: color =="3F2B4B" ? Colors.white :  kPrimaryColor),),
//              Padding(
//                padding: const EdgeInsets.only(top: 10),
//                child: SvgPicture.asset("images/logorex.svg"),
//              )
//            ],),
//          Row(
//            children: [
//              Image.asset("images/chip.png"),
//              SizedBox(width: 20,),
//              SvgPicture.asset("images/rexText.svg", color: color =="3F2B4B" ? Colors.white : null),
//            ],
//          ),
//
//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: [
//              Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: [
//                  Text("Card Name", style: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 5, color: color =="3F2B4B" ? Colors.white :  kPrimaryColor),),
//                  Text(virtualCardModel.card_title, style: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 9, color: color =="3F2B4B" ? Colors.white :   kPrimaryColor),),
//                ],
//              ),
//
//              aSingleVirtualCardModel == null ? Container() :     aSingleVirtualCardModel.card_type == "mastercard" ? Image.asset("images/masterRex.png"):Image.asset("images/visaBlue.png") ,
//            ],
//          )
//        ],
//      ),
//    );
//  }
//}
//
//
//class Back extends StatelessWidget {
//  final VirtualCardModel virtualCardModel;
//  final ASingleVirtualCardModel aSingleVirtualCardModel;
//  Back({this.aSingleVirtualCardModel, this.virtualCardModel});
//  @override
//  Widget build(BuildContext context) {
//    return Column(
//      mainAxisAlignment: MainAxisAlignment.start,
//      crossAxisAlignment: CrossAxisAlignment.start,
//
//      children: <Widget>[
//        Container(
//
//          margin: const EdgeInsets.only(top: 16),
//          height: 48,
//          width: double.infinity,
//          color: Colors.black,
//          child: Center(child: Text(aSingleVirtualCardModel == null ? " " :  aSingleVirtualCardModel.card_pan, style: GoogleFonts.mavenPro(color: Colors.white),)),
//        ),
////        Container(
////          margin: const EdgeInsets.only(top: 16),
////          child: Row(
////            crossAxisAlignment: CrossAxisAlignment.center,
////            children: <Widget>[
////              Expanded(
////                flex: 9,
////                child: Container(
////                  height: 38,
////                  color: Colors.white70,
////                ),
////              ),
////              Expanded(
////                flex: 3,
////                child: Container(
////                  color: Colors.white,
////                  child: Padding(
////                    padding: const EdgeInsets.all(5),
////                    child: Text(
////                      'XXX',
////
////                      maxLines: 1,
////                  style: TextStyle(color: Colors.black),
////                    ),
////                  ),
////                ),
////              )
////            ],
////          ),
////        ),
////          Expanded(
////            flex: 2,
////            child: Align(
////              alignment: Alignment.bottomRight,
////              child: Padding(
////                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
////                child: getCardTypeIcon(widget.cardNumber),
////              ),
////            ),
////          ),
//        Row(
//          crossAxisAlignment: CrossAxisAlignment.baseline,
//          children: [
//            Expanded(
//              flex: 4,
//              child: Container(
//
//                margin: const EdgeInsets.only(top: 16),
//                height: 30,
//                width: double.infinity,
//                color: Colors.grey,
//                child: Center(child: Text("", style: GoogleFonts.mavenPro(color: Colors.white),)),
//              ),
//            ),
//            SizedBox(width: 10,),
//            Text(aSingleVirtualCardModel == null ? " " :  aSingleVirtualCardModel.cvv)
//          ],
//        ),
//
//
//      ],
//    );
//  }
//
//
//
//
//
//
//}
//
//

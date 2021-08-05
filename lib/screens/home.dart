import 'dart:async';
import 'dart:io';
import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import 'package:rex_money/animation/fadeRoute.dart';
import 'package:rex_money/animation/sizeRoute.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/models/history.dart';
import 'package:rex_money/providers/appState.dart';
import 'package:rex_money/providers/conversionState.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/providers/transferState.dart';
import 'package:rex_money/reusables/customNav.dart';
import 'package:rex_money/reusables/dialoPopup.dart';
import 'package:rex_money/reusables/drawer.dart';
import 'package:rex_money/reusables/drawerList.dart';
import 'package:rex_money/reusables/history.dart';
import 'package:rex_money/reusables/popupModal.dart';
import 'package:rex_money/screens/notification/notificationScreen.dart';
import 'package:rex_money/screens/rates/rate.dart';
import 'package:rex_money/screens/dashboard.dart';
import 'package:rex_money/screens/fundAccount/fundAccount.dart';
import 'package:rex_money/screens/profile/profile.dart';
import 'package:rex_money/screens/requestMoney/requestMoney.dart';
import 'package:rex_money/screens/sendMoney/sendMoney.dart';
import 'package:rex_money/screens/profile/settings.dart';
import 'package:rex_money/screens/transactions/transactions.dart';
import 'package:rex_money/screens/user_profile.dart';
import 'package:rex_money/screens/virtualCards/cards.dart';
import 'package:rex_money/utils/commonUtils.dart';
import 'package:rex_money/utils/myUtils.dart';
import 'package:rex_money/utils/sizeConfig/sizeConfig.dart';
import 'package:rex_money/utils/systemUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth/login.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AfterLayoutMixin<Home> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  bool transactionLoading = false;
  AppState appState;
  TransferState transferState;
  LoginState loginState;
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  ConversionState conversionState;
  List<HistoryModel> transactionHistory = [];
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  var deviceId;
  var myDeviceToken;
  Timer timer;




  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    Future.delayed(Duration.zero, () {
      this.firebaseCloudMessagingListeners(context);
    });
//    initPlatformState();

    saveAuthCredentials();

    super.initState();
  }


  pinging() {
//    print("pinging");
    timer = Timer.periodic(Duration(minutes: 2), (Timer t) => getUserAuth());
  }

  void firebaseCloudMessagingListeners(BuildContext context) {
//    print("friririririrrebase");
    _firebaseMessaging.getToken().then((deviceToken) {
//      print("Firebase Device token: $deviceToken");
      setState(() {
        appState.myDeviceToken = deviceToken;
      });
//      print("Firebase Device token: ${appState.myDeviceToken}");
    });
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
//        appState.moneyRequest = true;
//        print("onMessage: $message");
//        print(message["notification"]["data"]);
//        print(message["data"]["notification_type"]);
        if (message["data"]["notification_type"] == "money-request" &&
            message["data"]["notification_type"] == "wallet-funding-success") {
          appState.moneyRequest = true;
          getUserAuth();
        }
      },
//      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
//        print("onLaunch: $message");
//        _navigateToItemDetail(message);

        _parseNotification(message, true);
      },
      onResume: (Map<String, dynamic> message) async {
//        print("onResume: $message");

//        _parseNotification(message, true);
//        _navigateToItemDetail(message);
      },
    );
  }

  _parseNotification(notification, bool showDetails) async {
//    print('Firebase message = $notification');
//    print('Firebase 555 = ${notification['notification']}');
    var message = notification['notification_body'];
//    print("$message parse notif");
    var isIos = Platform.isIOS;
//    Map<String, dynamic> message = json.decode(notification.containsKey('data')
//        ? notification['data']['message'] // When app is in foreground
//        : notification['message']);
    //Map<String, dynamic> message = Map();
    if (isIos == true) {
//      var jobId = notification['restaurant_id'];
//      var orderId = notification['order_id'];

//      if (showDetails) {
//        _startJobDetails();
//      } else {
////          _showJobNotif(message['title']);
//        _showJobNotificationDialog(message['title']);

//        if(message['title'] == "Ride has started"){
//          setState(() {
////            _loginViewModel.canContinue = true;
////            print("_loginViewModel.canContinue ${_loginViewModel.canContinue}");
//          });

//        }else if(message['title']== "started"){
//          setState(() {
////              _loginViewModel.hasStarted = true;
////              print("_loginViewModel.hasStarted ${_loginViewModel.hasStarted}");
//          });
//        }

    } else {
//      var message = message['data'];

//      print(message);
      if (showDetails) {
//        _startJobDetails();
      } else {
//        _showJobNotificationDialog(message['title']);
      }
    }
  }

  void _showJobNotificationDialog(
    String value,
    String status,
  ) async {
//    print("sdsf $value");

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text(status),
            content: Text(value),
          );
        });
  }

//  String _deviceId = 'Unknown';
  int _selectedIndex = 0;
  int selectedIndex = 0;

  void setBottomItem(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void getCurrentAppTheme() async {
//    print("called theme");
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();

//    print(themeChangeProvider);
  }

  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    loginState = Provider.of<LoginState>(context);
    appState = Provider.of<AppState>(context);
    conversionState = Provider.of<ConversionState>(context);
    // SizeConfig().init(context);
    transferState = Provider.of<TransferState>(context);

    themeChangeProvider = Provider.of<DarkThemeProvider>(context);
    loginState.saveUser();

    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDarkAccent : Colors.white,
        // backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Color(0xff0F1E72),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: CustomBottomNav(
          themeProvider: themeChangeProvider,
          onChanged: (v) {
//        setBottomItem(index);
//                        setBottomItem(0);
            if (v == 1) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ReceiveMoney(
//                                      appState: appState,
                          )));
            } else if (v == 2 && loginState.user.country == "Nigeria") {
              CommonUtils.modalBottomSheetMenu(
                  context: context,
                  body: buildModal(
                      loginState: loginState,
                      text: "Account Information",
                      subText: loginState.user.bankAaccountNumber,
                      themeChangeProvider: themeChangeProvider),
                  darkThemeProvider: themeChangeProvider);
            } else if ((v == 2 && loginState.user.country != "Nigeria")) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => FundAccount()));
            } else if (v == 3) {
//            print(v);
              Navigator.push(context, MaterialPageRoute(builder: (_) => Cards()));
            }
          },
        ),

        floatingActionButton: Container(
//      margin: EdgeInsets.all(10),
          child: FloatingActionButton(
            backgroundColor: themeChangeProvider.darkTheme ? kPrimaryColor : kPrimaryColor,
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => SendMoney()));
            },
            child: Transform.translate(
              offset: Offset(-2.1, 0),
              child: SvgPicture.asset("images/aeronew.svg"),
              //child: SvgPicture.asset("images/aero.svg"),
            ),
          ),
        ),
        body: Container(
             height: MediaQuery.of(context).size.height,
             color: themeChangeProvider.darkTheme ? kPrimaryDarkAccent : Color(0xff0F1E72),
         // color: MyColors.colorPrimary,
          child: Column(
            children: [
              Container(
               height: height*0.2,
//              height: SizeConfig.blockSizeVertical * 28.0,
//              width: SizeConfig.blockSizeHorizontal * 50,
                width: double.maxFinite,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,  //framedashboarddark
                        image: themeChangeProvider.darkTheme ? AssetImage("images/framedashboarddark.png") : AssetImage("images/frameDashboard.png"))),  //
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                   SizedBox(height: 10,),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     // GestureDetector(
                    //     //   onTap: () {
                    //     //     scaffoldKey.currentState.openDrawer();
                    //     //   },
                    //     //   child: Icon(
                    //     //     Icons.menu,
                    //     //     color: Colors.white,
                    //     //   ),
                    //     // ),
                    //     // Spacer(),
                    //     GestureDetector(
                    //       onTap: () {
                    //         appState.moneyRequest = false;
                    //         Navigator.push(
                    //             context, FadeRoute(page: NotificationScreen()));
                    //       },
                    //       child: Stack(
                    //         children: <Widget>[
                    //           Icon(
                    //             Icons.notifications,
                    //             color: Colors.white,
                    //           ),
                    //           if (appState.moneyRequest)
                    //             Icon(
                    //               Icons.notifications_active,
                    //               color: kprimaryYellow,
                    //             ),
                    //         ],
                    //       ),
                    //     )
                    //   ],
                    // ),
                    Row(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        loginState != null
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context, FadeRoute(page: ProfileScreen()));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Color(0xffE2E7F2).withOpacity(0.27),
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(360),
                                    child: Image.network(
                                      loginState.user.profilepic,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome back",
                               // "Welcome back @${loginState.user.userTag}",
                                style: GoogleFonts.raleway(
                                    color: Colors.white, fontSize: 12,
                                fontWeight:FontWeight.w400),
                              ),

                              RichText(
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                    text: loginState.user.firstName,
                                    style: GoogleFonts.mavenPro(
                                        fontSize: 24, fontWeight: FontWeight.bold),
                                    children: [
                                      TextSpan(
                                          text: " ${loginState.user.lastName}",
                                          style: GoogleFonts.mavenPro(
                                              color: kprimaryYellow,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold))
                                    ]),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            appState.moneyRequest = false;
                            Navigator.push(
                                context, FadeRoute(page: NotificationScreen()));
                          },
                          child: Stack(
                            children: <Widget>[
                              Icon(
                                Icons.notifications,
                                color: Colors.white,
                              ),
                              if (appState.moneyRequest)
                                Icon(
                                  Icons.notifications_active,
                                  color: kprimaryYellow,
                                ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height:22.25 * SizeConfig.heightMultiplier,
                            // height:16.9 * SizeConfig.heightMultiplier,
                            width: double.maxFinite,
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
//                          color: Colors.red,
                                color: themeChangeProvider.darkTheme
                                    ? kPrimaryDark
                                    : Colors.white,
                                image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image: themeChangeProvider.darkTheme ? AssetImage("images/framedashdark1.png") : AssetImage("images/framedash1.png"))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${loginState.user.currency} ACCOUNT",
                                  style: GoogleFonts.mavenPro(
                                      fontSize: 12,
                                      color: Colors.white,
                                      letterSpacing: 10.0),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
//
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          " ${loginState.user.symbol} ${MyUtils.getFormattedAmount(double.parse(loginState.user.balance.toString()))}",
                                          style: GoogleFonts.mavenPro(
                                              color: Colors.white,
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
//                                Icon(
//                                  Icons.arrow_forward_ios_rounded,
//                                  color: kPrimaryColor,
//                                ),
                                  ],
                                ),
                                Text(
                                  "Available Balance",
                                  style: GoogleFonts.mavenPro(
                                      fontSize: 14,
                                      color: Colors.white,
                                      letterSpacing: 1.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.all(10),

                        color:  themeChangeProvider.darkTheme ? Color(0x263E3F6F): Color(0xffE9EAFD),
                       // color: kPrimaryColor.withOpacity(0.3),
                        child: Row(
                          children: [
                            Text(
                              "RECENT ACTIVITY",
                              style: GoogleFonts.mavenPro(
                                color:  themeChangeProvider.darkTheme ? kPrimaryDarkText: kPrimaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 14
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    SizeRoute(
                                        page: Transaction(
                                      transactionHistory: transactionHistory,
                                      loading: transactionLoading,
                                    )));
                              },
                              child: Text(
                                "See more",
                                style: GoogleFonts.mavenPro(
                                  color: themeChangeProvider.darkTheme ? kPrimaryDarkText: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                    fontSize: 14
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      transactionLoading
                          ? Expanded(
                            child: Column(
                              children: [
                                SizedBox(height: 10,),
                                CupertinoActivityIndicator(),
                              ],
                            ),
                          )
                          : transactionHistory  != null && transactionHistory.length > 0 ?  Expanded(
                            child: RefreshIndicator(
                        onRefresh: _pullRefresh,
                        child: Container(
                            color: themeChangeProvider.darkTheme
                                ? kPrimaryDark
                                : Colors.white,
                            child: MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              child: ListView(
                                children: List.generate(
                                  transactionHistory.length < 5
                                      ? transactionHistory.length
                                      : 5,
                                      (index) {
                                    var e = transactionHistory[index];

                                    return transactionHistory[index].type ==
                                        "CR"
                                        ? HistoryCredit(
                                      colorSub:
                                      themeChangeProvider.darkTheme
                                          ? Colors.white
                                          : kPrimaryColor,
                                      color:
                                      themeChangeProvider.darkTheme
                                          ? kPrimaryDarkText
                                          : kprimaryLight,
                                      date: e.date,
                                      text: e.remark,
                                      currencyType:
                                      loginState.user.currency,
                                      amount: e.amount,
                                    )
                                        : HistoryDebit(
                                      colorSub:
                                      themeChangeProvider.darkTheme
                                          ? Colors.white
                                          : kPrimaryColor,
                                      color:
                                      themeChangeProvider.darkTheme
                                          ? kPrimaryDarkText
                                          : kprimaryLight,
                                      date: e.date,
                                      text: e.remark,
                                      currencyType:
                                      loginState.user.currency,
                                      amount: e.amount,
                                    );
                                  },
                                ),
                              ),
                            ),
                        ),
                      ),
                          ) : Center(
                            child: Container(
                           // margin: EdgeInsets.symmetric(vertical: 30),
                              margin: EdgeInsets.symmetric(vertical: height*0.03),

                              child: Column(
                            children: [

                              Text("No Transaction yet.", style: GoogleFonts.mavenPro(color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor, fontSize: 15),),
                              Text("Initiate transaction to view record", style: GoogleFonts.mavenPro(color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor, fontSize: 12),)
                            ],
                        ),

                      ),
                          )







                    ],
                  ),
                  decoration: BoxDecoration(
//                color: Colors.red,
                    color: themeChangeProvider.darkTheme ? kDashboardDark : Colors.white,
                    // color: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }



  Future<void> _pullRefresh() async {
     await getTransactionHistoryPull();
     await getUserAuth();

  }




@override
  void afterFirstLayout(BuildContext context) async {
    pinging();
    getUserAuth();

//    print("balance ${loginState.user.balance}");
    getTransactionHistory();

//    userDetails();
    getContactList();
  }

  getTransactionHistory() async {
    setState(() {
      transactionLoading = true;
    });
    var result =
        await conversionState.transactionHistory(token: loginState.user.token);
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
    } else if (result["error"] == false) {
      setState(() {
        transactionLoading = false;
        transactionHistory = result["transactionHistory"];
      });
    }
  }







  getTransactionHistoryPull() async {

    var result = await conversionState.transactionHistory(token: loginState.user.token);
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
    } else if (result["error"] == false) {
      setState(() {
//        transactionLoading = false;
        transactionHistory = result["transactionHistory"];
      });
    }
  }

  void getUserAuth() async {
    var result = await loginState.getAuthUser(token: loginState.user.token);
    if (result["error"] &&
        result["message"] == "You are not authorized to make this request") {
//      print("jdjdjdhd");
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
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false)));
    }
  }

  void getContactList() async {
    var result = await transferState.fetchContactList(
        token: loginState.user.token, contacts: appState.numbersToSend);
//    print("result$result");
  }

  void saveAuthCredentials() async {
    SharedPreferences prefrences = await SharedPreferences.getInstance();
    prefrences.setString("uemail", LoginState.phoned);
    prefrences.setString("upassword", LoginState.passwordd);
  }
}

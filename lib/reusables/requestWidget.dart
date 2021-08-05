import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/api/transactionpinService.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/models/virtualDollarCard.dart';
import 'package:rex_money/providers/appState.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/providers/transferState.dart';
import 'package:rex_money/providers/virtualCardState.dart';
import 'package:rex_money/reusables/confirmationPage.dart';
import 'package:rex_money/reusables/dialoPopup.dart';
import 'package:rex_money/reusables/preloader.dart';
import 'package:rex_money/screens/auth/login.dart';
import 'package:rex_money/screens/home.dart';
import 'package:rex_money/screens/notification/notificationScreen.dart';
import 'package:rex_money/screens/state/notifSuccess.dart';
import 'package:rex_money/utils/commonUtils.dart';
import 'package:rex_money/utils/myUtils.dart';



class RequestWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaf;
  final req;
  final userTag;
  final firstname;
  final lastname;
  final reason;
 String  status;
  final time;
  final amount;
  final requestId;



 RequestWidget({ Key key,this.userTag, this.reason, this.status, this.time,  this.amount, this.requestId, this.req, this.lastname, this.firstname, this.scaf}) : super(key: key);

  @override
  _RequestWidgetState createState() => _RequestWidgetState();
}

class _RequestWidgetState extends State<RequestWidget> {

  LoginState loginState;
  TransferState transferState;
  AppState appState;
  VirtualCardState virtualCardState;
  bool isDeclineloading = false;
  bool  isAcceptloading = false;



//  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<VirtualCardModel>  virtualCardModel = [];
  DarkThemeProvider darkThemeProvider;



  var requestId;
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  bool isLoading = false;
  TabController _tabController;
  bool  requestListLoading = false;







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
    loginState = Provider.of<LoginState>(context);
    appState = Provider.of<AppState>(context);
    transferState = Provider.of<TransferState>(context);

    themeChangeProvider = Provider.of<DarkThemeProvider>(context);
    print(themeChangeProvider.darkTheme);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        children: [
          Row(

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              IconButton(icon: Icon(Icons.arrow_back, color: themeChangeProvider.darkTheme ? kprimaryYellow:  kPrimaryColor,),  onPressed: null),


              Column(

                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

//                  ${widget.firstname} ${widget.lastname}
//                  Text.rich(
//
//
//                      TextSpan(children: [
//                    TextSpan(
//                        text:
//
//                        "@${widget.userTag} ",
//                        style: GoogleFonts.mavenPro(
//                          color: themeChangeProvider.darkTheme ? Colors.white:kPrimaryColor,
//                          fontWeight: FontWeight.bold,
//                          fontSize: 18,
//                        )),
//                    TextSpan(
//                        text:"is requesting for " ,
//                        style: GoogleFonts.mavenPro(
//                          color:themeChangeProvider.darkTheme ? Colors.white: kPrimaryColor,
//                          fontSize: 18,
//                        )),
//
//                    TextSpan(
//                        text: "${loginState.user.symbol} ${widget.amount}" ,
//                        style: GoogleFonts.mavenPro(
//                          color: themeChangeProvider.darkTheme ? Colors.white: kPrimaryColor,
//                          fontWeight: FontWeight.bold,
//                          fontSize: 15,
//                        )),
//                  ])),



                Container(
                  width: MediaQuery.of(context).size.width -90,
                  child: RichText(
                    softWrap: true,
                    text: TextSpan(
                  text:" ${widget.firstname} ${widget.lastname} (@${widget.userTag}) ",
                          style: GoogleFonts.mavenPro(
                            color: themeChangeProvider.darkTheme ? Colors.white:kPrimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        children:[
                        TextSpan(
                          text:"is requesting for " ,
                          style: GoogleFonts.mavenPro(
                            color:themeChangeProvider.darkTheme ? Colors.white: kPrimaryColor,
                            fontSize: 15,
                          )),

                      TextSpan(
                          text: "${loginState.user.symbol} ${widget.amount}" ,
                          style: GoogleFonts.mavenPro(
                            color: themeChangeProvider.darkTheme ? Colors.white: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          )),

                        ]

                    ),

                    ),
                ),


                  SizedBox(height: 5,),
                  Text("Reason: ${widget.reason}",         style: GoogleFonts.mavenPro(
                    color: themeChangeProvider.darkTheme ? Colors.white: kPrimaryColor,

                    fontSize: 15,
                  ) ),


                  SizedBox(height: 5,),


                  Text.rich(TextSpan(children: [
                    TextSpan(
                        text: MyUtils.formatDate(widget.time) ,
                        style: GoogleFonts.mavenPro(
                          color: themeChangeProvider.darkTheme ? Colors.white: kPrimaryColor,

                          fontSize: 15,
                        )),


                    TextSpan(
                        text: " ." ,
                        style: GoogleFonts.mavenPro(
                          color:themeChangeProvider.darkTheme ? Colors.white: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        )),

                    TextSpan(
                        text: " ${widget.status} ".toUpperCase() ,
                        style: GoogleFonts.mavenPro(
                          color: widget.status == "pending" ?  kprimaryYellow : widget.status == "accepted" ? Colors.green : Colors.red,
                          fontSize: 15,
                        )),


                  ])),

                  SizedBox(height: 5,),

                  widget.status == "pending"  ?           Row(
                    children: [
                      GestureDetector(
                        onTap: () async{
//                          if (_formKey.currentState.validate()) {
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
                               Accept();
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
//                          }
                        },
                        child: Container(

                          child: Center(child: Text("Accept",  style: GoogleFonts.mavenPro(color: Colors.white,  fontWeight: FontWeight.bold,),)),
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20)
                          ),
                          height: 30,
                          width: 100,
                        ),
                      ),
                      SizedBox(width: 20,),

                      GestureDetector(
                        onTap: (){
                          showBottom();
                        },
                        child: Container(

                          child: Center(child: Text("Decline", style: GoogleFonts.mavenPro(color: Colors.white , fontWeight: FontWeight.bold,),)),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20)
                          ),
                          height: 30,
                          width: 100,
                        ),
                      ),
                    ],
                  ) : Container()



                ],
              ),


            ],
          ),

          SizedBox(height: 3,),
          Divider()
        ],
      ),
    );
  }


  getRequestListpending() async {
    setState(() {
      requestListLoading = true;
    });
    var result = await transferState.fetchRequestListPending(token: loginState.user.token);
    setState(() {
      requestListLoading = false;
    });
    if (requestListLoading) {
      Navigator.pop(context, true);
    }



    }



  getRequestList() async {
    setState(() {
      requestListLoading = true;
    });
    var result = await transferState.fetchRequestList(token: loginState.user.token);
    setState(() {
      requestListLoading = false;
    });
    if (requestListLoading) {
      Navigator.pop(context, true);
    }



  }



showBottom() {
    showModalBottomSheet(context: context,

        backgroundColor:themeChangeProvider.darkTheme ? kPrimaryDark: Colors.white,

        shape:   RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (BuildContext bc){
          return  Container(
            height: 250,
            child: Column(

              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Text("Cancel Request?", style: TextStyle(fontSize: 16,   fontWeight: FontWeight.w600, color: themeChangeProvider.darkTheme ? Colors.white : Colors.black),
                  ),
                ),
                Divider(),
                SizedBox(height: 10,),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
              decline();


                  },
                  child: Container(
                    height:40 ,
                    width: 327,
                    decoration: BoxDecoration(
                        color: Colors.red
                    ),
                    child: Center(
                        child: Text('YES, DECLINE',
                          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        )
                    ),

                  ),
                ),
                SizedBox(height: 20,),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(

                    height:40 ,
                    width: 327,
                    decoration: BoxDecoration(
                        border: Border.all(color: kBlue) ,
                        color: Colors.white
                    ),
                    child: Center(
                        child: Text('NO',
                          style: TextStyle(fontSize: 14, color: kPrimaryDark,  fontWeight: FontWeight.bold),
                        )
                    ),

                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  void decline()async{
    setState(() {
      isDeclineloading = true;
    });
    if (isDeclineloading) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Preloader();
          });
    }

    var result  = await transferState.declineRequest(token: loginState.user.token, request_id:  widget.requestId);
    if (isDeclineloading) {
      Navigator.pop(context, true);
    }
    if (result["error"] &&
        result["message"] == "You are not authorized to make this request") {
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
   else if(result["error"] ==  false){
      setState(() {
        widget.status = "Declined";
      });
      getRequestList();

      getRequestListpending();
//      CommonUtils.showSuccessDialog(
//          context: context,
//          themeChangeProvider: themeChangeProvider,
//          text: "Successful Deciline request",
//          onClose: () {
//            Navigator.pop(context);
//
////            Navigator.push(
////                context, MaterialPageRoute(builder: (context) => NotificationScreen()));
//          });
    }else{
//      CommonUtils.showFlushBar(message: result["message"], title: "Alert", context: context, backgroundColor: themeChangeProvider.darkTheme ? kprimaryYellow : kPrimaryColor);

      CommonUtils.showMsg(result["message"], themeChangeProvider, context, widget.scaf, Colors.red);
    }


    print(result);
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
                    purpose: "Accept request to transfer to ${widget.userTag}",
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



   Accept()async{
    print("accept");
    setState(() {
      isAcceptloading = true;
    });
    if (isAcceptloading) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Preloader();
          });
    }

    var result  = await transferState.AcceptRequest(token: loginState.user.token, request_id:  widget.requestId);
    if (isAcceptloading) {
      Navigator.pop(context, true);
    }
    if (result["error"] &&
        result["message"] == "You are not authorized to make this request") {
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

   else if(result["error"] ==  false){
     print("___________${result}");
      setState(() {
        widget.status = "Accepted";
      });


     Navigator.pushAndRemoveUntil(
         context,
         MaterialPageRoute(builder: (context) => Notif(
           message: result["message"],
         )),
             (Route<dynamic> route) => false);


      getRequestList();

      getRequestListpending();

   }else{
      CommonUtils.showMsg(result["message"], themeChangeProvider, context, widget.scaf, Colors.red);
    }


    print(result);
  }

}
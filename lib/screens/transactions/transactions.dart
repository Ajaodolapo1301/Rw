import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/animation/fadeRoute.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/models/history.dart';
import 'package:rex_money/providers/appState.dart';
import 'package:rex_money/providers/conversionState.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/providers/transferState.dart';
import 'package:rex_money/reusables/dialoPopup.dart';
import 'package:rex_money/reusables/history.dart';
import 'package:rex_money/screens/auth/login.dart';
import 'package:rex_money/screens/transactions/transactionDetails.dart';




class Transaction extends StatefulWidget {
   List<HistoryModel> transactionHistory;
   bool  loading  = false;

  Transaction({this.transactionHistory,this.loading});
  @override
  _TransactionState createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> with AfterLayoutMixin<Transaction> {
  AppState appState;
  LoginState loginState;
  ConversionState conversionState;
  TransferState transferState;
  TextEditingController _rate =  TextEditingController();
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
    bool  transactionLoading = false;
  List<HistoryModel> transactionHistory = [];



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
  transferState = Provider.of<TransferState>(context);
    conversionState = Provider.of<ConversionState>(context);
    loginState = Provider.of<LoginState>(context);
    themeChangeProvider = Provider.of<DarkThemeProvider>(context);
    appState = Provider.of<AppState>(context);
    print(widget.loading);
    return Scaffold(
      appBar: AppBar(
        title: Text("Transactions", style: GoogleFonts.mavenPro(color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,fontSize: 17,),),
        backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.transparent,
        leading:  IconButton(icon: Icon(Icons.arrow_back, color: kprimaryYellow,),onPressed: ()=>Navigator.pop(context),),
      ),
      backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,

      
      
      body: SafeArea(
        bottom: false,

        child: Container(
          margin: EdgeInsets.all(10),
          color: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
          child:   widget.transactionHistory != null &&   widget.transactionHistory.length == 0 ?  Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("images/noTransaction.svg"),
                Text("No Transaction yet.", style: GoogleFonts.mavenPro(color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor, fontSize: 15),),
                Text("Initiate transaction to view record", style: GoogleFonts.mavenPro(color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor, fontSize: 12),)
              ],
            ),
          ) :  SingleChildScrollView(
            child:  Column(

              children: [



         widget.loading  ?  CupertinoActivityIndicator() :



  RefreshIndicator(
           onRefresh: _pullRefresh ,
           child: Column(
                    children:widget.transactionHistory.map((e)  {

                      return  e.type == "CR"  ?    GestureDetector(
                        onTap: (){
                          Navigator.push(
                              context,
                              FadeRoute(
                                  page: TransactionDetails(
                                    data: e,
                                  isDark: themeChangeProvider.darkTheme,
                                  )));
                        },
                        child: HistoryCredit(
                          date: e.date,
                          text: e.remark,
                          colorSub:
                          themeChangeProvider.darkTheme
                              ? Colors.white
                              : kPrimaryColor,
                          color:
                          themeChangeProvider.darkTheme
                              ? kPrimaryDarkText
                              : kprimaryLight,
                          currencyType: loginState.user.currency,
                          amount: e.amount,

                        ),
                      ) : GestureDetector(
                        onTap: (){
                          Navigator.push(
                              context,
                              FadeRoute(
                                  page: TransactionDetails(
                                    data: e,
                                    isDark: themeChangeProvider.darkTheme,
                                  )));
                        },
                        child: HistoryDebit(
                          date: e.date,
                          text: e.remark,
                          colorSub:
                          themeChangeProvider.darkTheme
                              ? Colors.white
                              : kPrimaryColor,
                          color:
                          themeChangeProvider.darkTheme
                              ? kPrimaryDarkText
                              : kprimaryLight,
                          currencyType: loginState.user.currency,
                          amount: e.amount,
                        ),
                      );
                    }).toList(),
                  ),
         )
              ],
            ),
          ),
        ),
      ),
      
      
    );
  }
  Future<void> _pullRefresh() async {
    await getTransactionHistoryPull();


  }
  @override
  void afterFirstLayout(BuildContext context)async {

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



}





import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rex_money/models/cardTrans.dart';
import 'package:rex_money/providers/appState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/animation/fadeRoute.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/models/history.dart';
import 'package:rex_money/providers/appState.dart';
import 'package:rex_money/providers/conversionState.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/providers/transferState.dart';
import 'package:rex_money/reusables/history.dart';
import 'package:rex_money/screens/transactions/transactionDetails.dart';
import 'package:rex_money/screens/virtualCards/cardTransactiondetails.dart';




class CardTransactionsHistory extends StatefulWidget {
  List<CardTransaction> transactionHistory;
  bool  loading  = false;

  CardTransactionsHistory({this.transactionHistory,this.loading});
  @override
  _CardTransactionsHistoryState createState() => _CardTransactionsHistoryState();
}

class _CardTransactionsHistoryState extends State<CardTransactionsHistory> with AfterLayoutMixin<CardTransactionsHistory> {
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
          child: SingleChildScrollView(
            child: Column(

              children: [
//              Row(
//                mainAxisAlignment: MainAxisAlignment.end,
//                children: [
//                  Text("Filter",style: GoogleFonts.raleway(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 11),),
//                  IconButton(icon: Icon(Icons.filter_list_sharp, size: 20,), onPressed: ()=>null)
//                ],
//              ),



                widget.loading  ?  CupertinoActivityIndicator() :      Column(
                  children:widget.transactionHistory.map((e)  {

                    return GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context,
                            FadeRoute(
                                page: CardTransactionDetails(
                                  data: e,
                                  isDark: themeChangeProvider.darkTheme,
                                )));
                      },
                      child: HistoryCredit(
                        date: e.created_at,
                        text: e.response_message,
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
                    ) ;
                  }).toList(),
                )
              ],
            ),
          ),
        ),
      ),


    );
  }

  @override
  void afterFirstLayout(BuildContext context)async {

  }






}
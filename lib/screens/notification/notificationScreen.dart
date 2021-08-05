import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/models/requestMoneyModel.dart';

import 'package:rex_money/models/virtualDollarCard.dart';
import 'package:rex_money/providers/appState.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/providers/transferState.dart';
import 'package:rex_money/providers/virtualCardState.dart';
import 'package:rex_money/reusables/dialoPopup.dart';
import 'package:rex_money/reusables/preloader.dart';
import 'package:rex_money/reusables/requestWidget.dart';
import 'package:rex_money/screens/auth/login.dart';
import 'package:rex_money/utils/commonUtils.dart';

import '../home.dart';


class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with SingleTickerProviderStateMixin, AfterLayoutMixin<NotificationScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AppState appState;
  List<VirtualCardModel>  virtualCardModel = [];
  DarkThemeProvider darkThemeProvider;
  LoginState loginState;
  TransferState transferState;
  VirtualCardState virtualCardState;
  bool isDeclineloading = false;
   bool  isAcceptloading = false;
  var requestId;
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  bool isLoading = false;
  TabController _tabController;
  bool  requestListLoading = false;

  bool  requestListPendingLoading = false;
  List<RequestMoneyListModel>  requestMoneyList = [];

  List<RequestMoneyListModel>  requestMoneyListPending = [];




  @override
  void initState() {

    getCurrentAppTheme();
    _tabController = new TabController(length: 2, vsync: this);
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

    return Scaffold(
      backgroundColor:
      themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Notification",
          style: GoogleFonts.mavenPro(
            color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
            fontSize: 17,
          ),
        ),
        backgroundColor:
        themeChangeProvider.darkTheme ? kPrimaryDark : Colors.transparent,
        leading:  IconButton(icon: Icon(Icons.arrow_back, color: kprimaryYellow,),onPressed: ()=>Navigator.pop(context),),
      ),
      body: Column(
        children: [

          TabBar(
            indicatorColor: themeChangeProvider.darkTheme ? kprimaryYellow : kPrimaryColor,
            unselectedLabelColor: Colors.grey,
            labelColor: themeChangeProvider.darkTheme ? kprimaryYellow :  kPrimaryColor,
            tabs: [
              Tab(
                child: Text("Requests", style: TextStyle(fontSize: 20),),
              ),
              Tab(
                child: Text("Activity", style: TextStyle(fontSize: 20),),
              )
            ],
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
          ),



          Expanded(
            child: TabBarView(
              children: [



//pending
                requestListPendingLoading ? Center(child: CircularProgressIndicator()) :  transferState.requestMoneyListModelPending!= null ?  transferState.requestMoneyListModelPending.length == 0 ? Center(child: Text("No new Request"),) :  Container(
                    width: double.infinity,
                    child: RefreshIndicator(
                      onRefresh: _pullRefresh,
                      child: ListView.builder(
                        itemBuilder: (context,  index){
//                      setState(() {
//                        requestId =
//                      });
                          return  transferState.requestMoneyListModelPending[index].request_status != "pending" ? Container() :   RequestWidget(


                            req: transferState.requestMoneyListModelPending[index],

                            firstname: transferState.requestMoneyListModelPending[index].firstname,
                            lastname: transferState.requestMoneyListModelPending[index].lastname,
                            status: transferState.requestMoneyListModelPending[index].request_status,
                            reason:transferState.requestMoneyListModelPending[index].narration,
                            userTag:  transferState.requestMoneyListModelPending[index].requester_tag,
                            requestId: transferState.requestMoneyListModelPending[index].request_id,
                            scaf: _scaffoldKey,

                            time: transferState.requestMoneyListModelPending[index].created_at ,

                            amount: transferState.requestMoneyListModelPending[index].amount_converted

                          );
                        },
                        itemCount: transferState.requestMoneyListModelPending.length,
                      ),
                    )
                ) :Container(),






//Accpted or delice

                requestListLoading ? Center(child: CircularProgressIndicator()) : transferState.requestMoneyListModel.length == 0 ? Center(child: Text("Nothing here")) :     Container(
                    width: double.infinity,
                    child: RefreshIndicator(
                      onRefresh: _pullRefresh2,
                      child: ListView.builder(
                        itemBuilder: (context,  index){
////                      setState(() {
//                        requestId = requestMoneyList[index].request_id;
////                      });


                          return    RequestWidget(
                              scaf: _scaffoldKey,
                            firstname: transferState.requestMoneyListModel[index].firstname,
                            lastname: transferState.requestMoneyListModel[index].lastname,
                            status:transferState.requestMoneyListModel[index].request_status,
                            reason:transferState.requestMoneyListModel[index].narration,
                            userTag:  transferState.requestMoneyListModel[index].requester_tag,

                            requestId: transferState.requestMoneyListModel[index].request_id,

                            time: transferState.requestMoneyListModel[index].created_at ,

                            amount: transferState.requestMoneyListModel[index].amount_converted,
                          );
                        },
                        itemCount: transferState.requestMoneyListModel.length,
                      ),
                    )
                )

              ],
              controller: _tabController,
            ),
          ),
        ],
      ),
    );
  }


  Future<void> _pullRefresh() async {
    await getRequestListPending();
//    await getUserAuth();
//    print(history)
//    setState(() {
//      transactionHistory = history;
//    });
    // why use freshWords var? https://stackoverflow.com/a/52992836/2301224
  }



  Future<void> _pullRefresh2() async {
    await getRequestList();
//    await getUserAuth();
//    print(history)
//    setState(() {
//      transactionHistory = history;
//    });
    // why use freshWords var? https://stackoverflow.com/a/52992836/2301224
  }
  @override
  void afterFirstLayout(BuildContext context)async {


getRequestList();
getRequestListPending();
    }



    getRequestList() async {
      setState(() {
        requestListLoading = true;
      });
      var result = await transferState.fetchRequestList(
          token: loginState.user.token);
      setState(() {
        requestListLoading = false;
      });

      if (result["error"] &&
          result["message"] == "You are not authorized to make this request") {
        showDialog(
            barrierDismissible: false,
            context: context,
            child: dialogPopup(
                themeDark: themeChangeProvider.darkTheme,
                body: Text(
                  "Session ended, please Login again",
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
          requestMoneyList = result["requestMoneyModel"];
        });
      }
    }




  getRequestListPending() async {
    setState(() {
      requestListPendingLoading = true;
    });
    var result = await transferState.fetchRequestListPending(
        token: loginState.user.token);
    setState(() {
      requestListPendingLoading = false;
    });

    if (result["error"] &&
        result["message"] == "You are not authorized to make this request") {
      showDialog(
          barrierDismissible: false,
          context: context,
          child: dialogPopup(
              themeDark: themeChangeProvider.darkTheme,
              body: Text(
                "Session ended, please Login again",
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
        requestMoneyListPending = result["requestMoneyModelPending"];
      });
    }
  }

  void showBottom() {
    showModalBottomSheet(context: context,
        backgroundColor: kPrimaryDark,
        shape:   RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (BuildContext bc){
          return  Container(
            color: kPrimaryDark,
            height: 250,
            child: Column(

              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Text("Cancel Request?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                Divider(),
                SizedBox(height: 10,),
                InkWell(
                  onTap: (){
//              decline();
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
                          style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
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






}






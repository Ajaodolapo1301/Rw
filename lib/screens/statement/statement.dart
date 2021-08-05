//import 'dart:convert';
//import 'package:loadmore/loadmore.dart';
//
//import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';
//import 'package:google_fonts/google_fonts.dart';
//import 'package:hive/hive.dart';
//import 'package:http/http.dart';
//import 'package:provider/provider.dart';
//import 'package:rex_money/api/authApi.dart';
//import 'package:rex_money/constants/colorConstants.dart';
//import 'package:rex_money/models/history.dart';
//import 'package:rex_money/models/statementData.dart';
//import 'package:rex_money/providers/conversionState.dart';
//import 'package:rex_money/providers/darkmode.dart';
//import 'package:rex_money/providers/infiniteScroll.dart';
//import 'package:rex_money/providers/loginState.dart';
//
//import 'package:flutter_boom_menu/flutter_boom_menu.dart';
//import 'package:rex_money/reusables/button.dart';
//import 'package:rex_money/reusables/dialoPopup.dart';
//import 'package:rex_money/reusables/preloader.dart';
//import 'package:rex_money/reusables/statementWidget.dart';
//import 'package:rex_money/screens/auth/login.dart';
//import 'package:rex_money/screens/statement/statementReceipt.dart';
//import 'package:rex_money/utils/myUtils.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//
//
////
////class Statement extends StatefulWidget {
////  @override
////  _StatementState createState() => _StatementState();
////}
////
////class _StatementState extends State<Statement> with AfterLayoutMixin<Statement> {
////  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
////  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
////  List<HistoryModel> transactionHistory = [];
////  ConversionState conversionState;
////  int get count => transactionHistory.length;
////
////  List<dynamic> list = [];
////  LoginState loginState;
////  bool transactionLoading = false;
////  var formKey = GlobalKey<FormState>();
////
////  String _startDate;
////  bool _startDateSelected = true;
////  String _endDate;
////  bool _endDateSelected = true;
////  var passwordKey = GlobalKey<FormState>();
////
////  @override
////  void initState() {
////    getCurrentAppTheme();
////
////    super.initState();
////  }
////
////  void getCurrentAppTheme() async {
////    themeChangeProvider.darkTheme =
////    await themeChangeProvider.darkThemePreference.getTheme();
////  }
////  @override
////  Widget build(BuildContext context) {
////    loginState = Provider.of<LoginState>(context);
////    conversionState = Provider.of<ConversionState>(context);
////    return Scaffold(
////      key: _scaffoldKey,
////      floatingActionButton: transactionHistory.length == 0 ? Container() : Builder(
////          builder: (context) {
////            return BoomMenu(
////              backgroundColor: kprimaryYellow,
////              animatedIcon: AnimatedIcons.menu_close,
////              animatedIconTheme: IconThemeData(size: 22.0),
////              overlayColor: Colors.black,
////              overlayOpacity: 0.7,
////              children: [
////                MenuItem(
////                    title: "Download",
////                    subtitle: "Download statement as pdf",
////                    backgroundColor: themeChangeProvider.darkTheme ? Color(0xff191d20) : kPrimaryColor,
////                    titleColor: Colors.white,
////                    subTitleColor: Colors.white,
////                    child: Icon(Icons.file_download, color: Colors.white,),
////                    onTap: (){
//////                      downloadStatement(context);
////                    }
////                ),
////                MenuItem(
////                    title: "Print",
////                    subtitle: "Print statement directly from your phone",
////                    backgroundColor: themeChangeProvider.darkTheme  ? Color(0xff191d20) : kPrimaryColor,
////                    titleColor: Colors.white,
////                    subTitleColor: Colors.white,
////                    child: Icon(Icons.print, color: Colors.white,),
////                    onTap: (){
//////                      printStatement();
////                    }
////                ),
////                MenuItem(
////                    title: "Share",
////                    subtitle: "Share statement pdf to others",
////                    backgroundColor:themeChangeProvider.darkTheme  ? Color(0xff191d20) : kPrimaryColor,
////                    titleColor: Colors.white,
////                    subTitleColor: Colors.white,
////                    child: Icon(Icons.share, color: Colors.white,),
////                    onTap: (){
//////                      shareStatement();
////                    }
////                ),
////              ],
////            );
////          }
////      ),
////      appBar: AppBar(
////        backgroundColor:
////        themeChangeProvider.darkTheme ? kPrimaryDark : Colors.transparent,
////        leading: IconButton(
////          icon: Icon(
////            Icons.arrow_back,
////            color: kprimaryYellow,
////          ),
////          onPressed: () => Navigator.pop(context),
////        ),
////        title: Text(
////          "Statement and Report",
////          style: GoogleFonts.mavenPro(
////              color:
////              themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
////              fontSize: 20),
////        ),
////      ),
////
////      body: Column(
////
////        children: [
////          Container(
////            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
////            child: Row(
////              mainAxisAlignment: MainAxisAlignment.end,
////              children: [
////
////                SvgPicture.asset("images/calendar.svg"),
////                GestureDetector(
////                    onTap: () {
////                      filter();
////                    },
////                    child: Text(
////                      " Select Range",
////                      style: GoogleFonts.mavenPro(
////                          fontWeight: FontWeight.bold,
////                          fontSize: 13,
////                          color: kprimaryYellow),
////                    ))
////              ],
////            ),
////          ),
////
////       transactionLoading ? Center(child: CircularProgressIndicator()): transactionHistory.length == 0 ? Center(child: Text("no history"),):
////       Expanded(
////
////            child: RefreshIndicator(
////              child: LoadMore(
////                isFinish: count >= transactionHistory.length,
////                onLoadMore: _loadMore,
////                child: ListView.builder(
////
////                  itemBuilder: (BuildContext context, int index) {
////                    return StatementWidget(
////              amount: transactionHistory[index].amount,
////                loginState: loginState,
////                remark: transactionHistory[index].remark,
////                date:transactionHistory[index].date,
////                type: transactionHistory[index].type,
////                themeChangeProvider: themeChangeProvider
//////
////
////            );
////          },
////
////                  itemCount: count,
////                ),
////                whenEmptyLoad: false,
////                delegate: DefaultLoadMoreDelegate(),
////                textBuilder: DefaultLoadMoreTextBuilder.english,
////              ),
////              onRefresh: _refresh,
////            ),
////          ),
////
//////   transactionLoading ? Center(child: CircularProgressIndicator()):
//////      Expanded(
//////        child: ListView.builder(
//////          itemCount: transactionHistory.length,
//////          itemBuilder: (context, index){
//////            return    StatementWidget(
//////              amount: transactionHistory[index].amount,
//////                loginState: loginState,
//////                remark: transactionHistory[index].remark,
//////                date:transactionHistory[index].date,
//////                type: transactionHistory[index].type,
//////                themeChangeProvider: themeChangeProvider
//////
//////
//////            );
//////          },
//////
//////        ),
//////      )
////
////
////
////        ],
////      ),
////    );
////  }
////  Future<bool> _loadMore() async {
////    print("onLoadMore");
////    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
////    load();
////    return true;
////  }
////
////  Future<void> _refresh() async {
////    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
////    transactionHistory.clear();
////    load();
////  }
////
////
////
////  void load() {
////    print("load");
////    setState(() {
////      getTransactionHistory();
////
////    list.addAll(transactionHistory);
////    });
////  }
////
////
////  Future selectDate({@required BuildContext context}) async {
////    final picked = await showDatePicker(
////      context: context,
////      firstDate: DateTime(2018),
////      lastDate: DateTime.now().add(Duration(hours: 1)),
////      initialDate: DateTime.now(),
////      selectableDayPredicate: (DateTime d) {
////        if (d.isBefore(DateTime.now().add(Duration(hours: 12)))) {
////          return true;
////        }
////        return false;
////      },
////    );
////    if (picked != null) {
////      return picked;
////    }
////    return null;
////  }
////
////  Future filter() {
////    return showModalBottomSheet(
////        context: context,
////        shape: RoundedRectangleBorder(
////            borderRadius: BorderRadius.only(
////                topLeft: Radius.circular(5), topRight: Radius.circular(5))),
////        builder: (context) {
////          return StatefulBuilder(
////            builder: (BuildContext context, StateSetter setState) {
////              return Container(
////                height: 250,
////                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
////                decoration: BoxDecoration(
////                    color: themeChangeProvider.darkTheme  ? Color(0xff121416) : Colors.white,
////                    borderRadius: BorderRadius.only(
////                        topLeft: Radius.circular(5),
////                        topRight: Radius.circular(5))),
////                child: Column(
////                  children: <Widget>[
////                    Align(
////                      alignment: Alignment.centerLeft,
////                      child: Text(
////                        "Filter",
////                        style: GoogleFonts.workSans(
////                          fontSize: 25,
////                          color: themeChangeProvider.darkTheme  ? Colors.white : Colors.black,
////                          fontWeight: FontWeight.w500,
////                        ),
////                      ),
////                    ),
////                    SizedBox(
////                      height: 10,
////                    ),
////                    FlatButton(
////                      shape: RoundedRectangleBorder(
////                          borderRadius: BorderRadius.circular(5),
////                          side: BorderSide(
////                              color: _startDateSelected
////                                  ? Colors.transparent
////                                  : Colors.redAccent,
////                              width: 1)),
////                      color:
////                      themeChangeProvider.darkTheme ? Color(0xff191D20) : textFieldBackgroundColor,
////                      onPressed: () async {
////                        DateTime date = await selectDate(context: context);
////                        setState(() {
////                          if (date != null) {
////                            _startDate = date.toString().split(" ")[0];
////                          }
////                        });
////                      },
////                      padding:
////                      EdgeInsets.symmetric(vertical: 12, horizontal: 10),
////                      child: Row(
////                        children: <Widget>[
////                          Icon(
////                            Icons.date_range,
////                            color: themeChangeProvider.darkTheme ? Colors.white : Colors.black,
////                          ),
////                          SizedBox(
////                            width: 5,
////                          ),
////                          Text(
////                            _startDate ?? "Choose start date",
////                            style: TextStyle(
////                                color: themeChangeProvider.darkTheme ? Colors.white : Colors.black,
////                                fontSize: 16),
////                          ),
////                          Expanded(
////                            child: Align(
////                              alignment: Alignment.centerRight,
////                              child: Text("Change"),
////                            ),
////                          )
////                        ],
////                      ),
////                    ),
////                    SizedBox(
////                      height: 10,
////                    ),
////                    FlatButton(
////                      shape: RoundedRectangleBorder(
////                          borderRadius: BorderRadius.circular(5),
////                          side: BorderSide(
////                              color: _endDateSelected
////                                  ? Colors.transparent
////                                  : Colors.redAccent,
////                              width: 1)),
////                      color:
////                      themeChangeProvider.darkTheme ? Color(0xff191D20) : textFieldBackgroundColor,
////                      onPressed: () async {
////                        DateTime date = await selectDate(context: context);
////                        setState(() {
////                          if (date != null) {
////                            _endDate = date.toString().split(" ")[0];
////                          }
////                        });
////                      },
////                      padding:
////                      EdgeInsets.symmetric(vertical: 12, horizontal: 10),
////                      child: Row(
////                        children: <Widget>[
////                          Icon(
////                            Icons.date_range,
////                            color: themeChangeProvider.darkTheme ? Colors.white : Colors.black,
////                          ),
////                          SizedBox(
////                            width: 5,
////                          ),
////                          Text(
////                            _endDate ?? "Choose end date",
////                            style: TextStyle(
////                                color: themeChangeProvider.darkTheme ? Colors.white : Colors.black,
////                                fontSize: 16),
////                          ),
////                          Expanded(
////                            child: Align(
////                              alignment: Alignment.centerRight,
////                              child: Text("Change"),
////                            ),
////                          )
////                        ],
////                      ),
////                    ),
////                    SizedBox(
////                      height: 10,
////                    ),
////                    Center(
////                      child: Button(
////                        text: "Apply Filter",
////                        onPressed: () async {
////                          // validate if date has been selected
////                          setState(() {
////                            if (_startDate == null || _startDate.isEmpty) {
////                              _startDateSelected = false;
////                            } else {
////                              _startDateSelected = true;
////                            }
////
////                            if (_endDate == null || _endDate.isEmpty) {
////                              _endDateSelected = false;
////                            } else {
////                              _endDateSelected = true;
////                            }
////                          });
////
////                          if (_startDateSelected && _endDateSelected) {
//////                            processedPages.clear();
////                            setState(() {
//////                              currentPage = 0;
////                            });
////                            Navigator.pop(context);
//////                            await load(
//////                                clear: true,
//////                                startDate: _startDate,
//////                                endDate: _endDate,
//////                                showLoading: true);
////                            getTransactionHistory();
////                          }
////                        },
////                      ),
////                    )
////                  ],
////                ),
////              );
////            },
////          );
////        });
////  }
////
////  @override
////  void afterFirstLayout(BuildContext context) {
////getTransactionHistory();
//////load();
////  }
////
////  getTransactionHistory() async {
////    setState(() {
////      transactionLoading = true;
////    });
////    var result =
////    await conversionState.AccountStatement(token: loginState.user.token, from_date: _startDate, to_date: _endDate, page_size: 2, page_index: 1);
////    if (result["error"] &&
////        result["message"] == "You are not authorized to make this request") {
////      print("jdjdjdhd");
////      showDialog(
////          barrierDismissible: false,
////          context: context,
////          child: dialogPopup(
////              themeDark: themeChangeProvider.darkTheme,
////              body: Text(
////                "Session has ended,Please Login again",
////                textAlign: TextAlign.center,
////                style: TextStyle(
////                    inherit: false,
////                    fontSize: 18,
////                    color: themeChangeProvider.darkTheme
////                        ? Colors.white
////                        : Colors.black),
////              ),
////              buttonText: "Ok",
////              onPressed: () {
////                final box = Hive.box("user");
////                box.put('user', null);
////                Navigator.pushAndRemoveUntil(
////                    context,
////                    MaterialPageRoute(builder: (context) => LoginPage()),
////                        (Route<dynamic> route) => false);
////              }));
////    } else if (result["error"] == false) {
////      setState(() {
////        transactionLoading = false;
////        transactionHistory = result["transactionHistory"];
////      });
////    }
////  }
////}
//
//
//
//
//
//
////class Statement extends StatefulWidget {
////  @override
////  _StatementState createState() => _StatementState();
////}
////
////class _StatementState extends State<Statement> with AfterLayoutMixin<Statement> {
////  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
////  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
////  List<HistoryModel> transactionHistory = [];
////  ConversionState conversionState;
////
////  LoginState loginState;
////  bool transactionLoading = false;
////  var formKey = GlobalKey<FormState>();
////
////  String _startDate;
////  bool _startDateSelected = true;
////  String _endDate;
////  bool _endDateSelected = true;
////  var passwordKey = GlobalKey<FormState>();
////  int currentPage = 0;
////  int lastPage = 1;
////
////  List<dynamic> list = [];
////  bool isEmpty = false;
////
////  List<int> processedPages = [];
////
////  int get count => list.length;
////
////  String status;
////  @override
////  void initState() {
////    getCurrentAppTheme();
////
////    super.initState();
////  }
////
////  void getCurrentAppTheme() async {
////    themeChangeProvider.darkTheme =
////    await themeChangeProvider.darkThemePreference.getTheme();
////  }
////
////
////
////
////  Future load(
////      {bool showLoading = false,
////        bool clear = false,
////        String startDate,
////        String endDate}) async {
////    var result = await getData(
////        context: context,
////
////        page_index: currentPage + 1,
////        showLoading: showLoading,
////        startdate: startDate,
////        enddate: endDate);
////
////    print("rrrrr$result");
////
////    try {
////      setState(() {
////        if (result != false) {
//////          currentPage = result.statementModel.currentPage;
//////          lastPage = result.statementModel.lastPage;
////
////          if (clear) {
////            list.clear();
////          }
////
////          list.addAll(result.statementModel);
////
////          setState(() {
////            isEmpty = list.isEmpty;
////          });
////        }
////      });
////    } catch (e) {
////      debugPrint(e.toString());
////    }
////  }
////
////  Future<bool> _loadMore() async {
////    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
////    load(clear: false);
////
////    return true;
////  }
////
////
////  Future<void> _refresh() async {
////    setState(() {
////      currentPage = 0;
////      lastPage = 1;
////      clearDate();
////      processedPages.clear();
////    });
////
////    await Future.delayed(Duration(seconds: 0, milliseconds: 800));
////    load(clear: true);
////  }
////  void clearDate() {
////    _startDate = null;
////    _startDateSelected = true;
////    _endDate = null;
////    _endDateSelected = true;
////  }
////  Future<dynamic> getData(
////      {BuildContext context,
////        int page_index,
////
////        String page_size,
////        String startdate,
////        String enddate,
////        bool showLoading = false}) async {
////    if (!processedPages.contains(page_index)) {
////      // try {
////      if (showLoading) {
////        showDialog(
////            context: context,
////            barrierDismissible: false,
////            builder: (BuildContext context) {
////              return Preloader();
////            });
////      }
////
////      processedPages.add(page_index);
////
//////      SharedPreferences pref = await SharedPreferences.getInstance();
////
////      //build url
//////      String url = Env.baseUrl + '/api/wallet/history';
////      String url = "$stagingUrl/auth/wallet/fiat/history";
////      URLQueryParams queryParams = new URLQueryParams();
////
////      queryParams.append('page_index', page_index);
//////      queryParams.append('reference', search);
////      queryParams.append('page_size', page_size);
////      queryParams.append('from_date', startdate);
////      queryParams.append('to_date', enddate);
////
////      url = url + "?" + queryParams.toString();
////
////      final resp = await get(url, headers: {
////        "accept": "application/json",
////        "content-type": "application/json",
////        "Authorization": "Bearer " +loginState.user.token,
////
////      });
////
////      var data = json.decode(resp.body);
////
////      print("data$data");
////
////      if (showLoading) {
////        Navigator.pop(context, true);
////      }
////
////      if (resp.statusCode == 200) {
////        //pull the business information of the merchant
////        return AccountStatement.fromJson(data);
////      } else {
////        showInSnackBar(data["message"]);
////        return false;
////      }
////      // } catch (e) {
////      //   if (showLoading) {
////      //     Navigator.pop(context, true);
////      //   }
////      //   showInSnackBar(e.toString());
////
////      //   return false;
////      // }
////    } else {
////      return false;
////    }
////  }
////  @override
////  Widget build(BuildContext context) {
////    loginState = Provider.of<LoginState>(context);
////    conversionState = Provider.of<ConversionState>(context);
////    return Scaffold(
////      key: _scaffoldKey,
////      floatingActionButton: Builder(
////          builder: (context) {
////            return BoomMenu(
////              backgroundColor: kprimaryYellow,
////              animatedIcon: AnimatedIcons.menu_close,
////              animatedIconTheme: IconThemeData(size: 22.0),
////              overlayColor: Colors.black,
////              overlayOpacity: 0.7,
////              children: [
////                MenuItem(
////                    title: "Download",
////                    subtitle: "Download statement as pdf",
////                    backgroundColor: themeChangeProvider.darkTheme ? Color(0xff191d20) : kPrimaryColor,
////                    titleColor: Colors.white,
////                    subTitleColor: Colors.white,
////                    child: Icon(Icons.file_download, color: Colors.white,),
////                    onTap: (){
//////                      downloadStatement(context);
////                    }
////                ),
////                MenuItem(
////                    title: "Print",
////                    subtitle: "Print statement directly from your phone",
////                    backgroundColor: themeChangeProvider.darkTheme  ? Color(0xff191d20) : kPrimaryColor,
////                    titleColor: Colors.white,
////                    subTitleColor: Colors.white,
////                    child: Icon(Icons.print, color: Colors.white,),
////                    onTap: (){
//////                      printStatement();
////                    }
////                ),
////                MenuItem(
////                    title: "Share",
////                    subtitle: "Share statement pdf to others",
////                    backgroundColor:themeChangeProvider.darkTheme  ? Color(0xff191d20) : kPrimaryColor,
////                    titleColor: Colors.white,
////                    subTitleColor: Colors.white,
////                    child: Icon(Icons.share, color: Colors.white,),
////                    onTap: (){
//////                      shareStatement();
////                    }
////                ),
////              ],
////            );
////          }
////      ),
////      appBar: AppBar(
////        backgroundColor:
////        themeChangeProvider.darkTheme ? kPrimaryDark : Colors.transparent,
////        leading: IconButton(
////          icon: Icon(
////            Icons.arrow_back,
////            color: kprimaryYellow,
////          ),
////          onPressed: () => Navigator.pop(context),
////        ),
////        title: Text(
////          "Statement and Report",
////          style: GoogleFonts.mavenPro(
////              color:
////              themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
////              fontSize: 20),
////        ),
////      ),
////
////      body: Column(
////
////        children: [
////          Container(
////            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
////            child: Row(
////              mainAxisAlignment: MainAxisAlignment.end,
////              children: [
////
////                SvgPicture.asset("images/calendar.svg"),
////                GestureDetector(
////                    onTap: () {
////                      filter();
////                    },
////                    child: Text(
////                      " Select Range",
////                      style: GoogleFonts.mavenPro(
////                          fontWeight: FontWeight.bold,
////                          fontSize: 13,
////                          color: kprimaryYellow),
////                    ))
////              ],
////            ),
////          ),
////
////
////          Expanded(
////            child: Container(
////              color: themeChangeProvider.darkTheme ? Colors.black : Colors.white,
////              child: RefreshIndicator(
////                child: isEmpty
////                    ? Center(
////                  child: Text(
////                    "No History",
////                    style: TextStyle(
////                      color: themeChangeProvider.darkTheme ? Colors.white : Colors.black,
////                    ),
////                  ),
////                )
////                    : LoadMore(
////                  isFinish: (currentPage >= lastPage),
////                  onLoadMore: _loadMore,
////                  child: ListView.separated(
////                    separatorBuilder: (context, index) {
////                      return SizedBox(
////                        height: 10,
////                      );
////                    },
////                    itemBuilder: (BuildContext context, int index) {
////                      return statementItem(list[index]);
////
////                    },
////                    itemCount: count,
////                  ),
////                  delegate: DefaultLoadMoreDelegate(),
////                  textBuilder: buildEnglishText,
////                ),
////                onRefresh: _refresh,
////              ),
////            ),
////          ),
////
////        ],
////      ),
////    );
////  }
////
////  String buildEnglishText(LoadMoreStatus status) {
////    String text;
////    switch (status) {
////      case LoadMoreStatus.fail:
////        text = "load fail, tap to retry";
////        break;
////      case LoadMoreStatus.idle:
////        text = "wait for loading";
////        break;
////      case LoadMoreStatus.loading:
////        text = "loading, wait for a moment ...";
////        break;
////      case LoadMoreStatus.nomore:
////        text = "";
////        break;
////      default:
////        text = "";
////    }
////    return text;
////  }
////
////  Widget statementItem(index) {
////    return Container(
////
////      decoration: BoxDecoration(
////          color: themeChangeProvider
////              .darkTheme
////              ? kPrimaryDarkTextField
////              : kPrimaryColor.withOpacity(0.1),
////
////          borderRadius: BorderRadius.circular(10)
////      ),
////      margin: EdgeInsets.symmetric(
////          horizontal: 20, vertical: 12),
////      height:65,
////      child: Container(
////        margin: EdgeInsets.symmetric(
////            horizontal: 15, vertical: 0),
////        child: Row(
////          mainAxisAlignment: MainAxisAlignment.spaceBetween,
////          children: [
////
////            Column(
////              mainAxisAlignment: MainAxisAlignment.center,
////              crossAxisAlignment: CrossAxisAlignment.start,
////              children: [
////                Text(MyUtils.formatDate(index.date),    style: GoogleFonts.raleway(
////                  fontSize: 10,
////                  color: themeChangeProvider.darkTheme
////                      ? Colors.white
////                      : kPrimaryColor,
////                ),),
////                Text(index.remark,  style: GoogleFonts.raleway(
////                  fontSize: 13,
////                  fontWeight: FontWeight.bold,
////                  color: themeChangeProvider.darkTheme
////                      ? Colors.white
////                      : kPrimaryColor,
////                ))
////              ],
////            ),
////
////
////            Text("${loginState.user.currency} ${index.amount}",  style: GoogleFonts.mavenPro(
////              fontSize: 14,
////              fontWeight: FontWeight.bold,
////              color: index.type == "CR" ? kprimaryGreen : kPrimaryColor,
////            ))
////
////          ],
////        ),
////      ),
////
////
////    );
////  }
////
////
////
////
////  void showInSnackBar(String value) {
////    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
////    try {
////      _scaffoldKey.currentState.showSnackBar(new SnackBar(
////        content: new Text(value),
////        backgroundColor: Colors.redAccent,
////      ));
////    } catch (e) {}
////  }
////
////
////
////  Future selectDate({@required BuildContext context}) async {
////    final picked = await showDatePicker(
////      context: context,
////      firstDate: DateTime(2018),
////      lastDate: DateTime.now().add(Duration(hours: 1)),
////      initialDate: DateTime.now(),
////      selectableDayPredicate: (DateTime d) {
////        if (d.isBefore(DateTime.now().add(Duration(hours: 12)))) {
////          return true;
////        }
////        return false;
////      },
////    );
////    if (picked != null) {
////      return picked;
////    }
////    return null;
////  }
////
////  Future filter() {
////    return showModalBottomSheet(
////        context: context,
////        shape: RoundedRectangleBorder(
////            borderRadius: BorderRadius.only(
////                topLeft: Radius.circular(5), topRight: Radius.circular(5))),
////        builder: (context) {
////          return StatefulBuilder(
////            builder: (BuildContext context, StateSetter setState) {
////              return Container(
////                height: 250,
////                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
////                decoration: BoxDecoration(
////                    color: themeChangeProvider.darkTheme  ? Color(0xff121416) : Colors.white,
////                    borderRadius: BorderRadius.only(
////                        topLeft: Radius.circular(5),
////                        topRight: Radius.circular(5))),
////                child: Column(
////                  children: <Widget>[
////                    Align(
////                      alignment: Alignment.centerLeft,
////                      child: Text(
////                        "Filter",
////                        style: GoogleFonts.raleway(
////                          fontSize: 20,
////                          color: themeChangeProvider.darkTheme  ? Colors.white : kPrimaryColor,
////                          fontWeight: FontWeight.w500,
////                        ),
////                      ),
////                    ),
////                    SizedBox(
////                      height: 10,
////                    ),
////                    FlatButton(
////                      shape: RoundedRectangleBorder(
////                          borderRadius: BorderRadius.circular(5),
////                          side: BorderSide(
////                              color: _startDateSelected
////                                  ? Colors.transparent
////                                  : Colors.redAccent,
////                              width: 1)),
////                      color:
////                      themeChangeProvider.darkTheme ? Color(0xff191D20) : textFieldBackgroundColor,
////                      onPressed: () async {
////                        DateTime date = await selectDate(context: context);
////                        setState(() {
////                          if (date != null) {
////                            _startDate = date.toString().split(" ")[0];
////                          }
////                        });
////                      },
////                      padding:
////                      EdgeInsets.symmetric(vertical: 12, horizontal: 10),
////                      child: Row(
////                        children: <Widget>[
////                          Icon(
////                            Icons.date_range,
////                            color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
////                          ),
////                          SizedBox(
////                            width: 5,
////                          ),
////                          Text(
////                            _startDate ?? "Choose start date",
////                            style: GoogleFonts.raleway(
////                                color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
////                                fontSize: 16),
////                          ),
////                          Expanded(
////                            child: Align(
////                              alignment: Alignment.centerRight,
////                              child: Text("Change"),
////                            ),
////                          )
////                        ],
////                      ),
////                    ),
////                    SizedBox(
////                      height: 10,
////                    ),
////                    FlatButton(
////                      shape: RoundedRectangleBorder(
////                          borderRadius: BorderRadius.circular(5),
////                          side: BorderSide(
////                              color: _endDateSelected
////                                  ? Colors.transparent
////                                  : Colors.redAccent,
////                              width: 1)),
////                      color:
////                      themeChangeProvider.darkTheme ? Color(0xff191D20) : textFieldBackgroundColor,
////                      onPressed: () async {
////                        DateTime date = await selectDate(context: context);
////                        setState(() {
////                          if (date != null) {
////                            _endDate = date.toString().split(" ")[0];
////                          }
////                        });
////                      },
////                      padding:
////                      EdgeInsets.symmetric(vertical: 12, horizontal: 10),
////                      child: Row(
////                        children: <Widget>[
////                          Icon(
////                            Icons.date_range,
////                            color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
////                          ),
////                          SizedBox(
////                            width: 5,
////                          ),
////                          Text(
////                            _endDate ?? "Choose end date",
////                            style: GoogleFonts.raleway(
////                                color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
////                                fontSize: 16),
////                          ),
////                          Expanded(
////                            child: Align(
////                              alignment: Alignment.centerRight,
////                              child: Text("Change"),
////                            ),
////                          )
////                        ],
////                      ),
////                    ),
////                    SizedBox(
////                      height: 10,
////                    ),
////                    Center(
////                      child: Button(
////                        text: "Apply Filter",
////                        onPressed: () async {
////                          // validate if date has been selected
////                          setState(() {
////                            if (_startDate == null || _startDate.isEmpty) {
////                              _startDateSelected = false;
////                            } else {
////                              _startDateSelected = true;
////                            }
////
////                            if (_endDate == null || _endDate.isEmpty) {
////                              _endDateSelected = false;
////                            } else {
////                              _endDateSelected = true;
////                            }
////                          });
////
////                          if (_startDateSelected && _endDateSelected) {
//////                            processedPages.clear();
////                            setState(() {
//////                              currentPage = 0;
////                            });
////                            Navigator.pop(context);
//////                            await load(
//////                                clear: true,
//////                                startDate: _startDate,
//////                                endDate: _endDate,
//////                                showLoading: true);
////                          }
////                        },
////                      ),
////                    )
////                  ],
////                ),
////              );
////            },
////          );
////        });
////  }
////
////  @override
////  void afterFirstLayout(BuildContext context) {
////    getTransactionHistory();
////  }
////
////  getTransactionHistory() async {
////    setState(() {
////      transactionLoading = true;
////    });
////    var result =
////    await conversionState.transactionHistory(token: loginState.user.token);
////    if (result["error"] &&
////        result["message"] == "You are not authorized to make this request") {
////      print("jdjdjdhd");
////      showDialog(
////          barrierDismissible: false,
////          context: context,
////          child: dialogPopup(
////              themeDark: themeChangeProvider.darkTheme,
////              body: Text(
////                "Session has ended,Please Login again",
////                textAlign: TextAlign.center,
////                style: TextStyle(
////                    inherit: false,
////                    fontSize: 18,
////                    color: themeChangeProvider.darkTheme
////                        ? Colors.white
////                        : Colors.black),
////              ),
////              buttonText: "Ok",
////              onPressed: () {
////                final box = Hive.box("user");
////                box.put('user', null);
////                Navigator.pushAndRemoveUntil(
////                    context,
////                    MaterialPageRoute(builder: (context) => LoginPage()),
////                        (Route<dynamic> route) => false);
////              }));
////    } else if (result["error"] == false) {
////      setState(() {
////        transactionLoading = false;
////        transactionHistory = result["transactionHistory"];
////      });
////    }
////  }
////
//
//
//
//
//class StatementScreen extends StatefulWidget {
//  @override
//  State<StatefulWidget> createState() {
//    return _StatementScreenState();
//  }
//}
//
//class _StatementScreenState extends State<StatementScreen> {
//
//LoginState loginState;
//  String _startDate;
//  bool _startDateSelected = true;
//  String _endDate;
//  bool _endDateSelected = true;
//
//  int currentPage = 0;
//  int lastPage = 1;
//
//  List<dynamic> list = [];
//  bool isEmpty = false;
//
//  List<int> processedPages = [];
//
//  int get count => list.length;
//
//  String status;
//DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
//  @override
//  void initState() {
//    initDark();
//    getCurrentAppTheme();
//    initTextScale();
//    super.initState();
//  }
//
//
//void getCurrentAppTheme() async {
//  themeChangeProvider.darkTheme =
//  await themeChangeProvider.darkThemePreference.getTheme();
//}
//
//
//final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//
//  bool isDark = true;
//
//  void initDark() async {
//    var pref = await SharedPreferences.getInstance();
//    setState(() {
//      isDark = pref.getBool("isDark") ?? false;
//    });
//  }
//
//  void initTextScale() async {
//    var pref = await SharedPreferences.getInstance();
//    setState(() {
//      textScale = pref.getDouble("textScaleFactor") ?? 1.0;
//    });
//  }
//
//  double textScale = 1.0;
//
//  @override
//  Widget build(BuildContext context) {
//  loginState =Provider.of(context);
//  themeChangeProvider = Provider.of(context);
//    return Scaffold(
//
//
//      appBar: AppBar(
//        backgroundColor:
//        themeChangeProvider.darkTheme ? kPrimaryDark : Colors.transparent,
//        leading: IconButton(
//          icon: Icon(
//            Icons.arrow_back,
//            color: kprimaryYellow,
//          ),
//          onPressed: () => Navigator.pop(context),
//        ),
//        title: Text(
//          "Statement and Report",
//          style: GoogleFonts.mavenPro(
//              color:
//              themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
//              fontSize: 20),
//        ),
//      ),
//      key: _scaffoldKey,
//
//      body: Container(
//        color: isDark ? Colors.black : Colors.white,
//        child: Column(
//          children: <Widget>[
//            Container(
//              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.end,
//                children: [
//
//                  SvgPicture.asset("images/calendar.svg"),
//                  GestureDetector(
//                      onTap: () {
//                        filter();
//                      },
//                      child: Text(
//                        " Select Range",
//                        style: GoogleFonts.mavenPro(
//                            fontWeight: FontWeight.bold,
//                            fontSize: 13,
//                            color: kprimaryYellow),
//                      ))
//                ],
//              ),
//            ),
//            Expanded(
//              child: Container(
//                color: themeChangeProvider.darkTheme ? Colors.black : Colors.white,
//                child: RefreshIndicator(
//                  child: isEmpty
//                      ? Center(
//                    child: Text(
//                      "No History",
//                      style: TextStyle(
//                        color: isDark ? Colors.white : Colors.black,
//                      ),
//                    ),
//                  )
//                      : LoadMore(
//                    isFinish: (currentPage >= list.length),
//                    onLoadMore: _loadMore,
//                    child: ListView.separated(
//                      separatorBuilder: (context, index) {
//                        print((currentPage >= list.length));
//                        print("current ${currentPage}");
//                        print(list.length);
//                        return SizedBox(
//                          height: 10,
//                        );
//                      },
//                      itemBuilder: (BuildContext context, int index) {
//                        return statementItem(list[index]);
////                            return Container(
////                              child: InkWell(
////                                onTap: () {
////                                  Navigator.push(
////                                    context,
////                                    MaterialPageRoute(
////                                        builder: (context) =>
//////                                            AccountStatementDetails(
////                                              data: list[index],
////                                            )),
////                                  );
////                                },
////                                child: Container(
////                                    decoration: BoxDecoration(
////                                        color: Colors.white,
////                                        borderRadius:
////                                        BorderRadius.circular(20)),
////                                    margin: EdgeInsets.only(
////                                        left: 5, right: 5),
////                                    child: ListTile(
////                                      title: Text(
////                                        list[index].remark,
////                                      ),
////                                      subtitle: Text("NGN" +
////                                          " " +
////                                          formatAmount(
////                                              list[index].amount)),
////                                      trailing: Column(
////                                        mainAxisAlignment:
////                                        MainAxisAlignment.spaceEvenly,
////                                        children: <Widget>[
////                                          Text(formatDate(
////                                              list[index].createdAt)),
////                                          displayStatus(
////                                              status: list[index].type,
////                                              createdAt:
////                                              list[index].createdAt)
////                                        ],
////                                      ),
////                                    )),
////                              ),
////                              alignment: Alignment.center,
////                            );
//                      },
//                      itemCount: count,
//                    ),
//                    delegate: DefaultLoadMoreDelegate(isDark: themeChangeProvider.darkTheme),
//                    textBuilder: buildEnglishText,
//                  ),
//                  onRefresh: _refresh,
//                ),
//              ),
//            ),
//          ],
//        ),
//      ),
//      floatingActionButton: list.isEmpty ? SizedBox() : Builder(
//          builder: (context) {
//            return BoomMenu(
//              backgroundColor: kprimaryYellow,
//              animatedIcon: AnimatedIcons.menu_close,
//              animatedIconTheme: IconThemeData(size: 22.0),
//              overlayColor: Colors.black,
//              overlayOpacity: 0.7,
//              children: [
//                MenuItem(
//                    title: "Download",
//                    subtitle: "Download statement as pdf",
//                    backgroundColor: themeChangeProvider.darkTheme ? Color(0xff191d20) : kPrimaryColor,
//                    titleColor: Colors.white,
//                    subTitleColor: Colors.white,
//                    child: Icon(Icons.file_download, color: Colors.white,),
//                    onTap: (){
//                      downloadStatement(context);
//                    }
//                ),
//                MenuItem(
//                    title: "Print",
//                    subtitle: "Print statement directly from your phone",
//                    backgroundColor: themeChangeProvider.darkTheme  ? Color(0xff191d20) : kPrimaryColor,
//                    titleColor: Colors.white,
//                    subTitleColor: Colors.white,
//                    child: Icon(Icons.print, color: Colors.white,),
//                    onTap: (){
//                      printStatement();
//                    }
//                ),
//                MenuItem(
//                    title: "Share",
//                    subtitle: "Share statement pdf to others",
//                    backgroundColor:themeChangeProvider.darkTheme  ? Color(0xff191d20) : kPrimaryColor,
//                    titleColor: Colors.white,
//                    subTitleColor: Colors.white,
//                    child: Icon(Icons.share, color: Colors.white,),
//                    onTap: (){
//                      shareStatement();
//                    }
//                ),
//              ],
//            );
//          }
//      ),
//    );
//  }
//
//Widget statementItem(index) {
//  return Container(
//
//    decoration: BoxDecoration(
//        color: themeChangeProvider
//            .darkTheme
//            ? kPrimaryDarkTextField
//            : kPrimaryColor.withOpacity(0.1),
//
//        borderRadius: BorderRadius.circular(10)
//    ),
//    margin: EdgeInsets.symmetric(
//        horizontal: 20, vertical: 12),
//    height:65,
//    child: Container(
//      margin: EdgeInsets.symmetric(
//          horizontal: 15, vertical: 0),
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        children: [
//
//          Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: [
//              Text(MyUtils.formatDate(index.date),    style: GoogleFonts.raleway(
//                fontSize: 10,
//                color: themeChangeProvider.darkTheme
//                    ? Colors.white
//                    : kPrimaryColor,
//              ),),
//              Text(index.remark,  style: GoogleFonts.raleway(
//                fontSize: 13,
//                fontWeight: FontWeight.bold,
//                color: themeChangeProvider.darkTheme
//                    ? Colors.white
//                    : kPrimaryColor,
//              ))
//            ],
//          ),
//
//
//          Text("${loginState.user.currency} ${index.amount}",  style: GoogleFonts.mavenPro(
//            fontSize: 14,
//            fontWeight: FontWeight.bold,
//            color: index.type == "CR" ? kprimaryGreen : kPrimaryColor,
//          ))
//
//        ],
//      ),
//    ),
//
//
//  );
//}
//
//  Future filter() {
//    return showModalBottomSheet(
//        context: context,
//        shape: RoundedRectangleBorder(
//            borderRadius: BorderRadius.only(
//                topLeft: Radius.circular(5), topRight: Radius.circular(5))),
//        builder: (context) {
//          return StatefulBuilder(
//            builder: (BuildContext context, StateSetter setState) {
//              return Container(
//                height: 250,
//                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                decoration: BoxDecoration(
//                    color: isDark ? Color(0xff121416) : Colors.white,
//                    borderRadius: BorderRadius.only(
//                        topLeft: Radius.circular(5),
//                        topRight: Radius.circular(5))),
//                child: Column(
//                  children: <Widget>[
//                    Align(
//                      alignment: Alignment.centerLeft,
//                      child: Text(
//                        "Filter",
//                        style: GoogleFonts.workSans(
//                          fontSize: 25,
//                          color: isDark ? Colors.white : Colors.black,
//                          fontWeight: FontWeight.w500,
//                        ),
//                      ),
//                    ),
//                    SizedBox(
//                      height: 10,
//                    ),
//                    FlatButton(
//                      shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(5),
//                          side: BorderSide(
//                              color: _startDateSelected
//                                  ? Colors.transparent
//                                  : Colors.redAccent,
//                              width: 1)),
//                      color:
//                      isDark ? Color(0xff191D20) : textFieldBackgroundColor,
//                      onPressed: () async {
//                        DateTime date = await selectDate(context: context);
//                        setState(() {
//                          if (date != null) {
//                            _startDate = date.toString().split(" ")[0];
//                          }
//                        });
//                      },
//                      padding:
//                      EdgeInsets.symmetric(vertical: 12, horizontal: 10),
//                      child: Row(
//                        children: <Widget>[
//                          Icon(
//                            Icons.date_range,
//                            color: isDark ? Colors.white : Colors.black,
//                          ),
//                          SizedBox(
//                            width: 5,
//                          ),
//                          Text(
//                            _startDate ?? "Choose start date",
//                            style: TextStyle(
//                                color: isDark ? Colors.white : Colors.black,
//                                fontSize: 16),
//                          ),
//                          Expanded(
//                            child: Align(
//                              alignment: Alignment.centerRight,
//                              child: Text("Change"),
//                            ),
//                          )
//                        ],
//                      ),
//                    ),
//                    SizedBox(
//                      height: 10,
//                    ),
//                    FlatButton(
//                      shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(5),
//                          side: BorderSide(
//                              color: _endDateSelected
//                                  ? Colors.transparent
//                                  : Colors.redAccent,
//                              width: 1)),
//                      color:
//                      isDark ? Color(0xff191D20) : textFieldBackgroundColor,
//                      onPressed: () async {
//                        DateTime date = await selectDate(context: context);
//                        setState(() {
//                          if (date != null) {
//                            _endDate = date.toString().split(" ")[0];
//                          }
//                        });
//                      },
//                      padding:
//                      EdgeInsets.symmetric(vertical: 12, horizontal: 10),
//                      child: Row(
//                        children: <Widget>[
//                          Icon(
//                            Icons.date_range,
//                            color: isDark ? Colors.white : Colors.black,
//                          ),
//                          SizedBox(
//                            width: 5,
//                          ),
//                          Text(
//                            _endDate ?? "Choose end date",
//                            style: TextStyle(
//                                color: isDark ? Colors.white : Colors.black,
//                                fontSize: 16),
//                          ),
//                          Expanded(
//                            child: Align(
//                              alignment: Alignment.centerRight,
//                              child: Text("Change"),
//                            ),
//                          )
//                        ],
//                      ),
//                    ),
//                    SizedBox(
//                      height: 10,
//                    ),
//                    Center(
//                      child: Button(
//                        text: "Apply Filter",
//                        onPressed: () async {
//                          // validate if date has been selected
//                          setState(() {
//                            if (_startDate == null || _startDate.isEmpty) {
//                              _startDateSelected = false;
//                            } else {
//                              _startDateSelected = true;
//                            }
//
//                            if (_endDate == null || _endDate.isEmpty) {
//                              _endDateSelected = false;
//                            } else {
//                              _endDateSelected = true;
//                            }
//                          });
//
//                          if (_startDateSelected && _endDateSelected) {
//                            processedPages.clear();
//                            setState(() {
//                              currentPage = 0;
//                            });
//                            Navigator.pop(context);
//                            await load(
//                                clear: true,
//                                startDate: _startDate,
//                                endDate: _endDate,
//                                showLoading: true);
//                          }
//                        },
//                      ),
//                    )
//                  ],
//                ),
//              );
//            },
//          );
//        });
//  }
//
//  Future selectDate({@required BuildContext context}) async {
//    final picked = await showDatePicker(
//      context: context,
//      firstDate: DateTime(2018),
//      lastDate: DateTime.now().add(Duration(hours: 1)),
//      initialDate: DateTime.now(),
//      selectableDayPredicate: (DateTime d) {
//        if (d.isBefore(DateTime.now().add(Duration(hours: 12)))) {
//          return true;
//        }
//        return false;
//      },
//    );
//    if (picked != null) {
//      return picked;
//    }
//    return null;
//  }
//
//  Future load({bool showLoading = false, bool clear = false, String startDate, String endDate}) async {
//    var result = await getData(
//        context: context,
//        page: currentPage ,
//        showLoading: showLoading,
//        startdate: startDate,
//        enddate: endDate);
//
//    print(result);
//    try {
//      setState(() {
//        if (result != false) {
//          currentPage = currentPage ++;
//          lastPage = list.length;
//
//          if (clear) {
//            list.clear();
//          }
//
//          list.addAll(result.statementModel);
//
//          setState(() {
//            isEmpty = list.isEmpty;
//          });
//        }
//      });
//    } catch (e) {
//      debugPrint(e.toString());
//    }
//  }
//
//  Future<bool> _loadMore() async {
//    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
//    load(clear: false);
//
//    return true;
//  }
//
//  void clearDate() {
//    _startDate = null;
//    _startDateSelected = true;
//    _endDate = null;
//    _endDateSelected = true;
//  }
//
//  Future<void> _refresh() async {
//    setState(() {
//      currentPage = 0;
//      lastPage = 1;
//      clearDate();
//      processedPages.clear();
//    });
//
//    await Future.delayed(Duration(seconds: 0, milliseconds: 800));
//    load(clear: true);
//  }
//
//  Future<dynamic> getData(
//      {BuildContext context,
//        int page,
//        String search,
//        String status,
//        String startdate,
//        String enddate,
//        bool showLoading = false}) async {
//
//
//    if (!processedPages.contains(page)) {
//      // try {
//      if (showLoading) {
//        showDialog(
//            context: context,
//            barrierDismissible: false,
//            builder: (BuildContext context) {
//              return Preloader();
//            });
//      }
//      print("______${showLoading}");
//      processedPages.add(page);
//      print(processedPages);
//      print(page);
//
//      String url ;
//
//      if(startdate != null && enddate != null){
//        url  =  "$stagingUrl/auth/wallet/fiat/statement?from_date=$startdate&to_date=$enddate&page_index=$page&page_size=10";
//
//      }else{
//        url  = "$stagingUrl/auth/wallet/fiat/statement?page_index=$page&page_size=10";
//      }
//
////      URLQueryParams queryParams = new URLQueryParams();
//
////      queryParams.append('page', page);
////
////      queryParams.append('from', startdate);
////      queryParams.append('to', enddate);
//
////      url = url + "?" + queryParams.toString();
//    print(url);
//      final resp = await get(url, headers: {
//        "accept": "application/json",
//        "content-type": "application/json",
//        "Authorization": "Bearer " + loginState.user.token,
//
//      });
//
//      var data = json.decode(resp.body);
//
//      print(data);
//
//      if (showLoading) {
//        Navigator.pop(context, true);
//      }
//      if (resp.statusCode == 200) {
//        //pull the business information of the merchant
//        return AccountStatement.fromJson(data);
//      } else {
//        showInSnackBar(data["message"]);
//        return false;
//      }
//      // } catch (e) {
//      //   if (showLoading) {
//      //     Navigator.pop(context, true);
//      //   }
//      //   showInSnackBar(e.toString());
//
//      //   return false;
//      // }
//    } else {
//      return false;
//    }
//  }
//
//
//
//  String buildEnglishText(LoadMoreStatus status) {
//    String text;
//    switch (status) {
//
//      case LoadMoreStatus.fail:
//        text = "load fail, tap to retry";
//        break;
//      case LoadMoreStatus.idle:
//        text = "wait for loading";
//        break;
//      case LoadMoreStatus.loading:
//        text = "loading, wait for a moment ...";
//        break;
//      case LoadMoreStatus.nomore:
//        text = "";
//        break;
//      default:
//        text = "";
//    }
//    print(status);
//    return text;
//  }
//
//  void showInSnackBar(String value) {
//    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
//    try {
//      _scaffoldKey.currentState.showSnackBar(new SnackBar(
//        content: new Text(value),
//        backgroundColor: Colors.redAccent,
//      ));
//    } catch (e) {}
//  }
//
//  void downloadStatement(BuildContext context) async {
//    while (currentPage < lastPage) {
//      if (_startDate != null) {
//        await load(
//            clear: true,
//            startDate: _startDate,
//            endDate: _endDate,
//            showLoading: true);
//      } else {
//        await load(showLoading: true);
//      }
//    }
//    await StatementReceiptScreen(
//      statementReceiptData: StatementReceiptData(
//          accountName:  loginState.user.bankAccountName,
//          openingBalance: list.last.currentBalance,
//          closingBalance: list.first.currentBalance,
//          accountNumber: loginState.user.bankAaccountNumber,
//          dateCreated: MyUtils.formatDate(DateTime.now().toString()),
//          requestedPeriod:
//          "${_startDate == null || _endDate == null ? MyUtils.formatDate(DateTime.now().toString()) : MyUtils.formatDate(_startDate) + "-" + MyUtils.formatDate(_endDate)}",
//          statementItem: list),
//    ).downloadReceipt();
//    Scaffold.of(context)
//        .showSnackBar(SnackBar(
//      content: Text(
//          "Receipt Downloaded. Check your Download folder"),
//      backgroundColor: Colors.green,
//      duration:
//      Duration(milliseconds: 2500),
//    ));
//  }
//
//  void printStatement() async {
//    print("print");
//    while (currentPage < lastPage) {
//      if (_startDate != null) {
//        await load(
//            clear: true,
//            startDate: _startDate,
//            endDate: _endDate,
//            showLoading: true);
//      } else {
//        await load(showLoading: true);
//      }
//    }
//    StatementReceiptScreen(
//      statementReceiptData: StatementReceiptData(
//          accountName:  loginState.user.bankAccountName,
//          openingBalance: list.last.currentBalance,
//          closingBalance: list.first.currentBalance,
//          accountNumber: loginState.user.bankAaccountNumber,
//          dateCreated: MyUtils.formatDate(DateTime.now().toString()),
//          requestedPeriod:
//          "${_startDate == null || _endDate == null ? MyUtils.formatDate(DateTime.now().toString()) : MyUtils.formatDate(_startDate) + "-" + MyUtils.formatDate(_endDate)}",
//          statementItem: list),
//    ).printPdf();
//  }
//
//  void shareStatement() async {
//    while (currentPage < lastPage) {
//      if (_startDate != null) {
//        await load(
//            clear: true,
//            startDate: _startDate,
//            endDate: _endDate,
//            showLoading: true);
//      } else {
//        await load(showLoading: true);
//      }
//    }
//    StatementReceiptScreen(
//      statementReceiptData:StatementReceiptData(
//          accountName:  loginState.user.bankAccountName,
//          openingBalance: list.last.currentBalance,
//          closingBalance: list.first.currentBalance,
//          accountNumber: loginState.user.bankAaccountNumber,
//          dateCreated: MyUtils.formatDate(DateTime.now().toString()),
//          requestedPeriod:
//          "${_startDate == null || _endDate == null ? MyUtils.formatDate(DateTime.now().toString()) : MyUtils.formatDate(_startDate) + "-" + MyUtils.formatDate(_endDate)}",
//          statementItem: list),
//    ).sharePdf();
//  }
//}
//
////class StatementReceiptData {
////  final String accountName;
////  final String openingBalance;
////  final String accountNumber;
////  final String requestedPeriod;
////  final String dateCreated;
////  final List statementItem;
////  final String closingBalance;
////
////  StatementReceiptData(
////      {this.accountName,
////        this.openingBalance,
////        this.accountNumber,
////        this.requestedPeriod,
////        this.dateCreated,
////        this.statementItem,
////        this.closingBalance});
////}
//
//
//
//
//
//
//
//

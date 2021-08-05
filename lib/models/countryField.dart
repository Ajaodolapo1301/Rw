class CountryField{
  String image;
  String text;
  CountryField({this.text, this.image});
}



//class Statements3 extends StatefulWidget {
//  @override
//  _Statements3State createState() => _Statements3State();
//}
//
//class _Statements3State extends State<Statements3> {
//  ScrollController _scrollController = new ScrollController();
//  int _page = 1;
//  bool isLoading = false;
//  LoginState loginState;
//
//  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
//  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//  List<HistoryModel> transactionHistory = [];
//  ConversionState conversionState;
//  int get count => transactionHistory.length;
//
//  List<dynamic> list = [];
//
//  bool transactionLoading = false;
//  var formKey = GlobalKey<FormState>();
//
//  String _startDate;
//  bool _startDateSelected = true;
//  String _endDate;
//  bool _endDateSelected = true;
//  var passwordKey = GlobalKey<FormState>();
//  DataProvider   videosBloc;
//  @override
//  void initState() {
//    super.initState();
//    getCurrentAppTheme();
//    videosBloc = Provider.of<DataProvider>(context, listen: false);
//    loginState = Provider.of<LoginState>(context, listen: false);
//    videosBloc.resetStreams();
//    videosBloc.fetchAllStatement(pageNumber: _page, page_size: 10, from_date: _startDate, to_date: _endDate, token: loginState.user.token);
//
//    _scrollController.addListener(() {
//      if (_scrollController.position.pixels ==
//          _scrollController.position.maxScrollExtent) {
//        videosBloc.setLoadingState(LoadMoreStatus.LOADING);
//        videosBloc.fetchAllStatement(pageNumber: ++_page, page_size: 10, token: loginState.user.token);
//      }
//    });
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
//    themeChangeProvider = Provider.of<DarkThemeProvider>(context);
//    return new Scaffold(
//
//      backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark :Colors.white,
//      floatingActionButton: videosBloc.allTransaction != null ?   videosBloc.allTransaction.length == 0 ? Container() : Builder(
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
//                    backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : kPrimaryColor,
//                    titleColor: Colors.white,
//                    subTitleColor: Colors.white,
//                    child: Icon(Icons.file_download, color: Colors.white,),
//                    onTap: (){
////                      downloadStatement(context);
//                    }
//                ),
//                MenuItem(
//                    title: "Print",
//                    subtitle: "Print statement directly from your phone",
//                    backgroundColor: themeChangeProvider.darkTheme  ? kPrimaryDark : kPrimaryColor,
//                    titleColor: Colors.white,
//                    subTitleColor: Colors.white,
//                    child: Icon(Icons.print, color: Colors.white,),
//                    onTap: (){
////                      printStatement();
//                    }
//                ),
//                MenuItem(
//                    title: "Share",
//                    subtitle: "Share statement pdf to others",
//                    backgroundColor:themeChangeProvider.darkTheme  ? kPrimaryDark : kPrimaryColor,
//                    titleColor: Colors.white,
//                    subTitleColor: Colors.white,
//                    child: Icon(Icons.share, color: Colors.white,),
//                    onTap: (){
////                      shareStatement();
//                    }
//                ),
//              ],
//            );
//          }
//      ) : Container(),
//      appBar: AppBar(
//        title: Text("Statement and Report", style: GoogleFonts.mavenPro(color: themeChangeProvider.darkTheme  ? Colors.white : kPrimaryColor,fontSize: 17,),),
//        backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.transparent,
//        centerTitle: true,
//        leading:  IconButton(icon: Icon(Icons.arrow_back, color: kprimaryYellow,),onPressed: ()=>Navigator.pop(context),),
//      ),
//      body: Consumer<DataProvider>(
//        builder: (context, usersModel, child) {
//          if (usersModel.allTransaction   != null && usersModel.allTransaction.length > 0 ) {
//            return Column(
//              children: [
//                Container(
//                  margin: EdgeInsets.only(right: 20),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.end,
//                    children: [
//
//                      SvgPicture.asset("images/calendar.svg"),
//                      GestureDetector(
//                          onTap: () {
//                            filter();
//                          },
//                          child: Text(
//                            " Select Range",
//                            style: GoogleFonts.mavenPro(
//                                fontWeight: FontWeight.bold,
//                                fontSize: 13,
//                                color: kprimaryYellow),
//                          ))
//                    ],
//                  ),
//                ),
//
//                SizedBox(height: 10,),
//                Expanded(child: _listView(usersModel)),
//              ],
//            );
//          }else if(usersModel.allTransaction  != null && usersModel.allTransaction.length == 0 ){
//            return   Center(child: Column(
//              children: [
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.end,
//                  children: [
//
//                    SvgPicture.asset("images/calendar.svg"),
//                    GestureDetector(
//                        onTap: () {
//                          filter();
//                        },
//                        child: Text(
//                          " Select Range",
//                          style: GoogleFonts.mavenPro(
//                              fontWeight: FontWeight.bold,
//                              fontSize: 13,
//                              color: kprimaryYellow),
//                        ))
//                  ],
//                ),
//                Text("No history"),
//              ],
//            ),);
//
//          }
//
//          return Column(children: [
//            Row(
//              mainAxisAlignment: MainAxisAlignment.end,
//              children: [
//
//                SvgPicture.asset("images/calendar.svg"),
//                GestureDetector(
//                    onTap: () {
//                      filter();
//                    },
//                    child: Text(
//                      " Select Range",
//                      style: GoogleFonts.mavenPro(
//                          fontWeight: FontWeight.bold,
//                          fontSize: 13,
//                          color: kprimaryYellow),
//                    ))
//              ],
//            ),
//
////
//
//            Center(child: CircularProgressIndicator())]);
//        },
//      ),
//    );
//  }
//
//
//
//
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
//                    color: themeChangeProvider.darkTheme  ? Color(0xff121416) : Colors.white,
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
//                          color: themeChangeProvider.darkTheme  ? Colors.white : Colors.black,
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
//                      themeChangeProvider.darkTheme ? Color(0xff191D20) : textFieldBackgroundColor,
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
//                            color: themeChangeProvider.darkTheme ? Colors.white : Colors.black,
//                          ),
//                          SizedBox(
//                            width: 5,
//                          ),
//                          Text(
//                            _startDate ?? "Choose start date",
//                            style: TextStyle(
//                                color: themeChangeProvider.darkTheme ? Colors.white : Colors.black,
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
//                      themeChangeProvider.darkTheme ? Color(0xff191D20) : textFieldBackgroundColor,
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
//                            color: themeChangeProvider.darkTheme ? Colors.white : Colors.black,
//                          ),
//                          SizedBox(
//                            width: 5,
//                          ),
//                          Text(
//                            _endDate ?? "Choose end date",
//                            style: TextStyle(
//                                color: themeChangeProvider.darkTheme ? Colors.white : Colors.black,
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
////                            processedPages.clear();
//                            setState(() {
////                              currentPage = 0;
//                            });
//                            Navigator.pop(context);
////                            await load(
////                                clear: true,
////                                startDate: _startDate,
////                                endDate: _endDate,
////                                showLoading: true);
//
//                            videosBloc.fetchAllStatement(pageNumber: _page, page_size: 10, token: loginState.user.token, to_date: _endDate, from_date: _startDate);
//
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
//
//
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
//
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
//
//  Widget _listView(DataProvider dataProvider) {
//    return
//      RefreshIndicator(
//        onRefresh: _pullRefresh,
//        child: ListView.separated(
//          itemCount: dataProvider.allTransaction.length,
//          controller: _scrollController,
//          shrinkWrap: true,
//          physics: const AlwaysScrollableScrollPhysics(),
//          itemBuilder: (context, index) {
//            print(index);
//            print("total npage ${dataProvider.totalRecords}");
//            print(dataProvider.allTransaction.length);
//            if ((index == dataProvider.allTransaction.length - 1) && dataProvider.allTransaction.length < dataProvider.totalRecords) {
//              return Center(child: CircularProgressIndicator());
//            }
//
//            return _buildRow(dataProvider.allTransaction[index]);
//          },
//          separatorBuilder: (context, index) {
//            return SizedBox(height: 4,);
//          },
//        ),
//      );
//  }
//
//  Future<void> _pullRefresh() async {
//    await videosBloc.fetchAllStatement(pageNumber: 1, page_size: 10, token: loginState.user.token, to_date: _endDate, from_date: _startDate);;
//
//
//  }
//
//  Widget _buildRow(StatementModel statementModel ) {
//    return
//      StatementWidget(
//          amount: statementModel.amount,
//          loginState: loginState,
//          remark: statementModel.remark,
//          date:statementModel.date,
//          type: statementModel.type,
//          themeChangeProvider: themeChangeProvider
////
////
//      );
//  }
//
//  @override
//  void dispose() {
//    _scrollController.dispose();
//    super.dispose();
//  }
//
//
////  void downloadStatement(BuildContext context) async {
////    while (currentPage < lastPage) {
////      if (_startDate != null) {
////        await load(
////            clear: true,
////            startDate: _startDate,
////            endDate: _endDate,
////            showLoading: true);
////      } else {
////        await load(showLoading: true);
////      }
////    }
////    await StatementReceiptScreen(
////      statementReceiptData: StatementReceiptData(
////          accountName: AppState.of(context).accountName,
////          openingBalance: list.last.currentBalance,
////          closingBalance: list.first.currentBalance,
////          accountNumber: AppState.of(context).accountNumber,
////          dateCreated: formatDate(DateTime.now().toString()),
////          requestedPeriod:
////          "${_startDate == null || _endDate == null ? formatDate(DateTime.now().toString()) : formatDate(_startDate) + "-" + formatDate(_endDate)}",
////          statementItem: list),
////    ).downloadReceipt();
////    Scaffold.of(context)
////        .showSnackBar(SnackBar(
////      content: Text(
////          "Receipt Downloaded. Check your Download folder"),
////      backgroundColor: Colors.green,
////      duration:
////      Duration(milliseconds: 2500),
////    ));
////  }
////
////  void printStatement() async {
////    while (currentPage < lastPage) {
////      if (_startDate != null) {
////        await load(
////            clear: true,
////            startDate: _startDate,
////            endDate: _endDate,
////            showLoading: true);
////      } else {
////        await load(showLoading: true);
////      }
////    }
////    StatementReceiptScreen(
////      statementReceiptData: StatementReceiptData(
////          accountName: AppState.of(context).accountName,
////          openingBalance: list.last.currentBalance,
////          closingBalance: list.first.currentBalance,
////          accountNumber: AppState.of(context).accountNumber,
////          dateCreated: formatDate(DateTime.now().toString()),
////          requestedPeriod:
////          "${_startDate == null || _endDate == null ? formatDate(DateTime.now().toString()) : formatDate(_startDate) + "-" + formatDate(_endDate)}",
////          statementItem: list),
////    ).printPdf();
////  }
////
////  void shareStatement() async {
////    while (currentPage < lastPage) {
////      if (_startDate != null) {
////        await load(
////            clear: true,
////            startDate: _startDate,
////            endDate: _endDate,
////            showLoading: true);
////      } else {
////        await load(showLoading: true);
////      }
////    }
////    StatementReceiptScreen(
////      statementReceiptData: StatementReceiptData(
////          accountName: AppState.of(context).accountName,
////          openingBalance: list.last.currentBalance,
////          closingBalance: list.first.currentBalance,
////          accountNumber: AppState.of(context).accountNumber,
////          dateCreated: formatDate(DateTime.now().toString()),
////          requestedPeriod:
////          "${_startDate == null || _endDate == null ? formatDate(DateTime.now().toString()) : formatDate(_startDate) + "-" + formatDate(_endDate)}",
////          statementItem: list),
////    ).sharePdf();
////  }
//}
//
//class StatementReceiptData {
//  final String accountName;
//  final String openingBalance;
//  final String accountNumber;
//  final String requestedPeriod;
//  final String dateCreated;
//  final List statementItem;
//  final String closingBalance;
//
//  StatementReceiptData(
//      {this.accountName,
//        this.openingBalance,
//        this.accountNumber,
//        this.requestedPeriod,
//        this.dateCreated,
//        this.statementItem,
//        this.closingBalance});
//}


//class Statement extends StatefulWidget {
//  @override
//  _StatementState createState() => _StatementState();
//}
//
//class _StatementState extends State<Statement> with AfterLayoutMixin<Statement> {
//  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
//  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//  List<HistoryModel> transactionHistory = [];
//  ConversionState conversionState;
//
//  LoginState loginState;
//  bool transactionLoading = false;
//  var formKey = GlobalKey<FormState>();
//
//  String _startDate;
//  bool _startDateSelected = true;
//  String _endDate;
//  bool _endDateSelected = true;
//  var passwordKey = GlobalKey<FormState>();
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
//  @override
//  void initState() {
//    getCurrentAppTheme();
//
//    super.initState();
//  }
//
//  void getCurrentAppTheme() async {
//    themeChangeProvider.darkTheme =
//    await themeChangeProvider.darkThemePreference.getTheme();
//  }
//
//
//
//
//  Future load(
//      {bool showLoading = false,
//        bool clear = false,
//        String startDate,
//        String endDate}) async {
//    var result = await getData(
//        context: context,
//
//        page_index: currentPage + 1,
//        showLoading: showLoading,
//        startdate: startDate,
//        enddate: endDate);
//
//    print("rrrrr$result");
//
//    try {
//      setState(() {
//        if (result != false) {
////          currentPage = result.statementModel.currentPage;
////          lastPage = result.statementModel.lastPage;
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
//  void clearDate() {
//    _startDate = null;
//    _startDateSelected = true;
//    _endDate = null;
//    _endDateSelected = true;
//  }
//  Future<dynamic> getData(
//      {BuildContext context,
//        int page_index,
//
//        String page_size,
//        String startdate,
//        String enddate,
//        bool showLoading = false}) async {
//    if (!processedPages.contains(page_index)) {
//      // try {
//      if (showLoading) {
//        showDialog(
//            context: context,
//            barrierDismissible: false,
//            builder: (BuildContext context) {
//              return Preloader();
//            });
//      }
//
//      processedPages.add(page_index);
//
////      SharedPreferences pref = await SharedPreferences.getInstance();
//
//      //build url
////      String url = Env.baseUrl + '/api/wallet/history';
//      String url = "$stagingUrl/auth/wallet/fiat/history";
//      URLQueryParams queryParams = new URLQueryParams();
//
//      queryParams.append('page_index', page_index);
////      queryParams.append('reference', search);
//      queryParams.append('page_size', page_size);
//      queryParams.append('from_date', startdate);
//      queryParams.append('to_date', enddate);
//
//      url = url + "?" + queryParams.toString();
//
//      final resp = await get(url, headers: {
//        "accept": "application/json",
//        "content-type": "application/json",
//        "Authorization": "Bearer " +loginState.user.token,
//
//      });
//
//      var data = json.decode(resp.body);
//
//      print("data$data");
//
//      if (showLoading) {
//        Navigator.pop(context, true);
//      }
//
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
//  @override
//  Widget build(BuildContext context) {
//    loginState = Provider.of<LoginState>(context);
//    conversionState = Provider.of<ConversionState>(context);
//    return Scaffold(
//      key: _scaffoldKey,
//      floatingActionButton: Builder(
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
////                      downloadStatement(context);
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
////                      printStatement();
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
////                      shareStatement();
//                    }
//                ),
//              ],
//            );
//          }
//      ),
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
//
//      body: Column(
//
//        children: [
//          Container(
//            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.end,
//              children: [
//
//                SvgPicture.asset("images/calendar.svg"),
//                GestureDetector(
//                    onTap: () {
//                      filter();
//                    },
//                    child: Text(
//                      " Select Range",
//                      style: GoogleFonts.mavenPro(
//                          fontWeight: FontWeight.bold,
//                          fontSize: 13,
//                          color: kprimaryYellow),
//                    ))
//              ],
//            ),
//          ),

//
//          Expanded(
//            child: Container(
//              color: themeChangeProvider.darkTheme ? Colors.black : Colors.white,
//              child: RefreshIndicator(
//                child: isEmpty
//                    ? Center(
//                  child: Text(
//                    "No History",
//                    style: TextStyle(
//                      color: themeChangeProvider.darkTheme ? Colors.white : Colors.black,
//                    ),
//                  ),
//                )
//                    : LoadMore(
//                  isFinish: (currentPage >= lastPage),
//                  onLoadMore: _loadMore,
//                  child: ListView.separated(
//                    separatorBuilder: (context, index) {
//                      return SizedBox(
//                        height: 10,
//                      );
//                    },
//                    itemBuilder: (BuildContext context, int index) {
//                      return statementItem(list[index]);
//
//                    },
//                    itemCount: count,
//                  ),
//                  delegate: DefaultLoadMoreDelegate(),
//                  textBuilder: buildEnglishText,
//                ),
//                onRefresh: _refresh,
//              ),
//            ),
//          ),
//
//        ],
//      ),
//    );
//  }
//
//  String buildEnglishText(LoadMoreStatus status) {
//    String text;
//    switch (status) {
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
//    return text;
//  }
//

//
//
//
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
//
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
//                    color: themeChangeProvider.darkTheme  ? Color(0xff121416) : Colors.white,
//                    borderRadius: BorderRadius.only(
//                        topLeft: Radius.circular(5),
//                        topRight: Radius.circular(5))),
//                child: Column(
//                  children: <Widget>[
//                    Align(
//                      alignment: Alignment.centerLeft,
//                      child: Text(
//                        "Filter",
//                        style: GoogleFonts.raleway(
//                          fontSize: 20,
//                          color: themeChangeProvider.darkTheme  ? Colors.white : kPrimaryColor,
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
//                      themeChangeProvider.darkTheme ? Color(0xff191D20) : textFieldBackgroundColor,
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
//                            color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
//                          ),
//                          SizedBox(
//                            width: 5,
//                          ),
//                          Text(
//                            _startDate ?? "Choose start date",
//                            style: GoogleFonts.raleway(
//                                color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
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
//                      themeChangeProvider.darkTheme ? Color(0xff191D20) : textFieldBackgroundColor,
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
//                            color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
//                          ),
//                          SizedBox(
//                            width: 5,
//                          ),
//                          Text(
//                            _endDate ?? "Choose end date",
//                            style: GoogleFonts.raleway(
//                                color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
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
////                            processedPages.clear();
//                            setState(() {
////                              currentPage = 0;
//                            });
//                            Navigator.pop(context);
////                            await load(
////                                clear: true,
////                                startDate: _startDate,
////                                endDate: _endDate,
////                                showLoading: true);
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
//  @override
//  void afterFirstLayout(BuildContext context) {
//    getTransactionHistory();
//  }
//
//  getTransactionHistory() async {
//    setState(() {
//      transactionLoading = true;
//    });
//    var result =
//    await conversionState.transactionHistory(token: loginState.user.token);
//    if (result["error"] &&
//        result["message"] == "You are not authorized to make this request") {
//      print("jdjdjdhd");
//      showDialog(
//          barrierDismissible: false,
//          context: context,
//          child: dialogPopup(
//              themeDark: themeChangeProvider.darkTheme,
//              body: Text(
//                "Session has ended,Please Login again",
//                textAlign: TextAlign.center,
//                style: TextStyle(
//                    inherit: false,
//                    fontSize: 18,
//                    color: themeChangeProvider.darkTheme
//                        ? Colors.white
//                        : Colors.black),
//              ),
//              buttonText: "Ok",
//              onPressed: () {
//                final box = Hive.box("user");
//                box.put('user', null);
//                Navigator.pushAndRemoveUntil(
//                    context,
//                    MaterialPageRoute(builder: (context) => LoginPage()),
//                        (Route<dynamic> route) => false);
//              }));
//    } else if (result["error"] == false) {
//      setState(() {
//        transactionLoading = false;
//        transactionHistory = result["transactionHistory"];
//      });
//    }
//  }
//}
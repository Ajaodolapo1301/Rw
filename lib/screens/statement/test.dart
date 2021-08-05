import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/api/authApi.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/models/history.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/reusables/button.dart';
import 'package:rex_money/reusables/dialoPopup.dart';
import 'package:rex_money/screens/auth/login.dart';
import 'package:rex_money/utils/myUtils.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int page = 0;
  List<AccountStatement> statements = [];
  bool isLoading = false;
bool isPageLoading = false;
  Future _loadData() async {
    // perform fetching data delay
    await new Future.delayed(new Duration(milliseconds: 2000 ));

    load();
    setState(() {
      isPageLoading = false;
    });

    print(isPageLoading);
    print("load more");
    // update data and loading status
    setState(() {
//      statements.addAll( );

      isLoading = false;
    });

    print(list);
  }


  Future _loadData2() async {
    // perform fetching data delay
    await new Future.delayed(new Duration(seconds: 2));
    load(pp: page);
    print("load more");
    // update data and loading status
    setState(() {
//      statements.addAll( );

      isLoading = false;
    });

    print(list);
  }


  LoginState loginState;
  String _startDate;
  bool _startDateSelected = true;
  String _endDate;
  bool _endDateSelected = true;



  List<StatementModel> list = [];
  bool isEmpty = false;

  List<int> processedPages = [];

  int get count => list.length;

  String status;
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  @override
  void initState() {

    getCurrentAppTheme();
    _loadData();
    super.initState();
  }


  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
    await themeChangeProvider.darkThemePreference.getTheme();
  }


  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    loginState =Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
        themeChangeProvider.darkTheme ? kPrimaryDark : Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: kprimaryYellow,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Statement and Report",
          style: GoogleFonts.mavenPro(
              color:
              themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
              fontSize: 20),
        ),
      ),
      key: _scaffoldKey,
      body: isPageLoading ? CircularProgressIndicator() :  Column(
        children: <Widget>[

          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                SvgPicture.asset("images/calendar.svg"),
                GestureDetector(
                    onTap: () {
                      filter();
                    },
                    child: Text(
                      " Select Range",
                      style: GoogleFonts.mavenPro(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: kprimaryYellow),
                    ))
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                    _loadData2();
                    // start loading data
                    setState(() {
                      isLoading = true;
                    });
                  }
                },
                child: list.length == 0 ? CircularProgressIndicator() : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    print(" index ${index}");

                    page =index;
                    return statementItem(list[index]);

                  },
                ),
              ),
            ),
          ),
          Container(
            height: isLoading ? 50.0 : 0,
            color: Colors.transparent,
            child: Center(
              child: new CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }



  Widget statementItem(index) {
    return Container(

      decoration: BoxDecoration(
          color: themeChangeProvider
              .darkTheme
              ? kPrimaryDarkTextField
              : kPrimaryColor.withOpacity(0.1),

          borderRadius: BorderRadius.circular(10)
      ),
      margin: EdgeInsets.symmetric(
          horizontal: 20, vertical: 12),
      height:65,
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: 15, vertical: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(MyUtils.formatDate(index.date),    style: GoogleFonts.raleway(
                  fontSize: 10,
                  color: themeChangeProvider.darkTheme
                      ? Colors.white
                      : kPrimaryColor,
                ),),
                Text(index.remark,  style: GoogleFonts.raleway(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: themeChangeProvider.darkTheme
                      ? Colors.white
                      : kPrimaryColor,
                ))
              ],
            ),


            Text("${loginState.user.currency} ${index.amount}",  style: GoogleFonts.mavenPro(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: index.type == "CR" ? kprimaryGreen : kPrimaryColor,
            ))

          ],
        ),
      ),


    );
  }




  Future<dynamic> getData(
      {BuildContext context,
        int page,
        String search,
        String status,
        String startdate,
        String enddate,
        bool showLoading = false}) async {
      String url ;

      if(startdate != null && enddate != null){
        url  =  "$stagingUrl/auth/wallet/fiat/statement?from_date=$startdate&to_date=$enddate&page_index=$page&page_size=10";

      }else{
        url  = "$stagingUrl/auth/wallet/fiat/statement?page_index=$page&page_size=10";
      }

      print(url);
      final resp = await get(url, headers: {
        "accept": "application/json",
        "content-type": "application/json",
        "Authorization": "Bearer " + loginState.user.token,

      });

      var data = json.decode(resp.body);

      setState(() {
        isPageLoading = true;
      });

      if (showLoading) {
        Navigator.pop(context, true);
      }
      if (resp.statusCode == 200) {
        //pull the business information of the merchant
        setState(() {
          isPageLoading = false;
        });
        return AccountStatement.fromJson(data);
      }
       else if (resp.statusCode == 401 &&
            data["message"] == "You are not authorized to make this request") {
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
          return false;
        }


//        showInSnackBar(data["message"]);


      // } catch (e) {
      //   if (showLoading) {
      //     Navigator.pop(context, true);
      //   }
      //   showInSnackBar(e.toString());

      //   return false;
      // }
    }

  void clearDate() {
    _startDate = null;
    _startDateSelected = true;
    _endDate = null;
    _endDateSelected = true;
  }

  Future<void> _refresh() async {
    setState(() {
      page = 0;
      clearDate();
      list.clear();
    });

    await Future.delayed(Duration(seconds: 0, milliseconds: 800));
    load(clear: true);
  }


  Future load({bool showLoading = false, bool clear = false, String startDate, String endDate, pp }) async {

    var result = await getData(
        context: context,
        page: page+1  ,
        showLoading: showLoading,
        startdate: startDate,
        enddate: endDate);

    print(result);
    try {
      setState(() {
        if (result != false) {


          if (clear) {
            list.clear();
          }

          list.addAll(result.statementModel);

        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
  Future filter() {
    return showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5))),
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: 250,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    color: themeChangeProvider.darkTheme  ? Color(0xff121416) : Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5))),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Filter",
                        style: GoogleFonts.raleway(
                          fontSize: 20,
                          color: themeChangeProvider.darkTheme  ? Colors.white : kPrimaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(
                              color: _startDateSelected
                                  ? Colors.transparent
                                  : Colors.redAccent,
                              width: 1)),
                      color:
                      themeChangeProvider.darkTheme ? Color(0xff191D20) : textFieldBackgroundColor,
                      onPressed: () async {
                        DateTime date = await selectDate(context: context);
                        setState(() {
                          if (date != null) {
                            _startDate = date.toString().split(" ")[0];
                          }
                        });
                      },
                      padding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.date_range,
                            color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            _startDate ?? "Choose start date",
                            style: GoogleFonts.raleway(
                                color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
                                fontSize: 16),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text("Change"),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(
                              color: _endDateSelected
                                  ? Colors.transparent
                                  : Colors.redAccent,
                              width: 1)),
                      color:
                      themeChangeProvider.darkTheme ? Color(0xff191D20) : textFieldBackgroundColor,
                      onPressed: () async {
                        DateTime date = await selectDate(context: context);
                        setState(() {
                          if (date != null) {
                            _endDate = date.toString().split(" ")[0];
                          }
                        });
                      },
                      padding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.date_range,
                            color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            _endDate ?? "Choose end date",
                            style: GoogleFonts.raleway(
                                color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
                                fontSize: 16),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text("Change"),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Button(
                        text: "Apply Filter",
                        onPressed: () async {
                          // validate if date has been selected
                          setState(() {
                            if (_startDate == null || _startDate.isEmpty) {
                              _startDateSelected = false;
                            } else {
                              _startDateSelected = true;
                            }

                            if (_endDate == null || _endDate.isEmpty) {
                              _endDateSelected = false;
                            } else {
                              _endDateSelected = true;
                            }
                          });

                          if (_startDateSelected && _endDateSelected) {
//                            processedPages.clear();
                            setState(() {
                              page = 0;
                            });
//                            Navigator.pop(context);
                            await load(
                                clear: true,
                                startDate: _startDate,
                                endDate: _endDate,
                                showLoading: true);
                          }
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          );
        });
  }


  Future selectDate({@required BuildContext context}) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2018),
      lastDate: DateTime.now().add(Duration(hours: 1)),
      initialDate: DateTime.now(),
      selectableDayPredicate: (DateTime d) {
        if (d.isBefore(DateTime.now().add(Duration(hours: 12)))) {
          return true;
        }
        return false;
      },
    );
    if (picked != null) {
      return picked;
    }
    return null;
  }


}





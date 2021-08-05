import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/models/history.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/utils/myUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionDetails extends StatefulWidget {
  final HistoryModel data;
  final bool isDark;

  TransactionDetails({
    @required this.data,
    this.isDark,
  });

  @override
  _TransactionDetailsState createState() =>
      _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
//  Dimens dimens;
  var headerStyle;
  var detailStyle;

  LoginState loginState;

  @override
  void initState() {
    initTextScale();
    setState(() {
      isDark = widget.isDark;
    });
    headerStyle = GoogleFonts.mavenPro(
        fontSize: 16, color: widget.isDark ? Colors.white : kPrimaryColor);
    detailStyle = GoogleFonts.raleway(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: widget.isDark ? Colors.white : kprimaryLight);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isDark = true;

  void initTextScale() async {
    var pref = await SharedPreferences.getInstance();
    setState(() {
      textScale = pref.getDouble("textScaleFactor") ?? 1.0;
    });
  }

  double textScale = 1.0;

  @override
  Widget build(BuildContext context) {
  loginState = Provider.of<LoginState>(context);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: textScale),
      child: new Scaffold(
          backgroundColor:  isDark ? kPrimaryDark : Colors.white,
          appBar: AppBar(
            title: Text("Transactions Details", style: GoogleFonts.mavenPro(color: isDark ? Colors.white : kPrimaryColor,fontSize: 17,),),
            backgroundColor: isDark? kPrimaryDark : Colors.transparent,
            centerTitle: true,
            leading:  IconButton(icon: Icon(Icons.arrow_back, color: kprimaryYellow,),onPressed: ()=>Navigator.pop(context),),
          ),
//          backgroundColor: isDark ? Colors.black : buttonColor,
          body: Container(
            alignment: Alignment.center,
            height:  MediaQuery.of(context).size.height,
            padding: EdgeInsets.zero,
            child: Column(
              children: <Widget>[


                Expanded(
                  child: ListView(
                    physics: NeverScrollableScrollPhysics() ,
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    children: <Widget>[
                      SizedBox(
                        height: 15,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Transaction ID",
                                style: headerStyle,
                              ),
                              Expanded(
                                child: Text(
                                  widget.data.transaction_id,
                                  textAlign: TextAlign.end,
                                  style: detailStyle,
                                ),
                              )
                            ],
                          ),
                          Divider()
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Amount",
                                style: headerStyle,
                              ),
                              Expanded(
                                child: Text(
                                  loginState.user.currency +
                                      " " +
                                    MyUtils.getFormattedAmount(double.parse(widget.data.amount)),
                                  textAlign: TextAlign.end,
                                  style: detailStyle,
                                ),
                              )
                            ],
                          ),
                          Divider()
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Type",
                                style: headerStyle,
                              ),
                              Expanded(
                                child: Text(
                                     widget.data.type,
                                  textAlign: TextAlign.end,

                                  style: GoogleFonts.raleway(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    color: widget.data.type == "CR" ? Colors.green : Colors.red
                                  ),
                                ),
                              )
                            ],
                          ),
                          Divider()
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Remarks",
                                style: headerStyle,
                              ),
                              Expanded(
                                child: Text(
                                  widget.data.remark ?? "",
                                  style: detailStyle,
                                  maxLines: 3,
                                  textAlign: TextAlign.end,
                                ),
                              )
                            ],
                          ),
                          Divider()
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Date",
                                style: headerStyle,
                              ),
                              Expanded(
                                child: Text(
                                 MyUtils.formatDate(widget.data.date),
                                  style: detailStyle,
                                  textAlign: TextAlign.end,
                                ),
                              )
                            ],
                          ),
                          Divider()
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

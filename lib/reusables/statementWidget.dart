import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/utils/myUtils.dart';

class StatementWidget extends StatelessWidget {

  final DarkThemeProvider themeChangeProvider;

  final LoginState loginState;
  final String type;
  final remark;
  final amount;
  final date;
  const StatementWidget({


    Key key,
    @required this.themeChangeProvider,
    this.loginState,
    this.date,
    this.amount,
    this.remark, this.type
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
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
                Text(MyUtils.formatDate(date),    style: GoogleFonts.raleway(
                  fontSize: 10,
                  color: themeChangeProvider.darkTheme
                      ? Colors.white
                      : kPrimaryColor,
                ),),
                Text(remark,  style: GoogleFonts.raleway(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: themeChangeProvider.darkTheme
                      ? Colors.white
                      : kPrimaryColor,
                ))
              ],
            ),


            Text("${loginState.user.currency} ${amount}",  style: GoogleFonts.mavenPro(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: type == "CR" ? kprimaryGreen : kPrimaryColor,
            ))

          ],
        ),
      ),


    );
  }
}
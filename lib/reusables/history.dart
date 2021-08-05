

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/utils/myUtils.dart';


class HistoryCredit extends StatelessWidget {
final  date;
final text;
final currencyType;
final amount;
final color;
final colorSub;


HistoryCredit({this.date, this.currencyType, this.amount, this.text, this.colorSub, this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin:EdgeInsets.only(left:15, top: 15, right: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(MyUtils.formatDate(date), style: GoogleFonts.raleway(color: color, fontSize: 12 ),),
                  SizedBox(height: 2,),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(text, style: GoogleFonts.raleway(color: colorSub, fontSize: 14),),
                  )
                ],
              ),


              Text.rich(TextSpan(children: [
                TextSpan(
                    text: "${currencyType} " ,
                    style: GoogleFonts.raleway(
                        fontSize: 14, color: kprimaryYellow, fontWeight: FontWeight.bold )),
                TextSpan(
                    text:amount.toString(),
                    style: GoogleFonts.mavenPro(
                        fontSize: 14, color: kprimaryYellow, fontWeight: FontWeight.bold )),
              ],
              )
              )
            ],
          ),
          SizedBox(height: 5,),
          Divider()
        ],
      ),
    );
  }
}




class HistoryDebit extends StatelessWidget {
  final  date;
  final text;
  final currencyType;
  final amount;

  final color;
  final colorSub;

  HistoryDebit({this.date, this.currencyType, this.amount, this.text, this.colorSub, this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left:15, top: 15, right: 15),
      child: GestureDetector(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(MyUtils.formatDate(date), style: GoogleFonts.raleway(color: color,fontSize: 12 ),),
                    SizedBox(height: 2,),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(text, style: GoogleFonts.raleway(color: colorSub, fontSize: 14),),
                    )
                  ],
                ),


                Text.rich(TextSpan(children: [
                  TextSpan(
                      text: "${currencyType} ",
                      style: GoogleFonts.raleway(
                          fontSize: 14, color: colorSub, fontWeight: FontWeight.bold )),
                  TextSpan(
                      text:"-${MyUtils.getFormattedAmount(double.parse(amount))}",
                      style: GoogleFonts.raleway(
                          fontSize: 14, color: colorSub, fontWeight: FontWeight.bold )),
                ],
                )
                )
              ],
            ),
            SizedBox(height: 5,),
            Divider()
          ],
        ),
      ),
    );
  }


}
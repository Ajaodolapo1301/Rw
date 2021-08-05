import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/utils/myUtils.dart';

class AmountInputSheet extends StatefulWidget {

    final DarkThemeProvider themeProvider;
  AmountInputSheet({this.themeProvider});

  @override
  _AmountInputSheetState createState() => _AmountInputSheetState();
}

class _AmountInputSheetState extends State<AmountInputSheet> {
  String error;
  double _itemCost;
  MoneyMaskedTextController _amountController2 =
  MoneyMaskedTextController(decimalSeparator: ".", thousandSeparator: ",");
  @override
  Widget build(BuildContext context) {
    return  Container(
      child:  Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
//          const Text(
//            'Enter Amount',
//            style: const TextStyle(
//                color: MyColors.colorPrimary, fontWeight: FontWeight.bold),
//          ),
          new TextField(
            controller: _amountController2,
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
//              LengthLimitingTextInputFormatter(5)
            ],
            onChanged: onAmountChange,
            decoration: new InputDecoration(
                border: new UnderlineInputBorder(
                    borderSide: new BorderSide(color: kPrimaryColor)),
                labelText: 'Amount',

                labelStyle: GoogleFonts.mavenPro(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color:widget.themeProvider.darkTheme ? Colors
                    .white : kPrimaryColor),
                prefixText: 'USD ',
                  prefixStyle: GoogleFonts.mavenPro(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color:widget.themeProvider.darkTheme ? Colors
                          .white : kPrimaryColor),
                errorMaxLines: 3,
                errorText: error),
            style: new TextStyle(color: kPrimaryColor, fontSize: 15.0),
            keyboardType: TextInputType.number,
          ),
          new SizedBox(height: 30),
          new SizedBox(
            width: double.infinity,
            child: new RaisedButton(
              onPressed: () {
                Navigator.of(context).pop(_amountController2.text);
              },
              color: kPrimaryColor,
              padding: EdgeInsets.symmetric(vertical: 14),
              child: new Text(
                'Withdraw',
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  void onAmountChange(String value) {
    int cost =  value.isNotEmpty ? int.parse(MyUtils.getCleanedNumber(value)) : 0;
    setState(() {
//      error = _generateError(cost);
      _itemCost = cost == null ? 0 : cost.toDouble();
    });
  }

//  String _generateError(int cost) {
//    String string;
//
//    if (cost < 2000) {
//      string =
//      'You cannot load less than NGN ${MyUtils.getFormattedAmount(Constants.minWalletBalance)}';
//    } else if ((cost + widget.currentBalance) > Constants.maxWalletBalance) {
//      string =
//      'Your wallet cannot accept more than NGN ${MyUtils.getFormattedAmount((Constants.maxWalletBalance - widget.currentBalance).toInt())}';
//    }
//    return string;
//  }
}
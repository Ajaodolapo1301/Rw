


import 'package:flutter/material.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/reusables/button.dart';

Widget dialogPopup(
    {Widget body, String buttonText, Function onPressed, bool themeDark = false}) {
  return Align(
    alignment: Alignment.center,
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 26),
      decoration: BoxDecoration(
          color: themeDark ? kPrimaryDark : Colors.white,
          borderRadius: BorderRadius.circular(5)),
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          body,
          SizedBox(
            height: 10,
          ),
          buttonText != null
              ? Button(
            onPressed: onPressed,
            text: buttonText,
          )
              : SizedBox()
        ],
      ),
    ),
  );
}
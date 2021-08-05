
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rex_money/constants/colorConstants.dart';

Container primaryButtonValidate({String text, formKey, VoidCallback onPress}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 20),
    child: SizedBox(
      width: double.maxFinite,
      height: 50,
      child: RaisedButton(
        onPressed: () {
          if (formKey.currentState.validate()) {
            onPress;
          }
        },
        child: Text(
          text,
          style: GoogleFonts.mavenPro(
            fontSize: 16,


          ),
        ),
        color: kPrimaryColor,
        padding: EdgeInsets.symmetric(vertical: 15),
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
      ),
    ),
  );
}


Container primaryButton({String text, VoidCallback onPress }) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 20),
    child: SizedBox(
      width: double.maxFinite,
      height: 50,
      child: RaisedButton(
        onPressed: onPress ,
        child: Text(
          text,
          style: GoogleFonts.mavenPro(
            fontSize: 16,
            fontWeight: FontWeight.bold

          ),
        ),
        color: kPrimaryColor,
        padding: EdgeInsets.symmetric(vertical: 15),
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/models/darkmode.dart';
import 'package:rex_money/providers/darkmode.dart';

Container userCard({String text, String subText , Widget image, DarkThemeProvider themeChangeProvider} ) {
  return Container(
    margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 0),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: themeChangeProvider.darkTheme ? kPrimaryDarkTextField : kprimaryLight.withOpacity(0.1)
    ),
    width: double.infinity,
    height: 66.94,
    child: Row(
      children: [

        SizedBox(width:20,),
        image,

        SizedBox(width:10,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text , style: GoogleFonts.raleway(
              color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ) ),
            SizedBox(height:5,),
            Row(
              children: [
                Text(subText, style: GoogleFonts.raleway(
                  color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor.withOpacity(0.4),
                  fontWeight: FontWeight.w500,
                  fontSize: 9,
                )),


              ],
            )
          ],
        ),





      ],
    ),
  );
}
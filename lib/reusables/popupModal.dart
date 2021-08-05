import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/models/darkmode.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';



Widget buildModal({text, subText,  themeChangeProvider, LoginState loginState}) {

  print(themeChangeProvider);
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: [
        Spacer(),
        Container(
//      margin: EdgeInsets.symmetric(
//      horizontal: 20,
//          vertical: 0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: themeChangeProvider.darkTheme
                  ? kPrimaryDarkTextField
                  : kprimaryLight.withOpacity(0.1)),
          width: double.infinity,
          height: 66.94,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(text,
                        style: GoogleFonts.mavenPro(
                          color: themeChangeProvider.darkTheme
                              ? Colors.white
                              : kPrimaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                        )),
                    SizedBox(
                      height: 2,
                    ),
                    Row(
                      children: [
                        Text("$subText ~ ${loginState.user.bankAccount}",
                            style: GoogleFonts.raleway(
                              color: themeChangeProvider.darkTheme
                                  ? Colors.white
                                  : kPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            )),
                      ],
                    )
                  ],
                ),
                GestureDetector(
                    onTap: () {
                      Clipboard.setData(new ClipboardData(
                          text: loginState.user.bankAaccountNumber));

                      toast("Copied to Clipboard");
                    },
                    child: SvgPicture.asset("images/copyBig.svg"))
              ],
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          "To fund your account kindly make a transfer from your local bank to your RexWire Account Information above",
          style: GoogleFonts.raleway(
              color: themeChangeProvider.darkTheme
                  ? Colors.white
                  : kprimaryLight,
              fontSize: 9),
        ),
        SizedBox(
          height: 30,
        ),

//        9921738168
        Container(
          child: SizedBox(
            width: double.maxFinite,
            height: 50,
            child: RaisedButton(
              onPressed: () {
                Clipboard.setData(new ClipboardData(
                    text: loginState.user.bankAaccountNumber));

                toast("Copied to Clipboard");
              },
              child: Text(
                "COPY ACCOUNT NO",
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
        ),
        SizedBox(
          height: 30,
        ),
      ],
    ),
  );
}
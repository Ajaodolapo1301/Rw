


import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/providers/darkmode.dart';

class CommonUtils{



static   modalBottomSheetMenu({BuildContext context, Widget body, DarkThemeProvider darkThemeProvider}){
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
        ),
        context: context,
        builder: (builder){
          return new Container(
            height: 300.0,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: new Container(
                decoration: new BoxDecoration(
                    color: darkThemeProvider.darkTheme  ? kPrimaryDark :  Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(20.0),
                        topRight: const Radius.circular(20.0))),
                child: body
            ),
          );
        }
    );
  }

 static Widget checkMArk() {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 800),
      curve: Curves.elasticInOut,
      tween: Tween<double>(begin: 5, end: 25),
      builder: (__, value, child) {
        return Container(
            child: Icon(Icons.done,

                color: Color(0xff009845)
            )
        );
      },
    );
  }


 static  Widget checkCancel() {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 800),
      curve: Curves.elasticInOut,
      tween: Tween<double>(begin: 5, end: 25),
      builder: (__, value, child) {
        return Container(
            child: Icon(Icons.cancel,

                color: Colors.red
            )
        );
      },
    );
  }

  static  showSuccessDialog({text, context,  DarkThemeProvider themeChangeProvider, VoidCallback onClose, String buttonText }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.symmetric(vertical: 40, horizontal: 25),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(
                    "images/yes.svg",
                    height: 100,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Success!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: themeChangeProvider.darkTheme? Colors.white : headerColor,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style:
                    GoogleFonts.karla(color: themeChangeProvider.darkTheme? Colors.white : smallTextColor, fontSize: 15),
                  ),
                  SizedBox(height: 20),

                  SizedBox(
                    width: double.maxFinite,
                    height: 50,
                    child: RaisedButton(
                      onPressed: onClose,
                      child: Text(
                        buttonText  ?? "Okay",
                        style: GoogleFonts.karla(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
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
                ],
              ),
            )
          ],
        );
      },
    );
  }


static showFlushBar({BuildContext context, String title , String message , Color backgroundColor}) async {
  Flushbar(
    title: title,
    message: message,
    isDismissible: true,
    flushbarPosition: FlushbarPosition.TOP,
    backgroundColor: backgroundColor,
    duration: Duration(seconds: 2),
    flushbarStyle: FlushbarStyle.FLOATING,
    margin: EdgeInsets.all(5),
    borderRadius: 12,
  )..show(context);
}



  static   showMsg(body, DarkThemeProvider themeChangeProvider, context, scaffoldKey, Color snackColor ) {
    final snackBar = SnackBar(
      backgroundColor: themeChangeProvider.darkTheme ? kprimaryYellow : snackColor,
      content: Text(body),
      action: SnackBarAction(
        textColor: Colors.white,
        label: "Close",
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
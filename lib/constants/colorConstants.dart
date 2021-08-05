import 'package:flutter/material.dart';


//Daniel code
const kDashboardDark = Color(0xff0A1030);


const kYellow = Color(0xffffe600);
const runYellow = Color(0xffffe600);
const runBlack = const Color(0xff1c1b1b);
const kBar = Color(0xffF2F5F7);
const kBlue = Color(0xff1c1b1b);
const kBlue1 = Color(0xFF007FBA);
 var kFaded= Color(0xff979797);
const kRegButton= Color(0xffDADEE3);
const kText = Color(0xff1B3760);
const kOwe= Color(0xffE6A40B);
//const kPrimaryColor = Color(0xff67407E);
const kAsh = Color(0xff959595);
const  kOrange = Color(0xffF15F22);
const  kDarkgreen   =    Color(0xff13C27C);
const  kgreen = Color(0xff96C93C);
const kRed= Color(0xffE02020);

const kprimaryYellow = Color(0xffFEB816);
const kprimaryLight =    Color(0xff987EA7);
const kprimaryGreen =   Color(0xff00B871);
const kPrimaryDark = Color(0xff1F1A21);
const kPrimaryDarkAccent = Color(0xff3E3F6F);
const kPrimaryDarkTextField = Color(0xff473A4D);
const kPrimaryDarkText = Color(0xffE3E4FF);

Color buttonColor = Color(0xff00ACEC);
Color headerColor = Color(0xff0D3E53);
Color smallTextColor = Color(0xffB3B3B3);
Color textFieldBackgroundColor = Color(0xffF5F9FF);
Color orangeColor = Color(0xffF87831);
Color greenColor = Color(0xff1AD88C);
Color modalWindowColor = Color(0xff335d6e);
Color ourBluishGreyColor = Color(0xff6D767D);
//const kPrimaryColor= Color(0xff67407E);
const kPrimaryColor= Color(0xff0F1E72);

//#67407E
final kTitleStyle = TextStyle(
  color: kFaded,
  fontFamily: 'CM Sans Serif',
  fontSize: 14.0,
  fontWeight: FontWeight.w700,
);


final kq = TextStyle(color: Color(0xff858484), fontSize:10, fontWeight: FontWeight.w500);



//final kSubtitleStyle =
//TextStyle(color: kPrimaryColor, fontSize: 32.0, fontWeight: FontWeight.w600);
//
//final bTextStyle = TextStyle(
//  color: Colors.black,
//  fontWeight: FontWeight.bold,
//);




class MyColors {

  static const Color colorPrimary = const Color(0xffFF6D50);
  static const Color lightGrey = const Color(0xffC1C1C1);
  static const Color colorPrimaryDark = const Color(0x33FF6D50);
  static const Color accentColor = const Color(0xffF5F5F5);
  static const Color grey = const Color(0xffE1E3E8);
  static Color grey1 = Color(0xffE1E3E8).withOpacity(0.5);
  static const Color otp = const Color(0xff182538);
  static const Color boxOtp = const Color(0x33C5CCD6);
  static const Color statusColor = const Color(0xFFCCB8B8);
  static const Color statusColor2 = const Color(0xFFB09393);
  static const Color textDetailsColor = const Color(0xFF665656);
  static Color accentColorLight = const Color(0xFFFB7D64);

  static Color appBarBlueBlack = const Color(0xff505B6A);
  static Color drawerHeaderColor = const Color(0xffffe600);
  static Color drawerBG = const Color(0xff1c1b1b);
  static Color textBlueBlack = const Color(0xff182538);
  static Color buttonColor = const Color(0xff007FBA);
  static Color bgGreen = const Color(0xff228370);


  static const Color accentColorDeep = const Color(0xffeaad30);
  static const Color colorGreyTrans = const Color(0xffd6d6d6);



  static const madison = const Color(0xFF0B3067);
  static const portGore = const Color(0xFF232846);
  static const goldenBell = const Color(0xFFED8F12);
  static const santasGrey = const Color(0xFF9DA3B4);
  static const bigStone = const Color(0xFF182538);
  static const athensGray = const Color(0xFFF2F2F4);
  static const blackSqueeze = const Color(0xFFF9FBFD);
  static const wildSand = const Color(0xFFF5F5F5);
  static const manatee = const Color(0xFF8C929C);
  static const catalinaBlue = const Color(0xFF061476);
  static const shamRock = const Color(0xFF2CC197);
  static const grayChateau = const Color(0xFF9FA7B3);
  static const ghost = const Color(0xFFE2E2E2);
  static const chablis = const Color(0xFFFFF2F3);
  static const aliceBlue = const Color(0xFFF8FCFF);

}
class Styles {

  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: isDarkTheme ? Colors.white : Colors.black,

      backgroundColor: isDarkTheme ? kPrimaryDark : Color(0xffF1F5FB),
      cursorColor: isDarkTheme ? kprimaryYellow : kPrimaryColor,
      indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xffCBDCF8),
      buttonColor: isDarkTheme ? Color(0xff3B3B3B) : Color(0xffF1F5FB),

      hintColor: isDarkTheme ? Color(0xff280C0B) : Color(0xffEECED3),

      highlightColor: isDarkTheme ? Color(0xff372901) : Color(0xffFCE192),
      hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),

      focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
      disabledColor: Colors.grey,
      textSelectionColor: isDarkTheme ? Colors.white : Colors.black,
      cardColor: isDarkTheme ? Color(0xFF151515) : Colors.white,
      canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
      appBarTheme: AppBarTheme(
        elevation: 0.0,
      ),
    );

  }
}
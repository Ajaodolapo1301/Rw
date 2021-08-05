import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/animation/fadeRoute.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/models/history.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/reusables/drawerList.dart';
import 'package:rex_money/screens/auth/login.dart';
import 'package:rex_money/screens/fundAccount/fundAccount.dart';
import 'package:rex_money/screens/increaseLimit/increaseLimit.dart';
import 'package:rex_money/screens/profile/profile.dart';
import 'package:rex_money/screens/rates/rate.dart';
import 'package:rex_money/screens/requestMoney/requestMoney.dart';
import 'package:rex_money/screens/profile/settings.dart';
import 'package:rex_money/screens/statement/faq.dart';
import 'package:rex_money/screens/statement/statement.dart';
import 'package:rex_money/screens/statement/test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Draw extends StatefulWidget {
  @override
  _DrawState createState() => _DrawState();
}

class _DrawState extends State<Draw> with AfterLayoutMixin<Draw> {
  LoginState loginState;
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void initState() {
    getCurrentAppTheme();

    super.initState();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  void afterFirstLayout(BuildContext context) {
//    loginState.getAuthUser();
  }

  @override
  Widget build(BuildContext context) {
    themeChangeProvider = Provider.of<DarkThemeProvider>(context);
    loginState = Provider.of<LoginState>(context);
    return Drawer(
      child: Container(
        color: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
        child: ListView(
//          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ProfileScreen()));
              },
              child: loginState.user == null
                  ? Container()
                  : CircleAvatar(
                      radius: 50,
                      backgroundColor: kprimaryLight.withOpacity(0.4),
                      child: Container(
                        height: 79,
                        width: 75,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: loginState == null
                                    ? Container()
                                    : NetworkImage(loginState.user.profilepic)),
                            borderRadius: BorderRadius.circular(50)),
//          height: 79,
//            width: 75,
//            child: Image.network(loginState.user.profilepic != null ? loginState.user.profilepic : " " , fit: BoxFit.cover,)
                      ),
                    ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("${loginState.user.firstName} ${loginState.user.lastName}",
                    style: GoogleFonts.raleway(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    )),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(loginState.user.bankAaccountNumber,
                        style: GoogleFonts.raleway(
                          color: themeChangeProvider.darkTheme
                              ? Colors.white
                              : kPrimaryColor.withOpacity(0.4),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        )),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                        onTap: () {
                          Clipboard.setData(new ClipboardData(
                              text: loginState.user.bankAaccountNumber));

                          toast("Copied to Clipboard");
                        },
                        child: SvgPicture.asset("images/copy.svg"))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text("${loginState.user.bankAccount}",
                    style: GoogleFonts.raleway(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    )),
                Divider()
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, FadeRoute(page: Rate()));
                  },
                  child: DrawerList(
                    color: themeChangeProvider.darkTheme
                        ? Color(0xffB88ED1)
                        : kPrimaryColor,
                    colorSub: themeChangeProvider.darkTheme
                        ? Colors.white
                        : kPrimaryColor,
                    text: "Check rate",
                    subtext: "Check current rate",
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, FadeRoute(page: FundAccount()));
                  },
                  child: DrawerList(
                    color: themeChangeProvider.darkTheme
                        ? Color(0xffB88ED1)
                        : kPrimaryColor,
                    colorSub: themeChangeProvider.darkTheme
                        ? Colors.white
                        : kPrimaryColor,
                    text: "Fund Account",
                    subtext: "Transfer fund across the world",
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
//                    Navigator.push(context, FadeRoute(page: StatementScreen()));

                                        Navigator.push(context, FadeRoute(page: MyHomePage()));
                  },
                  child: DrawerList(
                    color: themeChangeProvider.darkTheme
                        ? Color(0xffB88ED1)
                        : kPrimaryColor,
                    colorSub: themeChangeProvider.darkTheme
                        ? Colors.white
                        : kPrimaryColor,
                    text: "Statement/Report",
                    subtext: "See your transaction records",
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, FadeRoute(page: IncreaseLimit()));
                  },
                  child: DrawerList(
                    color: themeChangeProvider.darkTheme
                        ? Color(0xffB88ED1)
                        : kPrimaryColor,
                    colorSub: themeChangeProvider.darkTheme
                        ? Colors.white
                        : kPrimaryColor,
                    text: "Increase Limit",
                    subtext: "Increase your Spending Capacity",
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                GestureDetector(onTap: (){
                  Navigator.push(context, FadeRoute(page: FaqScreen()));
                },
                  child: DrawerList(
                    color: themeChangeProvider.darkTheme
                        ? Color(0xffB88ED1)
                        : kPrimaryColor,
                    colorSub: themeChangeProvider.darkTheme
                        ? Colors.white
                        : kPrimaryColor,
                    text: "FAQ ",
                    subtext: "See frequently asked questions",
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                DrawerList(
                  color: themeChangeProvider.darkTheme
                      ? Color(0xffB88ED1)
                      : kPrimaryColor,
                  colorSub: themeChangeProvider.darkTheme
                      ? Colors.white
                      : kPrimaryColor,
                  text: "Chat with us ",
                  subtext: "Talk to our Representatives",
                ),
                SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, FadeRoute(page: Settings()));
                  },
                  child: DrawerList(
                    color: themeChangeProvider.darkTheme
                        ? Color(0xffB88ED1)
                        : kPrimaryColor,
                    colorSub: themeChangeProvider.darkTheme
                        ? Colors.white
                        : kPrimaryColor,
                    text: "Settings ",
                    subtext: "Access to Security, Dark mode...",
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
                    showAlertDialog(context);
                  },
                  child: DrawerList(
                    color: themeChangeProvider.darkTheme
                        ? Color(0xffB88ED1)
                        : kPrimaryColor,
                    colorSub: themeChangeProvider.darkTheme
                        ? Colors.white
                        : kPrimaryColor,
                    text: "Logout ",
                    subtext: "Its not bye-bye",
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Yes"),
      onPressed: () async {
        final box = Hive.box("user");
        box.put('user', null);
        final SharedPreferences sharedPref =
            await SharedPreferences.getInstance();
//        sharedPref.clear();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logout"),
      content: Text("Are you sure you want to logout?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _logOut(BuildContext context) async {
    final box = Hive.box('driver');
    box.put('driver', null);
//    Navigator.pop(context);
//    Navigator.pop(context);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false);
//    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/providers/appState.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AppState appState;

  DarkThemeProvider darkThemeProvider;
  LoginState loginState;
  bool isSwitched = false;
  bool isDarkMode = false;
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  @override
  void initState() {
    getCurrentAppTheme();
    initIsSwitched();
    auth.canCheckBiometrics.then((value){
      setState(() {
        biometricsSupported = value;
      });
    });
    super.initState();
  }

  bool biometricsSupported = false;

  void initIsSwitched() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    setState(() {
      isSwitched = p.getBool("useFingerPrint") ?? false;
    });
  }

  final LocalAuthentication auth = LocalAuthentication();


  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    themeChangeProvider = Provider.of(context);
    loginState = Provider.of<LoginState>(context);
    return Scaffold(
      backgroundColor:
          themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Settings",
            style: GoogleFonts.mavenPro(
              color:
                  themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
              fontSize: 17,
            ),
          ),
          backgroundColor:
              themeChangeProvider.darkTheme ? kPrimaryDark : Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: kprimaryYellow,
            ),
            onPressed: () => Navigator.pop(context),
          )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
          ),
          UserPContainer(
              loginState: loginState, themeChangeProvider: themeChangeProvider),
          SizedBox(
            height: 20,
          ),
          Column(
            children: [
              if(biometricsSupported)settingsWidget1(
                  images: "images/finger.svg",
                  color: themeChangeProvider.darkTheme
                      ? kPrimaryDarkText
                      : kPrimaryColor,
                  colorSub: themeChangeProvider.darkTheme
                      ? Colors.white
                      : kprimaryLight,
                  text: "Security",
                  subtext: "Sign in with Biometrics print",
                  onSwitch: (value) async {
                    SharedPreferences p = await SharedPreferences.getInstance();
                    p.setBool("useFingerPrint", value);
                  }),
              settingsWidget2(
                images: "images/darkMode.svg",
                text: "Dark Mode",
                subtext: "Change App theme to Dark mode",
                color: themeChangeProvider.darkTheme
                    ? kPrimaryDarkText
                    : kPrimaryColor,
                colorSub: themeChangeProvider.darkTheme
                    ? Colors.white
                    : kprimaryLight,
              ),
              GestureDetector(
                onTap: (){
                  final RenderBox box = context.findRenderObject();
                   Share.share( "Hi, there! ${loginState.user.firstName} has invited you to enjoy free banking on RexWire.  Download RexWire here: https://rexwire.co.link/TbNke5FDza2WyLBw6 and join with this code: ${loginState.user.referral_code} .",
                      subject: "Share",

                      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
                },
                child: settingsWidget3(
                  images: "images/invitation.svg",
                  text: "Referral",
                  subtext: "Refer friends and close networks",
                  color: themeChangeProvider.darkTheme
                      ? kPrimaryDarkText
                      : kPrimaryColor,
                  colorSub: themeChangeProvider.darkTheme
                      ? Colors.white
                      : kprimaryLight,
                ),
              )
            ],
          ),
          Divider()
        ],
      ),
    );
  }

  Widget settingsWidget1(
      {bool val,
      String images,
      String text,
      String subtext,
      color,
      colorSub,
      Function(bool value) onSwitch}) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
              width: 20,
              height: 25,
              child: SvgPicture.asset(
                images,
                fit: BoxFit.cover,
                color: themeChangeProvider.darkTheme ? kprimaryYellow : null,
              )),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text,
                  style: GoogleFonts.raleway(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  )),
              Text(subtext,
                  style: GoogleFonts.raleway(
                    color: colorSub,
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                  ))
            ],
          ),
          Spacer(),
          Transform.scale(
            scale: 0.5,
            child: CupertinoSwitch(
              activeColor: kprimaryYellow,
              trackColor: kPrimaryColor,
              value: isSwitched,
              onChanged: (value) {
                setState(() {
                  isSwitched = value;
                });
                onSwitch(value);
                print(val);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget settingsWidget2(
      {bool val, String images, String text, String subtext, color, colorSub}) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
              width: 20,
              height: 20,
              child: SvgPicture.asset(
                images,
                fit: BoxFit.cover,
                color: themeChangeProvider.darkTheme ? kprimaryYellow : null,
              )),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text,
                  style: GoogleFonts.raleway(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  )),
              Text(subtext,
                  style: GoogleFonts.raleway(
                    color: colorSub,
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                  ))
            ],
          ),
          Spacer(),
          Transform.scale(
            scale: 0.5,
            child: CupertinoSwitch(
                activeColor: kprimaryYellow,
                trackColor: kPrimaryColor,
                value: themeChangeProvider.darkTheme,
                onChanged: (value) {
                  setState(() {
                    themeChangeProvider.darkTheme = value;
                  });

                  print(val);
                }),
          )
        ],
      ),
    );
  }

  Widget settingsWidget3(
      {bool val, String images, String text, String subtext, color, colorSub}) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
              width: 20,
              height: 20,
              child: SvgPicture.asset(
                images,
                fit: BoxFit.cover,
                color: themeChangeProvider.darkTheme ? kprimaryYellow : null,
              )),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text,
                  style: GoogleFonts.raleway(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  )),
              Text(subtext,
                  style: GoogleFonts.raleway(
                    color: colorSub,
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                  ))
            ],
          ),
          Spacer(),
          IconButton(
              icon: Icon(
                Icons.keyboard_arrow_right_sharp,
                size: 20,
                color: themeChangeProvider.darkTheme
                    ? Colors.white
                    : kPrimaryColor,
              ),
              onPressed: null)
        ],
      ),
    );
  }
}





_onShare(BuildContext context) async {
  // A builder is used to retrieve the context immediately
  // surrounding the RaisedButton.
  //
  // The context's `findRenderObject` returns the first
  // RenderObject in its descendent tree when it's not
  // a RenderObjectWidget. The RaisedButton's RenderObject
//  // has its position and size after it's built.
//  final RenderBox box = context.findRenderObject();
//
//  if (imagePaths.isNotEmpty) {
//    await Share.shareFiles(imagePaths,
//        text: text,
//        subject: subject,
//        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
//  } else {
//    await Share.share(text,
//        subject: subject,
//        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
//  }
//}
//
//_onShareWithEmptyOrigin(BuildContext context) async {
//  await Share.share("text");
}

class UserPContainer extends StatelessWidget {
  const UserPContainer({
    Key key,
    @required this.loginState,
    @required this.themeChangeProvider,
  }) : super(key: key);

  final LoginState loginState;
  final DarkThemeProvider themeChangeProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: kprimaryLight.withOpacity(0.1)),
      width: double.infinity,
      height: 94.94,
      child: Row(
        children: [
          SizedBox(
            width: 20,
          ),
          CircleAvatar(
            radius: 30,
            backgroundColor: kprimaryLight.withOpacity(0.5),
            child: Container(
              height: 43,
              width: 40,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(loginState.user.profilepic != null
                          ? loginState.user.profilepic
                          : " ")),
                  borderRadius: BorderRadius.circular(50)),
//          height: 79,
//            width: 75,
//            child: Image.network(loginState.user.profilepic != null ? loginState.user.profilepic : " " , fit: BoxFit.cover,)
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${loginState.user.firstName} ${loginState.user.lastName}",
                  style: GoogleFonts.raleway(
                    color: themeChangeProvider.darkTheme
                        ? kPrimaryDarkText
                        : kPrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                  )),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(loginState.user.bankAaccountNumber,
                      style: GoogleFonts.raleway(
                        color: themeChangeProvider.darkTheme
                            ? Colors.white
                            : kPrimaryColor,
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
              )
            ],
          ),
        ],
      ),
    );
  }
}

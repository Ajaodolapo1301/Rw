import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/api/transactionpinService.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/main.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/reusables/button.dart';
import 'package:rex_money/reusables/pinEntry.dart';
import 'package:rex_money/reusables/preloader.dart';
import 'package:rex_money/utils/create_pin_util.dart';

import 'home.dart';

class CreateTransactionPinScreen extends StatefulWidget {
  @override
  _CreateTransactionPinScreenState createState() =>
      _CreateTransactionPinScreenState();
}

class _CreateTransactionPinScreenState extends State<CreateTransactionPinScreen> {



  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }



  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
    await themeChangeProvider.darkThemePreference.getTheme();
  }

  String mainPin = "";

  String confrimPin = "";

  LoginState loginState;

  GlobalKey<ScaffoldState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    loginState = Provider.of<LoginState>(context);
    themeChangeProvider = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
      key: key,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            children: [
              SizedBox(height: 40),
              Center(child: SvgPicture.asset("images/name.svg")),
              SizedBox(height: 20),
              Text(
                "Create a new \ntransaction Pin",
                textAlign: TextAlign.center,
                style: GoogleFonts.raleway(
                    fontSize: 20,
                    color:themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(

                "Choose your preferred 4 digit pin and click continue to proceed",
                textAlign: TextAlign.center,
                style: GoogleFonts.raleway(color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor , fontSize: 15,),
              ),
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(height: 30),
                    Align(
                      child: Text(
                        "Enter Pin",
                        style: GoogleFonts.raleway(
                            color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor, fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    SizedBox(height: 10),
                    PinEntryTextField(

                      fields: 4,
                      isDark: themeChangeProvider.darkTheme,
                      showFieldAsBox: true,
                      isTextObscure: true,
                      onChanged: (pin) {
                        setState(() {
                          mainPin = pin;
                        });
                      },
                      onSubmit: () {},
                      getCont: (controllers) {},
                    ),
                    SizedBox(height: 30),
                    Align(
                      child: Text(
                        "Confirm Pin",
                        style: GoogleFonts.raleway(
                            color: themeChangeProvider.darkTheme ? Colors.white :  kPrimaryColor, fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    SizedBox(height: 10),
                    PinEntryTextField(
                      fields: 4,
                      isDark: themeChangeProvider.darkTheme,
                      showFieldAsBox: true,
                      isTextObscure: true,
                      onChanged: (pin) {
                        setState(() {
                          confrimPin = pin;
                        });
                        // setState(() {
                        //   ping = pin;
                        // });
                      },
                      onSubmit: () {},
                      getCont: (controllers) {},
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Button(
                onPressed: () {
                  if (!((mainPin.isEmpty || confrimPin.isEmpty) ||
                      (mainPin != confrimPin))) {
                    createPin(context);
                  }
                },
                text: "Continue",
                color: (mainPin.isEmpty || confrimPin.isEmpty) ||
                        (mainPin != confrimPin)
                    ? kPrimaryColor.withOpacity(0.5)
                    : kPrimaryColor,
              ),
              SizedBox(height: 5),
              if (mainPin.length == 4 && confrimPin.length > 3)
                Text(
                  mainPin != confrimPin ? "Pins don't match" : "",
                  style: GoogleFonts.raleway(color: Colors.red),
                )
            ],
          ),
        ),
      ),
    );
  }

  void createPin(BuildContext context) async {
    showDialog(
        context: context, builder: (context) => Preloader());
    var list = await TransactionPinService.enablePin(
      pin: mainPin,
      token: loginState.user.token,
    );
    Navigator.pop(context);
    if (list.first) {
//      await showDialog(context: context, child: VerificationSuccessfulWidget());
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Home()),
        (route) => false,
      );
    } else {
      key.currentState.showSnackBar(
        SnackBar(
          content: Text(list.last),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class VerificationSuccessfulWidget extends StatelessWidget {
  const VerificationSuccessfulWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 250,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 40,
              ),
              decoration:
                  BoxDecoration(color: kPrimaryColor, shape: BoxShape.circle),
            ),
            SizedBox(height: 20),
            Text(
              "Pin Created Successfully",
              style: GoogleFonts.raleway(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            SizedBox(height: 5),
            Text(
              "You transaction pin has been created, proceed to log in",
              textAlign: TextAlign.center,
              style: TextStyle(),
            ),
            SizedBox(height: 10),
            RaisedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: kPrimaryColor,
              textColor: Colors.white,
              child: Text(
                "Okay",
              ),
            )
          ],
        ),
      ),
    );
  }
}

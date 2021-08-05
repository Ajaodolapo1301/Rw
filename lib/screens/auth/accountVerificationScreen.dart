import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/api/transactionpinService.dart';
import 'package:rex_money/api/verifyAccountOTPService.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/reusables/accountVerificationOTP.dart';
import 'package:rex_money/reusables/preloader.dart';
import 'package:rex_money/screens/auth/login.dart';
import 'package:rex_money/screens/create_transaction_pin_screen.dart';
import 'package:rex_money/screens/home.dart';

class AccountVerificationScreen extends StatefulWidget {
  final String email;

  const AccountVerificationScreen({Key key, this.email}) : super(key: key);

  @override
  _AccountVerificationScreenState createState() =>
      _AccountVerificationScreenState();
}

class _AccountVerificationScreenState extends State<AccountVerificationScreen> {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  LoginState loginState;

  @override
  Widget build(BuildContext context) {
    themeChangeProvider = Provider.of<DarkThemeProvider>(context);
    loginState = Provider.of<LoginState>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor:
      themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
      appBar: AppBar(
        backgroundColor:
            themeChangeProvider.darkTheme ? kPrimaryDark : Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: kprimaryYellow,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Verify your account",
          style: GoogleFonts.mavenPro(
            color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Container(

              child: Text(
                "We sent an OTP to your ${widget.email}\nEnter it",
                textAlign: TextAlign.center,
                style: GoogleFonts.mavenPro(color: orangeColor),
              ),
            ),
            SizedBox(height:MediaQuery.of(context).size.height * 0.07),
            Expanded(
              child: AccountVerificationOTP(
                onClickConfirm: (otp) async {
                  showDialog(
                      context: context, builder: (context) => Preloader());
                  List list = await VerifyAccountOTPService.verifyAccount(
                      otp: otp, token: loginState.user.token);
                  Navigator.pop(context);
                  if (list.first) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return Preloader();
                      },
                    );
                    List list = await TransactionPinService.hasPin(
                      token: loginState.user.token,
                    );
                    if(list.first){
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => list.last ? Home() : CreateTransactionPinScreen()),
                              (route) => false);
                    }
                  } else {
                    _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: Text(
                          list.last,
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );

                  }
                  print(otp);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



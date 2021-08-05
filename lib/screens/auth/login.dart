import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/animation/fadeRoute.dart';
import 'package:rex_money/api/passwordResetService.dart';
import 'package:rex_money/api/transactionpinService.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/providers/appState.dart';
import 'package:rex_money/providers/conversionState.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/reusables/customTextField.dart';
import 'package:rex_money/reusables/preloader.dart';
import 'package:rex_money/screens/auth/otp.dart';
import 'package:rex_money/screens/auth/password_reset/enter_mail_page.dart';
import 'package:rex_money/screens/auth/regist.dart';
import 'package:rex_money/screens/auth/register.dart';
import 'package:rex_money/screens/auth/register2.dart';
import 'package:rex_money/screens/auth/selfie.dart';
import 'package:rex_money/screens/create_transaction_pin_screen.dart';
import 'package:rex_money/utils/commonUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home.dart';
import '../self.dart';
import 'accountVerificationScreen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  String phone;
  LoginState loginState;
  ConversionState conversionState;
  String password;

  AppState appState;
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  @override
  void initState() {
    getCurrentAppTheme();
    pullUpExistingCredetials();
    super.initState();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  void _showMsg(body) {
    final snackBar = SnackBar(
      content: Text(body),
      action: SnackBarAction(
        label: "Close",
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  final LocalAuthentication auth = LocalAuthentication();

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        // _isAuthenticating = true;
        // _authorized = 'Authenticating';
      });

      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true);
      if(authenticated){
        _handleLogin(context);
      }
      setState(() {
        // _isAuthenticating = false;
        // _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    // setState(() {
    //   _authorized = message;
    // });
  }

  TextEditingController emailcont = TextEditingController();

  bool obscureText = true;


  @override
  Widget build(BuildContext context) {
    appState = Provider.of(context);
    loginState = Provider.of<LoginState>(context);
    conversionState = Provider.of<ConversionState>(context);
    themeChangeProvider = Provider.of<DarkThemeProvider>(context);
    print(themeChangeProvider.darkTheme);
    return Scaffold(
      backgroundColor:
          themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
      key: _scaffoldKey,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 100),

                  SvgPicture.asset("images/name.svg"),
                  SizedBox(height: 5),
                  Text(
                    "Sign in to Your Account",
                    style: GoogleFonts.raleway(
                        color: themeChangeProvider.darkTheme
                            ? Colors.white
                            : kPrimaryColor,
                        fontSize: 11),
                  ),
                  SizedBox(
                    height: 30,
                  ),

                  CustomTextField(
                    prefix: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SvgPicture.asset(
                        "images/phone.svg",
                        color: themeChangeProvider.darkTheme
                            ? kprimaryYellow
                            : null,
                      ),
                    ),
                    color: kPrimaryColor.withOpacity(0.1),
                    header: "Email or Phone Number",
                    hint: "ajaodlp@xyz.com",
                    type: FieldType.text,
                    controller: emailcont,
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return " Field is required";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        phone = value;
//                          print(phoneNumber);
                      });
                    },
                  ),
                  CustomTextField(
                    color: kPrimaryColor.withOpacity(0.1),
                    header: "Password",
                    hint: "Password",
                    type: FieldType.password,
                    obscureText: obscureText,
                    suffix: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if(fingerPrintEnabled)GestureDetector(
                          onTap: () {
                            _authenticate();
                          },
                          child: Container(
                            child: Icon(Icons.fingerprint_rounded),
                            padding: EdgeInsets.symmetric(horizontal: 3),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                          child: Container(
                            child: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
                            padding: EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                      ],
                    ),
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return "Password is required";
                      }
                      return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FlatButton(
                      textColor: kPrimaryColor,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EnterEmailPage()));
                      },
                      child: Text("Forgot Password?"),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.maxFinite,
                      height: 54,
                      child: Builder(builder: (context) {
                        return RaisedButton(
                          elevation: 0,
                          onPressed: () async {
//                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState.validate()) {
                              _handleLogin(context);
////
                            }

//                            Navigator.push(context, MaterialPageRoute(builder: (context) => Selfie()));
                          },
                          child: Text(
                            "SIGN IN",
                            style: GoogleFonts.karla(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          color: kprimaryYellow,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(height: 20),
                  FlatButton(
                    onPressed: () {
                      Navigator.push(context, FadeRoute(page: Register()));
                    },
                    child: Text(
                      "Sign Up Here",
                      style: GoogleFonts.karla(
                        color: kprimaryYellow,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),


                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void userDetails() async {
    print("user details called");
    var result = await conversionState.userDevice(
        device_uuid: appState.deviceId,
        device_token: appState.myDeviceToken,
        token: loginState.user.token,
        device_platform: Platform.isIOS ? "ios" : "android");
    print(result);
  }

  _handleLogin(context) async {
//    isLoading ?  MyUtils.loadingDialog(context) : null;

    setState(() {
      isLoading = true;
    });

    if (isLoading) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Preloader();
          });
    }
    print(phone);
    print(password);
    var result = await loginState.login(phone: phone.trim(), password: password.trim());

    if (isLoading) {
      Navigator.pop(context, true);
    }
    if (result['error'] == true) {
      CommonUtils.showFlushBar(
          message: result['message'],
          context: context,
          title: "Login failed",
          backgroundColor:
              themeChangeProvider.darkTheme ? kprimaryYellow : kPrimaryColor);
    }
    else {
      if (!result["has_verified_email"]) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AccountVerificationScreen(
                  email: phone,
                )));
      } else {
        if (result["gotPin"]) {
          print(result);
          if (!result["hasPin"]) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CreateTransactionPinScreen()));
          } else {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Home()),
                (route) => false);
          }

          userDetails();
        }
        else {
          CommonUtils.showFlushBar(
              message: result['message'],
              context: context,
              title: "Login failed",
              backgroundColor: themeChangeProvider.darkTheme
                  ? kprimaryYellow
                  : kPrimaryColor);
        }
      }
      print(result);
      print("here");
    }

    setState(() {
      isLoading = false;
    });
  }

  String gotttenEmail;
  String gottenPassword;
  bool fingerPrintEnabled;

  void pullUpExistingCredetials() async {
    SharedPreferences prefrences = await SharedPreferences.getInstance();
    setState(() {
      fingerPrintEnabled = prefrences.getBool("useFingerPrint") ?? false;
      gotttenEmail = prefrences.getString("uemail");
      gottenPassword = prefrences.getString("upassword");
      print("pASSWORD $gottenPassword");
      if(gotttenEmail != null){
        phone = gotttenEmail;
        emailcont.text = phone;
        password = gottenPassword;
      }
    });
  }
}

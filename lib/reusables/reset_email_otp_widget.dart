import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/reusables/dialoPopup.dart';
import 'package:rex_money/reusables/otpTimer.dart';
import 'package:rex_money/reusables/preloader.dart';
import 'package:rex_money/screens/auth/register2.dart';

class ResetPasswordOtp extends StatefulWidget {
  final String email;

  final Function(String otp) onClickConfirm;

  const ResetPasswordOtp({Key key, this.email, this.onClickConfirm}) : super(key: key);

  @override
  _ResetPasswordOtpState createState() => new _ResetPasswordOtpState();
}

class _ResetPasswordOtpState extends State<ResetPasswordOtp>
    with SingleTickerProviderStateMixin, AfterLayoutMixin<ResetPasswordOtp> {
  // Constants
  final int time = 30;
  AnimationController _controller;
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  LoginState loginState;
  bool isLoading = false;

  // Variables
  Size _screenSize;
  int _currentDigit;
  int _firstDigit;
  int _secondDigit;
  int _thirdDigit;
  int _fourthDigit;
  int _fifthDigit;
  int _sixth;
  Timer timer;
  int totalTimeInSeconds;
  bool _hideResendButton;
  String otp;

  String userName = "";
  bool didReadNotifications = false;
  int unReadNotificationsCount = 0;

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  // Returns "Appbar"

  // Return "OTP" input field
  get _getInputField {
    return Padding(
      padding: const EdgeInsets.only(right: 50, left: 50),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _otpTextField(_firstDigit),
          _otpTextField(_secondDigit),
          _otpTextField(_thirdDigit),
          _otpTextField(_fourthDigit),
          _otpTextField(_fifthDigit),
          _otpTextField(_sixth),
        ],
      ),
    );
  }

  // Returns "OTP" input part
  get _getInputPart {
    return SingleChildScrollView(
      child: Container(
        child: new Column(
          children: <Widget>[
            SizedBox(height: 10),
            Text(
              "Enter the OTP sent to \n${widget.email}.",
              textAlign: TextAlign.center
              ,
            ),
            SizedBox(height: 20),
            _getInputField,
            SizedBox(height: 20),
            _getOtpKeyboard,
            SizedBox(
              height: 10,
            ),
            SizedBox(height: 5),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.maxFinite,
                height: 50,
                child: RaisedButton(
                  onPressed: () {
                    confirmOtp();
                  },
                  child: Text(
                    isLoading ? "Processing" : "CONFIRM",
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
          ],
        ),
      ),
    );
  }

  // Returns "Otp" keyboard
  get _getOtpKeyboard {
    return new Container(
        height: _screenSize.width - 80,
        child: new Column(
          children: <Widget>[
            new Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _otpKeyboardInputButton(
                        label: "1",
                        onPressed: () {
                          _setCurrentDigit(1);
                        }),
                    _otpKeyboardInputButton(
                        label: "2",
                        onPressed: () {
                          _setCurrentDigit(2);
                        }),
                    _otpKeyboardInputButton(
                        label: "3",
                        onPressed: () {
                          _setCurrentDigit(3);
                        }),
                  ],
                ),
              ),
            ),
            new Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _otpKeyboardInputButton(
                        label: "4",
                        onPressed: () {
                          _setCurrentDigit(4);
                        }),
                    _otpKeyboardInputButton(
                        label: "5",
                        onPressed: () {
                          _setCurrentDigit(5);
                        }),
                    _otpKeyboardInputButton(
                        label: "6",
                        onPressed: () {
                          _setCurrentDigit(6);
                        }),
                  ],
                ),
              ),
            ),
            new Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _otpKeyboardInputButton(
                        label: "7",
                        onPressed: () {
                          _setCurrentDigit(7);
                        }),
                    _otpKeyboardInputButton(
                        label: "8",
                        onPressed: () {
                          _setCurrentDigit(8);
                        }),
                    _otpKeyboardInputButton(
                        label: "9",
                        onPressed: () {
                          _setCurrentDigit(9);
                        }),
                  ],
                ),
              ),
            ),
            new Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new SizedBox(
                      width: 80.0,
                    ),
                    _otpKeyboardInputButton(
                        label: "0",
                        onPressed: () {
                          _setCurrentDigit(0);
                        }),
                    _otpKeyboardActionButton(
                        label: SvgPicture.asset("images/bck.svg"),
                        onPressed: () {
                          setState(() {
                            if (_sixth != null) {
                              _sixth = null;
                            } else if (_fifthDigit != null) {
                              _fifthDigit = null;
                            } else if (_fourthDigit != null) {
                              _fourthDigit = null;
                            } else if (_thirdDigit != null) {
                              _thirdDigit = null;
                            } else if (_secondDigit != null) {
                              _secondDigit = null;
                            } else if (_firstDigit != null) {
                              _firstDigit = null;
                            }
                          });
                        }),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  // Overridden methods
  @override
  void initState() {
    totalTimeInSeconds = time;
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: time))
          ..addStatusListener((status) {
            if (status == AnimationStatus.dismissed) {
              setState(() {
                _hideResendButton = !_hideResendButton;
              });
            }
          });
    _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);
    _startCountdown();

    getCurrentAppTheme();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void afterFirstLayout(BuildContext context) {}

  confirmOtp() async {
    if(otp?.length == 6){
      widget.onClickConfirm(otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    loginState = Provider.of<LoginState>(context);

    themeChangeProvider = Provider.of<DarkThemeProvider>(context);
    _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor:
          themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
      body: new Container(
        width: _screenSize.width,
//        padding: new EdgeInsets.only(bottom: 16.0),
        child: _getInputPart,
      ),
    );
  }

  // Returns "Otp custom text field"
  Widget _otpTextField(int digit) {
    return new Container(
      width: 35.0,
      height: 45.0,
      alignment: Alignment.center,
      child: new Text(
        digit != null ? digit.toString() : "0",
        style: new TextStyle(
          fontSize: 30.0,
          color: themeChangeProvider.darkTheme
              ? Colors.white
              : kPrimaryColor.withOpacity(0.5),
        ),
      ),
      decoration: BoxDecoration(),
    );
  }

  // Returns "Otp keyboard input Button"
  Widget _otpKeyboardInputButton({String label, VoidCallback onPressed}) {
    return new Material(
      color: Colors.transparent,
      child: new InkWell(
        onTap: onPressed,
        borderRadius: new BorderRadius.circular(40.0),
        child: new Container(
          height: 80.0,
          width: 80.0,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: new Center(
            child: new Text(
              label,
              style: new TextStyle(
                fontSize: 30.0,
                color: themeChangeProvider.darkTheme
                    ? Colors.white
                    : kPrimaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Returns "Otp keyboard action Button"
  _otpKeyboardActionButton({Widget label, VoidCallback onPressed}) {
    return new InkWell(
      onTap: onPressed,
      borderRadius: new BorderRadius.circular(40.0),
      child: new Container(
        height: 80.0,
        width: 80.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: new Center(
          child: label,
        ),
      ),
    );
  }

  // Current digit
  void _setCurrentDigit(int i) {
    setState(() {
      _currentDigit = i;
      if (_firstDigit == null) {
        _firstDigit = _currentDigit;
      } else if (_secondDigit == null) {
        _secondDigit = _currentDigit;
      } else if (_thirdDigit == null) {
        _thirdDigit = _currentDigit;
      } else if (_fourthDigit == null) {
        _fourthDigit = _currentDigit;

//        var otp = _firstDigit.toString() +
//            _secondDigit.toString() +
//            _thirdDigit.toString() +
//            _fourthDigit.toString();

        // Verify your otp by here. API call
      } else if (_fifthDigit == null) {
        _fifthDigit = _currentDigit;
      } else if (_sixth == null) {
        _sixth = _currentDigit;

        otp = _firstDigit.toString() +
            _secondDigit.toString() +
            _thirdDigit.toString() +
            _fourthDigit.toString() +
            _fifthDigit.toString() +
            _sixth.toString();
      }
    });
  }

  Future<Null> _startCountdown() async {
    setState(() {
      _hideResendButton = true;
      totalTimeInSeconds = time;
    });
    _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);
  }

  void clearOtp() {
    _sixth = null;
    _fifthDigit = null;
    _fourthDigit = null;
    _thirdDigit = null;
    _secondDigit = null;
    _firstDigit = null;
    setState(() {});
  }
}

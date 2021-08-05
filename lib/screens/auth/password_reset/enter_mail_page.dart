import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rex_money/api/passwordResetService.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/reusables/customTextField.dart';
import 'package:rex_money/reusables/preloader.dart';
import 'package:rex_money/screens/auth/password_reset/enter_otp_and_new_password_page.dart';

class EnterEmailPage extends StatefulWidget {
  @override
  _EnterEmailPageState createState() => _EnterEmailPageState();
}

class _EnterEmailPageState extends State<EnterEmailPage> {
  GlobalKey<FormState> _formState = GlobalKey<FormState>();

  String email = "";

  var key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: false,
        child: Container(
          child: Form(
            key: _formState,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(Icons.keyboard_backspace),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: kprimaryYellow,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Forgot Password?",
                        style: GoogleFonts.workSans(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: kPrimaryColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Enter your Email Address to send\n a Reset Password OTP",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.karla(
                            color: smallTextColor, fontSize: 13),
                      ),
                      SizedBox(height: 30),
                      CustomTextField(
                        header: "Email ",
                        hint: "josteve@xyz.ng",
                        type: FieldType.email,
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return "Email is required";
                          } else if (!EmailValidator.validate(
                              email.replaceAll(" ", "").trim())) {
                            return "Email is invalid";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          width: double.maxFinite,
                          child: Builder(builder: (context) {
                            return RaisedButton(
                              elevation: 0,
                              onPressed: () async {
                                if (_formState.currentState.validate()) {
                                  requestOTP(context);
                                }
                              },
                              child: Text(
                                "REQUEST OTP",
                                style: GoogleFonts.karla(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
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
                      SizedBox(height: 40),
                    ],
                  ),
                ),
                SizedBox(height: 160)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void requestOTP(BuildContext context) async {
    //hIT THE OTP ENDPOINT

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Preloader();
      },
    );

    var list = await PasswordResetService.initializePasswordReset(email: email);

    Navigator.pop(context);

    if (!list.first) {
      key.currentState.showSnackBar(
        SnackBar(
          content: Text(list.last),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => EnterOTPAndNewPasswordPage(
            email: email,
          ),
        ),
      );
    }

    //mOVE OTO THE NEXT SCREEN
  }
}

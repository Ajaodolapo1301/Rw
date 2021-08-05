import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rex_money/api/passwordResetService.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/reusables/customTextField.dart';
import 'package:rex_money/reusables/preloader.dart';
import 'package:rex_money/reusables/reset_email_otp_widget.dart';
import 'package:rex_money/screens/auth/otp.dart';

class EnterOTPAndNewPasswordPage extends StatefulWidget {
  final String email;

  const EnterOTPAndNewPasswordPage({Key key, this.email}) : super(key: key);

  @override
  _EnterOTPAndNewPasswordPageState createState() =>
      _EnterOTPAndNewPasswordPageState();
}

class _EnterOTPAndNewPasswordPageState
    extends State<EnterOTPAndNewPasswordPage> {
  GlobalKey<FormState> _formState = GlobalKey<FormState>();

  String password;

  var key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Container(
          child: Form(
            key: _formState,
            child: Column(
              children: [
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
                Text(
                  "Enter your new Password",
                  style: GoogleFonts.raleway(
                      color: kPrimaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                CustomTextField(
                  header: "New Password ",
                  type: FieldType.password,
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return "New password is required";
                    }
                    return null;
                  },
                ),
                Expanded(
                  child: ResetPasswordOtp(
                    email: widget.email,
                    onClickConfirm: (otpValue) async {
                      //validate password.
                      if (_formState.currentState.validate()) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Preloader();
                          },
                        );
                        List list =
                            await PasswordResetService.completePasswordReset(
                          email: widget.email,
                          newPassword: password,
                          otp: otpValue,
                        );
                        Navigator.pop(context);
                        key.currentState.showSnackBar(SnackBar(
                          content: Text(
                            list.last,
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                          backgroundColor:
                              list.first ? Colors.purple : Colors.red,
                        ));
                      }
                      //push email and otp to the endpoint
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

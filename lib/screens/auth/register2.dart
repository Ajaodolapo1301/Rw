import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/animation/fadeRoute.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/providers/appState.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/reusables/customTextField.dart';
import 'package:rex_money/reusables/dialoPopup.dart';
import 'package:rex_money/reusables/form.dart';
import 'package:rex_money/reusables/preloader.dart';
import 'package:rex_money/screens/auth/verifyIdentify.dart';
import 'package:rex_money/utils/commonUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  final phone;
  SignUpPage({this.phone});
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  String firstname = "";
  String lastname = "";
  String email = "";
  String state = "";
//  String password = "";
//  String confirmPassword = "";
  String address = "";
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  AppState appState;
  LoginState loginState;
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
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);
    loginState = Provider.of<LoginState>(context);
    themeChangeProvider =Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(

        backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(18.0),
          child: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: SvgPicture.asset("images/leftIcon.svg")),
        ),
      ),
      backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
      body: SafeArea(
        bottom: false,
        child: Container(
          color: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    Text(
                      "It will be quick, we Promise!",
                      style: GoogleFonts.workSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color:themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Enter your Names and Email Address",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.raleway(

                          color:themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
                          fontSize: 11),
                    ),
                    SizedBox(height: 30),

                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "1/4",
                            style: GoogleFonts.raleway(       color:themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    CustomTextField(
                      color: kPrimaryColor.withOpacity(0.1),
                      type: FieldType.name,
                      header: "First Name",
                      hint: "Sumaila",
                      validator: (value) {
                        if(value.trim().isEmpty){
                          return "Name is required";
                        }

                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          firstname = value;
                          appState.firstname = value;
                        });
                      },
                    ),

                    CustomTextField(
                      color: kPrimaryColor.withOpacity(0.1),
                      type: FieldType.name,
                      header: "Last Name",
                      hint: "Jumaila",
                      validator: (value) {
                        if(value.trim().isEmpty){
                          return "Name is required";
                        }
//                        if(!value.trim().contains(" ")){
//                          return "Add space then add the last name";
//                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                         lastname = value;
                         appState.lastname = value;
                        });
                      },
                    ),
                    CustomTextField(
                      color: kPrimaryColor.withOpacity(0.1),
                      header: "Email Address",
                      hint: "josteve@xyz.ng",
                      type: FieldType.email,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return "Email is required";
                        } else if (!EmailValidator.validate(
                            value.replaceAll(" ", "").trim())) {
                          return "Email is invalid";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          email = value;
                          appState.email = value;
                        });
                      },
                    ),

                    CustomTextField(
                      validator: (value) {
                        if(value.trim().isEmpty){
                          return "Address is required";
                        }
                        if(value.length < 20){
                          return "Address must be at least twenty ";
                        }
                        return null;
                      },
                      header: "Residential Address",
                      hint: "123, Plot xyz, Abuja, FCT, Nigeria ",
                      onChanged: (value) {
                        setState(() {
                          address = value;
                          appState.address = value;
                        });
                      },
                    ),
                    SizedBox(height: 30),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: double.maxFinite,
                        height: 50,
                        child: RaisedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _handleRegister2(context);
                            }
                          },
                          child: Text(
                            "PROCEED",
                            style: GoogleFonts.mavenPro(
                              fontSize: 16,
                                fontWeight: FontWeight.bold

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
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  _handleRegister2(context) async {
    setState(() {
      isLoading = true;
    });

    if (isLoading) {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return Preloader();
          });
    }

    var result = await loginState.registerStep2(firstName: firstname, lastName: lastname, email: email, residentialAddress: address, phoneNumber: widget.phone ?? "2347067927252" );
    if (isLoading) {
      Navigator.pop(context, true);
    }


    if (result['error'] == true) {
  CommonUtils.showMsg(result["message"], themeChangeProvider, context, _scaffoldKey, Colors.red);
    } else{

      Navigator.push(context, FadeRoute(page: VerifyIdentify(
        phone: widget.phone,
      )));
//      showDialog(context: context, child: dialogPopup(
//          themeDark: themeChangeProvider.darkTheme,
//          body:
//          Text(
//            "Successful!! ${ result['message']}",
//            textAlign:
//            TextAlign.center,
//            style: TextStyle(
//                inherit:
//                false,
//                fontSize:
//                18,
//                color:themeChangeProvider.darkTheme ? Colors.white:
//                Colors.black),
//          ),
//          buttonText:
//          "Ok",
//          onPressed:
//              () =>









//
//      Navigator.of(context).pushAndRemoveUntil(
//
//          MaterialPageRoute(builder: (context) => Otp(
//            phone: "$phoneCode${_phoneNumber.text}",
//          )),
//              (route) => false);


    }


  }

}




import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/animation/fadeRoute.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/providers/appState.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/reusables/customTextField.dart';
import 'package:rex_money/reusables/preloader.dart';
import 'package:rex_money/screens/auth/login.dart';
import 'package:rex_money/screens/auth/verifyIdentify.dart';
import 'package:rex_money/screens/home.dart';
import 'package:rex_money/utils/commonUtils.dart';
import 'package:rex_money/utils/myUtils.dart';
import 'package:stream_transform/stream_transform.dart';
class UserTag extends StatefulWidget {
  final phone;
  final imagePath;
  final imagePathname;
  UserTag({this.imagePath, this.imagePathname, this.phone});
  @override
  _UserTagState createState() => _UserTagState();
}

class _UserTagState extends State<UserTag> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamController<String> streamController = StreamController();
bool isLoading =  false;
  TextEditingController tag = TextEditingController();
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
var password;
var confirmPass;
  bool  error = false;
LoginState loginState;
  AppState appState;

  bool obscureText = true;
  bool obscureText2 = true;
  bool  isCheckLoading =  false;
 bool isButtonDisaled = true;
  var userTag;
  @override
  void initState() {
    getCurrentAppTheme();

    streamController.stream
        .transform(debounce(Duration(milliseconds: 400)))
        .listen((s) => _validatetext());
    super.initState();
  }

  _validatetext() {
    if (tag.text.length > 3) {
      chechAvail();
    }else{
      // some other code here
    }
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


  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
    await themeChangeProvider.darkThemePreference.getTheme();
  }





  @override
  Widget build(BuildContext context) {
    loginState = Provider.of<LoginState>(context);
    appState = Provider.of<AppState>(context);
    themeChangeProvider = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(

        backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: kprimaryYellow,
            ),
            onPressed: () => Navigator.pop(context),
          )
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
                      "Security and Tag",
                      style: GoogleFonts.workSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color:themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Create a password to login your",

                      textAlign: TextAlign.center,
                      style: GoogleFonts.karla(
                          color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor, fontSize: 11),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "account quickly.",

                      textAlign: TextAlign.center,
                      style: GoogleFonts.karla(
                          color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor, fontSize: 11),
                    ),
                    SizedBox(height: 50),


                    CustomTextField(
                      obscureText: obscureText2,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SvgPicture.asset("images/padlock.svg", color: themeChangeProvider.darkTheme ? kprimaryYellow : null,),
                      ),

                      type: FieldType.password,
                      suffix: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

                          GestureDetector(
                            onTap: (){
                              setState(() {
                                obscureText2 = !obscureText2;
                              });
                            },
                            child: Container(
                              child: Icon(obscureText2 ? Icons.visibility : Icons.visibility_off),
                              padding: EdgeInsets.symmetric(horizontal: 8),
                            ),
                          ),
                        ],
                      ),
                      header: "Password",
                      hint: "*****************",
                      validator: (value) {
                        if(value.trim().isEmpty){
                          return "PassWord is required";
                        }else if(!MyUtils().validateStructure(value)){
                          _showInSnackBar("Password Should contain Minimum 1 Upper case, Minimum 1 lowercase, Minimum 1 Numeric Number, Minimum 1 Special Character");
                          return "Password Should contain Minimum 1 Upper case, Minimum 1 lowercase, Minimum 1 Numeric Number, Minimum 1 Special Character";


                        }
//                        if(!value.trim().contains(" ")){
//                          return "PassWord sh";
//                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                    ),







                    CustomTextField(
                      obscureText: obscureText,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SvgPicture.asset("images/padlock.svg", color: themeChangeProvider.darkTheme ? kprimaryYellow : null,),
                      ),
                      suffix: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

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
                      type: FieldType.password,
                      header: "Confirm password",
                      hint: "*****************",
                      validator: (value) {
                        if(value.trim().isEmpty ){
                          return "Comfirm Password  is required";
                        }else if(value != password){
                          return "passwords do not match is required";
                        }

                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          confirmPass = value;
                        });
                      },
                    ),


                    CustomTextField(
                      suffix: isCheckLoading ? CupertinoActivityIndicator() : error ? CommonUtils.checkCancel() : error == false  &&  !isCheckLoading && !isButtonDisaled  ? CommonUtils.checkMArk() : null,
                    controller: tag,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SvgPicture.asset("images/padlock.svg", color: themeChangeProvider.darkTheme ? kprimaryYellow : null,),
                      ),
                      prefixText: '@ ',
                      color: kPrimaryColor.withOpacity(0.1),
                      header: "User Tag",
                      hint: "HeadHuncho",
                      type: FieldType.text,

                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return "UserTag is required";
                        }
                        return null;
                      },

                      onChanged: (value) {
                        setState(() {
                          isButtonDisaled = true;
                        });

                        if(value.isEmpty){
                          setState(() {
                            isButtonDisaled = true;
                          });
                        }
                        streamController.add(value);
                        setState(() {

                          userTag = value;
//                          print(phoneNumber);
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
                          disabledColor: isButtonDisaled ?   kprimaryLight : kPrimaryColor,
                          onPressed:isButtonDisaled ? null :  () {
                            if(_formKey.currentState.validate()){
                              _handleRegist(context);
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
  void _showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }











  _handleRegist(context) async {


//    isLoading ?  MyUtils.loadingDialog(context) : null;

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

//
    var result = await loginState.secureAccount(
      phone: widget.phone,
      password: password,
        user_tag: userTag,
    );


    if (isLoading) {
      Navigator.pop(context, true);
    }
    if (result['error'] == true) {
      CommonUtils.showMsg(result["message"], themeChangeProvider, context, _scaffoldKey, Colors.red);
    } else{
      toast("Successfully Registered, Please Login,  ");
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => false);
    }

    setState(() {
      isLoading = false;
    });
  }




  chechAvail() async{
    setState(() {
      isCheckLoading = true;
      isButtonDisaled = true;
    });
    var result =  await loginState.checkAvailabilty(tagName: userTag);
      if(result["error"] == false){
        setState(() {

          error =false;
          isButtonDisaled = false;
        });
      }else{
        setState(() {
          error = true;
          isButtonDisaled = true;
        });
        toast("This Tag name has been chosen by another user, Please choose another");
      }
    print(result);
    setState(() {
      isCheckLoading = false;
    });
  }



}

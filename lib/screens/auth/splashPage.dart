

import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';
import 'package:rex_money/models/user.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/screens/auth/login.dart';
import 'package:rex_money/screens/auth/onBoarding.dart';
import 'package:rex_money/screens/rates/rate.dart';
import 'package:rex_money/screens/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home.dart';



class SplashPage extends StatefulWidget {
  final User  user;
  SplashPage({this.user});
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with AfterLayoutMixin<SplashPage> {
  LoginState loginState;


  Future<bool> isFirstTime() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    var isFirstTime = sharedPref.getBool('first_time');
    if (isFirstTime != null && !isFirstTime) {
      sharedPref.setBool('first_time', false);
      return false;
    } else {
      sharedPref.setBool('first_time', false);
      return true;
    }
  }

  @override
  void initState() {

    super.initState();

//    Timer(Duration(seconds: 5,) , ()=> widget.user == null  ?  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage())) : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home())) );
    Timer(Duration(seconds: 5
    ), () {
     isFirstTime().then((isFirstTime) {
        isFirstTime ? Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>OnboardingScreen())) :  loginState.user != null ? Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home())) : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()))  ;
      });
    }
    );
  }



  @override
  Widget build(BuildContext context) {
    loginState = Provider.of<LoginState>(context);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[


          Center(
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50)
                  ),
                  height: 200,
                  width: 200,
                  child:SvgPicture.asset("images/rexLogo.svg") )
          ),

        ],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context)async {

    var result = await loginState.getflag();
//    print(result);

    var result2 = await loginState.getContinent();
//      print(result2);
  }
}



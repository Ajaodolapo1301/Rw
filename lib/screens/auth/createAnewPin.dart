
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/reusables/pincode.dart';




class ANewPin extends StatefulWidget {


  const ANewPin({Key key,}) : super(key: key);
  @override
 _ANewPinState createState() => _ANewPinState();
}

class _ANewPinState extends State<ANewPin> {

  String newPin;
  String pinFromEmail;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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




  List<TextEditingController> pinControllers =[];
  List<TextEditingController> otpControllers = [];


  @override
  Widget build(BuildContext context) {
    themeChangeProvider = Provider.of<DarkThemeProvider>(context);
    print(themeChangeProvider.darkTheme);
    return Scaffold(

      appBar: AppBar(

        backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(18.0),
          child: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: SvgPicture.asset("images/leftIcon.svg")),
        ),

        title: Text("Create a New Pin", style: GoogleFonts.mavenPro(color: themeChangeProvider.darkTheme ? Colors.white :  kPrimaryColor, fontWeight: FontWeight.bold),),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: themeChangeProvider.darkTheme ? Colors.black : Colors.white,
      key: _scaffoldKey,
      body: SafeArea(bottom: false,
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: themeChangeProvider.darkTheme ? Colors.black : Colors.white,
          child: Column(

            children: <Widget>[

              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    margin: EdgeInsets.symmetric(horizontal: 20,),
                    child: Column(


                      children: <Widget>[

                        SizedBox(height: MediaQuery.of(context).size.height * 0.1,),

                        SvgPicture.asset(
                          "images/name.svg",

                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 10),


                        SizedBox(
                          height: 30,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "New Pin",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.workSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: themeChangeProvider.darkTheme ? Colors.black : kPrimaryColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        PinEntryTextField(
                          fields: 4,
                          showFieldAsBox: true,
                          isTextObscure: true,
                          isDark: themeChangeProvider.darkTheme,
                          onSubmit: (pin){
                            setState(() {
                              newPin = pin;
                            });
                          },
                          getCont: (controller){
                            pinControllers = controller;
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Confirm New Pin",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.workSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: themeChangeProvider.darkTheme ? Colors.black  : kPrimaryColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        PinEntryTextField(
                          fields: 4,
                          isDark: themeChangeProvider.darkTheme,
                          isTextObscure: true,
                          showFieldAsBox: true,
                          getCont: (controllers){
                            otpControllers = otpControllers;
                          },
                          onSubmit: (pin){
                            setState(() {
                              pinFromEmail = pin;
                            });
                          },
                        ),
                        SizedBox(height: 40),
                        SizedBox(
                          width: double.maxFinite,
                          child: RaisedButton(
                            onPressed: ()async {
//                              await recoverPIN(
//                                  pin: this.newPin, tempPin: pinFromEmail);
                              pinControllers.forEach((element) {
                                element.clear();
                              });

                              otpControllers.forEach((element) {
                                element.clear();
                              });

//                              Navigator.pop(context);
                            },
                            child: Text(
                              "SIGN IN",
                              style: GoogleFonts.mavenPro(
                                fontSize: 16,

                              ),
                            ),
                            color: kprimaryYellow,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showInSnackBar(String value) {
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
    try {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(value),
        backgroundColor: Colors.redAccent,
      ));
    } catch (e) {}
  }

//  Future<bool> recoverPIN({String pin, String tempPin}) async {
//    SharedPreferences pref = await SharedPreferences.getInstance();
//
//
//
//    try {
//      String url = "${Env.baseUrl}/api/transaction_pin/recover";
//
//      showDialog(
//          context: context,
//          barrierDismissible: false,
//          builder: (BuildContext context) {
//            return Preloader();
//          });
//
//      final resp = await post(url,
//          headers: {
//            "accept": "application/json",
//            "content-type": "application/json",
//            "ACCESS-KEY": Env.accessToken,
//            "Authorization": "Bearer " + pref.getString("token"),
//            "MID": pref.getString("current_mid")
//          },
//          body: json.encode({"new_pin": pin, "temp_pin": tempPin}));
//
//      var data = json.decode(resp.body);
//      Navigator.pop(context);
//
//      if (resp.statusCode == 200 || resp.statusCode == 201) {
//        var result = Responses.fromJson(data);
//        print(data);
//        if (result.status == 200 || result.status == 201) {
//          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> FailedOrSuccessfulPage(failed: false, message: "Pin successfully updated", )));
////          showInSnackBar("New PIN has been successfully Created");
//
//          return true;
//        } else if (result.status == 401) {
//          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> FailedOrSuccessfulPage(failed: true, message: result.message, )));
////          showInSnackBar("Kindly recover pin.");
//
//          return false;
//        } else {
//          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> FailedOrSuccessfulPage(failed: true, message: result.message, )));
//
////          showInSnackBar(result.message);
//
//          return false;
//        }
//      } else if (resp.statusCode == 400) {
//        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> FailedOrSuccessfulPage(failed: true, message: data["message"] ?? "" )));
//
////        showInSnackBar("${data["message"]}");
//
//        return false;
//      } else {
//
//        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> FailedOrSuccessfulPage(failed: true, message: data["message"] ?? "" )));
//
//        showInSnackBar("${data["message"]}");
//
//        return false;
//      }
//    } catch (e) {
//
//      Navigator.pop(context);
//      print(e.toString());
//
//      return false;
//    }
//  }
//
//  Future<bool> forgotPIN() async {
//    SharedPreferences pref = await SharedPreferences.getInstance();
//
//    showDialog(
//        context: context,
//        barrierDismissible: false,
//        builder: (BuildContext context) {
//          return Preloader();
//        });
//
//    try {
//      String url = "${Env.baseUrl}/api/transaction_pin/forgot";
//
//      final resp = await get(url, headers: {
//        "accept": "application/json",
//        "content-type": "application/json",
//        "ACCESS-KEY": Env.accessToken,
//        "Authorization": "Bearer " + pref.getString("token"),
//        "MID": pref.getString("current_mid")
//      });
//
//      var data = json.decode(resp.body);
//      Navigator.pop(context);
//
//      print(resp.statusCode);
//
////      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("A temporary PIN has been sent to your email."),));
//      if (resp.statusCode == 200 || resp.statusCode == 201) {
//        var result = Responses.fromJson(data);
//        print(result.status);
//        if (result.status == 200) {
//          showInSnackBar("A temporary PIN has been sent to your email.");
//
//          return true;
//        } else if (result.status == 401) {
//          showInSnackBar("Kindly recover pin.");
//
//          return false;
//        } else {
//          showInSnackBar(result.message);
//
//          return false;
//        }
//      } else if (resp.statusCode == 400) {
//        showInSnackBar("${data["message"]}");
//
//        return false;
//      } else {
//        showInSnackBar("${data["message"]}");
//
//        return false;
//      }
//    } catch (e) {
//      print("cacelled");
//      Navigator.pop(context);
//      debugPrint(e.toString());
//
//      return false;
//    }
//  }
}
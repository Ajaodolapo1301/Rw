
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/animation/fadeRoute.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/screens/auth/upload.dart';
import 'package:rex_money/utils/commonUtils.dart';

class VerifyIdentify extends StatefulWidget {
  final phone;

  VerifyIdentify({this.phone});
  @override
  _VerifyIdentifyState createState() => _VerifyIdentifyState();
}

class _VerifyIdentifyState extends State<VerifyIdentify> {



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

  @override
  Widget build(BuildContext context) {
    themeChangeProvider = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(

        backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: kprimaryYellow,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,

      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Verify your Identity",
                style: GoogleFonts.workSans(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color:themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
                ),
              ),
              SizedBox(height: 2),
              Text(
                "To get verified, you will need to provide",
                textAlign: TextAlign.center,
                style: GoogleFonts.raleway(
                    color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor, fontSize: 12),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
//            SizedBox(height: 60),
              SvgPicture.asset("images/id.svg", color: themeChangeProvider.darkTheme ? kprimaryYellow : null,),
              SizedBox(height: 5),
              Text(
                "Government Issued ID card",
                textAlign: TextAlign.center,
                style: GoogleFonts.mavenPro(
                    color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor, fontWeight: FontWeight.bold , fontSize: 15),
              ),

              SizedBox(height: 5),
              Text(
                "Your passport, National ID or",
                textAlign: TextAlign.center,
                style: GoogleFonts.mavenPro(
                    color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor, fontSize: 11),
              ),
              Text(
                "a driving license.",
                textAlign: TextAlign.center,
                style: GoogleFonts.mavenPro(
                    color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor, fontSize: 11),
              ),



              SizedBox(height: MediaQuery.of(context).size.height * 0.05),


              SvgPicture.asset("images/Selfies.svg", color:  themeChangeProvider.darkTheme ? kprimaryYellow : null,),
              SizedBox(height: 5),
              Text(
                "A Selfie Photography",
                textAlign: TextAlign.center,
                style: GoogleFonts.mavenPro(
                    color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor, fontWeight: FontWeight.bold , fontSize: 15),
              ),

              SizedBox(height: 5),
              Text(
                "To match your face with",
                textAlign: TextAlign.center,
                style: GoogleFonts.mavenPro(
                    color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor, fontSize: 11),
              ),
              Text(
                "your Identity Card.",
                textAlign: TextAlign.center,
                style: GoogleFonts.mavenPro(
                    color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor, fontSize: 11),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Please be ready to accept the ", style: GoogleFonts.raleway(color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor.withOpacity(0.6), fontSize: 12),),
                Text("Terms of Use ", style: GoogleFonts.raleway(color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor.withOpacity(0.6), fontSize: 12, fontWeight: FontWeight.bold),),
                Text("and ", style: GoogleFonts.raleway(color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor.withOpacity(0.6), fontSize: 12, ),)

              ],

            ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Privacy Policy ", style: GoogleFonts.raleway(color:  themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,fontWeight: FontWeight.bold, fontSize: 12),),
                  Text("by Rexwire and also provide", style: GoogleFonts.raleway(color:  themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor, fontSize: 12, ),)


                ],

              ),

Spacer(),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.maxFinite,
                  height: 50,
                  child: RaisedButton(
                    onPressed: () {
//                            if (_formKey.currentState.validate()) {
                      Navigator.push(context, FadeRoute(page: Upload(
                        phone: widget.phone,
                      )));
//                            }
                    },
                    child: Text(
                      "I ACCEPT",
                      style: GoogleFonts.mavenPro(
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
                  ),
                ),
              ),
              SizedBox(height: 15),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.maxFinite,
                  height: 50,
                  child: RaisedButton(
                    onPressed: () {
                        CommonUtils.modalBottomSheetMenu(context: context, darkThemeProvider: themeChangeProvider,

                            body: Center(child: Text("You have to agree to submit some vital document to proceed on this platform")

                              ,));
                    },
                    child: Text(
                      "DECLINE",
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



              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}

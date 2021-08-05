






import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/providers/appState.dart';
import 'package:rex_money/providers/darkmode.dart';




class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  AppState appState;

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
    return Scaffold(

      appBar: AppBar(
        title: Text("User Profile", style: GoogleFonts.mavenPro(color: kPrimaryColor,fontSize: 17,),),
        backgroundColor: themeChangeProvider.darkTheme ? Colors.black : Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(18.0),
          child: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: SvgPicture.asset("images/leftIcon.svg")),
        ),
      ),


      body: Column(

        children: [
          SizedBox(height: 50,),
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: kprimaryLight.withOpacity(0.1)
              ),
              width: 335,
              height: 94.94,
              child: Row(
                children: [

                  SizedBox(width:20,),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: kprimaryLight.withOpacity(0.5),
                    child: Container(
                        height: 43,
                        width: 40,
                        child: Image.asset("images/avatar.png", fit: BoxFit.cover,)),
                  ),

                  SizedBox(width:10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Christopher Ntuk", style: GoogleFonts.raleway(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ) ),
                      SizedBox(height:5,),
                      Row(
                        children: [
                          Text("0122335654322", style: GoogleFonts.raleway(
                            color: kPrimaryColor.withOpacity(0.4),
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          )),

                          SizedBox(width:5,),
                          SvgPicture.asset("images/copy.svg")
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

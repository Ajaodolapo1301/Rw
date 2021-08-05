
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/providers/darkmode.dart';




class NotifError extends StatefulWidget {
  @override
  _NotifErrorState createState() => _NotifErrorState();
}

class _NotifErrorState extends State<NotifError> {




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
      backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Center(
            child: Column(
              children: [
                Image.asset("images/sad.png"),
                SizedBox(height: 5,),
                Text("Transfer was Unsuccessful.", style: GoogleFonts.raleway(
                    fontSize: 17,
                    fontWeight: FontWeight.bold
                ),),

                SizedBox(height: 5,),
                Container(
                    width: 208,

                    child: Text("Don't be Sad, Kindly Confirm your Details and try Again" , textAlign: TextAlign.center, style: GoogleFonts.raleway(
                        fontSize: 12,
                        fontWeight: FontWeight.bold
                    ),))

              ],
            ),
          ),



          Text("Go back Home")

        ],
      ),
    );
  }
}

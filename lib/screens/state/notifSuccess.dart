
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/screens/home.dart';
import 'package:rex_money/screens/requestMoney/requestMoney.dart';
import 'package:rex_money/screens/virtualCards/cardDetails.dart';
import 'package:rex_money/screens/virtualCards/cards.dart';




class Notif extends StatefulWidget {
  final message;
final bool fundwithcardnonAfrican;
  final  bool card;
  final fromReqSent;
  final bool fromFundCard;

  final bool fromIncreaseLimit;
  Notif({this.message, this.card = false, this.fromFundCard = false, this.fromReqSent = false, this.fundwithcardnonAfrican = false, this.fromIncreaseLimit = false});
  @override
  _NotifState createState() => _NotifState();
}

class _NotifState extends State<Notif> {




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

        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
Spacer(),
        Center(
          child: Column(
            children: [
              Image.asset("images/success.png"),
              SizedBox(height: 5,),
     Text(widget.fromReqSent ?  widget.message : widget.fromIncreaseLimit ? "Successfully Applied for Increase Limit": "Successful."  , style: GoogleFonts.raleway(
              fontSize: 17,
                color: themeChangeProvider.darkTheme ? kprimaryYellow : kPrimaryColor,
              fontWeight: FontWeight.bold
            ),),

              SizedBox(height: 5,),
      widget.fromReqSent ||  widget.fromIncreaseLimit ? Container() :        Container(
                width: 208,

                  child: Text(widget.message , textAlign: TextAlign.center, style: GoogleFonts.raleway(
                      fontSize: 12,
                      color: themeChangeProvider.darkTheme ? kprimaryYellow : kPrimaryColor,
                      fontWeight: FontWeight.bold
                  ),))

            ],
          ),
        ),
          Spacer(),

          Column(
            children: [
      widget.fromFundCard ?         GestureDetector(
                onTap: (){

Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Cards()));

//                  Navigator.pushAndRemoveUntil(
//                      context,
//                      MaterialPageRoute(builder: (context) => Cards()),
//                          (Route<dynamic> route) => false);
                },
                child: Text("Go Back", style: GoogleFonts.raleway(
                    fontSize: 17,
                    color: kprimaryYellow,
                    fontWeight: FontWeight.bold
                ),),
              ) :Container(),

              widget.card  ?          GestureDetector(
                onTap: (){


         Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Cards()),
                          (Route<dynamic> route) => false);
                },
                child: Text("Go Back", style: GoogleFonts.raleway(
                    fontSize: 17,
                    color: kprimaryYellow,
                    fontWeight: FontWeight.bold
                ),),
              ) :Container(),
SizedBox(height: 20,),
            widget.card || widget.fromFundCard  ?   Container():         GestureDetector(
                onTap: (){
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                          (Route<dynamic> route) => false);
                },
                child: Text("Go Back Home", style: GoogleFonts.raleway(
                    fontSize: 17,
                    color: kprimaryYellow,
                    fontWeight: FontWeight.bold
                ),),
              ),
            ],
          ),
   SizedBox(height: 100,)
        ],
      ),
    );
  }
}

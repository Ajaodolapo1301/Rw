
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rex_money/animation/sizeRoute.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/models/virtualDollarCard.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/screens/virtualCards/cardDetails.dart';
import 'package:rex_money/screens/virtualCards/cardDetails2.dart';

class VirtualCardActive extends StatelessWidget {
  final  VirtualCardModel  singleCard ;
  const VirtualCardActive({
    Key key,
    @required this.themeChangeProvider, this.singleCard
  }) : super(key: key);

  final DarkThemeProvider themeChangeProvider;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        print("pres");
        Navigator.push(context, SizeRoute(page: CardDetails22(
          singleCard: singleCard,
        )));
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 0),
        color:themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
        child: Column(
          children: [


//          Container(
//            margin: EdgeInsets.symmetric(
//                horizontal: 10,
//                vertical: 10),
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.end,
//              children: [
//                Text("+ NEW CARD", style: GoogleFonts.mavenPro(fontWeight: FontWeight.bold, fontSize: 13, color: kprimaryYellow),)
//
//              ],
//            ),
//          ),
//
//          SizedBox(height:10,),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: themeChangeProvider.darkTheme ? kPrimaryDarkTextField : kprimaryLight.withOpacity(0.1)
              ),
              width: double.infinity,
              height: 66.94,
              child: Row(
                children: [

                  SizedBox(width:20,),
                  SvgPicture.asset("images/fundCard.svg", height: 20,color:  themeChangeProvider.darkTheme ? kprimaryYellow : null, ),

                  SizedBox(width:20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text( singleCard.masked_pan , style: GoogleFonts.raleway(
                        color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ) ),
                      SizedBox(height:3,),
                      Row(
                        children: [
                          Text(singleCard.expiration, style: GoogleFonts.raleway(
                            color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor.withOpacity(0.4),
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                          )),


                        ],
                      )
                    ],
                  ),
                  Spacer(),
                  Text("ACTIVE", style: GoogleFonts.raleway(fontSize: 9 , fontWeight: FontWeight.bold, color: kprimaryGreen),),
                  SizedBox(width:10,),


                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}



class VirtualCardInActive extends StatelessWidget {
  final  VirtualCardModel  singleCard ;
  const VirtualCardInActive({
    Key key,
    @required this.themeChangeProvider, this.singleCard
  }) : super(key: key);

  final DarkThemeProvider themeChangeProvider;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, SizeRoute(page: CardDetails22(
          singleCard: singleCard,
        )));
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 0),
        color:themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
        child: Column(
          children: [

            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: themeChangeProvider.darkTheme ? kPrimaryDarkTextField : kprimaryLight.withOpacity(0.1)
              ),
              width: double.infinity,
              height: 66.94,
              child: Row(
                children: [

                  SizedBox(width:20,),
                  SvgPicture.asset("images/fundCard.svg", color:  themeChangeProvider.darkTheme ? kprimaryYellow : null, height: 20, ),

                  SizedBox(width:20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(singleCard.masked_pan , style: GoogleFonts.raleway(
                        color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ) ),
                      SizedBox(height:3,),
                      Row(
                        children: [
                          Text(singleCard.expiration, style: GoogleFonts.raleway(
                            color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor.withOpacity(0.4),
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                          )),


                        ],
                      )
                    ],
                  ),
                  Spacer(),
                  Text("INACTIVE", style: GoogleFonts.raleway(fontSize: 9 , fontWeight: FontWeight.bold, color:  themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor),),
                  SizedBox(width:10,),


                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
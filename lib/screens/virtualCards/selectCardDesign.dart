//import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/animation/fadeRoute.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/models/radioModel.dart';
import 'package:rex_money/providers/appState.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/reusables/primarybutton.dart';
import 'package:rex_money/reusables/radioItem.dart';
import 'package:rex_money/screens/virtualCards/CreateVirtualCard.dart';
import 'package:rex_money/screens/virtualCards/cardDetails.dart';

class SelectCardDesign extends StatefulWidget {
  final cardTile;
  SelectCardDesign({this.cardTile});
  @override
  _SelectCardDesignState createState() => _SelectCardDesignState();
}

class _SelectCardDesignState extends State<SelectCardDesign> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AppState appState;
  String _errortext;
  String _dropDownValueforCardTitle;
  DarkThemeProvider darkThemeProvider;
  LoginState loginState;
  bool isSwitched = false;
  bool isDarkMode = false;
  Color cardColor = Colors.white;
  var designCode;
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  List<RadioModel> sampleData = new List<RadioModel>();

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
    sampleData.add(new RadioModel(
        isSelected: true, button: Colors.white, colorCode: "#FFFFFF", text: "Default"));
    sampleData.add(new RadioModel(
        isSelected: false, button: Color(0xffFEB816), colorCode: "#FEB816", text: "Dark Tangerine"));
    sampleData.add(new RadioModel(
        isSelected: false, button: Color(0xff16AFFE), colorCode: "#16AFFE", text: "Deep Sky Blue"));
    sampleData.add(new RadioModel(
        isSelected: false, button: Color(0xff3F2B4B),colorCode: "#3F2B4B",  text: "Jagger Purple"));
    sampleData.add(new RadioModel(
        isSelected: false, button: Color(0xffFE1692),colorCode: "#FE1692",  text: "Deep Pink"));
    sampleData.add(new RadioModel(
        isSelected: false, button: Color(0xff2DD280),colorCode: "#2DD280",  text: " Shamrock Green"));

  }




  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    print(designCode);
    themeChangeProvider = Provider.of(context);
    loginState = Provider.of<LoginState>(context);
    return Scaffold(
      backgroundColor:
          themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Select Card Design",
            style: GoogleFonts.mavenPro(
              color:
                  themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
              fontSize: 17,
            ),
          ),
          backgroundColor:
              themeChangeProvider.darkTheme ? kPrimaryDark : Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: kprimaryYellow,
            ),
            onPressed: () => Navigator.pop(context),
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            Container(

              height: 200,
//              height: MediaQuery.of(context).size.height * 0.23,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
              child: Material(
                borderRadius: BorderRadius.circular(15),
                color: cardColor,
                elevation: 1,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                     "${loginState.user.firstName} ${loginState.user.lastName}",
                            style: GoogleFonts.mavenPro(
                                fontWeight: FontWeight.bold,
                                fontSize: 9,
                                color: designCode == "#3F2B4B" ? Colors.white :  kPrimaryColor),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: SvgPicture.asset("images/logorex.svg"),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              SvgPicture.asset("images/rexText.svg", color: designCode == "#3F2B4B" ? Colors.white :kPrimaryColor,),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "****  ****    ****    ****  ",
                                style:
                                    TextStyle(color: designCode == "#3F2B4B" ? Colors.white : Colors.black, fontSize: 20),
                              )
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
//                        Text("Card Name", style: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 5, color: kPrimaryColor),),
                              Text(
                                widget.cardTile != null ? widget.cardTile : " ",
                                style: GoogleFonts.raleway(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 9,
                                    color: designCode == "#3F2B4B" ? Colors.white : kPrimaryColor),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Image.asset("images/visaBlue.png", color: designCode == "#3F2B4B" || designCode == "#16AFFE" || designCode == "#FEB816" || designCode =="#FE1692"?  Colors.white : null,),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 26,
            ),
            Container(
              color: kPrimaryColor.withOpacity(0.2),
              height: 36,
              child: Padding(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "select designs".toUpperCase(),
                      style: GoogleFonts.mavenPro(
                          fontSize: 14,
                          color: themeChangeProvider.darkTheme
                              ? kPrimaryDarkText
                              : kPrimaryColor,
                          letterSpacing: 1.0),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 20,
            ),
        Container(
          height: 300,
          child: new ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: sampleData.length,
            itemBuilder: (BuildContext context, int index) {
              return  GestureDetector(
                //highlightColor: Colors.red,
//              splashColor: Colors.blueAccent,
                onTap: () {
                  setState(() {
                    designCode = sampleData[index].colorCode;
                    cardColor = sampleData[index].button;
                    sampleData.forEach((element) => element.isSelected = false);
                    sampleData[index].isSelected = true;
                  });
                },
                child:  RadioItem(sampleData[index]),
              );
            },
          ),
        ),

            SizedBox(
              height: 30,
            ),
            primaryButton(text: "Continue", onPress: () {


              Navigator.push(context, FadeRoute(page: CreateVirtualCard(
                designCode: designCode ?? "#FFFFFF" ,
                cardtitle: widget.cardTile,
              )));


            }),


          ],
        ),
      ),
    );
  }
}



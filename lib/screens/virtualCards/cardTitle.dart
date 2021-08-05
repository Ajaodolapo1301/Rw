import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/animation/fadeRoute.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/models/VirtualCardTitles.dart';
import 'package:rex_money/providers/appState.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/providers/virtualCardState.dart';
import 'package:rex_money/reusables/form.dart';
import 'package:rex_money/screens/virtualCards/selectCardDesign.dart';
import 'package:rex_money/utils/commonUtils.dart';
import 'package:rex_money/utils/myUtils.dart';


class CardTitle extends StatefulWidget {
  final String card_type;
  CardTitle({this.card_type});
  @override
  _CardTitleState createState() => _CardTitleState();
}

class _CardTitleState extends State<CardTitle> with AfterLayoutMixin<CardTitle> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AppState appState;
  String _errortext;
  VirtualCardlist _dropDownValueforCardTitle;
  DarkThemeProvider darkThemeProvider;
  LoginState loginState;
  bool isSwitched = false;
  bool  isDarkMode = false;
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  VirtualCardState virtualCardState;
    bool isLoading = false;
    List<VirtualCardlist> cardTitleList = [];
//  var cardTitleList = [
//    "Adobe",
//    "Airbnb",
//    "Aliexpress",
//    "Amazon",
//    "marketplace",
//    "Amazon Prime",
//    "Amazon web service",
//    "Apple AppStore",
//    "Apple itunes",
//    "Asos",
//    "Canva",
//    "Facebook",
//    "Facebook ads",
//    "Godaddy",
//    "Google",
//    "Google Ads",
//    "Gsuite",
//    "Jumia",
//    "Netflix",
//    "Konga",
//    "Mailchimp",
//    "Microsoft",
//    "Namecheap",
//    "Paypal",
//    "Playstore",
//    "Shopify",
//    "skillshare",
//    "Udemy",
//    "Domestika",
//    "Zoom",
//    "Instagram Shopping",
//    "Instagram Ads"
//  ];


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

    virtualCardState = Provider.of(context);
    themeChangeProvider = Provider.of(context);
    loginState = Provider.of<LoginState>(context);
    return Scaffold(
      backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
          centerTitle: true,
          title: Text("Card Title", style: GoogleFonts.mavenPro(color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,fontSize: 17,),),
          backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.transparent,
          leading:  IconButton(icon: Icon(Icons.arrow_back, color: kprimaryYellow,),onPressed: ()=>Navigator.pop(context),)
      ),
  body: Column(
    children: [
      SizedBox(
        height: 16,
      ),
      Container(
        margin: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              "Select a Card label",
              style: GoogleFonts.mavenPro(
                fontWeight:
                FontWeight.bold,
                fontSize: 13,
                color: themeChangeProvider.darkTheme
                    ? Colors.white
                    : kPrimaryColor,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Stack(
              children: [
                FormField(builder: (
                    FormFieldStatestate) {
                  return DropdownButtonHideUnderline(

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .stretch,
                        children: <Widget>[
                          InputDecorator(

                            decoration:
                            InputDecoration(
                              hintText: "Choose card label",

                              hintStyle:  GoogleFonts
                                  .raleway(
                                  fontSize: 14,
                                  color: themeChangeProvider.darkTheme
                                      ? Colors
                                      .white
                                      : kPrimaryColor),
                              contentPadding:EdgeInsets.fromLTRB(10,0,10,0),
                              border:  FormBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),

                              ),


                              fillColor: themeChangeProvider.darkTheme
                                  ? kPrimaryDarkTextField
                                  : kPrimaryColor.withOpacity(0.1),

                              filled: true,

                              labelStyle:
                              TextStyle(
                                color: themeChangeProvider.darkTheme
                                    ? Colors
                                    .white
                                    : Colors
                                    .black, //This is an example of a change
                              ),
//                                                                  labelText: _dropDownValue == null ? "Select Monthly transaction volume " : " Select Monthly transaction volume",
                              errorText:
                              _errortext,
                            ),
                            isEmpty:
                            _dropDownValueforCardTitle == null,
                            child:
                            DropdownButton<
                                VirtualCardlist>(
                              icon:  Icon(Icons.arrow_drop_down, size: 19,) ,
                              dropdownColor: themeChangeProvider.darkTheme
                                  ? kPrimaryDarkTextField
                                  : Colors
                                  .white,

                              value: _dropDownValueforCardTitle,
                              isDense: true,
                              onChanged: (
                                  VirtualCardlist newValue) {
                                setState(() {
                                  _dropDownValueforCardTitle =
                                      newValue;
                                });
                              },

                              items: cardTitleList.map((
                                  VirtualCardlist value) {
                                return DropdownMenuItem<
                                    VirtualCardlist>(
                                  value: value,
                                  child: Text(
                                      value.card_title ,
                                      style: GoogleFonts
                                          .raleway(
                                        fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: themeChangeProvider.darkTheme
                                              ? Colors
                                              .white
                                              : kPrimaryColor)),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ));
                },
                ),

                isLoading
                    ? Positioned(
                    top: 15,
                    right: 10,
                    child: CupertinoActivityIndicator())
                    : SizedBox()
              ],
            ),
          ],
        ),
      ),

      SizedBox(
        height: 15,
      ),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: double.maxFinite,
          height: 50,
          child: RaisedButton(
            disabledColor:  kPrimaryColor,
            onPressed: () {

         _dropDownValueforCardTitle == null ?  toast("Please Select a card name") :   Navigator.push(context, FadeRoute(page: SelectCardDesign(
                cardTile: _dropDownValueforCardTitle.card_title,
              )));
            },
            child: Text(
              "Continue",
              style: GoogleFonts.mavenPro(
                  fontSize: 17,
                  fontWeight: FontWeight.w700

              ),
            ),
            color: kPrimaryColor,
            padding: EdgeInsets.symmetric(vertical: 15),
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    ],
  ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    getTitles();
  }

  void getTitles() async{
    setState(() {
      isLoading = true;
    });
  var result = await  virtualCardState.listofTitles(token: loginState.user.token);
    setState(() {
      isLoading = false;
    });
  if(result["error"] == false){
    setState(() {
      cardTitleList = result["virtualcardList"];
    });
  }else{

    CommonUtils.showMsg(result["message"], themeChangeProvider, context, _scaffoldKey, Colors.red);

//      CommonUtils.showFlushBar(message: result["message"], title: "Alert", context: context, backgroundColor: themeChangeProvider.darkTheme ? kprimaryYellow : kPrimaryColor);
  }

  }
}

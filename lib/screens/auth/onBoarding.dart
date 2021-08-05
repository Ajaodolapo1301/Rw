import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rex_money/animation/fadeRoute.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/screens/auth/login.dart';
import 'package:rex_money/screens/rates/rate.dart';
import 'package:rex_money/utils/sizeConfig/sizeConfig.dart';


class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List<OnboardItem> items = [
    OnboardItem(
        assetImagePath: "images/pana.svg",

        headerText: "Send Money across Africa and beyond.",
        subText: "Excellent rate and no transfer fee."),
    OnboardItem(
        assetImagePath: "images/rafiki.svg",
        headerText: "Your Money arrives just in time as promised",
        subText: "Prompt and Guaranteed delivery."),
    OnboardItem(
        assetImagePath: "images/panaboard.svg",
        headerText: "Safe ad Secured",
        subText: "Your information is always confidential and your funds are protected..",

      isLast: true,
    ),

  ];

  @override
  void initState() {
//    PushNotificationsManager().init(context);
    pageController = PageController();
    pageController.addListener(() {
      setState(() {
        page = pageController.page.round();
        print(page);
      });
    });

    super.initState();
  }

  int page = 0;
  PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      backgroundColor: Color(0xffff5d4c),
      body: Stack(
        children: <Widget>[
          PageView.builder(
            controller: pageController,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              page = index;
              return Transform.scale(
                scale: index == 0 ? 1.01: 1,
                child: Container(
                  decoration: BoxDecoration(
                  color: Colors.white
                  ),
                  child: Container(
                    margin: EdgeInsets.only(bottom: index == 2 ? 50 : 60),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Builder(
                            builder: (_) {
                              if(index == 0){
                                return Transform.translate(
                                  offset: Offset(0, 50),
                                  child: Transform.scale(
                                    scale: 1,
                                    child: SvgPicture.asset(
                                      items[index].assetImagePath,
                                      height: 64.5 * SizeConfig.imageSizeMultiplier,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                );
                              }
                              if (index == 2) {
                                return SvgPicture.asset(
                                  items[index].assetImagePath,
                                  height: 64.5 * SizeConfig.imageSizeMultiplier,
                                  // width: 500,
                                  fit: BoxFit.contain,
                                );
                              }
                              return SvgPicture.asset(
                                items[index].assetImagePath,
                                height: 64.5 * SizeConfig.imageSizeMultiplier,
                                // width:  500,
                                fit: BoxFit.contain,
                              );
                            },
                          ),
                        ),
                        SizedBox(height:  index == 2? 30 : 10),


                 index == 0 ?    Container(
                          width: 206,
//                          height: 16,
                          child: Text(
                            items[index].headerText,
                            style: GoogleFonts.mavenPro(
                                fontSize: 22,
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ) : index == 1 ?
                 Container(
                   width: 248,

                   child: Text(
                     items[index].headerText,
                     style: GoogleFonts.mavenPro(
                         fontSize: 22,
                         color: kPrimaryColor,
                         fontWeight: FontWeight.bold),
                     textAlign: TextAlign.center,
                   ),
                 ) :  Container(
                   width: 185,
//                          height: 16,
                   child: Text(
                     items[index].headerText,
                     style: GoogleFonts.mavenPro(
                         fontSize: 22,
                         color: kPrimaryColor,
                         fontWeight: FontWeight.bold),
                     textAlign: TextAlign.center,
                   ),
                 ),
                        SizedBox(height: 10),
                    index == 2    ?Container(
                      width: 292,
                      child: Text(
                        items[index].subText,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.raleway(
                          fontSize: 15,
                          color: kPrimaryColor,
                        ),
                      ),
                    ) : index == 1 ? Container(
                      width: 214,
                      child: Text(
                        items[index].subText,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.raleway(
                          fontSize: 15,
                          color: kPrimaryColor,
                        ),
                      ),
                    ):

                    Container(
                          width: 160,
                          child: Text(
                            items[index].subText,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.raleway(
                              fontSize: 15,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                        SizedBox(height: index == 2 ? 10 : 0),
                        index == 2
                            ? Column(
                              children: [
                                Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: SizedBox(
                                width: double.maxFinite,
                                child: RaisedButton(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  onPressed: () {
                                Navigator.push(
                                    context, FadeRoute(page: LoginPage()));
                                  },
                                  elevation: 0,
                                  child: Text(
                                    "Get Started".toUpperCase(),
                                    style: GoogleFonts.mavenPro(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  color: kPrimaryColor,
                                ),
                          ),
                        ),
                    SizedBox(height: 10,),

//                                GestureDetector(
//                                  onTap:(){
//                                    Navigator.push(
//                                        context, FadeRoute(page: Rate()));
//              },
//                                  child: Container(
//                                      child: Text("Check rates",
//                                      style: GoogleFonts.raleway(
//                                        color: kprimaryYellow,
//                                        fontSize: 14,
//                                        fontWeight: FontWeight.bold,
//
//                                      ))),
//                                )
                              ],
                            )
                            : SizedBox()
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: items.length,
          ),
          page != 2
              ? Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              margin: EdgeInsets.symmetric(vertical: 0),
              child: Row(
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                    child: Text(
                      "SKIP",
                      style: GoogleFonts.karla(
                        color: kPrimaryColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Spacer(),
                  Indicator(
                    position: page,
                    numberOfItems: 3,
                  ),
                  Spacer(),
                  Opacity(
                    opacity: 0,
                    child: FlatButton(
                      onPressed: () {},
                      child: Text(
                        "SKIP",
                        style: GoogleFonts.mavenPro(
                          color: kPrimaryColor,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
              : SizedBox()
        ],
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  final int position;
  final int numberOfItems;

  const Indicator({Key key, this.position, this.numberOfItems})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        numberOfItems,
            (index) => index == position ? getCircle() : getCircleSmallOrange(),
      ),
    );
  }

  Widget getCircle() {
    return Container(
      margin: EdgeInsets.all(2),
      width: 9,
      height: 9,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: kPrimaryColor
      ),
    );
  }

  Widget getCircleSmallOrange() {
    return Container(
      width: 9,
      height: 9,
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: kPrimaryColor.withOpacity(0.3)
      ),
    );
  }
}

class OnboardItem {

  final String assetImagePath;
  final String headerText;
  final String subText;
  final bool isLast;

  OnboardItem(
      {

        this.assetImagePath,
        this.headerText,
        this.subText,
        this.isLast = false});
}

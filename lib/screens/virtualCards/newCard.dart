import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/animation/fadeRoute.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/providers/appState.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/screens/virtualCards/cardTitle.dart';

class NewCard extends StatefulWidget {
  @override
  _NewCardState createState() => _NewCardState();
}

class _NewCardState extends State<NewCard> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AppState appState;

  DarkThemeProvider darkThemeProvider;
  LoginState loginState;
  bool isSwitched = false;
  bool  isDarkMode = false;
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

  int position = 0;
//  List<String> images = [
//    "images/cardvi.png",
//    "images/cardvi.png",
//    "images/cardvi.png"
//  ];




  @override
  Widget build(BuildContext context) {
    themeChangeProvider = Provider.of(context);
    loginState = Provider.of<LoginState>(context);
    return Scaffold(
      backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
          centerTitle: true,
          title: Text("New Card", style: GoogleFonts.mavenPro(color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,fontSize: 17,),),
          backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.transparent,
          leading:  IconButton(icon: Icon(Icons.arrow_back, color: kprimaryYellow,),onPressed: ()=>Navigator.pop(context),)
      ),
    body:  Column(
        crossAxisAlignment: CrossAxisAlignment.center,
      children: [
//        CarouselSlider(
//          options: CarouselOptions(
//            aspectRatio: 16/9,
//            viewportFraction: 0.7,
//            enableInfiniteScroll: false,
//            reverse: true,
//            height:MediaQuery.of(context).size.height * 0.7,
//            enlargeCenterPage: true,
//
//            enlargeStrategy: CenterPageEnlargeStrategy.height,
//          ),
//          items: images.asMap().map((i, img) {
//            setState(() {
//              position = i;
//            });
//            print("Position$position");
//            return     MapEntry(i, Builder(
//
//              builder: (BuildContext context) {
//                print("iiiii$i");
//////                setState(() {
////                position = i;
////
//////              });
//
//
//                return Container(
//                    width: double.infinity,
//
//
//                    decoration: BoxDecoration(
//                        image: DecorationImage(
//                            fit: BoxFit.cover,
//                            image: AssetImage(img)
//                        )
//                    )
//
//                );
//
//              },
//            ));
//          }
//
//          ).values.toList()
//        ),


//        Row(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: [
//            Indicator(
//              position: position ,
//              numberOfItems: images.length,
//            ),
//          ],
//        ),




//      Container(
//        height: 300,
//        child: ListView.builder(
//
//          reverse: true,
//          scrollDirection: Axis.horizontal,
//          itemCount: images.length,
//          itemBuilder: (BuildContext context, index){
//            return  Container(
//
//              height: 300,
//                width: double.infinity,
//
//                decoration: BoxDecoration(
//                    image: DecorationImage(
//                        fit: BoxFit.cover,
//                        image: AssetImage(images[index])
//                    )
//                )
//
//            );
//          },
//
//        ),
//      ),

//            Container(
//              height:MediaQuery.of(context).size.height * 0.7,
//              decoration: BoxDecoration(
//                image: DecorationImage(
//                  image: AssetImage("images/cardvi.png")
//                )
//              ),
//            ),



        Spacer(),

        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: double.maxFinite,
            height: 50,
            child: RaisedButton(
              disabledColor:  kPrimaryColor,
              onPressed: () {

        Navigator.push(context, FadeRoute(page: CardTitle()));
              },
              child: Text(
                "Select",
                style: GoogleFonts.mavenPro(
                    fontSize: 17,
                    fontWeight: FontWeight.bold

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
        SizedBox(height: 40),

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
      width: 10,
      height: 5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
          shape: BoxShape.rectangle,
          color: Colors.red
      ),
    );
  }

  Widget getCircleSmallOrange() {
    return Container(
      width: 20,
      height: 9,
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          shape: BoxShape.rectangle,
          color: Colors.white
      ),
    );
  }
}


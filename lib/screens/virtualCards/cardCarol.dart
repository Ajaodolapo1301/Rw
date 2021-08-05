
import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/animation/fadeRoute.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/models/VcardType.dart';
import 'package:rex_money/providers/virtualCardState.dart';
import 'package:rex_money/reusables/dialoPopup.dart';
import 'package:rex_money/screens/auth/login.dart';
import 'package:rex_money/utils/commonUtils.dart';
import 'package:rex_money/utils/deviceUtils.dart';

import 'package:rex_money/providers/appState.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';

import 'cardTitle.dart';

class CardCarolScreen extends StatefulWidget {
  @override
  _CardCarolScreenState createState() => _CardCarolScreenState();
}

class _CardCarolScreenState extends State<CardCarolScreen>  with TickerProviderStateMixin, AfterLayoutMixin<CardCarolScreen>{


  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AppState appState;

  DarkThemeProvider darkThemeProvider;
  LoginState loginState;
  VirtualCardState virtualCardState;
  bool isSwitched = false;
  bool  isDarkMode = false;
  bool isLoading = false;
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


var selected = -1;
//  final int _numPages = 4;

  List<VirtualcardTypes> pages= [];

//  List<String> _numPages = [
//    "images/cardvi.png",
//    "images/cardvi.png",
//    "images/cardvi.png"
//  ];
  int _currentPage = 0;
  PageController _pageController =
  PageController(initialPage: 0, viewportFraction: 0.8);

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < pages.length; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      height: 8.0,
      width: isActive ? 15: 8.0,
      decoration: BoxDecoration(
        color: isActive ? kprimaryYellow : Color(0xffDBDBDB),
        borderRadius: BorderRadius.all(Radius.circular(13 / 2)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    themeChangeProvider = Provider.of(context);
    loginState = Provider.of<LoginState>(context);
    virtualCardState = Provider.of<VirtualCardState>(context);
    appState = Provider.of<AppState>(context);
    return Scaffold(
      backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
          centerTitle: true,
          title: Text("New Card", style: GoogleFonts.mavenPro(color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,fontSize: 17,),),
          backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.transparent,
          leading:  IconButton(icon: Icon(Icons.arrow_back, color: kprimaryYellow,),onPressed: ()=>Navigator.pop(context),)
      ),
      body: isLoading ? Center(child: CupertinoActivityIndicator()) : Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: PageView.builder(

              itemCount: pages.length,
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (_, index) {
                return GestureDetector(



                    child: _buildContent(pages[_currentPage].image_url, index, _currentPage, ));
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildPageIndicator(),
                  ),
//                  Row(
//                    children: <Widget>[
//                      Expanded(
//                        child: InkWell(
//                          onTap: () {
//                            _pageController.previousPage(
//                                duration: Duration(milliseconds: 300),
//                                curve: Curves.easeInOut);
//                          },
//                          child: Container(
//                            height: 52,
//                            decoration: BoxDecoration(
//                              color: Color(0xff78849E),
//                              borderRadius: BorderRadius.circular(12),
//                            ),
//                            child: Center(
//                              child: Text(
//                                'BACK',
//                                style: TextStyle(
//                                  fontSize: 16,
//                                  color: Colors.white,
//                                ),
//                              ),
//                            ),
//                          ),
//                        ),
//                      ),
//                      SizedBox(height: 25,),
//
////                      Spacer(),
//
//
//                      SizedBox(height: 40),
//
//
//
////                      Expanded(
////                        child: InkWell(
////                          onTap: () {
//////                            if ((_pageController.page).toInt() == _numPages-1){
//////                              Navigator.pushNamed(context, RoutesName.welcomeRoute);
//////                            } else {
//////                              _pageController.nextPage(
//////                                  duration: Duration(milliseconds: 300),
//////                                  curve: Curves.easeInOut);
//////                            }
////                          },
////                          child: Container(
////                            height: 52,
////                            decoration: BoxDecoration(
////                              color: kprimaryYellow,
////                              borderRadius: BorderRadius.circular(12),
////                            ),
////                            child: Center(
////                              child: Text(
////                                'NEXT',
////                                style: TextStyle(
////                                  fontSize: 16,
////                                  color: Colors.white,
////                                ),
////                              ),
////                            ),
////                          ),
////                        ),
////                      )
//                    ],
//                  ),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.maxFinite,
                      height: 50,
                      child: RaisedButton(
                        disabledColor:  kPrimaryColor,
                        onPressed: ()  {

                     selected != -1 ?      Navigator.push(context, FadeRoute(page: CardTitle(
                       card_type: pages[selected].type_id,
                     ))) : toast("Tap card to select a card type");

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

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(img, index, currentPage) {
    return GestureDetector(

      onTap: (){
      setState(() {
        selected = index;



        print(pages[selected].type_id);
      });
      setState(() {
        appState.cardType = pages[selected].type_id;
      });
      },
      child: Stack(
        children: [

          Container(
            height: MediaQuery.of(context).size.height * 0.9,

              width: double.infinity,
              decoration: BoxDecoration(
//                  image: DecorationImage(
//                      fit: BoxFit.cover,
//                      image: NetworkImage(img)
//                  )


              ),
            child: Image.network(img, fit: BoxFit.cover,     loadingBuilder: (context, child, p){
              if(p == null) return child;


              return CupertinoActivityIndicator(
//                value: p.expectedTotalBytes != null ?
//                p.cumulativeBytesLoaded / p.expectedTotalBytes
//                    : null,
//                valueColor: AnimationController(vsync: this).drive(Tween(begin: Colors.black, end: Colors.black)),
              );
            },),

          ),



          Positioned(
            top: 50,
            right: 50,
            child: AnimatedOpacity(opacity:  selected == index ? 1:0,
                duration: Duration(milliseconds: 300),
                child: Material(
                  elevation: 3,
                  shape: CircleBorder(),
                  child: Container(
                    height: 13,
                    width: 13,
                    child: Icon(Icons.check, size: 10, color: Colors.white,),
                    decoration: BoxDecoration(
                        color: kPrimaryColor,
                        shape: BoxShape.circle
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    getTypes();
  }


  getTypes()async{
    setState(() {
      isLoading = true;
    });
    var result = await virtualCardState.listofCardTypes(token: loginState.user.token);

    setState(() {
      isLoading = false;
    });
    if (result["error"] && result["message"] == "You are not authorized to make this request") {

      showDialog(
          barrierDismissible: false,
          context: context,
          child: dialogPopup(
              themeDark: themeChangeProvider.darkTheme,
              body: Text(
              "Session ended, Please Login again",
                textAlign: TextAlign.center,
                style: TextStyle(
                    inherit: false,
                    fontSize: 18,
                    color: themeChangeProvider.darkTheme
                        ? Colors.white
                        : Colors.black),
              ),
              buttonText: "Ok",
              onPressed: () {
                final box = Hive.box("user");
                box.put('user', null);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                        (Route<dynamic> route) => false);
              }));
    } else  if(result["error"] == false){
      setState(() {
        pages = result["virtualcardTypes"];
      });

    }else{
      CommonUtils.showMsg(result["message"], themeChangeProvider, context,
          _scaffoldKey, kPrimaryColor);
    }
  }



}



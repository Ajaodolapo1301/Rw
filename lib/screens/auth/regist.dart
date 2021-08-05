
import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/models/continentModel.dart';
import 'package:rex_money/models/flags.dart';
import 'package:rex_money/providers/appState.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/reusables/customTextField.dart';
import 'package:rex_money/reusables/dialoPopup.dart';
import 'package:rex_money/reusables/dropDown.dart';
import 'package:rex_money/reusables/dropDown2.dart';
import 'package:rex_money/reusables/dropDownContinent.dart';
import 'package:rex_money/reusables/preloader.dart';
import 'package:rex_money/screens/auth/register2.dart';
import 'package:rex_money/utils/commonUtils.dart';
import 'package:rex_money/utils/myUtils.dart';

import 'otp.dart';




class Regist extends StatefulWidget {
  @override
  _RegistState createState() => _RegistState();
}

class _RegistState extends State<Regist>  with AfterLayoutMixin<Regist>{
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  LoginState loginState;
  Color accountDropDownValueColor = kprimaryLight;
 ScrollController controller;
  bool isScrollingDisabled = false;
  bool isCountryDropDownVisible = false;
  bool isButtonDisaled = false;
  bool isContinentDropDownVisible = false;
  bool isStateDropDownVisible = false;
bool isLoading = false;
bool loading = false;
bool  isContintentLoading = false;
bool error = false;
bool isButtonDisabled = false;
bool countryloading = false;
  bool isNigeria = false;
  List<ContinentModel> continents = [];
bool isLoadingBvn = false;
bool enableTextfield = true;
  var continent;
  void _showMsg(body) {
    final snackBar = SnackBar(
      content: Text(body),
      action: SnackBarAction(
        label: "Close",
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
    var continentHint = "Select your Continent";
var countryHint = "Select your Country";
  var stateHint = "Select your State";
var countryId;
  List<States> myStates = [];
  List<Flag> countries = [];


var pic = "";
AppState appState;
  var phoneCode;
  TextEditingController _phoneNumber = TextEditingController();

  TextEditingController _bvnNumber = TextEditingController();



  List<String> continentList = [
    "Africa",
    "North America",
        "South America",
       "Asia",
    "Australia",
    "Antarctica",
    "Europe",
  ];

  void initState() {
    getCurrentAppTheme();
    controller = ScrollController();
    super.initState();
  }


  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
    await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);
    loginState = Provider.of<LoginState>(context);
    themeChangeProvider = Provider.of<DarkThemeProvider>(context);
    return Scaffold(

      key: _scaffoldKey,
      appBar: AppBar(

        backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(18.0),
          child: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: SvgPicture.asset("images/leftIcon.svg")),
        ),
      ),

      body:   GestureDetector(
        onTap: resetDropDownVisibilities,
        child: SafeArea(
          bottom: false,
          child: Container(
            color: themeChangeProvider.darkTheme ?  kPrimaryDark : Colors.transparent,

            child: Stack(
              children: [
                Form(
                  key: _formKey,
                    child: ListView(

                      physics: isScrollingDisabled
                          ? NeverScrollableScrollPhysics()
                          : BouncingScrollPhysics(),
                      controller: controller,
                      children: [
                        SizedBox(height: 30),

                        Column(
                          children: [
                            Text(
                              "We love to meet you!",
                              style: GoogleFonts.mavenPro(color: themeChangeProvider.darkTheme ? Colors.white: kPrimaryColor, fontSize: 17),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Fill the form and sign up in Minutes",
                              style: GoogleFonts.raleway(color: themeChangeProvider.darkTheme ? Colors.white: kPrimaryColor, fontSize: 11),
                            ),

                          ],
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "1/4",
                                style: GoogleFonts.raleway(color: themeChangeProvider.darkTheme ? Colors.white: kPrimaryColor, fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),




                        CustomTextField(

                          header: "Continent",
                          hint: continentHint,
                          type: FieldType.dropdown,
                          dropDownValueColor: themeChangeProvider.darkTheme ? kPrimaryDarkTextField :  accountDropDownValueColor,
                          onTap: () {
                            print("continents $continents");
//                            isNigeria = false;
                            scrollToTop();
                            setState(() {
                              continentHint = "Select your Continent";
                              isContinentDropDownVisible = !isContinentDropDownVisible;
                              isCountryDropDownVisible = false;
                              isButtonDisaled = false;
                              isStateDropDownVisible = false;
                              isScrollingDisabled = true;
                              FocusScope.of(context).unfocus();
                            });
                          },
                        ),



                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(

                                prefix: SvgPicture.network(pic),
//                          color: kPrimaryColor.withOpacity(0.1),
                                header:
                                "Country",
                                hint: countryHint,
                                type: FieldType.dropdown,
                                dropDownValueColor: themeChangeProvider.darkTheme ? kPrimaryDarkTextField :  accountDropDownValueColor,
                                onTap: () {
                                  isNigeria = false;
                                  scrollToTop();
                                  setState(() {
                                    isCountryDropDownVisible = !isCountryDropDownVisible;
                                    isStateDropDownVisible = false;
                                    isScrollingDisabled = true;
                                    FocusScope.of(context).unfocus();
                                  });
                                },
                              ),
                            ),
                            if(countryloading)Row(
                              children: [
                                CupertinoActivityIndicator(),
                                SizedBox(width: 20),
                              ],
                            ),
                          ],
                        ),


                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
//                                color: kPrimaryColor.withOpacity(0.1),
                                header:
                                "State",
                                hint: stateHint,
                                type: FieldType.dropdown,
                                dropDownValueColor: accountDropDownValueColor,
                                onTap: () {
                                  scrollToTop();
                                  setState(() {
                                    isStateDropDownVisible = !isStateDropDownVisible;
                                    isCountryDropDownVisible = false;
                                    isScrollingDisabled = true;
                                    FocusScope.of(context).unfocus();
                                  });
                                },
                              ),
                            ),

                            if(loading)Row(
                              children: [
                                CupertinoActivityIndicator(),
                                SizedBox(width: 20),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 10),

                        Container(
//            width: 340,
                          child: CustomTextField(
//                            color: kPrimaryColor.withOpacity(0.1),
                            header: "Phone Number",
                            hint:  " 7067987364",
                            prefixText: "(+${phoneCode == null ? 234: phoneCode }) ",
                            type: FieldType.phone,

                            controller: _phoneNumber,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Phone Number  is required";
                              }

                              if (value.length < 8) {
                                return "Invalid Phone Number";
                              }

                              return null;
                            },


                          ),
                        ),



                        isNigeria ?   CustomTextField(
                          suffix: isLoadingBvn ? CupertinoActivityIndicator() : error ? CommonUtils.checkCancel() : error == false  &&  !isLoadingBvn && !isButtonDisaled  ? CommonUtils.checkMArk() : null,
                          color: kPrimaryColor.withOpacity(0.1),
                          header: "Bank Verification Number (BVN)",
                          hint:  "01232 3333 1234 ",


//                            enableInteractiveSelection: enableTextfield,
                          type: FieldType.phone,

                          controller: _bvnNumber,

                          onChanged: (value){
                            if (value.length < 10) {

                            } else if (value.length == 11) {

                                setState(() {
                                  verifyBvn();
                              });
                            }

                          },
                          validator:   isNigeria ?  (value) {
                            if (value.isEmpty) {
                              return "Bvn  is required";
                            }

                            if (value.length < 11) {
                              return "Invalid BVn";
                            }

                            return  null;
                          } : null,


                        ) : Container(),
                        SizedBox(height: isNigeria ? MediaQuery.of(context).size.height * 0.10 :MediaQuery.of(context).size.height * 0.03),


            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, ),
              child: SizedBox(
            width: double.maxFinite,
            height: 50,
            child: RaisedButton(
              disabledColor: isButtonDisaled ? kprimaryLight : kPrimaryColor,
              onPressed:isButtonDisaled ? null :  () {
                if (_formKey.currentState.validate()) {

                  _handleRegister1(context);
                }
              },
              child: Text(
                "PROCEED",
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


SizedBox(height: 10,)



                      ],
                    )
                ),


                Visibility(
                  visible: isContinentDropDownVisible,
                  child: DropDownContinent(
                    items: loginState.continent,
                    position: 30,
                    onSelect: (value, id) {
                      print(value);
                      setState(() {
                    continentHint = value;
                    getcountries(id: id);
                    accountDropDownValueColor = themeChangeProvider.darkTheme ? kPrimaryDarkTextField :  Colors.white;
                      });
                      resetDropDownVisibilities();
                    },
                  ),
                ),

                Visibility(
                  visible: isCountryDropDownVisible,
                  child: DropDown(
                    items: countries,
                    position: 95,
                    onSelect: (value,  id, flagPic, code) {
                      if(value == "Nigeria"){

                        setState(() {
                          isNigeria = true;
                          isButtonDisaled = true;
                        });
                      }
                      setState(() {
                        phoneCode = code;
                        pic =  flagPic;
                        countryId = id;
                        countryHint = value;

                      });
                      getState();
                      resetDropDownVisibilities();
                    },
                  ),
                ),
                Visibility(
                  visible: isStateDropDownVisible,
                  child: DropDown2(
                    items: myStates,
                    position: 205,
                    onSelect: (value) {
                      print("value $value");
                      setState(() {
                        stateHint = value;
                        accountDropDownValueColor = themeChangeProvider.darkTheme ? kPrimaryDarkTextField :  Colors.white;
                      });
                      resetDropDownVisibilities();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  getcontinent() async {
    print("continent");
    setState(() {
      isContintentLoading = true;
    });

    var result = await loginState.getContinent();
    setState(() {
      isContintentLoading = false;
    });

    if (result["error"] == false) {
      setState(() {
        continents = result["continent"];
      });
    }
  }




  getcountries({id}) async {
    print("countries");
   countryloading = true;
    var result = await loginState.getCountries(id: id);
    setState(() {
      countryloading = false;
    });
    print(result);
    if (result["error"] == false) {
      setState(() {
        countries = result["flags"];
        countryloading = false;
      });
    }
  }



  getState() async{
    loading = true;
    var result   = await loginState.getStates(id: countryId);
    if(result["error"] == false){
      setState(() {
        myStates = result["states"];
        loading = false;
      });
    }



  }








  void verifyBvn()async{

    setState(() {
      isLoadingBvn = true;
    });
    print("called");
    var result  = await loginState.verifyBvn(phone: "$phoneCode${_phoneNumber.text}", bvn: _bvnNumber.text);
   setState(() {
     isLoadingBvn = false;
   });
    if(result["error"] == false){
      setState(() {
        isButtonDisaled = false;
        error = false;
      });
    }else{
      setState(() {
        isButtonDisaled = true;
        error = true;
        toast("BVN Verification Failed, Please Check and Enter a Correct BVN" );
      });
    }
  }


  _handleRegister1(context) async {
    setState(() {
      isLoading = true;
    });

    if (isLoading) {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return Preloader();
          });
    }

    var result = await loginState.registerUserStep1(phone: "$phoneCode${_phoneNumber.text}" , country: countryHint, state: stateHint, bvn: _bvnNumber.text, continent: continentHint);
    if (isLoading) {
      Navigator.pop(context, true);
    }

//    print(result["message"]["data"]["masked_phone"]);
    if (result['error'] == true) {
      _showMsg(result['message']);
    } else{

      Navigator.push(context, MaterialPageRoute(builder: (context)=> Otp(
        maskedPhone: result["message"]["data"]["masked_phone"] ,
        phone: "$phoneCode${_phoneNumber.text}",
      )));
//      showDialog(context: context, child: dialogPopup(
//          themeDark: themeChangeProvider.darkTheme,
//          body:
//      Text(
//        "Successful!! ${ result['message']["message"]}",
//        textAlign:
//        TextAlign.center,
//        style: TextStyle(
//            inherit:
//            false,
//            fontSize:
//            18,
//            color:themeChangeProvider.darkTheme ? Colors.white:
//            Colors.black),
//      ),
//          buttonText:
//          "Ok",
//          onPressed:
//              () =>
//
//      ));

    }

    setState(() {
      appState.phone = "$phoneCode${_phoneNumber.text}";
      appState.state = stateHint;
      isLoading = false;
    });
  }







  void scrollToTop() {
    controller.animateTo(0,
        duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  void resetDropDownVisibilities() {
    setState(() {
      isScrollingDisabled = false;
      isContinentDropDownVisible = false;
      isCountryDropDownVisible = false;
      isStateDropDownVisible = false;
    });
  }

  @override
  void afterFirstLayout(BuildContext context) {
getcontinent();
  }
}

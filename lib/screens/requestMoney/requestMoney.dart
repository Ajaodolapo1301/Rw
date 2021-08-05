
import 'package:after_layout/after_layout.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/animation/fadeRoute.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/models/flags.dart';
import 'package:rex_money/providers/appState.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/providers/transferState.dart';
import 'package:rex_money/reusables/customTextField.dart';
import 'package:rex_money/reusables/form.dart';
import 'package:rex_money/screens/requestMoney/requestMoneyTag.dart';
import 'package:rex_money/utils/commonUtils.dart';
import 'package:rex_money/utils/myUtils.dart';



class ReceiveMoney extends StatefulWidget {
  @override
  _ReceiveMoneyState createState() => _ReceiveMoneyState();
}

class _ReceiveMoneyState extends State<ReceiveMoney>  with AfterLayoutMixin<ReceiveMoney>{
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _formKey = new GlobalKey<FormState>();
  TextEditingController narration = TextEditingController();
  AppState  appState;
  String _errortext;
  Flag _dropDownValue1;
  LoginState loginState;
  TransferState transferState;
  final int time = 30;
  AnimationController _controller;
  var amount;
//  final _scaffoldKey = GlobalKey<ScaffoldState>();


  bool isLoading = false;

  // Variables
  Size _screenSize;
  int _currentDigit;
  int _firstDigit;
  int _secondDigit;
  int _thirdDigit;
  int _fourthDigit;
  int _fifthDigit;
  int _sixth;
  int _seventh;
//  Timer timer;
  int totalTimeInSeconds;
  bool _hideResendButton;
  var otp;

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

  String userName = "";
  bool didReadNotifications = false;
  int unReadNotificationsCount = 0;

  var currency;
  var symbol;
  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
    await themeChangeProvider.darkThemePreference.getTheme();
  }

  getPermissions() async {
    if (await Permission.contacts.request().isGranted) {
      getAllContacts();
//      searchController.addListener(() {
//        filterContacts();
//      });
    }
  }

  getAllContacts() async {
    List colors = [Colors.green, Colors.indigo, Colors.yellow, Colors.orange];
    int colorIndex = 0;
    List<Contact> _contacts =
    (await ContactsService.getContacts(withThumbnails: false)).toList();
    _contacts.forEach((contact) {
//      Color baseColor = colors[colorIndex];
//      contactsColorMap[contact.displayName] = baseColor;
//      colorIndex++;
      if (colorIndex == colors.length) {
        colorIndex = 0;
      }
    });

//    setState(() {
//      _contacts.forEach((element) {
////        contacts.add(element.phones)
//      });
//    });

    setState(() {
      _contacts.forEach((element) {
        element.phones.forEach((element) {
          appState.numbersToSend.add(element.value.toString());
        });
      });
    });
//    print(appState.numbersToSend);
  }

  // Returns "Otp keyboard input Button"
  Widget _otpKeyboardInputButton({String label, VoidCallback onPressed}) {
    return new Material(
      color: Colors.transparent,
      child: new InkWell(
        onTap: onPressed,
        borderRadius: new BorderRadius.circular(40.0),
        child: new Container(
          height: 80.0,
          width: 80.0,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
          ),
          child:  Center(
            child:  Text(
              label,
              style:  GoogleFonts.mavenPro(
                fontSize: 30.0,
                color: themeChangeProvider.darkTheme ? Colors.white: kPrimaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Returns "Otp keyboard action Button"
  _otpKeyboardActionButton({Widget label, VoidCallback onPressed}) {
    return new InkWell(
      onTap: onPressed,
      borderRadius: new BorderRadius.circular(40.0),
      child: new Container(
        height: 80.0,
        width: 80.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: new Center(
          child: label,
        ),
      ),
    );
  }

  // Current digit
  void _setCurrentDigit(int i) {
    setState(() {
      _currentDigit = i;
      if (_firstDigit == null) {
        _firstDigit = _currentDigit;
      } else if (_secondDigit == null) {
        _secondDigit = _currentDigit;
      } else if (_thirdDigit == null) {
        _thirdDigit = _currentDigit;
      } else if (_fourthDigit == null) {
        _fourthDigit = _currentDigit;

//        var otp = _firstDigit.toString() +
//            _secondDigit.toString() +
//            _thirdDigit.toString() +
//            _fourthDigit.toString();

        // Verify your otp by here. API call
      }else if(_fifthDigit == null){
        _fifthDigit = _currentDigit;
      }else if(_sixth == null){
        _sixth = _currentDigit;

//     setState(() {
//       otp = _firstDigit.toString() +
//           _secondDigit.toString() +
//           _thirdDigit.toString() +
//           _fourthDigit.toString() +
//           _fifthDigit.toString() +
//           _sixth.toString();
//     });

      }else{
        CommonUtils. showFlushBar(message: "You cant go pass 100,000", context: context, title: "Oh,No", backgroundColor: themeChangeProvider.darkTheme ? kprimaryYellow: kPrimaryColor );
      }


    });
  }



  // Returns "Otp custom text field"
  Widget _otpTextField(int digit1, int digit2, int digit3,int digit4 ,int digit5,int digit6, ) {
     amount =   "${digit1 != null ? digit1 : "0"}""${digit2 != null ? digit2 : ""}""${digit3 != null ? digit3 : ""}""${digit4 != null ? digit4 : ""}""${digit5 != null ? digit5 : ""}""${digit6 != null ? digit6 : ""}";
//    print("ff$amount");
    return  Container(
//      width: 35.0,

//      height: 45.0,
//      alignment: Alignment.center,
      child:  Text(MyUtils.getFormattedAmount(int.parse(amount)),
             style:  GoogleFonts.mavenPro(
          fontSize: 30.0,
          color: themeChangeProvider.darkTheme ? Colors.white :  kPrimaryColor.withOpacity(0.5),
        ),
      ),
      decoration: BoxDecoration(
      ),
    );
  }

  Widget _otpSymbol(String digit) {
    return new Container(
      width: 35.0,

      height: 45.0,
      alignment: Alignment.center,
      child: new Text(
        digit != null ? digit.toString() : " ",
        style: new TextStyle(
          fontSize: 30.0,
          color:  kPrimaryColor.withOpacity(0.5),
        ),
      ),
      decoration: BoxDecoration(

//        color: kPrimaryColor.withOpacity(0.3),
//            color: Colors.grey.withOpacity(0.4),
//          border: Border(
//              bottom: BorderSide(
//                width: 2.0,
//                color: kPrimaryColor,
//              ))
      ),
    );
  }


  // Return "OTP" input field
  get _getInputField {
    return new Row(
//      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[

//        _otpSymbol(loginState.user.symbol == null ? " " : loginState.user.symbol),
        _otpTextField(_firstDigit, _secondDigit, _thirdDigit, _fourthDigit, _fifthDigit, _sixth),
//          _otpTextField(_secondDigit),
//          _otpTextField(_thirdDigit),
//          _otpTextField(_fourthDigit),
//          _otpTextField(_fifthDigit),
//          _otpTextField(_sixth),
      ],
    );
  }




  // Returns "Otp" keyboard
  get _getOtpKeyboard {
    return new Container(
        height: _screenSize.width - 60,
        child: new Column(
          children: <Widget>[
            new Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _otpKeyboardInputButton(
                        label: "1",
                        onPressed: () {
                          _setCurrentDigit(1);
                        }),
                    _otpKeyboardInputButton(
                        label: "2",
                        onPressed: () {
                          _setCurrentDigit(2);
                        }),
                    _otpKeyboardInputButton(
                        label: "3",
                        onPressed: () {
                          _setCurrentDigit(3);
                        }),
                  ],
                ),
              ),
            ),
            new Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _otpKeyboardInputButton(
                        label: "4",
                        onPressed: () {
                          _setCurrentDigit(4);
                        }),
                    _otpKeyboardInputButton(
                        label: "5",
                        onPressed: () {
                          _setCurrentDigit(5);
                        }),
                    _otpKeyboardInputButton(
                        label: "6",
                        onPressed: () {
                          _setCurrentDigit(6);
                        }),
                  ],
                ),
              ),
            ),
            new Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _otpKeyboardInputButton(
                        label: "7",
                        onPressed: () {
                          _setCurrentDigit(7);
                        }),
                    _otpKeyboardInputButton(
                        label: "8",
                        onPressed: () {
                          _setCurrentDigit(8);
                        }),
                    _otpKeyboardInputButton(
                        label: "9",
                        onPressed: () {
                          _setCurrentDigit(9);
                        }),
                  ],
                ),
              ),
            ),
            new Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new SizedBox(
                      width: 80.0,
                    ),
                    _otpKeyboardInputButton(
                        label: "0",
                        onPressed: () {
                          _setCurrentDigit(0);
                        }),
                    _otpKeyboardActionButton(
                        label: SvgPicture.asset("images/bck.svg"),
                        onPressed: () {
                          setState(() {

                            if (_sixth != null) {
                              _sixth = null;
                            }
                            else if (_fifthDigit != null) {
                              _fifthDigit = null;
                            }
                            else if (_fourthDigit != null) {
                              _fourthDigit = null;
                            } else if (_thirdDigit != null) {
                              _thirdDigit = null;
                            } else if (_secondDigit != null) {
                              _secondDigit = null;
                            } else if (_firstDigit != null) {
                              _firstDigit = null;
                            }
                          });
                        }),
                  ],
                ),
              ),
            ),
          ],
        ));
  }



  get _getInputPart {
    return SingleChildScrollView(
      child: new Column(
//      mainAxisSize: MainAxisSize.max,
//      mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[


          SizedBox(height: MediaQuery.of(context).size.height * 0.05,),


          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(5),
              decoration: BoxDecoration(

                color: kprimaryLight.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4)
              ),
//                height: 40,
//                 width: 40,
                  child: Text(loginState.user.symbol, textAlign: TextAlign.center, style: GoogleFonts.mavenPro(fontSize: 25, color: themeChangeProvider.darkTheme ? kprimaryYellow :  kPrimaryColor,  ),)),
              SizedBox(width: 5,),
//                        Text(otp?? "0"),
             _otpTextField(_firstDigit, _secondDigit, _thirdDigit, _fourthDigit, _fifthDigit, _sixth),
//              _getInputField
//              Text(MyUtils.getFormattedAmount(100000),style: GoogleFonts.mavenPro(fontSize: 38, color: themeChangeProvider.darkTheme ? kprimaryYellow : kPrimaryColor ),),


            ],
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
          _getOtpKeyboard,


        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    loginState = Provider.of<LoginState>(context);
    appState = Provider.of<AppState>(context);
    transferState = Provider.of<TransferState>(context);
    themeChangeProvider = Provider.of<DarkThemeProvider>(context);
    _screenSize = MediaQuery.of(context).size;
    return Scaffold(

      backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor:    themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
        leading:  IconButton(icon: Icon(Icons.arrow_back, color: kprimaryYellow,),onPressed: ()=>Navigator.pop(context),),
        title: Text("Request Money", style: GoogleFonts.mavenPro(color: themeChangeProvider.darkTheme? Colors.white : kPrimaryColor,fontSize: 20),),
      ),

        body: Container(
          height: MediaQuery.of(context).size.height,

//          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(

              children: [


//Spacer()
//                Container(
//                          margin: EdgeInsets.only(right: 20, left: 20),
//                  child: Column(              crossAxisAlignment: CrossAxisAlignment.start,
//                    children: [
//                      Text(
//                        "Select Currency",
//                        style: GoogleFonts.mavenPro(
////                  fontWeight: FontWeight.bold,
//                          fontSize: 14,
//                          color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
//                        ),
//                      ),
//                      SizedBox(height: 6 ),
//                      Container(
////                    height: 50,
//                        child: FormField(builder: (
//                            FormFieldStatestate) {
//                          return DropdownButtonHideUnderline(
//
//                              child: Column(
//                                crossAxisAlignment: CrossAxisAlignment
//                                    .stretch,
//                                children: <Widget>[
//                                  InputDecorator(
//
//                                    decoration: InputDecoration(
////                                border: FormBorder(
////                                  borderRadius: BorderRadius.circular(2),
////                                ),
//                                      hintText: "Select Your Country",
//                                      hintStyle: GoogleFonts
//                                          .raleway(
//                                          fontSize: 14,
//                                          color:themeChangeProvider.darkTheme
//                                              ? Colors
//                                              .white
//                                              : Color(0xff9479A4)),
//
//
//                                fillColor: themeChangeProvider.darkTheme
//                                    ? kPrimaryDarkTextField: kPrimaryColor.withOpacity(0.1),
//
//
//                                      filled: true,
//
//                                      labelStyle:
//                                      TextStyle(
//                                        color: themeChangeProvider.darkTheme
//                                            ? Colors
//                                            .white
//                                            : Colors
//                                            .black, //This is an example of a change
//                                      ),
////                                                                  labelText: _dropDownValue == null ? "Select Monthly transaction volume " : " Select Monthly transaction volume",
//                                      errorText:
//                                      _errortext,
//                                    ),
//                                    isEmpty:
//                                    _dropDownValue1 == null,
//                                    child: Container(
//
//
//                                      child: DropdownButton<Flag>(
//
//                                        onTap: (){
//                                          setState(() {
////                                  tapped = true;
////                                  isNigeria = false;
//                                          });
////                                print(tapped);
//                                        },
//
//                                        dropdownColor: themeChangeProvider.darkTheme
//                                            ? kPrimaryDarkTextField
//                                            : Colors
//                                            .white,
//
//
//                                        style: TextStyle(color: themeChangeProvider.darkTheme ? Colors.white : Colors.black) ,
//
//                                        icon: Row(
//                                          children: [
//                                            Text( currency == null  ? " " : currency,  style: GoogleFonts.raleway(
////                  fontWeight: FontWeight.bold,
//                                              fontSize: 12,
//                                              color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
//                                            ),),
//                                            Icon(Icons.keyboard_arrow_down_sharp, color: Color(0xff9479A4),),
//                                          ],
//                                        ),
//                                        value: _dropDownValue1,
//
//                                        isDense: true,
//                                        onChanged: (
//                                            Flag newValue) {
////                                if(newValue.country == "Nigeria"){
////
//////                                  setState(() {
//////                                    isNigeria = true;
//////                                  });
////                                }
//
//
//                                          setState(() {
//
////                                  tapped = false;
////                                  id = newValue.id;
////                                  phoneCode = newValue.phoneCode;
//
//
//                                            _dropDownValue1 = newValue;
//                                            symbol = _dropDownValue1.symbol;
//                                            currency = _dropDownValue1.currency;
//                                          });
//                                          print(currency);
//                                        },
//
//
//
//                                        items: loginState.flags.map((Flag value) {
//
//                                          return DropdownMenuItem<
//                                              Flag>(
//                                            value: value,
//                                            child: Row(
//                                              children: [
//                                                Container(
//                                                  height: 16,
//                                                  width: 25,
//
//                                                  child: SvgPicture.network(value.flag),
//                                                ),
//                                                SizedBox(width: 10,),
//                                                Text( value.country ,
//                                                    style: GoogleFonts
//                                                        .raleway(
//                                                        fontSize: 14,
//                                                        color:themeChangeProvider.darkTheme
//                                                            ? Colors
//                                                            .white
//                                                            : Color(0xff9479A4))),
//                                              ],
//                                            ),
//                                          );
//                                        }).toList(),
//                                      ),
//                                    ),
//                                  ),
//                                ],
//                              ));
//                        },
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
//SizedBox(height: 20,),
                Form(
                  key: _formKey,
                  child: CustomTextField(
                    color: kPrimaryColor.withOpacity(0.1),
                    header: "Narration",
                    hint: "What's the money for?",
                    type: FieldType.text,
                    onChanged: (value) {
//                      print(value);

                    },
                    controller: narration,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Narration is required";
                      }

                      if (value.length < 5) {
                        return "Narration is should be more 5 characters";
                      }

                      return null;
                    },
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                _getInputPart,



//
//                SizedBox(height: 10,),

                SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.maxFinite,
                    height: 50,
                    child: RaisedButton(
                      onPressed: () {
                      if (_firstDigit == null) {
                        CommonUtils. showFlushBar(message: "Amount is required", context: context, title: "Oh,No", backgroundColor: themeChangeProvider.darkTheme ? kprimaryYellow: kPrimaryColor );
                      }else if(_formKey.currentState.validate()){
                        Navigator.push(context, FadeRoute(page: RequestMoneyTag(
                          amount: amount,
                          narration: narration.text,
                        )));
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

                SizedBox(height: 20,)
              ],
            ),
          ),
        ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
getContactList();
  }

  void getContactList() async {
    var result = await transferState.fetchContactList(
        token: loginState.user.token, contacts: appState.numbersToSend);
//    print("result$result");
  }



}

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/animation/fadeRoute.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/models/continentModel.dart';
import 'package:rex_money/models/flags.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/reusables/customTextField.dart';
import 'package:rex_money/reusables/form.dart';
import 'package:rex_money/reusables/preloader.dart';
import 'package:rex_money/screens/auth/otp.dart';
import 'package:rex_money/screens/auth/register2.dart';
import 'package:rex_money/utils/commonUtils.dart';
import 'package:rex_money/utils/myUtils.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> with AfterLayoutMixin<Register> {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();  LoginState loginState;
  String _errortext;
//  bool isButtonDisabled = false;

  bool isButtonDisaled = false;
  Flag _dropDownValueforCountry;
  bool  isContintentLoading = false;
  States _dropDownValueforState ;
  ContinentModel _dropDownValueforContinent;
  bool isLoading = false;
  bool isLoadingBvn = false;
  bool isNigeria = false;

  bool error = false;
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


  List<States> myStates = [];
  var id;
  var phoneCode;
//  List<States> myStates = [];
  List<Flag> countries = [];

  bool countryloading = false;
  TextEditingController _phoneNumber = TextEditingController();

  TextEditingController _bvnNumber = TextEditingController();
  List<ContinentModel> continents = [];

var country;
var state;
   bool loading = false;
  bool tapped = false;
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
    loginState = Provider.of<LoginState>(context);
    themeChangeProvider =Provider.of(context);
    print(tapped);



    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(

        backgroundColor: themeChangeProvider.darkTheme ? Colors.black : Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: kprimaryYellow,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body:  Container(
//        margin: EdgeInsets.all(20),
        color: themeChangeProvider.darkTheme ? Colors.black : Colors.transparent,
          width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30),

              Column(
                children: [
                  Text(
                    "We love to meet you!",
                    style: GoogleFonts.mavenPro(color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor, fontSize: 17),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Fill the form and sign up in Minutes",
                    style: GoogleFonts.raleway(color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor, fontSize: 11),
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
                      style: GoogleFonts.raleway(color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),

              Form(key: _formKey,
                child: Column(
                  children: [
// continent
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical:12 ),
//              width: 340,
                      decoration: BoxDecoration(
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Continent",
                            style: GoogleFonts.mavenPro(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
                            ),
                          ),
                          SizedBox(height: 6 ),
                          Container(

                            child: FormField(builder: (
                                FormFieldStatestate) {
                              return DropdownButtonHideUnderline(

                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .stretch,
                                    children: <Widget>[
                                      InputDecorator(

                                        decoration: InputDecoration(

                                          contentPadding:EdgeInsets.fromLTRB(10,0,10,0),
                                          border:  FormBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(5.0)),

                                          ),
                                          hintText: "Select Your Continent",
                                          hintStyle: GoogleFonts
                                              .raleway(
                                            fontSize: 14,
                                            color:themeChangeProvider.darkTheme
                                                ? Colors
                                                .white
                                                : kPrimaryColor,),



                                          fillColor: themeChangeProvider
                                              .darkTheme
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
                                        _dropDownValueforContinent == null,
                                        child: Container(


                                          child: DropdownButton<ContinentModel>(

                                            onTap: (){
                                              setState(() {

                                              });
                                            },

                                            dropdownColor: themeChangeProvider.darkTheme
                                                ? kPrimaryDark
                                                : Colors
                                                .white,
                                            style: TextStyle(color: themeChangeProvider.darkTheme ? Colors.white : Colors.black) ,
                                            icon: Container(
                                                  height:20,
                                                child: Icon(Icons.keyboard_arrow_down_sharp,size: 19, color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,)),
                                            value: _dropDownValueforContinent,

                                            isDense: true,
                                            onChanged: (ContinentModel newValue) {



                                              setState(() {
                                                _dropDownValueforCountry = null;
                                                _dropDownValueforState = null;
                                                getcountries(id: newValue.continent_id);
                                                _dropDownValueforContinent = newValue;


                                              });
                                            },



                                            items: loginState.continent.map((ContinentModel value) {

                                              return DropdownMenuItem<ContinentModel>(
                                                value: value,
                                                child: Row(
                                                  children: [
                                                    Text( value.continent_name ,
                                                        style: GoogleFonts
                                                            .raleway(
                                                            fontSize: 14,
                                                            color:themeChangeProvider.darkTheme
                                                                ? Colors
                                                                .white
                                                                : Color(0xff9479A4))),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ));
                            },
                            ),
                          ),
                        ],
                      ),
                    ),

//                  SizedBox(height: 10,),


//Country
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical:12 ),
//              width: 340,
                      decoration: BoxDecoration(

                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Country",
                            style: GoogleFonts.mavenPro(
                    fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
                            ),
                          ),
                          SizedBox(height: 6 ),
                          Container(

                            child: Stack(
                              children: [
                                FormField(builder: (
                                    FormFieldStatestate) {
                                  return DropdownButtonHideUnderline(

                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .stretch,
                                        children: <Widget>[
                                          InputDecorator(

                                            decoration: InputDecoration(

                                              contentPadding:EdgeInsets.fromLTRB(10,0,10,0),
                                              border:  FormBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(5.0)),

                                              ),
                                              hintText: "Select Your Country",
                                              hintStyle: GoogleFonts
                                                  .raleway(
                                                  fontSize: 14,
                                                  color:themeChangeProvider.darkTheme
                                                      ? Colors
                                                      .white
                                                      : kPrimaryColor,),



                                              fillColor: themeChangeProvider
                                                  .darkTheme
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
                                            _dropDownValueforCountry == null,
                                            child: Container(


                                              child: DropdownButton<Flag>(

                                                onTap: (){
                                                  setState(() {
                                                    _dropDownValueforState = null;
                                                    tapped = true;
                                                    isNigeria = false;

                                                  });print(tapped);
                                                },

                                                dropdownColor: themeChangeProvider.darkTheme
                                                    ? kPrimaryDark
                                                    : Colors
                                                    .white,
                                                style: TextStyle(color: themeChangeProvider.darkTheme ? Colors.white : Colors.black) ,
                                                icon: countryloading ? Container():  Icon(Icons.keyboard_arrow_down_sharp,  color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor, size: 19,),
                                                value: _dropDownValueforCountry,

                                                isDense: true,
                                                onChanged: (
                                                    Flag newValue) {
                                                  if(newValue.country == "Nigeria"){

                                                    setState(() {
                                                      isNigeria = true;
                                                      isButtonDisaled = true;
                                                    });
                                                  }


                                                  setState(() {

                                                    tapped = false;
                                                    id = newValue.id;
                                                    phoneCode = newValue.phoneCode;

                                                    _dropDownValueforCountry = newValue;

                                                    country = _dropDownValueforCountry.country;
                                                    getState(id: newValue.id);


                                                  });
                                                },



                                                items: countries.map((Flag value) {

                                                  return DropdownMenuItem<
                                                      Flag>(
                                                    value: value,
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          height: 16,
                                                          width: 25,

                                                          child: SvgPicture.network(value.flag),
                                                        ),
                                                        SizedBox(width: 10,),
                                                        Text( value.country ,
                                                            style: GoogleFonts
                                                                .raleway(
                                                                fontSize: 14,
                                                                color:themeChangeProvider.darkTheme
                                                                    ? Colors
                                                                    .white
                                                                    : Color(0xff9479A4))),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ));
                                },
                                ),

                                countryloading
                                    ? Positioned(
                                    top: 15,
                                    right: 10,
                                    child:CupertinoActivityIndicator())
                                    : SizedBox()
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),




//                    countryloading ? Container(
//                        height:20,
//                        child: CupertinoActivityIndicator()):



                    SizedBox(height: 10,),

//State
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical:12 ),
//              width: 340,
                      decoration: BoxDecoration(

                      ),
//              margin: EdgeInsets.only(right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "States",
                            style: GoogleFonts.mavenPro(
                    fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
                            ),
                          ),
                          SizedBox(height: 6 ),
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

                                            contentPadding:EdgeInsets.fromLTRB(10,0,10,0),
                                            border:  FormBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(5.0)),

                                            ),
                                            hintText: "Select Your State",
                                            hintStyle: GoogleFonts
                                                .raleway(
                                                fontSize: 14,
                                              color:themeChangeProvider.darkTheme
                                                  ? Colors
                                                  .white
                                                  : kPrimaryColor,),



                                            fillColor: themeChangeProvider
                                                .darkTheme
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
                                          _dropDownValueforState == null,
                                          child:
                                          DropdownButton<States>(
                                            dropdownColor: themeChangeProvider.darkTheme
                                                ? kPrimaryDark
                                                : Colors
                                                .white,
                                            style: TextStyle(color: themeChangeProvider.darkTheme ? Colors.white : Colors.black) ,
                                            icon: loading ? Container() :  Icon(Icons.keyboard_arrow_down_sharp, color: themeChangeProvider.darkTheme ? Colors.white : Color(0xff9479A4),size: 19,),
                                            value: _dropDownValueforState,
                                            isDense: true,
                                            onChanged: (
                                                States newValue) {
                                              setState(() {
//                                        tapped ? _dropDownValue2 = null : _dropDownValue2;
                                                _dropDownValueforState = newValue;
                                                state = _dropDownValueforState.state;

                                                print("stating $state");
                                              });


                                            },

                                            items:  myStates.map((States value) {
                                              return DropdownMenuItem<States>(
                                                value: value,
                                                child: Row(
                                                  children: [

                                                    SizedBox(width: 10,),
                                                    Text( tapped ? " " : value.state ,
                                                        style: GoogleFonts
                                                            .raleway(
                                                            fontSize: 14,
                                                            color:themeChangeProvider.darkTheme
                                                                ? Colors
                                                                .white
                                                                : Color(0xff9479A4))),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    ));
                              },
                              ),


                              loading
                                  ? Positioned(
                                  top: 15,
                                  right: 10,
                                  child:CupertinoActivityIndicator())
                                  : SizedBox()
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 10,),

//Phone nun
                    Container(
//            width: 340,
                      child: CustomTextField(
                        color: kPrimaryColor.withOpacity(0.1),
                        header: "Phone Number",
                        hint:  "7067927252 ",
                        prefixText: "(+${phoneCode == null ? 234: phoneCode }) ",


                        type: FieldType.phone,

                        controller: _phoneNumber,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Number  is required";
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
                      type: FieldType.number,
                      textInputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        new LengthLimitingTextInputFormatter(11),
                      ],

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
                  ],
                ),

              ),


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
          ),
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
//      _dropDownValue1 = loginState.flags[0];
    });
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


  getState({id}) async{
    loading = true;
 var result   = await loginState.getStates(id: id);
    if(result["error"] == false){
      setState(() {
        myStates = result["states"];
        loading = false;
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

    var result = await loginState.registerUserStep1(phone: "$phoneCode${_phoneNumber.text}" , country: _dropDownValueforCountry.country, state: _dropDownValueforState.state, bvn: _bvnNumber.text, continent: _dropDownValueforContinent.continent_name);
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

//    setState(() {
//      appState.phone = "$phoneCode${_phoneNumber.text}";
//      appState.state = stateHint;
//      isLoading = false;
//    });
  }


}

import 'dart:io';

import 'package:cloudinary_client/cloudinary_client.dart';
import 'package:flutter/material.dart';

import 'package:path/path.dart';
import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_svg/svg.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/models/increaseLimit.dart';

import 'package:rex_money/providers/appState.dart';
import 'package:rex_money/providers/conversionState.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/providers/transferState.dart';
import 'package:rex_money/reusables/customTextField.dart';
import 'package:rex_money/reusables/dialoPopup.dart';
import 'package:rex_money/reusables/form.dart';
import 'package:rex_money/reusables/preloader.dart';
import 'package:rex_money/screens/auth/login.dart';
import 'package:rex_money/screens/state/notifSuccess.dart';
import 'package:rex_money/utils/commonUtils.dart';
import 'package:rex_money/utils/exi.dart';
import 'package:rex_money/utils/myUtils.dart';
import 'package:rex_money/utils/systemUtils.dart';





class IncreaseLimit extends StatefulWidget {
  @override
  _IncreaseLimitState createState() => _IncreaseLimitState();
}

class _IncreaseLimitState extends State<IncreaseLimit>  with AfterLayoutMixin<IncreaseLimit>{
  AppState appState;
  LoginState loginState;
  ConversionState conversionState;
  TransferState transferState;
  IncreaseLimitModel _dropDownValueIncreaseLimit;
  List<IncreaseLimitModel> listOfLimit = [];
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme = await themeChangeProvider.darkThemePreference.getTheme();
  }

var picUrl;
  bool limitLoading = false;
  bool sendDocLoading = false;
  String _errortext;
  var _currencies = [
    "Entry",
    "Intermediate",
    "Super human"
  ];
  String _dropdownvalueforBills;

  var bills = [
    "Waste disposal bill",
    "Electricity bill",
    "Water bill"
  ];

  File _image;
  TextEditingController _narration = TextEditingController();
  TextEditingController imagename = TextEditingController();
  @override
  Widget build(BuildContext context) {
    themeChangeProvider = Provider.of<DarkThemeProvider>(context);
    loginState = Provider.of<LoginState>(context);
    appState = Provider.of<AppState>(context);
    // SizeConfig().init(context);
    conversionState = Provider.of<ConversionState>(context);
    transferState = Provider.of<TransferState>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor:
      themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor:
        themeChangeProvider.darkTheme ? kPrimaryDark : Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: kprimaryYellow,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Increase Limit",
          style: GoogleFonts.mavenPro(
              color:
              themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
              fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(

          children: [
            Form(
                key: _formKey,
                child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Select Limit Cadre",
                        style: GoogleFonts.mavenPro(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: themeChangeProvider.darkTheme
                              ? Colors.white
                              : kPrimaryColor,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Stack(
                        children: [
                          FormField(
                            builder: (FormFieldStatestate) {
                              return DropdownButtonHideUnderline(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      InputDecorator(
                                        decoration: InputDecoration(


                                          contentPadding:EdgeInsets.fromLTRB(10,0,10,0),
                                          border:  FormBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(5.0)),

                                          ),


                                          fillColor: themeChangeProvider
                                              .darkTheme
                                              ? kPrimaryDarkTextField
                                              : kPrimaryColor.withOpacity(0.1),

                                          filled: true,

                                          labelStyle: TextStyle(
                                            color: themeChangeProvider.darkTheme
                                                ? Colors.white
                                                : Colors
                                                .black, //This is an example of a change
                                          ),
//                                                                  labelText: _dropDownValue == null ? "Select Monthly transaction volume " : " Select Monthly transaction volume",
                                          errorText: _errortext,
                                          hintText:  "Select Limit Cadre",

                                          hintStyle: GoogleFonts.mavenPro(

                                            fontSize: 14,
                                            color: themeChangeProvider.darkTheme
                                                ? Colors.white
                                                : kPrimaryColor, //This is an example of a change
                                          ),
                                        ),
                                        isEmpty: _dropDownValueIncreaseLimit == null,
                                        child: DropdownButton<IncreaseLimitModel>(
                                          onTap: () {

                                              print("jndjbhd");
                              },
                                          icon: limitLoading ? Container() : Icon(Icons.keyboard_arrow_down_sharp, size: 19, color: kprimaryYellow,),
                                          dropdownColor:
                                          themeChangeProvider.darkTheme
                                              ? kPrimaryDarkTextField
                                              : Colors.white,
                                          value: _dropDownValueIncreaseLimit,
                                          isDense: true,

                                          onChanged: (IncreaseLimitModel newValue) {
                                            setState(() {
                                              _dropDownValueIncreaseLimit = newValue;
                                              _dropdownvalueforBills = null;
                                            });
                                          },
                                          items: conversionState.increaseLimit.map((IncreaseLimitModel value) {
                                            return DropdownMenuItem<IncreaseLimitModel>(
                                              value: value,
                                              child: Text(value.package_name,
                                                  style: GoogleFonts.raleway(
                                                      fontSize: 14,
                                                      color: themeChangeProvider
                                                          .darkTheme
                                                          ? Colors.white
                                                          : kPrimaryColor)),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ));
                            },
                          ),
                          limitLoading
                              ? Positioned(
                              top: 10,
                              right: 10,
                              child:MyUtils.cupertinoDark(
                                  context: context))
                              : SizedBox()
                        ],
                      ),
                    ],
                  ),
                ),



                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Select Utility Bill",
                        style: GoogleFonts.mavenPro(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: themeChangeProvider.darkTheme
                              ? Colors.white
                              : kPrimaryColor,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      FormField(
                        builder: (FormFieldStatestate) {
                          return DropdownButtonHideUnderline(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  InputDecorator(
                                    decoration: InputDecoration(


                                      contentPadding:EdgeInsets.fromLTRB(10,0,10,0),
                                      border:  FormBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),

                                      ),
//                                          focusedBorder: InputBorder.none,
//                                          enabledBorder: InputBorder.none,
//                                          errorBorder: InputBorder.none,
//                                          disabledBorder: InputBorder.none,
//
//                                      hint: "Select Utility Bill",
                                      fillColor: themeChangeProvider
                                          .darkTheme
                                          ? kPrimaryDarkTextField
                                          : kPrimaryColor.withOpacity(0.1),

                                      filled: true,

                                      labelStyle: GoogleFonts.mavenPro(
                                        color: themeChangeProvider.darkTheme
                                            ? Colors.white
                                            : Colors
                                            .black, //This is an example of a change
                                      ),
//                                                                  labelText: _dropDownValue == null ? "Select Monthly transaction volume " : " Select Monthly transaction volume",
                                      errorText: _errortext,
                                      hintText:  "Select Utility Bill",

                                      hintStyle: GoogleFonts.mavenPro(
                                        fontSize: 14,
                                        color: themeChangeProvider.darkTheme
                                            ? Colors.white
                                            : kPrimaryColor, //This is an example of a change
                                      ),
                                    ),
                                    isEmpty: _dropdownvalueforBills == null,

                                    child: DropdownButton<String>(
                                      icon: Icon(Icons.keyboard_arrow_down_sharp, color: kprimaryYellow,),
                                      dropdownColor:
                                      themeChangeProvider.darkTheme
                                          ? kPrimaryDarkTextField
                                          : Colors.white,
                                      value: _dropdownvalueforBills,
                                      isDense: true,

                                      onChanged: (String newValue) {
                                        setState(() {
                                          _dropdownvalueforBills = newValue;
                                        });
                                      },
                                      items: bills.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value,
                                              style: GoogleFonts.raleway(
                                                  fontSize: 14,
                                                  color: themeChangeProvider
                                                      .darkTheme
                                                      ? Colors.white
                                                      : kPrimaryColor)),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ));
                        },
                      ),
                    ],
                  ),
                ),

                CustomTextField(
                  readOnly: true,
                  onTap: (){

                    getImageByGallery();
                  },
                  suffix: Padding(
                    padding: const EdgeInsets.all(15),
                    child: SvgPicture.asset("images/attachment.svg"),
                  ),
                  controller: imagename,
                  type: FieldType.number,
                  onChanged: (value) {
//                    streamController2.add(value);
                    setState(() {
//                      amount = value;
                    });

//                    print("amount $amount");
                  },
                    hint: "Your utility bill image ",
                  header: "Upload Utility Bill",

                ),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Reason for Increase",
                        style: GoogleFonts.raleway(

                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: themeChangeProvider.darkTheme
                              ? Colors.white
                              : kPrimaryColor,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      TextFormField(
                        style: GoogleFonts.raleway(

                            fontSize: 13,
                            color: themeChangeProvider.darkTheme
                                ? Colors.white
                                : kPrimaryColor),
                        controller: _narration,
                        decoration: InputDecoration(
                          border: FormBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 12.0, top: 10.0),
                          fillColor: themeChangeProvider.darkTheme
                              ? kPrimaryDarkTextField
                              : kPrimaryColor.withOpacity(0.1),
                          filled: true,
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
//                  maxLength: 100,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.maxFinite,
                    height: 50,
                    child: RaisedButton(

                      onPressed:  () async {
                      sendDocument(context);
                      },
                      child: Text(
                        "PROCEED",
                        style: GoogleFonts.mavenPro(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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
              ],
            ))
          ],
        ),
      ),
    );
  }


  Future getImageByGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 20, maxHeight: 500.0, maxWidth: 500.0);
    var imag = await fixExifRotation(image.path);
    setState(() {
      _image = imag;
      imagename.text =      basename(_image.path);
//      imagename.text = _image.path.split('/').last;
    });

  }

  @override
  void afterFirstLayout(BuildContext context) {
      if(conversionState.increaseLimit == null || conversionState.increaseLimit.length == 0){
        getListofLimit();
      }
  }

  void getListofLimit()async {
    setState(() {
      limitLoading = true;
    });


    var result =  await conversionState.listOfLimits(token: loginState.user.token);
    setState(() {
      limitLoading = false;
    });

    if(result["error"] == false){
      setState(() {
        listOfLimit = result["increaseLimit"];

      });
    }
  }



  sendDocument(context) async {
    setState(() {
      sendDocLoading = true;
    });

    if (sendDocLoading) {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return Preloader();
          });
    }

    CloudinaryClient client = new CloudinaryClient(
        "734211642123311", "ghT9LjkHFAsZSCdhpu_Fzo0j9gI", "rexwire");


    var response = await client.uploadImage(_image.path, folder: CloudinaryFolderStaging.LimitDocument);


    print(response.secure_url);
    setState(() {
      picUrl = response.secure_url;
    });


    var result = await conversionState.applyForLimit(
        token: loginState.user.token,
        limit: _dropDownValueIncreaseLimit.level,
        utilityBillType: _dropdownvalueforBills,
        reason: _narration.text,
        image: picUrl
    );
    if (sendDocLoading) {
      Navigator.pop(context, true);
    }
    if (result["error"] &&
        result["message"] == "You are not authorized to make this request") {
      print("jdjdjdhd");
      showDialog(
          barrierDismissible: false,
          context: context,
          child: dialogPopup(
              themeDark: themeChangeProvider.darkTheme,
              body: Text(
                "Session has ended,Please Login again",
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
    }
    else if (result['error'] == true) {
      CommonUtils.showMsg(
          result["message"], themeChangeProvider, context, _scaffoldKey,
          Colors.red);
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Notif(
        fromIncreaseLimit: true,
          )));
    }
  }

}




import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/api/conversionApi.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/models/mobileMoneyModel.dart';
import 'package:rex_money/providers/conversionState.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/reusables/customTextField.dart';
import 'package:rex_money/reusables/dialoPopup.dart';
import 'package:rex_money/reusables/form.dart';
import 'package:rex_money/reusables/preloader.dart';
import 'package:rex_money/screens/auth/login.dart';
import 'package:rex_money/screens/fundAccount/webView.dart';
import 'package:rex_money/utils/commonUtils.dart';

import '../home.dart';
import 'fundAccount.dart';


class MobileMoney extends StatefulWidget {
  @override
  _MobileMoneyState createState() => _MobileMoneyState();
}

class _MobileMoneyState extends State<MobileMoney>  with AfterLayoutMixin<MobileMoney>{


  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  String phone;
  LoginState  loginState;
  String password;
  var realAmount;
  MobileMoneyModel _dropDownValueForProvider;
  ScrollController controller;
  bool isScrollingDisabled = false;
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  String _errortext;
List <MobileMoneyModel> mobileMoneyModel  =  [];
ConversionState conversionState;

bool fundingLoading = false;
  MoneyMaskedTextController _amountController = MoneyMaskedTextController(decimalSeparator: ".", thousandSeparator: ",");
  TextEditingController _beneficiary = TextEditingController();
  TextEditingController _mobileNum = TextEditingController();
  TextEditingController _narration = TextEditingController();


  @override
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
    conversionState = Provider.of<ConversionState>(context);
    loginState = Provider.of<LoginState>(context);
    themeChangeProvider = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor:  themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
      appBar: AppBar(
        title: Text("Mobile Money", style: GoogleFonts.mavenPro(color:  themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,fontSize: 17,),),
        backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
        leading:  IconButton(icon: Icon(Icons.arrow_back, color: kprimaryYellow,),onPressed: ()=>Navigator.pop(context),),
      ),

      body: isLoading ? Center(child: CircularProgressIndicator()) :

      Column(
        children: [
          SizedBox(height: 10,),
          conversionState.mobileMoneyModel.length  ==  0 ? Center(child: Text("Sorry, Not available for Your Country"),)
          :    SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
            children: [

                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Select Network",
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
                        height: 4,
                      ),
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
                                    hintText: "Select provider ",

                                    hintStyle:  GoogleFonts
                                        .raleway(
                                        fontSize:14,
                                        color: themeChangeProvider.darkTheme ? Colors.grey : kPrimaryColor),
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
                                    errorText: _errortext,
                                  ),
                                  isEmpty:
                                  _dropDownValueForProvider ==
                                      null,
                                  child:
                                  DropdownButton<
                                      MobileMoneyModel>(
                                    dropdownColor: themeChangeProvider.darkTheme
                                        ? kPrimaryDarkTextField
                                        : Colors
                                        .white,

                                    value: _dropDownValueForProvider,
                                    isDense: true,
                                    onChanged: (
                                        MobileMoneyModel newValue) {
                                      setState(() {
                                        _dropDownValueForProvider =
                                            newValue;
                                      });
                                    },

                                    items: conversionState.mobileMoneyModel
                                        .map((
                                        MobileMoneyModel value) {
                                      return DropdownMenuItem<
                                          MobileMoneyModel>(
                                        value: value,
                                        child: Text(
                                            value.network_provider,
                                            style: GoogleFonts
                                                .raleway(
                                                fontSize: 12,
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
                    ],
                  ),
                ),



                //Account num
                CustomTextField(
//                        color: kPrimaryColor.withOpacity(0.1),
                  header: "Mobile Number (Optional)",
                  hint: "5532-1233-212",
                  type: FieldType.number,


                  onChanged: (value) {
                    print(value);

                  },
                  controller: _mobileNum,
//              validator: (value) {
//                if (value.isEmpty) {
//                  return "field is required";
//                }
//
//                if (value.length <= 10) {
//                  return "Invalid Account number";
//                }
//
//                return null;
//              },
                ),





//Amount
                CustomTextField(
                  color: themeChangeProvider.darkTheme ? Colors.red :  kPrimaryColor.withOpacity(0.1) ,
                  header: "Amount",
                  hint: "",
                  type: FieldType.text,
                  prefixText: "${loginState.user.symbol} ",

                  onChanged: (value) {
                    print(value);
                  },
                  controller: _amountController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Amount is required";
                    }

                    if (value.length <= 4) {
                      return "Invalid Amount";
                    }

                    return null;
                  },
                ),



            ],
        ),
              )),
          ),


          //ACCOUNT NAME
//          CustomTextField(
//            color: kPrimaryColor.withOpacity(0.1),
//            header: "Beneficiary Name",
//            hint: "Sumaila Finidi",
//            type: FieldType.text,
//
//
//            onChanged: (value) {
//              print(value);
//
//            },
//            controller: _beneficiary,
//            validator: (value) {
//              if (value.isEmpty) {
//                return "Field is required";
//              }
//
//              if (value.length <= 4) {
//                return "field Amount";
//              }
//
//              return null;
//            },
//          ),


          Spacer(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.maxFinite,
              height: 50,
              child: RaisedButton(
                onPressed: () {
                    if(_dropDownValueForProvider != null){
                      if (_formKey.currentState.validate()  ) {
                       sendMobileMoney();
                      }
                    }else{
                      toast("Select a provider");
                    }

                },
                child:   Text(
                 "FUND ACCCOUNT",
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



          SizedBox(height: 30,),
        ],
      )

    );
  }

  sendMobileMoney() async {
    setState(() {
fundingLoading = true;
    });

    if (fundingLoading) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Preloader();
          });
    }

    String s = _amountController.text.toString().replaceAll(RegExp(r"([.]*00)(?!.*\d)"), "");
    var cleanAmount = s.trim().replaceAll(",", "");
    print("cleanAmount$cleanAmount");
    setState(() {
      realAmount = cleanAmount;
    });

    print(realAmount);
    print(_dropDownValueForProvider.network_provider);
   var result = await conversionState.fundWalletWithMobileMoney(token: loginState.user.token,  network:  _dropDownValueForProvider.network_provider, amount: realAmount );
    if (fundingLoading) {
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
                result['message'],
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

  else    if(result["error"] == false){
        setState(() {
          fundingLoading = false;
          CommonUtils.showSuccessDialog(context: context, buttonText: result["urlRedirect"] == null ? "Okay" : "Validate payment", themeChangeProvider: themeChangeProvider, text: "Charge initiated, click 'validate' to validate payment  ", onClose: (){

            result["urlRedirect"] == null ?  Navigator.push(context, MaterialPageRoute(builder: (context)=> Home())) :    Navigator.push(context, MaterialPageRoute(builder: (context)=> WebViewContainer(result["urlRedirect"])));
        });

        });

      }else{
        CommonUtils.showMsg(result["message"], themeChangeProvider, context, _scaffoldKey, Colors.red);
      }
  }



  @override
  void afterFirstLayout(BuildContext context) async {
      if(conversionState.mobileMoneyModel.isEmpty ||conversionState.mobileMoneyModel == null ){
        fetchMobileMoneyProvider();
      }
  }




  fetchMobileMoneyProvider()async{
    print(loginState.user.country_id);
    setState(() {
      isLoading = true;
    });
    var result  =  await conversionState.fetchListMobileMoney(token: loginState.user.token, country_id: loginState.user.country_id);
    if(result["error"] ==  false){
      setState(() {
        isLoading = false;
        mobileMoneyModel = result["mobileMoney"];
      });
    }
  }




}


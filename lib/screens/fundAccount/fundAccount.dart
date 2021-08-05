import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
//import 'package:flutterwave/core/flutterwave.dart';
//import 'package:flutterwave/models/responses/charge_response.dart';
//import 'package:flutterwave/utils/flutterwave_constants.dart';
//import 'package:flutterwave/utils/flutterwave_currency.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/api/stripeService.dart';
import 'package:rex_money/reusables/form.dart';
import 'package:rex_money/reusables/usercard.dart';
import 'package:rex_money/screens/fundAccount/funWallateCard.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/reusables/primarybutton.dart';
import 'package:rex_money/screens/fundAccount/fundAccountLOcal.dart';
import 'package:rex_money/screens/fundAccount/mobileMoney.dart';
import 'package:rex_money/utils/commonUtils.dart';
import 'package:rex_money/flutterWave/core/flutterwave.dart';
import 'package:rex_money/flutterWave/models/responses/charge_response.dart';
import 'package:rex_money/flutterWave/utils/flutterwave_constants.dart';
import 'package:rex_money/flutterWave/utils/flutterwave_currency.dart';


class FundAccount extends StatefulWidget {
  @override
  _FundAccountState createState() => _FundAccountState();
}

class _FundAccountState extends State<FundAccount> with AfterLayoutMixin<FundAccount> {
  DarkThemeProvider darkThemeProvider;
  LoginState loginState;
  String _dropDownValue;
  String _errortext;
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  var foreign = [
    "Card",
  ];


  var African = [
    "Card",
    "Mobile Money",
  ];





  var txRef = "rexWire-${DateTime.now().millisecondsSinceEpoch}";
  final String amount = "200";
   String currency;


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
    darkThemeProvider = Provider.of<DarkThemeProvider>(context);
    loginState = Provider.of<LoginState>(context);
      print( loginState.user.with_card);
    return Scaffold(
      backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Fund Account", style: GoogleFonts.mavenPro(color:  themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor ,fontSize: 17,),),
          backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.transparent,
            leading:  IconButton(icon: Icon(Icons.arrow_back, color: kprimaryYellow,),onPressed: ()=>Navigator.pop(context),)
        ),


      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 50,),
          userCard( image:         CircleAvatar(
            radius: 25,

            backgroundColor: kprimaryLight.withOpacity(0.5),


            child: Container(
              height: 41,
              width: 40,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(loginState.user.profilepic != null
                          ? loginState.user.profilepic
                          : " ")),
                  borderRadius: BorderRadius.circular(50)),
//          height: 79,
//            width: 75,
//            child: Image.network(loginState.user.profilepic != null ? loginState.user.profilepic : " " , fit: BoxFit.cover,)
            ),
          ), text: "${loginState.user.firstName} ${loginState.user.lastName}", subText: "@${loginState.user.userTag}", themeChangeProvider: themeChangeProvider ),


          SizedBox(height: 20,),
          userCard( image: SvgPicture.asset("images/fundCard.svg", color: themeChangeProvider.darkTheme ? kprimaryYellow : null, ), text: "Saved Card", subText: "Click here to Manage saved card" ,themeChangeProvider: themeChangeProvider ),


//          Row(
//            mainAxisAlignment: MainAxisAlignment.start,
//
//            children: [
//              Text("Other Option", style: GoogleFonts.mavenPro(
//                color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
//                fontWeight: FontWeight.w500,
//                fontSize: 13,
//              ) ),
//            ],
//          ),
          SizedBox(
            height: 30,
          ),
       loginState.user.with_card ?    Container(

            margin: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  "Other Option",
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
                  height: 8,
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

                              border: FormBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),


                              fillColor: themeChangeProvider.darkTheme ? Color(0xff473A4D)
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
                            _dropDownValue ==
                                null,
                            child:
                            DropdownButton<String>(
                              dropdownColor: themeChangeProvider.darkTheme

                                  ? kPrimaryDarkTextField
                                  : Colors
                                  .white,

                              value: _dropDownValue,
                              isDense: true,
                              onChanged: (
                                  String newValue) {
                                setState(() {
                                  _dropDownValue =
                                      newValue;
                                });
                              },

                              items: foreign
                                  .map((
                                  String value) {
                                return DropdownMenuItem<
                                    String>(
                                  value: value,
                                  child: Text(
                                      value ,
                                      style: GoogleFonts
                                          .raleway(
                                          fontSize: 12,
                                          color: themeChangeProvider.darkTheme ? Colors
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
          ) :

       Container(

         margin: EdgeInsets.symmetric(
             horizontal: 20,
             vertical: 5),
         child: Column(
           crossAxisAlignment:
           CrossAxisAlignment.start,
           children: [
             Text(
               "Other Option",
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
               height: 8,
             ),
             Container(
               height: 50,
               child: FormField(builder: (
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
                             border: FormBorder(
                               borderRadius: BorderRadius.circular(5),
                             ),


                             fillColor: themeChangeProvider.darkTheme ? Color(0xff473A4D)
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
                           _dropDownValue ==
                               null,
                           child:
                           DropdownButton<String>(
                             dropdownColor: themeChangeProvider.darkTheme

                                 ? kPrimaryDarkTextField
                                 : Colors
                                 .white,

                             value: _dropDownValue,
                             isDense: true,
                             onChanged: (
                                 String newValue) {
                               setState(() {
                                 _dropDownValue =
                                     newValue;
                               });
                             },

                             items:  African
                                 .map((
                                 String value) {
                               return DropdownMenuItem<
                                   String>(
                                 value: value,
                                 child: Text(
                                     value ,
                                     style: GoogleFonts
                                         .raleway(
                                         fontSize: 12,
                                         color: themeChangeProvider.darkTheme ? Colors
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
             ),
           ],
         ),
       ),
          Spacer(),
          Spacer(),
          primaryButton(text: "PROCEED", onPress: (){
            if(_dropDownValue == "Card" && loginState.user.with_card  && loginState.user.continent != "Africa") {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => FundWalletCard()));
            }
            else if (_dropDownValue == "Card" && loginState.user.with_local_card && loginState.user.continent == "Africa" ){
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => FundWalletLocal()));
//              beginPayment();
            }else if (_dropDownValue == "Mobile Money"){
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MobileMoney()));
            }

          })   ,    SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }





//  beginPayment() async {
//
//    print("called");
//    final Flutterwave flutterwave =  Flutterwave.forUIPayment(
//        context: this.context,
//        encryptionKey: "FLWSECK_TEST113c26fc0ea6",
//        publicKey: "FLWPUBK_TEST-d6537348416f04e19f6aca5fb7246e7c-X",
//        currency: currency,
//        amount: this.amount,
//        email: loginState.user.email,
//        fullName: "${loginState.user.firstName} ${loginState.user.lastName}",
//        txRef: this.txRef,
//        isDebugMode: true,
//
//        phoneNumber: loginState.user.phone,
//        acceptCardPayment: true,
//        acceptUSSDPayment: false,
//        acceptAccountPayment: false,
//        acceptFrancophoneMobileMoney: false,
//        acceptGhanaPayment: true,
//        acceptMpesaPayment: false,
//        acceptRwandaMoneyPayment: false,
//        acceptUgandaPayment: true,
//        acceptZambiaPayment: true);
//
//    try {
//      final ChargeResponse response = await flutterwave.initializeForUiPayments();
//      if (response == null) {
//        // user didn't complete the transaction. Payment wasn't successful.
//      } else {
//        final isSuccessful = checkPaymentIsSuccessful(response);
//        if (isSuccessful) {
//          // provide value to customer
//        } else {
//          // check message
//          print(response.message);
//
//          // check status
//          print(response.status);
//
//          // check processor error
//          print(response.data.processorResponse);
//        }
//      }
//    } catch (error, stacktrace) {
////       handleError(error);
//      print(stacktrace);
//    }
//  }
//
//
//  bool checkPaymentIsSuccessful(final ChargeResponse response) {
//    return response.data.status == FlutterwaveConstants.SUCCESSFUL &&
//        response.data.currency == this.currency &&
//        response.data.amount == this.amount &&
//        response.data.txRef == this.txRef;
//  }





  @override
  void afterFirstLayout(BuildContext context) {


    if( loginState.user.continent == "Africa" ){
      setState(() {
        _dropDownValue =  African[0];
      });
    }else{
      setState(() {
        _dropDownValue =  foreign[0];
      });

    }



if(loginState.user.country == "Ghana"){
  print("na me");
  currency  = FlutterwaveCurrency.GHS;
}else if(loginState.user.country == "Rwanda"){
setState(() {
  currency  = FlutterwaveCurrency.RWF;
});
}else if(loginState.user.country == "Kenya"){
setState(() {
  currency  = FlutterwaveCurrency.KES;
});
}else if(loginState.user.country == "Rwanda"){
setState(() {
  currency  = FlutterwaveCurrency.RWF;
});
}else if(loginState.user.country == "Uganda"){
setState(() {
  currency  = FlutterwaveCurrency.UGX;
});
}else if(loginState.user.country == "Zambia"){
setState(() {
  currency  = FlutterwaveCurrency.ZMW;
});
}else{
 return;

}



  }
  
  
  
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/providers/appState.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/providers/transferState.dart';

import 'customTextField.dart';




class NoAuth extends StatefulWidget {

  final amount;
  final cardNum;
  final expMonth;
  final expYear;
  final cvv;
  final transRef;
    final auth_mode;
  NoAuth({this.amount, this.cardNum, this.expMonth, this.expYear, this.cvv, this.transRef, this.auth_mode});
  @override
  _NoAuthState createState() => _NoAuthState();
}

class _NoAuthState extends State<NoAuth> {
LoginState loginState;
TransferState transferState;
  AppState appState;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _formKey = new GlobalKey<FormState>();
  var country;
  var zipcode;
  var city;
  var cardAddress;
  var cardState;
  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);
    loginState = Provider.of<LoginState>(context);
    transferState = Provider.of<TransferState>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Address Verification", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child:  Column(
          children: [
            Form(

              key: _formKey,
              child:  Column(

                children: [

                  CustomTextField(
                    color: kPrimaryColor.withOpacity(0.1),
                    type: FieldType.text,
                    header: "City",
                    hint: "Lagos",
                    validator: (value) {
                      if(value.trim().isEmpty){
                        return "Name is required";
                      }

                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                 city = value;
                      });
                    },
                  ),

                  CustomTextField(
                    color: kPrimaryColor.withOpacity(0.1),
                    type: FieldType.text,
                    header: "Address",
                    hint: "Dove court estate",
                    validator: (value) {
                      if(value.trim().isEmpty){
                        return "Address is required";
                      }
//                        if(!value.trim().contains(" ")){
//                          return "Add space then add the last name";
//                        }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                 cardAddress = value;
                      });
                    },
                  ),

                  CustomTextField(
                    color: kPrimaryColor.withOpacity(0.1),
                    type: FieldType.text,
                    header: "State",
                    hint: "Greater Accra",
                    validator: (value) {
                      if(value.trim().isEmpty){
                        return "State is required";
                      }
//                        if(!value.trim().contains(" ")){
//                          return "Add space then add the last name";
//                        }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                 cardState = value;
                      });
                    },
                  ),
                  CustomTextField(
                    color: kPrimaryColor.withOpacity(0.1),
                    type: FieldType.text,
                    header: "Country",
                    hint: "Ghana",
                    validator: (value) {
                      if(value.trim().isEmpty){
                        return "Country is required";
                      }
//                        if(!value.trim().contains(" ")){
//                          return "Add space then add the last name";
//                        }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                      country = value;
                      });
                    },
                  ),


                  CustomTextField(
                    color: kPrimaryColor.withOpacity(0.1),
                    type: FieldType.number,
                    header: "ZipCode",
                    hint: "02234",
                    validator: (value) {
                      if(value.trim().isEmpty){
                        return "ZipCode is required";
                      }
//                        if(!value.trim().contains(" ")){
//                          return "Add space then add the last name";
//                        }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                    zipcode = value;
                      });
                    },
                  ),


                ],
              ),
            ),


            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.maxFinite,
                height: 50,
                child: RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
//                          fetchKeysAndMakingPayment();
//                          fundAccountStep1();
                  obje();
                    }
                  },
                  child: Text(
                    "Continue".toUpperCase(),
                    style: GoogleFonts.mavenPro(
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
        )
      ),
    );
  }


  void obje()async{
    var result = {};
    result["city"] = city;
    result["country"] = country;
    result ["address"] = cardAddress;
    result["state"] = cardState;
    result["zipcode"] = zipcode;


    var response  = await transferState.fundWalletWithCardAfricanStep2(token: loginState.user.token, amount: widget.amount,card_no:widget.cardNum, card_security: widget.cvv, expiry_year: widget.expYear, expiry_month: widget.expMonth.length  == 1 ? "0${widget.expMonth.toString()}"  :  widget.expMonth.toString(), transaction_ref: widget.transRef, auth_type: widget.auth_mode, card_pin: result );
    print(result);
  print(response);
  }



}

import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/providers/appState.dart';
import 'package:rex_money/providers/conversionState.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';

//import 'package:rex_money/reusables/cardAnim.dart';
import 'package:rex_money/reusables/customTextField.dart';

class NewVirtualcard extends StatefulWidget {
  @override
  _NewVirtualcardState createState() => _NewVirtualcardState();
}

class _NewVirtualcardState extends State<NewVirtualcard> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _formKey = new GlobalKey<FormState>();
  AppState appState;

  DarkThemeProvider darkThemeProvider;
  LoginState loginState;
  var cardTitle = new TextEditingController();
  var address = new TextEditingController();
  var city = new TextEditingController();

  var state = new TextEditingController();
  var postal = new TextEditingController();

  MoneyMaskedTextController _amountController =
      MoneyMaskedTextController(decimalSeparator: ".", thousandSeparator: ",");

  var title = "";
  ConversionState conversionState;
  bool isSwitched = false;
  bool isDarkMode = false;
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

  @override
  Widget build(BuildContext context) {
    themeChangeProvider = Provider.of<DarkThemeProvider>(context);
    loginState = Provider.of<LoginState>(context);
    conversionState = Provider.of<ConversionState>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor:
          themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "New Virtual Card",
          style: GoogleFonts.mavenPro(
            color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
            fontSize: 17,
          ),
        ),
        backgroundColor:
            themeChangeProvider.darkTheme ? kPrimaryDark : Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(18.0),
          child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset("images/leftIcon.svg")),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
//    mainAxisAlignment: MainAxisAlignment.center,
          children: [
//        CreditCardWidget(
//          cardbgColor:  kPrimaryColor,
//          cardTitle: title,
//          expiryDate: title,
//          cardHolderName: "${loginState.user.firstName} ${loginState.user.lastName}",
//          cvvCode: "cvvCode",
//          showBackView: false,
//        ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
//                      color: kPrimaryColor.withOpacity(0.1),
                    type: FieldType.card,
                    header: "Card Title",
                    hint: "Netflix Subscription",
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return "Title is required";
                      }

                      return null;
                    },
                    onChanged: (String value) {
                      setState(() {
                        title = value;
                      });
                    },

                    controller: cardTitle,
                  ),
                  CustomTextField(
//                      color: kPrimaryColor.withOpacity(0.1),
                    type: FieldType.card,
                    header: "Address",
                    hint: "19 North Bridge, Edinburgh EH1 1SD, United Kingdom",
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return "Address is required";
                      }

                      return null;
                    },
                    onChanged: (String value) {},

                    controller: address,
                  ),
                  CustomTextField(
//                      color: kPrimaryColor.withOpacity(0.1),
                    type: FieldType.card,
                    header: "City",
                    hint: "Edinburgh",
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return "City is required";
                      }

                      return null;
                    },
                    onChanged: (String value) {},

                    controller: city,
                  ),
                  CustomTextField(
                    color: kPrimaryColor.withOpacity(0.1),
                    header: "Amount to Fund",
                    hint: "",
                    type: FieldType.cardNum,
                    prefix: Container(
                      margin: EdgeInsets.only(right: 5),
                      child: Text(
                        loginState.user.currency,
                        style: GoogleFonts.workSans(
                            color: themeChangeProvider.darkTheme
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                    onChanged: (value) {

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
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: state,
                          color: kPrimaryColor.withOpacity(0.1),
                          header: "State",
                          hint: "Edinburgh",
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return "State is required";
                            }

                            return null;
                          },
                          type: FieldType.cardNum,
                          onChanged: (value) {},
                        ),
                      ),
                      Expanded(
                        child: CustomTextField(
                          controller: postal,
                          color: kPrimaryColor.withOpacity(0.1),
                          header: "Postal Code",
                          hint: "EH14",
                          type: FieldType.cardNum,
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return "Postal code is required";
                            }

                            return null;
                          },
                          onChanged: (value) {},
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 20,
            ),

            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.maxFinite,
                height: 50,
                child: RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
//                  payWithCard();
                    }
                  },
                  child: Text(
                    "Create Card",
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

            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}

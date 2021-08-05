import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/flutterWave/core/card_payment_manager/card_payment_manager.dart';
import 'package:rex_money/flutterWave/core/flutterwave_payment_manager.dart';
import 'package:rex_money/flutterWave/core/mobile_money/mobile_money_payment_manager.dart';
import 'package:rex_money/flutterWave/core/mpesa/mpesa_payment_manager.dart';
import 'package:rex_money/flutterWave/core/pay_with_account_manager/bank_account_manager.dart';
import 'package:rex_money/flutterWave/core/ussd_payment_manager/ussd_manager.dart';
import 'package:rex_money/flutterWave/core/voucher_payment/voucher_payment_manager.dart';
import 'package:rex_money/flutterWave/models/responses/charge_response.dart';
import 'package:rex_money/flutterWave/widgets/bank_account_payment/bank_account_payment.dart';
import 'package:rex_money/flutterWave/widgets/card_payment/card_payment.dart';
import 'package:rex_money/flutterWave/widgets/mobile_money/pay_with_mobile_money.dart';
import 'package:rex_money/flutterWave/widgets/mpesa_payment/pay_with_mpesa.dart';
import 'package:rex_money/flutterWave/widgets/ussd_payment/pay_with_ussd.dart';
import 'package:rex_money/flutterWave/widgets/voucher_payment/pay_with_voucher.dart';
import 'package:rex_money/providers/darkmode.dart';


import 'flutterwave_payment_option.dart';

class FlutterwaveUI extends StatefulWidget {
  final FlutterwavePaymentManager _flutterwavePaymentManager;

  FlutterwaveUI(this._flutterwavePaymentManager);

  @override
  _FlutterwaveUIState createState() => _FlutterwaveUIState();
}

class _FlutterwaveUIState extends State<FlutterwaveUI> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();







  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
    await themeChangeProvider.darkThemePreference.getTheme();
  }


  @override
  Widget build(BuildContext context) {
print("${widget._flutterwavePaymentManager.country} from widget");
    final FlutterwavePaymentManager paymentManager =
        this.widget._flutterwavePaymentManager;

    return  Scaffold(
        backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
        appBar: AppBar(

          elevation: 0.0,
          centerTitle: true,
          title: Text("Fund Account", style: GoogleFonts.mavenPro(color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,fontSize: 17,),),
          backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark: Colors.white,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: kprimaryYellow,
              ),
              onPressed: () => Navigator.pop(context),
            )
        ),

        key: this._scaffoldKey,
        body: Container(
          alignment: Alignment.bottomCenter,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(10, 70, 10, 0),
                child: Column(
                  children: [
//                    Row(
//                      mainAxisSize: MainAxisSize.max,
//                      children: [
//                        Icon(
//                          Icons.lock,
//                          size: 10.0,
//                          color: Colors.black,
//                        ),
//                        SizedBox(
//                          width: 5.0,
//                        ),
//                        Text(
//                          "SECURED BY FLUTTERWAVE",
//                          style: TextStyle(
//                              color: Colors.black,
//                              fontSize: 10.0,
//                              letterSpacing: 1.0),
//                        )
//                      ],
//                    ),
//                    SizedBox(
//                      width: double.infinity,
//                      height: 80,
//                    ),
//                    Container(
//                      width: double.infinity,
//                      margin: EdgeInsets.fromLTRB(0, 80, 0, 0),
//                      child: Text(
//                        "How would you \nlike to pay?",
//                        textAlign: TextAlign.left,
//                        style: TextStyle(
//                          fontWeight: FontWeight.bold,
//                          color: Colors.black,
//                          fontSize: 30.0,
//                        ),
//                      ),
//                    ),
//                    Align(
//                      alignment: Alignment.centerLeft,
//                      child: Container(
//                        height: 5,
//                        width: 200,
//                        color: Colors.pink,
//                        margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
//                      ),
//                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 100.0,
              ),
              Container(
                color: Colors.white38,
                width: double.infinity,
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
//                    Visibility(
//                      visible: paymentManager.acceptAccountPayment,
//                      child: Column(
//                        children: [
//                          SizedBox(
//                            width: double.infinity,
//                            height: 50.0,
//                            child: FlutterwavePaymentOption(
//                              handleClick: this._launchPayWithAccountWidget,
//                              buttonText: "Account",
//                            ),
//                          ),
//                          SizedBox(
//                            height: 0.5,
//                          ),
//                        ],
//                      ),
//                    ),
                    Visibility(
                      visible: paymentManager.acceptCardPayment,
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 50.0,
                            child: FlutterwavePaymentOption(
                              handleClick: this._launchCardPaymentWidget,
                              buttonText: "Card",
                            ),
                          ),
                          SizedBox(
                            height: 0.5,
                          ),
                        ],
                      ),
                    ),
//                    Visibility(
//                      visible: paymentManager.acceptUSSDPayment,
//                      child: Column(
//                        children: [
//                          SizedBox(
//                            height: 50.0,
//                            child: FlutterwavePaymentOption(
//                              handleClick: this._launchUSSDPaymentWidget,
//                              buttonText: "USSD",
//                            ),
//                          ),
//                          SizedBox(
//                            height: 0.5,
//                          ),
//                        ],
//                      ),
//                    ),
//                    Visibility(
//                      visible: paymentManager.acceptMpesaPayment,
//                      child: Column(children: [
//                        SizedBox(
//                          height: 50.0,
//                          child: FlutterwavePaymentOption(
//                            handleClick: this._launchMpesaPaymentWidget,
//                            buttonText: "Mpesa",
//                          ),
//                        ),
//                        SizedBox(
//                          height: 0.5,
//                        ),
//                      ]),
//                    ),
//                    Visibility(
//                      visible: paymentManager.acceptRwandaMoneyPayment,
//                      child: Column(
//                        children: [
//                          SizedBox(
//                            height: 50.0,
//                            child: FlutterwavePaymentOption(
//                              handleClick: this._launchMobileMoneyPaymentWidget,
//                              buttonText: "Rwanda Mobile Money",
//                            ),
//                          ),
//                          SizedBox(
//                            height: 0.5,
//                          ),
//                        ],
//                      ),
//                    ),
//                    Visibility(
//                      visible: paymentManager.acceptGhanaPayment,
//                      child: Column(
//                        children: [
//                          SizedBox(
//                            height: 50.0,
//                            child: FlutterwavePaymentOption(
//                              handleClick: this._launchMobileMoneyPaymentWidget,
//                              buttonText: "Ghana Mobile Money",
//                            ),
//                          ),
//                          SizedBox(
//                            height: 0.5,
//                          ),
//                        ],
//                      ),
//                    ),
//                    Visibility(
//                      visible: paymentManager.acceptUgandaPayment,
//                      child: Column(
//                        children: [
//                          SizedBox(
//                            height: 50.0,
//                            child: FlutterwavePaymentOption(
//                              handleClick: this._launchMobileMoneyPaymentWidget,
//                              buttonText: "Uganda Mobile Money",
//                            ),
//                          ),
//                          SizedBox(
//                            height: 0.5,
//                          ),
//                        ],
//                      ),
//                    ),
//                    Visibility(
//                      visible: paymentManager.acceptZambiaPayment,
//                      child: Column(
//                        children: [
//                          SizedBox(
//                            height: 50.0,
//                            child: FlutterwavePaymentOption(
//                              handleClick: this._launchMobileMoneyPaymentWidget,
//                              buttonText: "Zambia Mobile Money",
//                            ),
//                          ),
//                          SizedBox(
//                            height: 0.5,
//                          ),
//                        ],
//                      ),
//                    ),
//                    Visibility(
//                      visible: false,
//                      child: Column(
//                        children: [
//                          SizedBox(
//                            height: 50.0,
//                            child: FlutterwavePaymentOption(
//                              handleClick: () => {},
//                              buttonText: "Barter",
//                            ),
//                          ),
//                          SizedBox(
//                            height: 0.5,
//                          ),
//                        ],
//                      ),
//                    ),
//                    Visibility(
//                      visible: paymentManager.acceptVoucherPayment,
//                      child: Column(
//                        children: [
//                          SizedBox(
//                            height: 50.0,
//                            child: FlutterwavePaymentOption(
//                              handleClick: this._launchVoucherPaymentWidget,
//                              buttonText: "Voucher",
//                            ),
//                          ),
//                          SizedBox(
//                            height: 0.5,
//                          ),
//                        ],
//                      ),
//                    ),
//                    Visibility(
//                      visible: paymentManager.acceptFancophoneMobileMoney,
//                      child: SizedBox(
//                        height: 50.0,
//                        child: FlutterwavePaymentOption(
//                          handleClick: this._launchMobileMoneyPaymentWidget,
//                          buttonText: "Francophone Mobile Money",
//                        ),
//                      ),
//                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );

  }

  void _launchCardPaymentWidget() async {
    final CardPaymentManager cardPaymentManager = this.widget._flutterwavePaymentManager.getCardPaymentManager();
    print("${cardPaymentManager.country} currency from chargeP");
    final ChargeResponse chargeResponse = await Navigator.push(
      this.context,
      MaterialPageRoute(builder: (context) => CardPayment(cardPaymentManager)),
    );
    String message;
    if (chargeResponse != null) {
      message = chargeResponse.message;
    } else {
      message = "Transaction cancelled";
    }
    this.showSnackBar(message);
    Navigator.pop(this.context, chargeResponse);
  }

//  void _launchPayWithAccountWidget() async {
//    final BankAccountPaymentManager bankAccountPaymentManager =
//        this.widget._flutterwavePaymentManager.getBankAccountPaymentManager();
//    final response = await Navigator.push(
//      this.context,
//      MaterialPageRoute(
//          builder: (context) => PayWithBankAccount(bankAccountPaymentManager)),
//    );
//    Navigator.pop(this.context, response);
//  }
//
//  void _launchUSSDPaymentWidget() async {
//    final USSDPaymentManager paymentManager =
//        this.widget._flutterwavePaymentManager.getUSSDPaymentManager();
//    final response = await Navigator.push(
//      this.context,
//      MaterialPageRoute(builder: (context) => PayWithUssd(paymentManager)),
//    );
//    Navigator.pop(this.context, response);
//  }
//
//  void _launchMobileMoneyPaymentWidget() async {
//    final MobileMoneyPaymentManager mobileMoneyPaymentManager =
//        this.widget._flutterwavePaymentManager.getMobileMoneyPaymentManager();
//    final response = await Navigator.push(
//      this.context,
//      MaterialPageRoute(
//          builder: (context) => PayWithMobileMoney(mobileMoneyPaymentManager)),
//    );
//    Navigator.pop(this.context, response);
//  }
//
//  void _launchMpesaPaymentWidget() async {
//    final FlutterwavePaymentManager paymentManager =
//        this.widget._flutterwavePaymentManager;
//    final MpesaPaymentManager mpesaPaymentManager =
//        paymentManager.getMpesaPaymentManager();
//    final response = await Navigator.push(
//      this.context,
//      MaterialPageRoute(
//          builder: (context) => PayWithMpesa(mpesaPaymentManager)),
//    );
//    Navigator.pop(this.context, response);
//  }
//
//  void _launchVoucherPaymentWidget() async {
//    final VoucherPaymentManager voucherPaymentManager =
//    this.widget._flutterwavePaymentManager.getVoucherPaymentManager();
//    final response = await Navigator.push(
//      this.context,
//      MaterialPageRoute(
//          builder: (context) => PayWithVoucher(voucherPaymentManager)),
//    );
//    Navigator.pop(this.context, response);
//  }

  // Todo: include when Barter Payment is ready from on v3
  // void _launchBarterPaymentWidget() async {
  //   final MobileMoneyPaymentManager mobileMoneyPaymentManager =
  //       this.widget._flutterwavePaymentManager.getMobileMoneyPaymentManager();
  //   final response = await Navigator.push(
  //     this.context,
  //     MaterialPageRoute(
  //         builder: (context) => PayWithMobileMoney(mobileMoneyPaymentManager)),
  //   );
  //   Navigator.pop(this.context, response);
  // }

  // Todo: include when UK bank codes is ready on v3
  // void _launchUKAccountPaymentWidget() async {
  //   final MobileMoneyPaymentManager mobileMoneyPaymentManager =
  //       this.widget._flutterwavePaymentManager.getMobileMoneyPaymentManager();
  //   final response = await Navigator.push(
  //     this.context,
  //     MaterialPageRoute(
  //         builder: (context) => PayWithMobileMoney(mobileMoneyPaymentManager)),
  //   );
  //   Navigator.pop(this.context, response);
  // }

  // Todo include when Bank Transfer Payment is optimized.
  // void _launchBankTransferPaymentWidget() async {
  //   final BankTransferPaymentManager bankTransferPaymentManager =
  //       this.widget._flutterwavePaymentManager.getBankTransferPaymentManager();
  //   final response = await Navigator.push(
  //     this.context,
  //     MaterialPageRoute(
  //         builder: (context) => PayWithBankTransfer(bankTransferPaymentManager)),
  //   );
  //   Navigator.pop(this.context, response);
  // }

  void showSnackBar(String message) {
    SnackBar snackBar = SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
    );
    this._scaffoldKey.currentState.showSnackBar(snackBar);
  }
}

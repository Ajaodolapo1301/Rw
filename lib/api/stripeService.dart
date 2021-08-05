import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:rex_money/api/authApi.dart';
import 'package:rex_money/models/fundAccountKeys.dart';
import 'package:stripe_payment/stripe_payment.dart';

class StripeTransactionResponse {
  String message;
  bool success;
  String paymentIntentId;

  String paymentMethodId;

  StripeTransactionResponse(
      {this.message, this.success, this.paymentIntentId, this.paymentMethodId});
}

class StripeService with ChangeNotifier {
  var _paymentMethodB;

  get paymentMethodB => _paymentMethodB;

  set paymentMethod(_paymentMethodB1) {
    _paymentMethodB = _paymentMethodB1;
    notifyListeners();
  }

  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  static String secret =
      'sk_test_51HbMpwLb4XONjITjpTpqGWKgLuuEOMwEybxqIXuAGOPmKTuvsYREK0BHFF4kmlKZvoOP5HUavIfRFJSGTKa0GOjT00O0Ib4Hap';

  static init({pubKey}) {
    StripePayment.setOptions(StripeOptions(
        publishableKey: pubKey, merchantId: "Test", androidPayMode: 'test'));
  }

  static Future<StripeTransactionResponse> payViaCard(
      {String amount,
      token,
      CreditCard card,
      FundAccountKey fetchkeys,
      userMid,
      paymentMethod}) async {
//    print(card);
//    print(amount);

    try {
      var paymentMethod = await StripePayment.createPaymentMethod(
          PaymentMethodRequest(card: card));
//      print(paymentMethod);

//await   StripeService.init(pubKey: fetchkeys.publishableKey);

      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
          clientSecret: fetchkeys.clientSecret,
          paymentMethodId: paymentMethod.id));
//      print("response.paymentIntentId${response.paymentIntentId}");
      if (response.status == 'succeeded') {
        return new StripeTransactionResponse(
            message: 'Transaction successful',
            success: true,
            paymentIntentId: response.paymentIntentId,
            paymentMethodId: response.paymentMethodId);
      } else {
        return new StripeTransactionResponse(
            message: 'Transaction failed', success: false);
      }
    } on PlatformException catch (err) {
      return StripeService.getPlatformExceptionErrorResult(err);
    } catch (err) {
      return new StripeTransactionResponse(
          message: 'Transaction failed: ${err.toString()}', success: false);
    }
  }

//  static Future<StripeTransactionResponse> payWithNewCard({String amount, String currency, secretKey}) async {
//    try {
//      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
//          CardFormPaymentRequest()
//      );
//      var paymentIntent = await StripeService.createPaymentIntent(
//          amount,
//          currency,
//          secretKey
//      );
//      var response = await StripePayment.confirmPaymentIntent(
//          PaymentIntent(
//              clientSecret: paymentIntent['client_secret'],
//              paymentMethodId: paymentMethod.id
//          )
//      );
//      if (response.status == 'succeeded') {
//        return new StripeTransactionResponse(
//            message: 'Transaction successful',
//            success: true
//        );
//      } else {
//        return new StripeTransactionResponse(
//            message: 'Transaction failed',
//            success: false
//        );
//      }
//    } on PlatformException catch(err) {
//      return StripeService.getPlatformExceptionErrorResult(err);
//    } catch (err) {
//      return new StripeTransactionResponse(
//          message: 'Transaction failed: ${err.toString()}',
//          success: false
//      );
//    }
//  }

  static getPlatformExceptionErrorResult(err) {
//    print(err);
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled';
    }

    return new StripeTransactionResponse(message: message, success: false);
  }

//  static Future<Map<String, dynamic>> createPaymentIntent({String amount, String currency, secretkey}) async {
//    try {
//      Map<String, dynamic> body = {
//        'amount': amount,
//        'currency': currency,
//        'payment_method_types[]': 'card'
//      };
//      Map<String, String> headers = {
//        'Authorization': 'Bearer $secretkey',
//        'Content-Type': 'application/x-www-form-urlencoded'
//      };
//
//
//      var response = await http.post(
//          StripeService.paymentApiUrl,
//          body: body,
//          headers: headers
//      );
//      return jsonDecode(response.body);
//    } catch (err) {
//      print('err charging user: ${err.toString()}');
//    }
//    return null;
//  }

// static   Future<Map<String, dynamic>> confirmWalletFunding({paymentIntent, userMid, token}) async{
//
//    final String url = "$stagingUrl/auth/wallet/fund/card/confirm";
//
//
//    var body = {
//      "payment_intent_id": paymentIntent,
//      "user_mid": userMid,
//
//    };
//
//
//    _setHeaders() =>
//        {
//
//          "Authorization": "Bearer $token"
//        };
//
//    try {
//      var response = await http.post(url, body: body, headers: _setHeaders());
//      int statusCode = response.statusCode;
//      print(statusCode);
//      print(response.body);
//      if (statusCode == 201 ) {
//              return jsonDecode(response.body);
//      }
//
//    }catch(e){
//      print(e.toString());
//    }
//
//
//  }

}

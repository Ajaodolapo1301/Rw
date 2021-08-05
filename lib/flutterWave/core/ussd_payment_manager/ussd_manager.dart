import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:rex_money/flutterWave/models/requests/ussd/ussd_request.dart';
import 'package:rex_money/flutterWave/models/responses/charge_response.dart';
import 'package:rex_money/flutterWave/utils/flutterwave_urls.dart';

class USSDPaymentManager {
  String publicKey;
  String currency;
  String amount;
  String email;
  String txRef;
  bool isDebugMode;
  String phoneNumber;
  String fullName;

  /// USSDPaymentManager constructor
  /// Available for only payments with NGN currency
  /// returns an instance of USSDPaymentManager
  USSDPaymentManager({
    @required this.publicKey,
    @required this.currency,
    @required this.amount,
    @required this.email,
    @required this.txRef,
    @required this.isDebugMode,
    @required this.phoneNumber,
    @required this.fullName,
  });

  /// Initiates payments via USSD
  /// Available for only payments with NGN currency
  /// returns an instance of ChargeResponse or throws an error
  Future<ChargeResponse> payWithUSSD(
      USSDRequest ussdRequest, http.Client client) async {
    final requestBody = ussdRequest.toJson();

    final url = FlutterwaveURLS.getBaseUrl(this.isDebugMode) +
        FlutterwaveURLS.PAY_WITH_USSD;
    try {
      final http.Response response = await client.post(url,
          headers: {HttpHeaders.authorizationHeader: this.publicKey},
          body: requestBody);

      ChargeResponse chargeResponse =
      ChargeResponse.fromJson(json.decode(response.body));
      return chargeResponse;
    } catch (error) {
      throw (FlutterError(error.toString()));
    } finally {
      client.close();
    }
  }
}

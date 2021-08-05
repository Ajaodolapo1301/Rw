import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:rex_money/api/authApi.dart';

class TransactionPinService {
  static Future<List> enablePin({String pin, String token}) async {
    try {
      String url = "$stagingUrl/auth/user/pin";

      var response = await post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode(
          {
            "transaction_pin": pin,
          },
        ),
      );
      if(response.statusCode == 200){
        return [true];
      }

      return [false, "Something went wrong"];
      print(response.statusCode);
      print(response.body);
      return [];
    } catch (e) {
      if (e is SocketException) {
        return [false, "Check your internet connection and try again"];
      }
//      print(e);
      return [false, "Something went wrong"];
    }
  }

  static Future<List> validatePin(
      {String pin, String purpose, String token}) async {
    try {
      String url = "$stagingUrl/auth/user/pin/validate";

      var response = await post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode(
          {"transaction_pin": pin, "purpose": purpose},
        ),
      );

//      print("I am here");
//
//      print(response.statusCode);
//      print(response.body);

      if (response.statusCode == 200) {
        return [true, "Pin validated"];
      }

      if(response.statusCode == 500){
        return [false, "Something went wrong"];
      }
      return [false, "Invalid Pin"];
    } catch (e) {
      if (e is SocketException) {
        return [false, "Check your internet connection and try again"];
      }
      print(e);
      return [false, "Something went wrong"];
    }
  }

  static Future<List> hasPin({String token}) async {
    try {
      String url = "$stagingUrl/auth/profile";

      var response = await get(
        url,
        headers: {"Authorization": "Bearer $token"},
      );

//      print("${jsonDecode(response.body)["has_pin"]}  has pin oooo");



      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
//        print("${data["has_pin"]}  jajajaajajaja");
        return [true, data["has_pin"]];
      }

      return [false, "Something went wrong"];
    } catch (e) {
      if (e is SocketException) {
        return [false, "Check your internet connection and try again"];
      }
      return [false, "Something went wrong"];
    }
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:rex_money/api/authApi.dart';

class VerifyAccountOTPService {
  static Future verifyAccount({String otp, String token}) async {
    try {
      String url = "$stagingUrl/register/step/verify/email";
      var response = await post(url,
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json"
          },
          body: jsonEncode({"otp": otp}));

      var data = jsonDecode(response.body);
      return [data["status"], data["message"]];
    } catch (e) {
      if (e is SocketException) {
        return [false, "Check your internet connection and try again"];
      }

      return [false, "Something went wrong"];
    }
  }
}

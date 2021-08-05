import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import 'authApi.dart';

class PasswordResetService {
  static Future<List> initializePasswordReset({String email}) async {
    try {
      String url = "$stagingUrl/password/reset";
      var response = await post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
          {
            "email_address": email,
          },
        ),
      );
//      print(response.body);
      var data = jsonDecode(response.body);
      return [data["status"], data["message"]];
    } catch (e) {
      if (e is SocketException) {
        return [false, "Check your internet connection and try again."];
      }

      return [false, "Something went wrong"];
    }
  }

  static Future<List> completePasswordReset({String email, String otp, String newPassword}) async {
    try {
      String url = "$stagingUrl/password/reset";
      var response = await put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
          {
            "email_address": email,
            "otp": otp,
            "new_password": newPassword
          },
        ),
      );
//      print(response.statusCode);
//      print(response.body);
      var data = jsonDecode(response.body);
      return [data["status"], data["message"]];
    } catch (e) {
      if (e is SocketException) {
        return [false, "Check your internet connection and try again."];
      }

      return [false, "Something went wrong"];
    }
  }
}

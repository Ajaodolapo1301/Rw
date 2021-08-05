import 'dart:convert';

import 'package:http/http.dart';
import 'package:rex_money/api/authApi.dart';

class ProfileService {
  static Future<bool> changeUserTag(
      { String newUserTag,  String token}) async {
    try {
      String url = "$stagingUrl/auth/profile";
//      print(token);
      var response = await put(url,
          body: jsonEncode({"user_tag": newUserTag}),
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json"
          });
//      print(response.body);
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  static Future<List> changePassword(
      {String oldPassword, String newPassword, String token}) async {
    try {
      String url = "$stagingUrl/auth/profile/password";
      var response = await put(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode(
          {
            "current_password": oldPassword,
            "new_password": newPassword,
          },
        ),
      );
      if (response.statusCode == 200) {}

      var data = jsonDecode(response.body);

      return [
        data["status"] ?? false,
        data["status"] ? "Password changed" : data["message"] ?? ""
      ];
    } catch (e) {
      return [false, "Something went wrong"];
    }
  }
}

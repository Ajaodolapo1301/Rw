import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:rex_money/models/continentModel.dart';
import 'package:rex_money/models/flags.dart';
import 'package:rex_money/models/user.dart';
import 'package:rex_money/reusables/flag.dart';
import 'package:rex_money/utils/upload.dart';

//const liveurl = "https://rex.devchris.com.ng/api/v1";

const stagingUrl = "https://staging.api.rexwire.co/api/v1";

abstract class AbstractAuth {


  Future<Map<String, dynamic>> getCountries({id});
  Future<Map<String, dynamic>> getContinent();

  Future<Map<String, dynamic>> getflags();

  Future<Map<String, dynamic>> getStates({id});

  Future<Map<String, dynamic>> login({phone, password});
  Future<Map<String, dynamic>> registerStep1({phone, country, state, bvn, continent});
  Future<Map<String, dynamic>> registerStep2(
      {firstName,
      lastName,
      phoneNumber,
      email,
      residentialAddress,
//      password,
//      state,
//      userTag,
//      imageUrl,
//      idType,
//      idTypeUrl
      });




  Future<Map<String, dynamic>> verifyBvn({phone, bvn});

  Future<Map<String, dynamic>> validateOtp({phone, otp});

  Future<Map<String, dynamic>> uploadIdentification({phone, id_type, id_type_url});

  Future<Map<String, dynamic>> uploadSelfie({phone, image_url});

  Future<Map<String, dynamic>> secureAccount({phone, password,user_tag});
  Future<Map<String, dynamic>> checkAvailabilty({tagName});

  Future<Map<String, dynamic>> getUserDetail({token});
//  Future<Map<String, dynamic>> verifyAccout({token, otp});

}

class Auth implements AbstractAuth {
  @override
  Future<Map<String, dynamic>> getContinent() async {
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/lookups/continent/all";

    try {
      var response = await http.get(url);
      int statusCode = response.statusCode;
//        print(response.body);
//      print(response.statusCode);
      if (statusCode != 200) {
        result["message"] = jsonDecode(response.body)["error"];
        result['error'] = true;
      } else {
        result["error"] = false;
        List<ContinentModel> continent = [];
        (jsonDecode(response.body)["data"] as List).forEach((cont) {
          continent.add(ContinentModel.fromJson(cont));
        });

        result['continent'] = continent;
      }
    } catch (error) {
//      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }




  @override
  Future<Map<String, dynamic>> getCountries({id}) async {
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/lookups/continent/$id/countries";

    try {
      var response = await http.get(url);
      int statusCode = response.statusCode;
//    print(response.body);
      if (jsonDecode(response.body)["status"] == null || jsonDecode(response.body)["status"] == false ||
          statusCode != 200) {
        result["message"] = jsonDecode(response.body)["error"];

//        print("eeroror${result["message"]}");
        result['error'] = true;
      } else {
        result["error"] = false;
        List<Flag> flag = [];
        (jsonDecode(response.body)["data"] as List).forEach((flagg) {
          flag.add(Flag.fromJson(flagg));
        });

        result['flags'] = flag;
      }
    } catch (error) {
//      print(error.toString());
      result["message"] = error.toString();
    }
    return result;
  }


  @override
  Future<Map<String, dynamic>> getflags() async {
//    print("calllllled");
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/all/countries";

    try {
      var response = await http.get(url);
      int statusCode = response.statusCode;

      if (jsonDecode(response.body)["status"] == null ||
          jsonDecode(response.body)["status"] == false ||
          statusCode != 200) {
        result["message"] = jsonDecode(response.body)["error"];

//        print("eeroror${result["message"]}");
        result['error'] = true;
      } else {
        result["error"] = false;
        List<Flag> flag = [];
        (jsonDecode(response.body)["data"] as List).forEach((flagg) {
          flag.add(Flag.fromJson(flagg));
        });

        result['flags'] = flag;
      }
    } catch (error) {
//      print(error.toString());
      result["message"] = error.toString();
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> getStates({id}) async {
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/single/state/$id";

    try {
      var response = await http.get(url);
      int statusCode = response.statusCode;
//      print(response.body);
      if (jsonDecode(response.body)["status"] == null ||
          jsonDecode(response.body)["status"] == false ||
          statusCode != 200) {
        result["message"] = jsonDecode(response.body)["error"];

//        print("eeroror${result["message"]}");
        result['error'] = true;
      } else {
        result["error"] = false;
        List<States> states = [];
        (jsonDecode(response.body)["data"] as List).forEach((flagg) {
//          print(flagg["state"]);
          states.add(States.fromJson(flagg));
        });

        result['states'] = states;
      }
    } catch (e) {
//      print(e.toString());
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> login({phone, password}) async {
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/login";

    var body = {
      "username": phone.trim(),
      "password": password.trim(),
    };

    _setHeaders() => {
          'content-type': 'application/json',
        };

//    print("my body$body");

    try {
      var response = await http.post(url, body: body, ).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

//      print(statusCode);
//      print(response.body);
//      print(jsonDecode(response.body)["token"]);
      if (statusCode != 200) {
        result["message"] = jsonDecode(response.body)["message"];

//        print("eeroror${result["message"]}");
        result['error'] = true;
      } else {
        result["error"] = false;
//        print(json.decode(response.body)["message"]);
        var user = User.fromJson(json.decode(response.body));

        result['user'] = user;
        result['has_verified_email'] = jsonDecode(response.body)["has_verified_email"];
      }
    } catch (error) {
//      print(error.toString());
      result["message"] = error.toString();
    }
//    print("papapapa $result");

    return result;
  }





  @override
  Future<Map<String, dynamic>> getUserDetail({token}) async {
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/profile";
    var headers = {'Authorization': 'Bearer $token'};
    try {
      var response = await http.get(url, headers: headers);
      int statusCode = response.statusCode;
//      print(statusCode);
//      print("response getProfile ${response.body}");
//      print(statusCode);
      if (statusCode != 200) {
        result["message"] = jsonDecode(response.body)["error"];
        result['error'] = true;
      } else if (statusCode == 401) {
        result['error'] = true;
        result["message"] = "Unauthorized";
      }else{
//        print("im here");
//      else if (jsonDecode(response.body)["error"] == null) {
//        if (jsonDecode(response.body)["error"] == true) {
//          result['error'] = true;
//        } else {
          result["error"] = false;

//          print("gagagag${jsonDecode(response.body)["has_pin"]}");
          var u = User.fromJson2(jsonDecode(response.body));

//          print("u-------  $u");
          result['user'] = u;
//        }
      }
    } catch (e) {
//      result["message"] = e.toString();
//      print("e.toString()${e.toString()}");
    }

//    print("hshs$result");
    return result;
  }

  @override
  Future<Map<String, dynamic>> registerStep1({phone, country, state, bvn, continent}) async {
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/register/step/account";
    var body = {
      "continent" : continent,
      "phone_number": phone,
      "country": country,
      "state": state,
      "bvn": bvn ?? " ",
    };
    _setHeaders() => {
          'content-type': 'application/json',
        };
    try {
//      print("++++++++$body");
      var response =
          await http.post(url, body: jsonEncode(body), headers: _setHeaders());
      int statusCode = response.statusCode;
//      print(statusCode);
//      print(response.body);
      if (jsonDecode(response.body)["status"] != true) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else {
        result["error"] = false;
        result["message"] = jsonDecode(response.body);
      }
    } catch (e) {
      result["message"] = e.toString();
//      print(e.toString());
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> validateOtp({phone, otp}) async {
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/register/step/verify/phone";
    var body = {
      "phone_number": phone,
      "otp": otp,
    };
//    _setHeaders() => {
//      'content-type' : 'application/json',
//    };
    try {
      var response = await http.post(
        url,
        body: body,
      );
      int statusCode = response.statusCode;
//      print(statusCode);
//      print(response.body);
      if (jsonDecode(response.body)["status"] != true) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else {
        result["error"] = false;
        result["message"] = jsonDecode(response.body);
      }
    } catch (error) {
//      print(error.toString());
    }

    return result;
  }








  @override
  Future<Map<String, dynamic>> registerStep2(
      {firstName,
      lastName,
      phoneNumber,
      email,
      residentialAddress,
     }) async {
//    Dio dio = new Dio();

    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/register/step/profile";


    var body = {
      "firstname": firstName,
      "lastname": lastName,
      "phone_number": phoneNumber,
      "email": email,
      "residential_address": residentialAddress,
//      "password": password,
//      "state": state,
//      "user_tag": userTag,
//      "id_type": idType,
//      "image_url": imageUrl,
//      "id_type_url": idTypeUrl
    };
//    print(body);
////print(body);
////
//
//    // open a bytestream
//    var stream = new http.ByteStream(DelegatingStream.typed(imageUrl.openRead()));
//    var stream2 = new http.ByteStream(DelegatingStream.typed(idTypeUrl.openRead()));
//    // get file length
//    var length = await imageUrl.length();
//    var length2 = await idTypeUrl.length();
//    // string to uri
//    var uri = Uri.parse(url);
//
//    var request = new http.MultipartRequest("POST", uri);
//    var multipartFile = new http.MultipartFile('image_url', stream, length, filename: basename(imageUrl.path));
//
//    var multipartFile2 = new http.MultipartFile('id_type_url', stream2, length2, filename: basename(idTypeUrl.path));
//    request.files.add(multipartFile);
//    request.files.add(multipartFile2);
//    request.fields.addAll(    {
//      "firstname": firstName,
//      "lastname": lastName,
//      "phone_number": phoneNumber,
//      "email": email,
//      "residential_address": residentialAddress,
//      "password": password,
//      "state": state,
//      "user_tag": userTag,
//      "state": state,
//      "id_type": idType ,
//
//    });
////    print(body);
//    print(multipartFile2);
//    print(multipartFile);
//    var response = await request.send();
//    print(response.statusCode);
//print("got herere");
//
//    response.stream.transform(utf8.decoder).listen((value) {
//      print(value);
    try {
      var response = await http.post(url, body: body);
      int statusCode = response.statusCode;
//      print(statusCode);
//      print(response.body);
      if (jsonDecode(response.body)["status"] != true || statusCode != 200) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else {
        result["error"] = false;
        result["message"] = jsonDecode(response.body)["message"];
      }
    } catch (error) {
//      print(error.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> checkAvailabilty({tagName}) async {
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/usertag/availability/$tagName";
    try {
      var response = await http.get(url);

      if (response.statusCode != 200 ||
          jsonDecode(response.body)["status"] != true) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else {
        result["error"] = false;
        result["message"] = jsonDecode(response.body)["message"];
      }
    } catch (e) {
//      print(e.toString());
    }

    return result;
  }





  @override
  Future<Map<String, dynamic >> secureAccount({phone, password, user_tag}) async{
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/register/step/security";
    var body = {
    "password" : password,
      "phone_number": phone,
      "user_tag": user_tag,
    };
//    print(body);
    try {
      var response = await http.post(url, body: body);

      if (response.statusCode != 200 ||
          jsonDecode(response.body)["status"] != true) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else {
        result["error"] = false;
        result["message"] = jsonDecode(response.body)["message"];
      }
    } catch (e) {
//      print(e.toString());
    }

    return result;
  }

  @override
  Future<Map<String,dynamic >> uploadIdentification({phone, id_type, id_type_url}) async{
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/register/step/identification";
    var body = {
      "phone_number" : phone,
      "id_type": id_type,
      "id_type_url": id_type_url,
    };
//print(body);
    try {
      var response = await http.post(url, body: body);

      if (response.statusCode != 200 ||
          jsonDecode(response.body)["status"] != true) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else {
        result["error"] = false;
        result["message"] = jsonDecode(response.body)["message"];
      }
    } catch (e) {
//      print(e.toString());
    }

    return result;
  }

  @override
  Future<Map<String,dynamic>> uploadSelfie({phone, image_url}) async{
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/register/step/selfie";
    var body = {
      "phone_number" : phone,
      "image_url": image_url,

    };

    try {
      var response = await http.post(url, body: body);

      if (response.statusCode != 200 ||
          jsonDecode(response.body)["status"] != true) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else {
        result["error"] = false;
        result["message"] = jsonDecode(response.body)["message"];
      }
    } catch (e) {
//      print(e.toString());
    }

    return result;
  }

  @override
  Future<Map<String,dynamic >> verifyBvn({phone, bvn}) async{
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/register/step/verify/bvn";
    var body = {
      "phone_number" : phone,
      "bvn": bvn,

    };
//  print(body);
    try {
      var response = await http.post(url, body: body);
//        print(response.body);
      if (response.statusCode != 200 ||
          jsonDecode(response.body)["status"] != true) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else {
        result["error"] = false;
        result["message"] = jsonDecode(response.body)["message"];
      }
    } catch (e) {
//      print(e.toString());
    }

    return result;
  }

//  @override
//  Future<Map<String, dynamic >> verifyAccout({token, otp}) async{
//    Map<String, dynamic> result = {};
//    final String url = "$stagingUrl/register/step/verify/email";
//
//    var body = {
//      "otp": otp,
//
//    };
//
//  var  headers ={
//      "Authorization": "Bearer $token",
//    "Content-Type": "application/json"
//    };
//
//
//
//    try {
//      var response = await http.post(url, body: body, headers: headers ).timeout(Duration(seconds: 30));
//      int statusCode = response.statusCode;
//
//      print(statusCode);
//      print(response.body);
//      print(jsonDecode(response.body)["token"]);
//      if (statusCode != 200) {
//        result["message"] = jsonDecode(response.body)["message"];
//
//        print("eeroror${result["message"]}");
//        result['error'] = true;
//      } else {
//        result["error"] = false;
//        print(json.decode(response.body)["message"]);
//        var user = User.fromJson(json.decode(response.body));
//
//        result['user'] = user;
////        result['has_verified_email'] = jsonDecode(response.body)["has_verified_email"];
//      }
//    } catch (error) {
//      print(error.toString());
//      result["message"] = error.toString();
//    }
//    print("papapapa $result");
//
//    return result;
//  }


//Future<bool> _uploadAvatar() async {
//  Dio dio = new Dio();
//  bool error = false;
//  print("ooooo ${_image.path}");
//  var formData = FormData.fromMap({
//    "image": await MultipartFile.fromFile(_image.path,
//        filename: "img${loginState.user.image}"),
//  });
//
//  var headers = {
//    'Authorization': '${loginState.user.token}',
////      "accept": "*/*",
////      "Content-Type": "multipart/form-data"
//  };
//  print("pppp ${formData.files}");
//
//  try {
//    var response = await dio.post(
//        'https://api.liveyourdreamnigeria.com/api/v1/user/uploadImage',
//        data: formData,
//        options: Options(headers: headers, responseType: ResponseType.json));
//    print("result ${response.data}");
//    Scaffold.of(context).showSnackBar(
//      SnackBar(
//        content: Text(response.data["message"]),
//        backgroundColor: Colors.green,
//        duration: Duration(
//          seconds: 5,
//        ),
//      ),
//    );
//    error = false;
//  } catch (e) {
//    print("error ${e.toString()}");
//    error = true;
//  }
//
//  return error;
//}
}




import 'dart:convert';


import 'package:http/http.dart' as http;
import 'package:rex_money/models/fundAccountKeys.dart';
import 'package:rex_money/models/history.dart';
import 'package:rex_money/models/increaseLimit.dart';
import 'package:rex_money/models/mobileMoneyModel.dart';
import 'package:rex_money/models/rateModel.dart';
import 'package:rex_money/models/tagFetch.dart';
import 'package:rex_money/screens/increaseLimit/increaseLimit.dart';
const liveurl =  "https://rex.devchris.com.ng/api/v1";

const stagingUrl = "https://staging.api.rexwire.co/api/v1";
abstract class AbstractConversion{
  Future<Map<String,dynamic>> conversion({firstCurrency, secondCurrency,firstAmount, token });
  Future<Map<String,dynamic>> fundAccount({amount,  token, });
  Future<Map<String,dynamic>> confirmWalletFunding({paymentIntent, token, paymentMethod});
//  Future<Map<String,dynamic>> walletToWalletFunding({userTag,  token, amount, narration});
  Future<Map<String,dynamic>> transactionHistory({token, });


  Future<Map<String,dynamic>> AccountStatement({token, from_date, to_date, page_index, page_size});


  Future<Map<String,dynamic>> fetchListMobileMoney({token, country_id});
  Future<Map<String,dynamic>> fundWalletWithMobileMoney({token, amount, network});
  Future<Map<String, dynamic>> userDevice({device_token, device_platform, device_uuid, token});
  Future<Map<String,dynamic>> getAccountCharges({token, amount});
  Future<Map<String,dynamic>> listOfLimits({token});
  Future<Map<String,dynamic>> applyForLimit({token, limit, utilityBillType, image, reason});
}


class Conversion implements AbstractConversion {
  @override
  Future<Map<String, dynamic >> conversion({firstCurrency, secondCurrency,firstAmount, token}) async{
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/rates";


    var body = {

      "from": firstCurrency,
      "to": secondCurrency,
      "amount": firstAmount
    };
    _setHeaders() =>
        {

          "Authorization": "Bearer $token"
        };

//    print(firstCurrency);
//    print(secondCurrency);
//    print(body);
//    print(url);
    try{
      var response = await http.post(url, body: body, headers: _setHeaders());
      int statusCode = response.statusCode;
//      print(statusCode);
//      print(response.body);
      if(statusCode != 200){
        result["message"] = jsonDecode(response.body)["message"];
//        print("eeroror${result["message"]}");
        result['error'] = true;
      }else{
        result['error'] = false;
        var rate = RateModel.fromJson(jsonDecode(response.body));
        result["message"] = rate;
      }
    }catch(e){
//      print(e.toString());
    }

    return result;
  }

  @override
  Future<Map<String,  dynamic>> fundAccount({amount,  token, paymentMethod})  async {
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/wallet/fiat/fund/card";


    var body = {
      "amount": amount,
//      "user_mid": userMid,

    };


    _setHeaders() =>
        {

          "Authorization": "Bearer $token"
        };

//    print("amountlala $amount");
//    print("body $body");
    try {
      var response = await http.post(url, body: body, headers: _setHeaders());
      int statusCode = response.statusCode;
//      print(statusCode);
//      print(response.body);
      if (statusCode != 201) {
        result["message"] = jsonDecode(response.body);
//        print("eeroror${result["message"]}");
        result['error'] = true;
      } else if (jsonDecode(response.body)["data"]["exceptionMessage"] != null) {
        result['error'] = true;
        result["message"] = (jsonDecode(response.body)["data"]["exceptionMessage"]);
      } else{
        result['error'] = false;
        var keys = FundAccountKey.fromJson(json.decode(response.body)["data"]);
        result["keys"] = keys;
      }


    }catch(e){
//      print(e.toString());
    }
//    print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic>> confirmWalletFunding({paymentIntent, token, paymentMethod}) async{
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/wallet/fiat/fund/card/confirm";


    var body = {
      "payment_intent_id": paymentIntent,
//      "user_mid": userMid,
      "payment_method_id" : paymentMethod
    };


    _setHeaders() =>
        {

          "Authorization": "Bearer $token"
        };


    try {
      var response = await http.post(url, body: body, headers: _setHeaders());
      int statusCode = response.statusCode;
//      print(statusCode);
//
//      print(response);
//      print("${response.body}  na me ooo");
      if (statusCode != 200 ) {
        result["message"] = jsonDecode(response.body) ?? "created" ;
//        print("eeroror${result["message"]}");
        result['error'] = true;
      } else if (jsonDecode(response.body)["data"]["exceptionMessage"] != null) {
        result['error'] = true;
        result["message"] = (jsonDecode(response.body)["data"]["exceptionMessage"]);
      } else{
        result['error'] = false;
        result["balance"]  = json.decode(response.body)["data"]["balance"];
        result["message"] = json.decode(response.body)["message"];

      }

    }catch(e){
//      print(e.toString());
    }
//    print(result);
    return result;
  }

//  @override
//  Future<Map<String, dynamic >> walletToWalletFunding({userTag, token, amount, narration})  async{
//    Map<String, dynamic> result = {};
//    final String url = "$stagingUrl/auth/transfer/fiat/wallet/wallet";
//
//
//    var body = {
//      "user_tag": userTag,
////      "user_mid": userMid,
//      "amount" : amount,
//      "narration" : narration ?? " "
//    };
//
//
//    _setHeaders() =>
//        {
//
//          "Authorization": "Bearer $token"
//        };
//
//    print(body);
//    try {
//      var response = await http.post(url, body: body, headers: _setHeaders());
//      int statusCode = response.statusCode;
//      print(statusCode);
//      print(response.body);
//      if (statusCode != 201  && jsonDecode(response.body)["status"] !=  true) {
//        result["message"] = jsonDecode(response.body)["message"];
//
//        result['error'] = true;
//      } else if (jsonDecode(response.body)["status"] == false) {
//        result['error'] = true;
//        result["message"] = (jsonDecode(response.body)["message"]);
//      } else{
//        result['error'] = false;
//        result["balance"]  = json.decode(response.body)["data"]["balance"];
//        result["message"] = json.decode(response.body)["message"];
//
//      }
//
//    }catch(e){
//      print(e.toString());
//    }
//    print(result);
//    return result;
//  }
//
//
//  @override
//  Future<Map<String, dynamic >> fetchToTransfer({userTag, token})async {
//    Map<String, dynamic> result = {};
//    final String url = "$stagingUrl/auth/transfer/receiver?user_tag=$userTag";
//
////
////    var body = {
////      "user_tag": userTag,
////
////    };
//
//
//    _setHeaders() =>
//        {
//
//          "Authorization": "Bearer $token"
//        };
//
//    print(url);
//    print(_setHeaders());
//    try {
//      var response = await http.get(url,  headers: _setHeaders());
//      int statusCode = response.statusCode;
//      print(statusCode);
//      print(response.body);
//      if (statusCode != 200  && jsonDecode(response.body)["status"] !=  true) {
//        result["message"] = jsonDecode(response.body)["message"];
//
//        result['error'] = true;
//      }  else{
//        result['error'] = false;
//        var fetchToTransfer = TagFetch.fromJson(json.decode(response.body)["data"]);
//        result["balance"]  = fetchToTransfer;
//        result["message"] = json.decode(response.body)["message"];
//
//      }
//
//    }catch(e){
//      print(e.toString());
//    }
//    print(result);
//    return result;
//
//  }

  @override
  Future<Map<String, dynamic >> fetchListMobileMoney({token, country_id}) async{
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/lookup/mobilemoney-networks?country_id=$country_id";
    _setHeaders() =>
        {

          "Authorization": "Bearer $token"
        };

//    print(url);
//    print(_setHeaders());
    try {
      var response = await http.get(url,  headers: _setHeaders());
      int statusCode = response.statusCode;
      print(statusCode);
      print( " mobile ${response.body}");
      if (statusCode != 200  && jsonDecode(response.body)["status"] !=  true) {
        result["message"] = jsonDecode(response.body)["message"];

        result['error'] = true;
      }  else{
        result['error'] = false;
        List<MobileMoneyModel> mobileMoney = [];

        (jsonDecode(response.body)['data'] as List).forEach((dat){
          mobileMoney.add(MobileMoneyModel.fromJson(dat));
        });
        result['mobileMoney'] = mobileMoney;

      }

    }catch(e){
//      print(e.toString());
    }
//    print(result);
    return result;

  }

  @override
  Future<Map<String, dynamic >> fundWalletWithMobileMoney({token, amount, network}) async{
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/wallet/fiat/fund/mobile-money";


    var body = {
      "amount" : amount,
      "network" : network
    };


    _setHeaders() =>
        {

          "Authorization": "Bearer $token"
        };

//    print(body);
    try {
      var response = await http.post(url, body: body, headers: _setHeaders());
      int statusCode = response.statusCode;
//      print(statusCode);
//      print(response.body);
      if (statusCode != 201  && jsonDecode(response.body)["status"] !=  true) {
        result["message"] = jsonDecode(response.body)["message"];

        result['error'] = true;
      } else{
        result['error'] = false;
        result["status"]  = json.decode(response.body)["data"]["status"];
        result["message"] = json.decode(response.body)["data"]["message"];
        result ["urlRedirect"] =  json.decode(response.body)["data"]["meta"]["authorization"]["redirect"];
      }

    }catch(e){
//      print(e.toString());
    }
//    print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic >> transactionHistory({token}) async{
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/wallet/fiat/history";




    _setHeaders() =>
        {

          "Authorization": "Bearer $token"
        };

//print(url);
    try {
      var response = await http.get(url,headers: _setHeaders());
      int statusCode = response.statusCode;
//      print(statusCode);
//      print("response.body${response.body}");
      if (statusCode != 201  && jsonDecode(response.body)["status"] !=  true) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else{
        result['error'] = false;
        List<HistoryModel> historyModel = [];

        (jsonDecode(response.body)['data'] as List).forEach((dat){
          historyModel.add(HistoryModel.fromJson(dat));
        });
        result['transactionHistory'] = historyModel;

      }

    }catch(e){
//      print(e.toString());
    }

    return result;
  }









  @override
  Future<Map<String, dynamic >> AccountStatement({token,from_date, to_date, page_index, page_size}) async{
    Map<String, dynamic> result = {};
//    final String url = "$stagingUrl/auth/wallet/fiat/statement?from_date=$from_date&to_date=$to_date&page_index=$page_index&page_size=$page_size";

    String url ;
    if(from_date != null && to_date != null){
      url  =  "$stagingUrl/auth/wallet/fiat/statement?from_date=$from_date&to_date=$to_date&page_index=$page_index&page_size=$page_size";

    }else{
      url  = "$stagingUrl/auth/wallet/fiat/statement?page_index=$page_index&page_size=$page_size";
    }


    _setHeaders() =>
        {

          "Authorization": "Bearer $token"
        };

//    print(url);
    try {
      var response = await http.get(url,headers: _setHeaders());
      int statusCode = response.statusCode;
//      print(statusCode);
//      print("response.body${response.body}");
      if (statusCode != 201  && jsonDecode(response.body)["status"] !=  true) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else{
        result['error'] = false;
        List<HistoryModel> historyModel = [];

        (jsonDecode(response.body)['data'] as List).forEach((dat){
          historyModel.add(HistoryModel.fromJson(dat));
        });
        result['transactionHistory'] = historyModel;

      }

    }catch(e){
//      print(e.toString());
    }
//    print(result);
    return result;
  }



  @override
  Future<Map<String, dynamic >> userDevice({device_token, device_platform, device_uuid, token}) async{
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/user/device";
    var body = {
      "device_token": device_token,
      "device_platform": device_platform,
      "device_uuid": device_uuid
    };
    _setHeaders() =>
        {
          "Authorization": "Bearer $token"
        };

//    print("Url$url");
//
//    print("bdoy$body");
    try {
      var response = await http.post(url, body: body, headers: _setHeaders());



      int statusCode = response.statusCode;
//      print(statusCode);
//      print("${response.body} userDevice");
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
  Future<Map<String, dynamic >> getAccountCharges({token, amount}) async {
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/lookup/account-charges";


    var body = {
      "amount": amount
    };
    _setHeaders() =>
        {

          "Authorization": "Bearer $token"
        };


//    print(body);
//    print(url);
    try{
      var response = await http.post(url, body: body, headers: _setHeaders());
      int statusCode = response.statusCode;
//      print(statusCode);
//      print(response.body);
      if(statusCode != 200){
        result["message"] = jsonDecode(response.body)["message"];
//        print("eeroror${result["message"]}");
        result['error'] = true;
      }else{
        result['error'] = false;
        result["data"] = jsonDecode(response.body)["data"];
      }
    }catch(e){
//      print(e.toString());
    }

    return result;
  }

  @override
  Future<Map<String, dynamic >> listOfLimits({token}) async{
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/user/limit/packages";




    _setHeaders() =>
        {

          "Authorization": "Bearer $token"
        };

//    print(url);
    try {
      var response = await http.get(url,headers: _setHeaders());
      int statusCode = response.statusCode;
//      print(statusCode);
//      print("response.body${response.body}");
      if (statusCode != 200  && jsonDecode(response.body)["status"] !=  true) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else{
        result['error'] = false;
        List<IncreaseLimitModel> increaseLimit = [];

        (jsonDecode(response.body)['data'] as List).forEach((dat){
          increaseLimit.add(IncreaseLimitModel.fromJson(dat));
        });
        result['increaseLimit'] = increaseLimit;

      }

    }catch(e){
//      print(e.toString());
    }

    return result;
  }

  @override
  Future<Map<String,dynamic >> applyForLimit({token, limit, utilityBillType, image, reason}) async{
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/user/limit/increase";


    var body = {
      "limit": limit,
      "image_type":utilityBillType,
      "reason":reason,
      "image_url" :image
    };
    _setHeaders() =>
        {

          "Authorization": "Bearer $token"
        };


//    print(body);
//    print(url);
    try{
      var response = await http.post(url, body: body, headers: _setHeaders());
      int statusCode = response.statusCode;
//      print(statusCode);
//      print(response.body);
      if(statusCode != 201){
        result["message"] = jsonDecode(response.body)["message"];
//        print("eeroror${result["message"]}");
        result['error'] = true;
      }else{
        result['error'] = false;
        result["data"] = jsonDecode(response.body)["message"];
      }
    }catch(e){
//      print(e.toString());
    }

    return result;
  }
}
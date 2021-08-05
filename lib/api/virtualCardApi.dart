
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rex_money/models/VcardType.dart';
import 'package:rex_money/models/VirtualCardTitles.dart';
import 'package:rex_money/models/aSingleVirtualCardModel.dart';
import 'package:rex_money/models/cardTrans.dart';
import 'package:rex_money/models/virtualDollarCard.dart';

import 'authApi.dart';

abstract class AbstractVirtualCard{

  Future<Map<String,dynamic>> createVirtualCard({card_title, design_code, amount, token, card_type });
  Future<Map<String,dynamic>> listAllDollarCard({token});
  Future<Map<String,dynamic>> aVirtualCard({ token, id});
  Future<Map<String,dynamic>> freezeCard({ token, id, type});
  Future<Map<String,dynamic>> getcardTransaction({ token, id,from_date, to_date });
  Future<Map<String,dynamic>> fundCard({ token, amount, id });
  Future<Map<String,dynamic>> listofTitles({ token});
  Future<Map<String,dynamic>> listofCardTypes({ token});
  Future<Map<String,dynamic>> terminateCard({ token, id});
  Future<Map<String,dynamic>> withdrawCard({ token, id, amount});

}


class VirtualCardApi implements AbstractVirtualCard{
  @override
  Future<Map<String, dynamic>> createVirtualCard({card_title, design_code, amount, token, card_type})async {
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/virtual-card/create";


    var body = {
      "card_title": card_title,
      "amount" : amount,
      "design_code" : design_code,
      "type_id": card_type,
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
      } else if (jsonDecode(response.body)["status"] == false) {
        result['error'] = true;
        result["message"] = (jsonDecode(response.body)["message"]);
      } else{
        result['error'] = false;
        result["message"] = json.decode(response.body)["message"];

      }

    }catch(e){
//      print(e.toString());
    }
//    print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic >> listAllDollarCard({token}) async{
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/virtual-card/list";
    _setHeaders() =>
        {
          "Authorization": "Bearer $token"
        };


    try {
      var response = await http.get(url,headers: _setHeaders());
      int statusCode = response.statusCode;
//      print(statusCode);
//      print(  "resrsrs ${response.body}");
      if (statusCode != 201  && jsonDecode(response.body)["status"] !=  true) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else{
        result['error'] = false;
        List<VirtualCardModel> virtualCardModell = [];

        (jsonDecode(response.body)['data'] as List).forEach((dat){
//          print("$dat kikikiki");
          virtualCardModell.add(VirtualCardModel.fromJson(dat));
        });

//        print(virtualCardModell);
        result['virtualDollarCards'] = virtualCardModell;

      }

    }catch(e){
//      print(e.toString());
    }
//    print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic >> aVirtualCard({token, id}) async{
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/virtual-card/$id";
    _setHeaders() =>
        {

          "Authorization": "Bearer $token"
        };


    try {
      var response = await http.get(url,headers: _setHeaders());
      int statusCode = response.statusCode;
//      print(statusCode);
//      print(response.body);
      if (statusCode != 201  && jsonDecode(response.body)["status"] !=  true) {
        result["message"] = jsonDecode(response.body)["message"];

        result['error'] = true;
      } else if (jsonDecode(response.body)["status"] == false) {
        result['error'] = true;
        result["message"] = (jsonDecode(response.body)["message"]);
      } else{
        result['error'] = false;
        result["message"] = json.decode(response.body)["message"];
        var card = ASingleVirtualCardModel.fromJson(jsonDecode(response.body)["data"]);
          result["card"] = card;
      }

    }catch(e){
//      print(e.toString());
    }
//    print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic >> freezeCard({token, id, type}) async{
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/virtual-card/$id/freeze";
    _setHeaders() =>
        {

          "Authorization": "Bearer $token"
        };




  var body = {
    "action" : type
  };


    try {
      var response = await http.post(url, body:body, headers: _setHeaders());
      int statusCode = response.statusCode;
//      print(statusCode);
//      print(response.body);
      if (statusCode != 201  && jsonDecode(response.body)["status"] !=  true) {
        result["message"] = jsonDecode(response.body)["message"];

        result['error'] = true;
      } else if (jsonDecode(response.body)["status"] == false) {
        result['error'] = true;
        result["message"] = (jsonDecode(response.body)["message"]);
      } else{
        result['error'] = false;
        result["message"] = json.decode(response.body)["message"];
      }

    }catch(e){
//      print(e.toString());
    }
//    print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic >> getcardTransaction({token, id, from_date, to_date})async {
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/virtual-card/$id/transactions?from_date=$from_date&to_date=$to_date&page_index=1&page_size=7";
    _setHeaders() =>
        {
          "Authorization": "Bearer $token"
        };


    try {
      var response = await http.get(url,headers: _setHeaders());
      int statusCode = response.statusCode;
//      print(statusCode);
//      print(response.body);
      if (statusCode != 201  && jsonDecode(response.body)["status"] !=  true) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else{
        result['error'] = false;

        List<CardTransaction> cardTransaction = [];

        (jsonDecode(response.body)['data'] as List).forEach((dat){

          cardTransaction.add(CardTransaction.fromJson(dat));
        });

//        print(cardTransaction);
        result['cardTransaction'] = cardTransaction;

      }

    }catch(e){
//      print(e.toString());
    }
//    print(result);
    return result;
  }

  @override
  Future<Map<String,dynamic >> fundCard({token, amount, id})async {
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/virtual-card/$id/fund";


    var body = {
      "amount" : amount,
    };


    _setHeaders() =>
        {

          "Authorization": "Bearer $token"
        };

//    print(body);
//    print(url);
    try {
      var response = await http.post(url, body: body, headers: _setHeaders());
      int statusCode = response.statusCode;
//      print(statusCode);
//      print(response.body);
      if (statusCode != 201  && jsonDecode(response.body)["status"] !=  true) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else if (jsonDecode(response.body)["status"] == false) {
        result['error'] = true;
        result["message"] = (jsonDecode(response.body)["message"]);
      } else{
        result['error'] = false;
        result["message"] = json.decode(response.body)["message"];

      }

    }catch(e){
//      print(e.toString());
    }
//    print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic >> listofTitles({token}) async{
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/virtual-card/titles";
    _setHeaders() =>
        {
          "Authorization": "Bearer $token"
        };


    try {
      var response = await http.get(url,headers: _setHeaders());
      int statusCode = response.statusCode;
//      print(statusCode);
//      print(url);
//      print(  "resrsrs ${response.body}");
      if (statusCode != 201  && jsonDecode(response.body)["status"] !=  true) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else{
        result['error'] = false;
        List<VirtualCardlist> virtualcardList = [];

        (jsonDecode(response.body)['data'] as List).forEach((dat){
//          print("$dat kikikiki");
          virtualcardList.add(VirtualCardlist.fromJson(dat));
        });

//        print(virtualcardList);
        result['virtualcardList'] = virtualcardList;

      }

    }catch(e){
//      print(e.toString());
    }
//    print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic >> listofCardTypes({token}) async{
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/virtual-card/types";
    _setHeaders() =>
        {
          "Authorization": "Bearer $token"
        };


    try {
      var response = await http.get(url,headers: _setHeaders());
      int statusCode = response.statusCode;
//      print(statusCode);
//      print(url);
//      print(  "resrsrs ${response.body}");
      if (statusCode != 201  && jsonDecode(response.body)["status"] !=  true) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else{
        result['error'] = false;
        List<VirtualcardTypes> virtualcardTypes = [];

        (jsonDecode(response.body)['data'] as List).forEach((dat){
//          print("$dat kikikiki");
          virtualcardTypes.add(VirtualcardTypes.fromJson(dat));
        });

//        print(virtualcardTypes);
        result['virtualcardTypes'] = virtualcardTypes;

      }

    }catch(e){
//      print(e.toString());
    }
//    print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic >> terminateCard({token, id})async {
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/virtual-card/$id/terminate";




    _setHeaders() =>
        {

          "Authorization": "Bearer $token"
        };


//    print(url);
    try {
      var response = await http.post(url,  headers: _setHeaders());
      int statusCode = response.statusCode;
//      print(statusCode);
//      print(response.body);
      if (statusCode != 200  && jsonDecode(response.body)["status"] !=  true) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else if (jsonDecode(response.body)["status"] == false) {
        result['error'] = true;
        result["message"] = (jsonDecode(response.body)["message"]);
      } else{
        result['error'] = false;
        result["message"] = json.decode(response.body)["message"];

      }

    }catch(e){
//      print(e.toString());
    }
//    print(result);
    return result;
  }

  @override
  Future<Map<String,dynamic >> withdrawCard({token, id, amount}) async{
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/virtual-card/$id/withdraw";


    var body = {
      "amount" : amount,
    };


    _setHeaders() =>
        {

          "Authorization": "Bearer $token"
        };

//    print(body);
//    print(url);
    try {
      var response = await http.post(url, body: body, headers: _setHeaders());
      int statusCode = response.statusCode;
//      print(statusCode);
//      print(response.body);
      if (statusCode != 200  && jsonDecode(response.body)["status"] !=  true) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else if (jsonDecode(response.body)["status"] == false) {
        result['error'] = true;
        result["message"] = (jsonDecode(response.body)["message"]);
      } else{
        result['error'] = false;
        result["message"] = json.decode(response.body)["message"];

      }

    }catch(e){
//      print(e.toString());
    }
//    print(result);
    return result;
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rex_money/models/bankBranchModel.dart';
import 'package:rex_money/models/banks.dart';
import 'package:rex_money/models/contactList.dart';
import 'package:rex_money/models/localCardFundModel.dart';
import 'package:rex_money/models/mobileMoneyModel.dart';
import 'package:rex_money/models/receiveTrans.dart';
import 'package:rex_money/models/requestModel.dart';
import 'package:rex_money/models/requestMoneyModel.dart';
import 'package:rex_money/models/resolveAccModel.dart';
import 'package:rex_money/models/tagFetch.dart';
import 'package:rex_money/models/transactionFee.dart';
import 'authApi.dart';

abstract class AbstractTransfer{

  Future<Map<String,dynamic>> fetchToTransfer({userTag,  token});
  Future<Map<String,dynamic>> walletToWalletFunding({userTag,  token, amount, narration});
  Future<Map<String,dynamic>> fetchBank({token, country});
  Future<Map<String,dynamic>> fetchBankAfrica({token, country});

  Future<Map<String,dynamic>> fetchNetworksAfrica({token, country});
  Future<Map<String,dynamic>> fetchBankBranchAfrica({token, id});

  Future<Map<String,dynamic>> resolveBankName({token, account_number, bank_code});
  Future<Map<String,dynamic>> getCharges({token, amount});
  Future<Map<String,dynamic>> getReceivingCountries ({token});
  Future<Map<String,dynamic>> getFees({token, amount, country_id});





  Future<Map<String,dynamic>> getReceivingCountriesMobileMoney ({token});
  Future<Map<String,dynamic>> interBankFunding({bank_code,  token, account_number, amount, narration});
  Future<Map<String,dynamic>> interBankFundingAfrica({account_bank, currency, token, account_number, destination_branch_code, beneficiary_name, amount, narration});
  Future<Map<String,dynamic>> requestForMoney({request_from,  token, amount, narration});
  Future<Map<String,dynamic>> fetchRequestList({token});
  Future<Map<String,dynamic>> fetchRequestListPending({token});



  Future<Map<String,dynamic>> fetchContactList({token,  contacts});
  Future<Map<String,dynamic>> declineRequest({token, request_id});
  Future<Map<String,dynamic>> AcceptRequest({token, request_id});
  Future<Map<String,dynamic>> fundWalletWithCardAfrican({token, amount, card_no,expiry_month,expiry_year, card_security});
  Future<Map<String,dynamic>> fundWalletWithCardAfricanStep2({token, amount, card_no,expiry_month,expiry_year, card_security, card_pin, transaction_ref, auth_type});
  Future<Map<String,dynamic>> fundWalletWithCardAfricanStep3({token, transaction_ref, otp});
  Future<Map<String,dynamic>> fundWalletWithCardAfricanStep4({token, transaction_id});









}


class TransferApi implements AbstractTransfer{
  @override
  Future<Map<String, dynamic >> walletToWalletFunding({userTag, token, amount, narration})  async{
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/transfer/fiat/wallet/wallet";


    var body = {
      "user_tag": userTag,
//      "user_mid": userMid,
      "amount" : amount,
      "narration" : narration ?? " "
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
        result["balance"]  = json.decode(response.body)["data"]["balance"];
        result["message"] = json.decode(response.body)["message"];

      }

    }catch(e){
//      print(e.toString());
    }
//    print(result);
    return result;
  }


  @override
  Future<Map<String, dynamic >> fetchToTransfer({userTag, token})async {
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/transfer/receiver?user_tag=$userTag";




    _setHeaders() =>
        {

          "Authorization": "Bearer $token"
        };

//    print(url);
//    print(_setHeaders());
    try {
      var response = await http.get(url,  headers: _setHeaders());
      int statusCode = response.statusCode;
//      print(statusCode);
//      print(response.body);
      if (statusCode != 200  && jsonDecode(response.body)["status"] !=  true) {
        result["message"] = jsonDecode(response.body)["message"];

        result['error'] = true;
      }  else{
        result['error'] = false;
        var fetchToTransfer = TagFetch.fromJson(json.decode(response.body)["data"]);
        result["balance"]  = fetchToTransfer;
        result["message"] = json.decode(response.body)["message"];

      }

    }catch(e){
//      print(e.toString());
    }
//    print(result);
    return result;

  }

  @override
  Future<Map<String, dynamic >> fetchBank({token, country}) async{
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/lookup/receiving-banks/$country";




    _setHeaders() =>
        {

          "Authorization": "Bearer $token"
        };


    try {
//      print("callalalaed");
      var response = await http.get(url, headers: _setHeaders());
      int statusCode = response.statusCode;
//      print(statusCode);
//      print("${response.body}  resba");
      if (statusCode != 201  && jsonDecode(response.body)["status"] !=  true) {
        result["message"] = jsonDecode(response.body)["message"];

        result['error'] = true;
      } else if (jsonDecode(response.body)["status"] == false) {
        result['error'] = true;
        result["message"] = (jsonDecode(response.body)["message"]);
      } else{
        result['error'] = false;
        List<Banks> banks = [];

        (jsonDecode(response.body)['data'] as List).forEach((dat){
          banks.add(Banks.fromJson(dat));
        });

//        print(banks);
        result['banks'] = banks;
      }

    }catch(e){
      print(e.toString());
    }







//    print(result);
    return result;
  }






  @override
  Future<Map<String, dynamic >> fetchBankAfrica({token, country}) async{
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/lookup/receiving-banks/$country";




    _setHeaders() =>
        {

          "Authorization": "Bearer $token"
        };


    try {
//      print("callalalaed");
      var response = await http.get(url, headers: _setHeaders());
      int statusCode = response.statusCode;
//      print(statusCode);
//      print("${response.body}  resba");
      if (statusCode != 201  && jsonDecode(response.body)["status"] !=  true) {
        result["message"] = jsonDecode(response.body)["message"];

        result['error'] = true;
      } else if (jsonDecode(response.body)["status"] == false) {
        result['error'] = true;
        result["message"] = (jsonDecode(response.body)["message"]);
      } else{
        result['error'] = false;
        List<BanksAfrica> banksAfrica = [];

        (jsonDecode(response.body)['data'] as List).forEach((dat){
          banksAfrica.add(BanksAfrica.fromJson(dat));
        });

//        print(banks);
        result['banks'] = banksAfrica;
      }

    }catch(e){
//      print(e.toString());
    }







//    print(result);
    return result;
  }


  @override
  Future<Map<String, dynamic >> fetchNetworksAfrica({token, country}) async{
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/lookup/receiving-networks/$country";




    _setHeaders() =>
        {

          "Authorization": "Bearer $token"
        };


    try {
//      print("callalalaed mobileMonet");
//      print(url);
      var response = await http.get(url, headers: _setHeaders());
      int statusCode = response.statusCode;
//      print(statusCode);
//      print("${response.body}  resba");
      if (statusCode != 201  && jsonDecode(response.body)["status"] !=  true) {
        result["message"] = jsonDecode(response.body)["message"];

        result['error'] = true;
      } else if (jsonDecode(response.body)["status"] == false) {
        result['error'] = true;
        result["message"] = (jsonDecode(response.body)["message"]);
      } else{
        result['error'] = false;
        List<MobileMoneyModel> mobileMoney = [];

        (jsonDecode(response.body)['data'] as List).forEach((dat){
          mobileMoney.add(MobileMoneyModel.fromJson(dat));
        });
        result['mobileMoney'] = mobileMoney;



//        result['error'] = false;
//        List<BanksAfrica> banksAfrica = [];
//
//        (jsonDecode(response.body)['data'] as List).forEach((dat){
//          banksAfrica.add(BanksAfrica.fromJson(dat));
//        });

//        print(banks);

      }

    }catch(e){
//      print(e.toString());
    }







//    print(result);
    return result;
  }





  @override
  Future<Map<String, dynamic >> resolveBankName({token, account_number, bank_code}) async {
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/lookup/resolve-account-name";


    var body = {
      "account_number": account_number,
        "bank_code" :bank_code
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
      }  else{
        result['error'] = false;

        if( json.decode(response.body)["data"] != null || json.decode(response.body)["data"]["resolved"] != false){
          var accName  = ResolveAccountModel.fromJson( json.decode(response.body)["data"]["data"]);
          result["accName"] = accName;
        }else{
          result["message"] = "No resolve";
        }

      }

    }catch(e){
//      print(e.toString());
    }
//    print(result);
    return result;
  }

  @override
  Future<Map<String,dynamic >> getCharges({token, amount})async {
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/lookup/account-charges";


    var body = {
      "amount": amount,

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
      }  else{
        result['error'] = false;
        result["rate"] = json.decode(response.body)["data"];

      }

    }catch(e){
//      print(e.toString());
    }
//    print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic >> getReceivingCountries({token})async {
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/lookup/bank-transfer-receiver/all";


    _setHeaders() => {
          "Authorization": "Bearer $token"
        };


    try {

      var response = await http.get(url, headers: _setHeaders());
      int statusCode = response.statusCode;
//      print(statusCode);
//      print("${response.body}  resba");
      if (statusCode != 201  && jsonDecode(response.body)["status"] !=  true) {
        result["message"] = jsonDecode(response.body)["message"];

        result['error'] = true;
      } else if (jsonDecode(response.body)["status"] == false) {
        result['error'] = true;
        result["message"] = (jsonDecode(response.body)["message"]);
      } else{
        result['error'] = false;
        List<ReceiveTransfer> receive = [];

        (jsonDecode(response.body)['data'] as List).forEach((dat){
          receive.add(ReceiveTransfer.fromJson(dat));
        });


        result['receivingCountries'] = receive;
      }

    }catch(e){
//      print(e.toString());
    }
//    print(result);
    return result;
  }



  @override
  Future<Map<String, dynamic >> getReceivingCountriesMobileMoney({token})async {
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/lookup/mobile-money-receiver/all";


    _setHeaders() => {
      "Authorization": "Bearer $token"
    };


    try {

      var response = await http.get(url, headers: _setHeaders());
      int statusCode = response.statusCode;
//      print(statusCode);
//      print("${response.body}  resba");
      if (statusCode != 201  && jsonDecode(response.body)["status"] !=  true) {
        result["message"] = jsonDecode(response.body)["message"];

        result['error'] = true;
      } else if (jsonDecode(response.body)["status"] == false) {
        result['error'] = true;
        result["message"] = (jsonDecode(response.body)["message"]);
      } else{
        result['error'] = false;
        List<ReceiveTransfer> receive = [];

        (jsonDecode(response.body)['data'] as List).forEach((dat){

          receive.add(ReceiveTransfer.fromJson(dat));
        });


        result['receivingCountriesMobile'] = receive;
      }

    }catch(e){
//      print(e.toString());
    }
//    print("resrsrsrsrsrs ${result}");
    return result;
  }


  @override
  Future<Map<String, dynamic >> interBankFunding({bank_code, token, account_number, amount, narration}) async{
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/transfer/fiat/wallet/nigeria-bank-account";


    var body = {
      "bank_code": bank_code,
"account_number": account_number,
      "amount" : amount,
      "narration" : narration ?? " "
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
  Future<Map<String, dynamic >> requestForMoney({request_from, token, amount, narration}) async {
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/transfer/fiat/request";


    var body = {
      "request_from": request_from,
      "amount" : amount,
      "narration" : narration
    };


    _setHeaders() =>
        {

          "Authorization": "Bearer $token"
        };

//    print(body);
    try {
      var response = await http.post(url, body: body, headers: _setHeaders());
      int statusCode = response.statusCode;
//      print("${statusCode} cose");
//      print(response.body);
      if (statusCode != 200  && jsonDecode(response.body)["status"] !=  true) {
        result["message"] = jsonDecode(response.body)["message"];

        result['error'] = true;
      } else if (jsonDecode(response.body)["status"] == false) {
        result['error'] = true;
        result["message"] = (jsonDecode(response.body)["message"]);
      } else{
        result['error'] = false;

        var req  = RequestModel.fromJson(json.decode(response.body)["data"]);

        result["request"] = req;
      }

    }catch(e){
//      print(e.toString());
    }
//    print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic >> fetchRequestList({token}) async {
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/transfer/fiat/request/list";




    _setHeaders() =>
        {

          "Authorization": "Bearer $token"
        };


    try {
//      print("callalalaed");
      var response = await http.get(url, headers: _setHeaders());
      int statusCode = response.statusCode;
//      print(statusCode);
//      print(" list${response.body}  ");
      if (statusCode != 201  && jsonDecode(response.body)["status"] !=  true) {
        result["message"] = jsonDecode(response.body)["message"];

        result['error'] = true;
      } else if (jsonDecode(response.body)["status"] == false) {
        result['error'] = true;
        result["message"] = (jsonDecode(response.body)["message"]);
      } else{
        result['error'] = false;
        List<RequestMoneyListModel> requestMoneyModel = [];

        (jsonDecode(response.body)['data'] as List).forEach((dat){
          requestMoneyModel.add(RequestMoneyListModel.fromJson(dat));
        });


        result['requestMoneyModel'] = requestMoneyModel;
      }

    }catch(e){
//      print(e.toString());
    }
//    print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic >> fetchContactList({token,  contacts})async {
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/transfer/fiat/request/contacts";

//print(contacts);

    var body = {
      "contact_list": jsonEncode(contacts)


    };

    _setHeaders() =>
        {
          "Authorization": "Bearer $token"
        };

//  print(jsonEncode(contacts));
    try {
//      print(body);
//      print(url);
      var response = await http.post(url, headers: _setHeaders(), body: body);
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
        List<ContactList> contactList = [];

        (jsonDecode(response.body)['data'] as List).forEach((dat){
          contactList.add(ContactList.fromJson(dat));
        });

//        print(banks);
        result['contactList'] = contactList;
      }

    }catch(e){
//      print(e.toString());
    }
//    print(result);
    return result;
  }


  @override
  Future<Map<String, dynamic >> declineRequest({token, request_id}) async{
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/transfer/fiat/request/decline";



    var body = {
      "request_id": request_id
    };

    _setHeaders() =>
        {
          "Authorization": "Bearer $token"
        };

//    print(body);
    try {
      var response = await http.put(url, headers: _setHeaders(), body: body);
      int statusCode = response.statusCode;
      print(statusCode);
      print(response.body);
      if (statusCode != 201  && jsonDecode(response.body)["status"] !=  true) {
        result["message"] = jsonDecode(response.body)["message"];

        result['error'] = true;
      }else{
        result['error'] = false;
        result['message'] = jsonDecode(response.body)["message"];
      }


    }catch(e){
//      print(e.toString());
    }

    return result;
  }

  @override
  Future<Map<String,dynamic >> interBankFundingAfrica({account_bank, currency, token, account_number, destination_branch_code, beneficiary_name, amount, narration}) async{
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/transfer/fiat/wallet/africa";

    var body = {
      "account_bank": account_bank,
      "account_number": account_number,
      "amount" : amount,
      "narration" : narration ?? " ",
      "destination_branch_code"  : destination_branch_code,
      "beneficiary_name": beneficiary_name,
      "currency" : currency
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
  Future<Map<String, dynamic >> fetchBankBranchAfrica({token, id}) async{
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/lookup/receiving-banks/$id/branches";


    _setHeaders() => {
      "Authorization": "Bearer $token"
    };


    try {

      var response = await http.get(url, headers: _setHeaders());
      int statusCode = response.statusCode;
//      print(statusCode);
//      print("${response.body}  resba");
      if (statusCode != 201  && jsonDecode(response.body)["status"] !=  true) {
        result["message"] = jsonDecode(response.body)["message"];

        result['error'] = true;
      } else if (jsonDecode(response.body)["status"] == false) {
        result['error'] = true;
        result["message"] = (jsonDecode(response.body)["message"]);
      } else{
        result['error'] = false;
        List<BankBranch> branch = [];

        (jsonDecode(response.body)['data'] as List).forEach((dat){
          branch.add(BankBranch.fromJson(dat));
        });


        result['branch'] = branch;
      }

    }catch(e){
//      print(e.toString());
    }
//    print(result);
    return result;
  }

  @override
  Future<Map<String,dynamic >> AcceptRequest({token, request_id}) async{
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/transfer/fiat/request/accept";



    var body = {
      "request_id": request_id
    };

    _setHeaders() =>
        {
          "Authorization": "Bearer $token"
        };

//    print("accprt $body");
    try {
      var response = await http.put(url, headers: _setHeaders(), body: body);
      int statusCode = response.statusCode;
//      print(statusCode);
//      print(response.body);
      if (jsonDecode(response.body)["status"] ==  false) {
        result["message"] = jsonDecode(response.body)["message"];

        result['error'] = true;
      }else{
        result['error'] = false;
        result['message'] = jsonDecode(response.body)["message"];
      }


    }catch(e){
//      print(e.toString());
    }

    return result;
  }

  @override
  Future<Map<String, dynamic >> fundWalletWithCardAfrican({token, amount, card_no, expiry_month, expiry_year, card_security})async {
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/wallet/fiat/fund/local-card/initiate";



    var body = {
      "amount": amount,
      "card_number": card_no,
      "expiry_month": expiry_month.toString(),
      "expiry_year": expiry_year,
      "card_security": card_security
    };

//    .length == 1 ? "0${expiry_month}" : expiry_year.toString()


    _setHeaders() =>
        {
          "Authorization": "Bearer $token"
        };

//  print(body);
    try {
      var response = await http.post(url, headers: _setHeaders(), body: body);
      int statusCode = response.statusCode;
//      print(statusCode);
//      print(response.body);
      if (jsonDecode(response.body)["status"] ==  false  ) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      }else if (statusCode == 200){
//        result['error'] = false;
//        result["card"] = jsonDecode(response.body)["data"]["processor_response"];
        result['error'] = false;
        var card =  LocalCardFund.fromJson(jsonDecode(response.body)["data"]);
        result["card"] = card;
      }else {
        result['error'] = false;
        var card =  LocalCardFund.fromJson(jsonDecode(response.body)["data"]);


        result["card"] = card;
      }


    }catch(e){
//      print(e.toString());
    }
//print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic>> fundWalletWithCardAfricanStep2({token, amount, card_no, expiry_month, expiry_year, card_security, card_pin, transaction_ref, auth_type}) async{
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/wallet/fiat/fund/local-card/charge";



    var body = {
      "amount": amount,
      "card_number": card_no,
      "expiry_month": expiry_month,
      "expiry_year": expiry_year,
      "card_security": card_security,
      "transaction_ref": transaction_ref,
      "auth_mode": auth_type,
      "auth_value": auth_type == "avs_noauth"  ?  jsonEncode(card_pin) :card_pin
    };

    _setHeaders() =>
        {
          "Authorization": "Bearer $token"
        };

//print(body);
    try {
      var response = await http.post(url, headers: _setHeaders(), body: body);
      int statusCode = response.statusCode;
//      print(statusCode);
//      print(response.body);
      if (jsonDecode(response.body)["status"] ==  false) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      }else{
        result['error'] = false;

        result["message"] = jsonDecode(response.body)["data"];
        var card =  LocalCardFund2.fromJson(jsonDecode(response.body));
        result["card2"] = card;
      }


    }catch(e){
//      print(e.toString());
    }



    return result;
  }

  @override
  Future<Map<String, dynamic >> fundWalletWithCardAfricanStep3({token, transaction_ref, otp})async {
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/wallet/fiat/fund/local-card/validate";



    var body = {
      "flutterwave_ref": transaction_ref,
      "otp": otp
    };

    _setHeaders() =>
        {
          "Authorization": "Bearer $token"
        };

//print(url);
//    print(body);

    try {
      var response = await http.post(url, headers: _setHeaders(), body: body);
      int statusCode = response.statusCode;
//      print(statusCode);
//      print(response.body);
      if (jsonDecode(response.body)["status"] !=  true) {
        result["message"] = jsonDecode(response.body)["data"]["message"];
        result['error'] = true;
      }else{
        result['error'] = false;
        result["message"] = jsonDecode(response.body)["data"];
//        var card =  LocalCardFund.fromJson(jsonDecode(response.body)["data"]);
//        result["card"] = card;
      }


    }catch(e){
//      print(e.toString());
    }

    return result;
  }




  @override
  Future<Map<String,dynamic >> fundWalletWithCardAfricanStep4({token, transaction_id}) async{
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/wallet/fiat/fund/local-card/verify";



    var body = {
      "transaction_id": transaction_id.toString(),

    };

    _setHeaders() =>
        {
          "Authorization": "Bearer $token"
        };

//    print(url);
//    print(body);

    try {
      var response = await http.post(url, headers: _setHeaders(), body: body);
      int statusCode = response.statusCode;
//      print(statusCode);
//      print(response.body);
      if (jsonDecode(response.body)["status"] !=  true) {
        result["message"] = jsonDecode(response.body)["data"]["message"];
        result['error'] = true;
      }else{
        result['error'] = false;
        result["message"] = jsonDecode(response.body)["data"];
//        var card =  LocalCardFund.fromJson(jsonDecode(response.body)["data"]);
//        result["card"] = card;
      }


    }catch(e){
//      print(e.toString());
    }

    return result;
  }

  @override
  Future<Map<String, dynamic >> fetchRequestListPending({token}) async {
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/transfer/fiat/request/pending";




    _setHeaders() =>
        {

          "Authorization": "Bearer $token"
        };


    try {
//      print("callalaled Pending");
      var response = await http.get(url, headers: _setHeaders());
      int statusCode = response.statusCode;
//      print(statusCode);
//      print("pending ${response.body}  ");
      if (statusCode != 201  && jsonDecode(response.body)["status"] !=  true) {
        result["message"] = jsonDecode(response.body)["message"];

        result['error'] = true;
      } else if (jsonDecode(response.body)["status"] == false) {
        result['error'] = true;
        result["message"] = (jsonDecode(response.body)["message"]);
      } else{
        result['error'] = false;
        List<RequestMoneyListModel> requestMoneyModelPending = [];

        (jsonDecode(response.body)['data'] as List).forEach((dat){
          requestMoneyModelPending.add(RequestMoneyListModel.fromJson(dat));
        });


        result['requestMoneyModelPending'] = requestMoneyModelPending;
      }

    }catch(e){
//      print(e.toString());
    }
//    print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic >> getFees({token, amount, country_id}) async{
    Map<String, dynamic> result = {};
    final String url = "$stagingUrl/auth/transfer/fiat/fee?amount=$amount&country_id=$country_id";


    _setHeaders() =>
        {

          "Authorization": "Bearer $token"
        };


    try {
      var response = await http.get(url,  headers: _setHeaders());
      int statusCode = response.statusCode;
//      print(statusCode);
//      print(" fee${response.body}");
      if (statusCode != 200  && jsonDecode(response.body)["status"] !=  true) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      }  else{
        result['error'] = false;
        var fee = TransactionFee.fromJson( json.decode(response.body)["data"]);

        result["fee"] = fee;

      }

    }catch(e){
//      print(e.toString());
    }
//    print(result);
    return result;
  }



}




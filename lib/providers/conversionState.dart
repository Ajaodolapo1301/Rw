import 'package:flutter/cupertino.dart';
import 'package:rex_money/api/conversionApi.dart';
import 'package:rex_money/models/history.dart';
import 'package:rex_money/models/increaseLimit.dart';
import 'package:rex_money/models/mobileMoneyModel.dart';

class ConversionState extends AbstractConVersionVieModel with ChangeNotifier {
  List<HistoryModel> _historyModel = [];
  List<HistoryModel> get historyModel => _historyModel;

  set historyModel(List<HistoryModel> historyModel1) {
    _historyModel = historyModel1;
    notifyListeners();
  }




  List<IncreaseLimitModel> _increaseLimit = [];
  List<IncreaseLimitModel> get increaseLimit => _increaseLimit;

  set increaseLimit(List<IncreaseLimitModel> increaseLimit1) {
    _increaseLimit = increaseLimit1;
    notifyListeners();
  }


  List<MobileMoneyModel> _mobileMoneyModel = [];
  List<MobileMoneyModel> get mobileMoneyModel => _mobileMoneyModel;

  set mobileMoneyModel(List<MobileMoneyModel> mobileMoneyModel1) {
    _mobileMoneyModel = mobileMoneyModel1;
    notifyListeners();
  }




  @override
  Future<Map<String, dynamic>> conversion({
    firstCurrency,
    secondCurrency,
    firstAmount,
    token

  }) async {
    Map<String, dynamic> result = Map();

    try {
      result = await Conversion().conversion(
          firstAmount: firstAmount,
          firstCurrency: firstCurrency,
          secondCurrency: secondCurrency,token: token
      );
      if (result['error'] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      }
    } catch (e) {
//      print(e.toString());
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> fundAccount({amount, token}) async {
    Map<String, dynamic> result = Map();

    try {
      result = await Conversion().fundAccount(
        amount: amount,
        token: token,
      );
      if (result['error'] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      }
    } catch (e) {
//      print(e.toString());
    }

//    print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic>> confirmWalletFunding(
      {paymentIntent, paymentMethod, token}) async {
    Map<String, dynamic> result = Map();

    try {
      result = await Conversion().confirmWalletFunding(
          paymentIntent: paymentIntent,
          token: token,
          paymentMethod: paymentMethod);
      if (result['error'] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      }
    } catch (e) {
//      print(e.toString());
    }

//    print(result);
    return result;
  }



  @override
  Future<Map<String, dynamic>> fetchListMobileMoney({token, country_id}) async {
    Map<String, dynamic> result = Map();

    try {
      result = await Conversion().fetchListMobileMoney(
        token: token,
        country_id: country_id
      );
      if (result['error'] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      }else{
        mobileMoneyModel = result["mobileMoney"];
      }
    } catch (e) {
//      print(e.toString());
    }

//    print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic>> fundWalletWithMobileMoney(
      {token, amount, network}) async {
    Map<String, dynamic> result = Map();

    try {
      result = await Conversion().fundWalletWithMobileMoney(
          token: token, amount: amount, network: network);
      if (result['error'] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      }
    } catch (e) {
//      print(e.toString());
    }

//    print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic>> transactionHistory({token,}) async {
    Map<String, dynamic> result = Map();

    try {
      result = await Conversion().transactionHistory(token: token);
      if (result['error'] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      } else {
        _historyModel = result["transactionHistory"];
      }
    } catch (e) {
//      print(e.toString());
    }

//    print(result);
    return result;
  }




  @override
  Future<Map<String, dynamic>> AccountStatement({token,from_date, to_date, page_index, page_size}) async {
    Map<String, dynamic> result = Map();

    try {
      result = await Conversion().AccountStatement(token: token, from_date: from_date, to_date: to_date, page_index: page_index, page_size: page_size);
      if (result['error'] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      } else {
        _historyModel = result["transactionHistory"];
      }
    } catch (e) {
//      print(e.toString());
    }

//    print(result);
    return result;
  }



  @override
  Future<Map<String, dynamic>> userDevice(
      {device_token, device_platform, device_uuid, token}) async {
    Map<String, dynamic> result = Map();
    try {
      result = await Conversion().userDevice(
          token: token,
          device_platform: device_platform,
          device_token: device_token,
          device_uuid: device_uuid);
//      print(result);
      if (result["error"] == null) {
        result["error"] = true;
        result['message'] = result["message"];
      }
    } catch (e) {
//      print(e.toString());
//      print(e.toString());
      result['error'] = true;
      result['message'] = e.toString();
    }
    return result;
  }

  @override
  Future<Map<String, dynamic >> getAccountCharges({token, amount}) async{
    Map<String, dynamic> result = Map();

    try {
      result = await Conversion().getAccountCharges(
        token: token,
        amount: amount
      );
      if (result['error'] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      }
    } catch (e) {
//      print(e.toString());
    }

//    print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic >> listOfLimits({token})async {
    Map<String, dynamic> result = Map();

    try {
      result = await Conversion().listOfLimits(token: token);
      if (result['error'] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      } else {
        _increaseLimit = result["increaseLimit"];
      }
    } catch (e) {
//      print(e.toString());
    }

//    print(result);
    return result;
  }

  @override
  Future<Map<String,dynamic >> applyForLimit({token, limit, utilityBillType, image, reason})async {
    Map<String, dynamic> result = Map();

    try {
      result = await Conversion().applyForLimit(
          token: token,
          limit: limit,
          reason:reason ,
          utilityBillType: utilityBillType,
          image: image
      );
      if (result['error'] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      }
    } catch (e) {
//      print(e.toString());
    }

//    print(result);
    return result;
  }
}









abstract class AbstractConVersionVieModel {
  Future<Map<String, dynamic>> conversion(
      {firstCurrency, secondCurrency, firstAmount, token});
  Future<Map<String, dynamic>> fundAccount({
    amount,
    token,
  });
  Future<Map<String, dynamic>> confirmWalletFunding(
      {paymentIntent, token, paymentMethod});
//  Future<Map<String,dynamic>> walletToWalletFunding({userTag,  token, amount, narration});
//  Future<Map<String,dynamic>> fetchToTransfer({userTag,  token});
  Future<Map<String, dynamic>> userDevice(
      {device_token, device_platform, device_uuid, token});
  Future<Map<String, dynamic>> transactionHistory({token, });

  Future<Map<String, dynamic>> AccountStatement({token, from_date, to_date, page_index, page_size});

  Future<Map<String, dynamic>> fundWalletWithMobileMoney(
      {token, amount, network});
  Future<Map<String, dynamic>> fetchListMobileMoney({token, country_id});
  Future<Map<String,dynamic>> listOfLimits({token});
  Future<Map<String,dynamic>> getAccountCharges({token, amount});
  Future<Map<String,dynamic>> applyForLimit({token, limit, utilityBillType, image, reason});
}

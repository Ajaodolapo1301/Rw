
import 'package:flutter/foundation.dart';
import 'package:rex_money/api/transferApi.dart';
import 'package:rex_money/models/contactList.dart';
import 'package:rex_money/models/receiveTrans.dart';
import 'package:rex_money/models/requestMoneyModel.dart';

abstract class AbstractTransferVieModel{

  Future<Map<String,dynamic>> walletToWalletFunding({userTag,  token, amount, narration});
  Future<Map<String,dynamic>> fetchToTransfer({userTag,  token});
  Future<Map<String,dynamic>> fetchBank({token, country});
  Future<Map<String,dynamic>> getCharges({token, amount});



  Future<Map<String,dynamic>> getFees({token, amount, country_id});
  Future<Map<String,dynamic>> resolveBankName({token, account_number, bank_code});
  Future<Map<String,dynamic>> getReceivingCountries ({token});
  Future<Map<String,dynamic>> interBankFundingAfrica({account_bank, currency, token, account_number, destination_branch_code, beneficiary_name, amount, narration});
  Future<Map<String,dynamic>> interBankFunding({bank_code,  token, account_number, amount, narration});
  Future<Map<String,dynamic>> requestForMoney({request_from,  token, amount, narration});
  Future<Map<String,dynamic>> fetchRequestList({token});
  Future<Map<String,dynamic>> declineRequest({token, request_id});
  Future<Map<String,dynamic>> fetchContactList({token,  contacts});
  Future<Map<String,dynamic>> fetchBankAfrica({token, country});
  Future<Map<String,dynamic>> AcceptRequest({token, request_id});
  Future<Map<String,dynamic>> fetchBankBranchAfrica({token, id});
  Future<Map<String,dynamic>> fundWalletWithCardAfrican({token, amount, card_no,expiry_month,expiry_year, card_security  });
  Future<Map<String,dynamic>> fundWalletWithCardAfricanStep2({token, amount, card_no,expiry_month,expiry_year, card_security, card_pin, transaction_ref, auth_type});
  Future<Map<String,dynamic>> fundWalletWithCardAfricanStep3({token, transaction_ref, otp});
  Future<Map<String,dynamic>> fundWalletWithCardAfricanStep4({token, transaction_id});
  Future<Map<String,dynamic>> fetchRequestListPending({token});
}




class TransferState extends AbstractTransferVieModel with ChangeNotifier{



  List<ReceiveTransfer> _receiverList = [];
  List<ReceiveTransfer> get receiverList => _receiverList;

  set receiverList(List<ReceiveTransfer> receiverList1) {
    _receiverList = receiverList1;
    notifyListeners();
  }


  List<ReceiveTransfer> _receiverListMobileMoney = [];
  List<ReceiveTransfer> get receiverListMobileMoney => _receiverListMobileMoney;

  set receiverListMobileMoney(List<ReceiveTransfer> receiverListMobileMoney1) {
    _receiverListMobileMoney = receiverListMobileMoney;
    notifyListeners();
  }





//Accept or Decline
  List<RequestMoneyListModel> _requestMoneyListModel = [];
  List<RequestMoneyListModel> get requestMoneyListModel => _requestMoneyListModel;

  set requestMoneyListModel(List<RequestMoneyListModel> requestMoneyListModel1) {
    _requestMoneyListModel = requestMoneyListModel1;
    notifyListeners();
  }


//  Pending
  List<RequestMoneyListModel> _requestMoneyListModelPending = [];
  List<RequestMoneyListModel> get requestMoneyListModelPending => _requestMoneyListModelPending;

  set requestMoneyListModelPending(List<RequestMoneyListModel> requestMoneyListModelPending1) {
    _requestMoneyListModelPending = requestMoneyListModelPending1 ;
    notifyListeners();
  }



  List<ContactList> _contactList = [];
  List<ContactList> get contactList => _contactList;

  set contactList(List<ContactList> contactList1) {
    _contactList = contactList1;
    notifyListeners();
  }


  @override
  Future<Map<String, dynamic >> walletToWalletFunding({userTag,  token, amount, narration}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await TransferApi().walletToWalletFunding(amount: amount,  token: token,userTag: userTag, narration: narration);
      if(result['error'] == null){
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      }
    }catch(e){
//      print(e.toString());
    }


//    print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic >> fetchToTransfer({userTag, token}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await TransferApi().fetchToTransfer(token: token, userTag: userTag);
      if(result['error'] == null){
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      }
    }catch(e){
//      print(e.toString());
    }


//    print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic >> fetchBank({token, country})async {
    Map<String, dynamic> result = Map();

    try{
      result = await TransferApi().fetchBank(token: token, country: country);
      if(result['error'] == null){
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      }
    }catch(e){
//      print(e.toString());
    }


//    print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic>> getCharges({token, amount})async {
    Map<String, dynamic> result = Map();

    try{
      result = await TransferApi().getCharges(token: token, amount: amount);
      if(result['error'] == null){
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      }
    }catch(e){
//      print(e.toString());
    }


//    print(result);
    return result;
  }

  @override
  Future<Map<String,dynamic >> resolveBankName({token, account_number, bank_code}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await TransferApi().resolveBankName(token: token, account_number: account_number, bank_code: bank_code);
      if(result['error'] == null){
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      }
    }catch(e){
//      print(e.toString());
    }


//    print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic>> getReceivingCountries({token}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await TransferApi().getReceivingCountries(token: token);
      if(result['error'] == null){
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      }else{
        receiverList = result["receivingCountries"];
//        print(receiverList);
      }
    }catch(e){
//      print(e.toString());
    }


//    print(result);
    return result;
  }



  @override
  Future<Map<String, dynamic>> getReceivingCountriesMobileMoney({token}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await TransferApi().getReceivingCountriesMobileMoney(token: token);
      if(result['error'] == null){
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      }else{
        receiverListMobileMoney = result["receivingCountriesMobile"];

      }
    }catch(e){
//      print(e.toString());
    }


//    print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic >> interBankFunding({bank_code, token, account_number, amount, narration})async {
    Map<String, dynamic> result = Map();

    try{
      result = await TransferApi().interBankFunding(amount: amount,  bank_code:  bank_code, token: token,account_number: account_number, narration: narration);
      if(result['error'] == null){
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      }
    }catch(e){
//      print(e.toString());
    }


//    print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic >> fetchRequestList({token}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await TransferApi().fetchRequestList(token: token);
      if(result['error'] == null){
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      }else{

        requestMoneyListModel = result["requestMoneyModel"];
      }
    }catch(e){
//      print(e.toString());
    }


//    print(result);
    return result;
  }

  @override
  Future<Map<String,  dynamic>> requestForMoney({request_from, token, amount, narration})async {
    Map<String, dynamic> result = Map();

    try{
      result = await TransferApi().requestForMoney(token: token, request_from: request_from, amount: amount, narration: narration, );
      if(result['error'] == null){
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      }
    }catch(e){
//      print(e.toString());
    }


//    print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic >> fetchContactList({token, contacts}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await TransferApi().fetchContactList(token: token, contacts: contacts);
      if(result['error'] == null){
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      }else{
        contactList = result["contactList"];

      }
    }catch(e){
//      print(e.toString());
    }


//    print(result);
    return result;
  }



  @override
  Future<Map<String, dynamic >> declineRequest({token, request_id})async {
    Map<String, dynamic> result = Map();

    try{
      result = await TransferApi().declineRequest(token: token, request_id: request_id );
      if(result['error'] == null){
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      }
    }catch(e){
//      print(e.toString());
    }


//    print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic >> fetchBankAfrica({token, country})async {
    Map<String, dynamic> result = Map();

    try{
      result = await TransferApi().fetchBankAfrica(token: token, country: country);
      if(result['error'] == null){
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      }
    }catch(e){
//      print(e.toString());
    }


//    print(result);
    return result;
  }




  @override
  Future<Map<String, dynamic >> fetchNetworksAfrica({token, country})async {
    Map<String, dynamic> result = Map();

    try{
      result = await TransferApi().fetchNetworksAfrica(token: token, country: country);
      if(result['error'] == null){
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      }
    }catch(e){
//      print(e.toString());
    }


//    print(result);
    return result;
  }








  @override
  Future<Map<String,dynamic >> fetchBankBranchAfrica({token, id}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await TransferApi().fetchBankBranchAfrica(token: token, id: id);
      if(result['error'] == null){
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      }
    }catch(e){
//      print(e.toString());
    }


//    print(result);
    return result;
  }

  @override
  Future<Map<String,dynamic>> interBankFundingAfrica({account_bank, currency, token, account_number, destination_branch_code, beneficiary_name, amount, narration}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await TransferApi().interBankFundingAfrica(token: token,account_bank: account_bank,currency: currency, account_number: account_number, amount: amount, destination_branch_code: destination_branch_code, beneficiary_name: beneficiary_name, narration: narration);
      if(result['error'] == null){
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      }
    }catch(e){
//      print(e.toString());
    }


//    print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic>> AcceptRequest({token, request_id})async {
    Map<String, dynamic> result = Map();

    try{
      result = await TransferApi().AcceptRequest(token: token, request_id: request_id );
      if(result['error'] == null){
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      }
    }catch(e){
//      print(e.toString());
    }


//    print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic >> fundWalletWithCardAfrican({token, amount, card_no, expiry_month, expiry_year, card_security}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await TransferApi().fundWalletWithCardAfrican(token: token, card_security: card_security, card_no: card_no, expiry_month: expiry_month, expiry_year: expiry_year, amount: amount );
      if(result['error'] == null){
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      }
    }catch(e){
//      print(e.toString());
    }


//    print(result);
    return result;
  }

  @override
  Future<Map<String,dynamic >> fundWalletWithCardAfricanStep2({token, amount, card_no, expiry_month, expiry_year, card_security, card_pin, transaction_ref, auth_type}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await TransferApi().fundWalletWithCardAfricanStep2(token: token, card_security: card_security, card_no: card_no, expiry_month: expiry_month, expiry_year: expiry_year, amount: amount,card_pin:card_pin , transaction_ref:transaction_ref, auth_type: auth_type  );
      if(result['error'] == null){
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      }
    }catch(e){
//      print(e.toString());
    }


//    print(result);
    return result;
  }

  @override
  Future<Map<String,dynamic >> fundWalletWithCardAfricanStep3({token, transaction_ref, otp})async {
    Map<String, dynamic> result = Map();

    try{
      result = await TransferApi().fundWalletWithCardAfricanStep3(token: token, otp: otp , transaction_ref: transaction_ref);
      if(result['error'] == null){
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      }
    }catch(e){
//      print(e.toString());
    }


//    print(result);
    return result;
  }

  @override
  Future<Map<String,dynamic >> fundWalletWithCardAfricanStep4({token, transaction_id}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await TransferApi().fundWalletWithCardAfricanStep4(token: token, transaction_id: transaction_id);
      if(result['error'] == null){
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      }
    }catch(e){
//      print(e.toString());
    }


//    print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic >> fetchRequestListPending({token}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await TransferApi().fetchRequestListPending(token: token);
      if(result['error'] == null){
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      }else{

        requestMoneyListModelPending = result["requestMoneyModelPending"];
      }
    }catch(e){
//      print(e.toString());
    }


//    print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic>> getFees({token, amount, country_id}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await TransferApi().getFees(token: token, amount: amount, country_id: country_id);
      if(result['error'] == null){
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      }
    }catch(e){
//      print(e.toString());
    }


//    print(result);
    return result;
  }

}



import 'package:flutter/cupertino.dart';
import 'package:rex_money/api/virtualCardApi.dart';
import 'package:rex_money/models/virtualDollarCard.dart';

class VirtualCardState extends AbstractVirtualVieModel with ChangeNotifier{



  List<VirtualCardModel> _virtualModel = [];
  List<VirtualCardModel> get virtualModel => _virtualModel;

  set virtualModel(List<VirtualCardModel> virtualModel1) {
    _virtualModel = virtualModel1;
    notifyListeners();
  }
  @override
  Future<Map<String,dynamic >> aVirtualCard({token, id}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await VirtualCardApi().aVirtualCard( token: token,id: id);
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
  Future<Map<String,dynamic >> createVirtualCard({card_title, design_code, amount, token,card_type}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await VirtualCardApi().createVirtualCard(amount: amount,  token: token,card_title: card_title, design_code: design_code, card_type: card_type);
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
  Future<Map<String,dynamic >> freezeCard({token, id, type})async {
    Map<String, dynamic> result = Map();

    try{
      result = await VirtualCardApi().freezeCard(id: id,  token: token,type: type);
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
  Future<Map<String,dynamic >> listAllDollarCard({token})async {
    Map<String, dynamic> result = Map();

    try{
      result = await VirtualCardApi().listAllDollarCard(token: token);
      if(result['error'] == null){
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      }else{
        _virtualModel = result["virtualDollarCards"];

      }
    }catch(e){
//      print(e.toString());
    }


//    print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic >> getcardTransaction({token, id, from_date, to_date}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await VirtualCardApi().getcardTransaction(token: token, from_date: from_date, to_date: to_date, id: id);
      if(result['error'] == null){
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      }else{
//        _virtualModel = result["virtualDollarCards"];

      }
    }catch(e){
//      print(e.toString());
    }


//    print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic >> fundCard({token, amount, id}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await VirtualCardApi().fundCard(amount: amount, id: id,  token: token,);
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
  Future<Map<String,dynamic >> listofTitles({token}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await VirtualCardApi().listofTitles( token: token,);
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
  Future<Map<String,dynamic >> listofCardTypes({token}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await VirtualCardApi().listofCardTypes( token: token,);
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
  Future<Map<String,dynamic >> terminateCard({token, id})async {
    Map<String, dynamic> result = Map();

    try{
      result = await VirtualCardApi().terminateCard( token: token,id: id);
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
  Future<Map<String, dynamic >> withdrawCard({token, id, amount}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await VirtualCardApi().withdrawCard( token: token,amount: amount, id: id);
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


abstract class AbstractVirtualVieModel{

  Future<Map<String,dynamic>> createVirtualCard({card_title, design_code, amount, token, card_type});
  Future<Map<String,dynamic>> listAllDollarCard({ token});
  Future<Map<String,dynamic>> aVirtualCard({ token, id});
  Future<Map<String,dynamic>> freezeCard({ token, id, type});
  Future<Map<String,dynamic>> getcardTransaction({ token, id,from_date, to_date });
  Future<Map<String,dynamic>> fundCard({ token, amount, id });
  Future<Map<String,dynamic>> listofTitles({ token});
  Future<Map<String,dynamic>> terminateCard({ token, id});
  Future<Map<String,dynamic>> withdrawCard({ token, id, amount});
  Future<Map<String,dynamic>> listofCardTypes({ token});
}
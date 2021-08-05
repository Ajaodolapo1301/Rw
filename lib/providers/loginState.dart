import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rex_money/api/authApi.dart';
import 'package:rex_money/api/transactionpinService.dart';
import 'package:rex_money/models/continentModel.dart';
import 'package:rex_money/models/flags.dart';
import 'package:rex_money/models/user.dart';

class LoginState extends AbstractLoginViewModel with ChangeNotifier {
  List<ContinentModel> _continent = [];

  List<ContinentModel> get continent => _continent;

  set continent(List<ContinentModel> flags1) {
    _continent = flags1;
    notifyListeners();
  }

  List<Flag> _flags = [];

  List<Flag> get flags => _flags;

  set flags(List<Flag> flags1) {
    _flags = flags1;
    notifyListeners();
  }

  List<States> _states = [];

  List<States> get states => _states;

  set states(List<States> states1) {
    _states = states1;
    notifyListeners();
  }

  User _user;
  Box box;

  User get user => _user;

  set tag(String newTag) {
    _user.userTag = newTag;
    notifyListeners();
  }

//  final auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;

  set user(User value) {
    _user = value;

    notifyListeners();
  }

  LoginState(User value) {
    box = Hive.box("user");
    if (value != null) {
      user = value;
    }
  }

  @override
  Future<Map<String, dynamic>> getflag() async {
    Map<String, dynamic> result = Map();
    try {
      result = await Auth().getflags();

      if (result['error'] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      } else if (result['error'] == false) {
        flags = result['flags'];
      }
    } catch (error) {
//      print("error ${error.toString()}");

      result['error'] = true;
      result['message'] = error.toString();
    }

//    print("harryppp $result");

    return result;
  }

  @override
  Future<Map<String, dynamic>> getStates({id}) async {
    Map<String, dynamic> result = Map();

    try {
      result = await Auth().getStates(id: id);
      if (result['error'] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      } else if (result['error'] == false) {
        states = result['states'];
      }
    } catch (e) {
//      print(e.toString());
    }
//    print("states $result");
    return result;
  }

  @override
  Future<Map<String, dynamic>> getAuthUser({token}) async {
    Map<String, dynamic> result = Map();
    try {
      result = await Auth().getUserDetail(token: token);

//      print("result get user$result");
      if (result['error'] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      } else if (result['error'] == true) {
        result['error'] = true;
        result['message'] = result["message"];
      }
    } catch (error) {
//      print(error.toString());
      result['error'] = true;
      result['message'] = result["message"];
    }

    if (result['error'] == false) {
      User user1 = result['user'];

      user.balance = user1.balance;
      user.profilepic = user1.profilepic;

      user = user;
      notifyListeners();
    }
//    print(result);
    return result;
  }

  @override
  Future<Map<String, dynamic>> login({phone, password}) async {
    Map<String, dynamic> result = Map();
    try {
      result = await Auth().login(phone: phone, password: password);
//      print("result $result");
      if (result["error"] == null) {
        result["error"] = true;
        result['message'] = "An error occured, Please try again";
      }
    } catch (error) {
      result['error'] = true;
      result['message'] = error.toString();
    }

    if (result['error'] == false) {
//      print("Subhanallah");

        print(result['user']);
      var list = await TransactionPinService.hasPin(token: result['user'].token);
//      print("${list} list");
      result["hasPin"] = list.last;
      result["gotPin"] = list.first;
      user = result['user'];

      phoned = phone;
      passwordd = password;
      //
    }

    //print("loginfrom state $user");
    return result;
  }

  void saveUser() {
    box.put('user', user);
  }

  static String phoned;
  static String passwordd;

//

  @override
  Future<Map<String, dynamic>> registerUserStep1(
      {phone, country, state, bvn, continent}) async {
    Map<String, dynamic> result = Map();

    try {
      result = await Auth().registerStep1(
          phone: phone,
          country: country,
          state: state,
          bvn: bvn,
          continent: continent);
//      print(" jsjajsj${result}");
      if (result["error"] == null) {
        result["error"] = true;
        result['message'] = result["message"];
      }
    } catch (error) {
//      print(error.toString());
      result['error'] = true;
      result['message'] = error.toString();
    }

    if (result['error'] == false) {
      result["message"] = result["message"];
    }

//    print("register $result");
    return result;
  }

  @override
  Future<Map<String, dynamic>> validateOtp({phone, otp}) async {
    Map<String, dynamic> result = Map();

    try {
      result = await Auth().validateOtp(phone: phone, otp: otp);
//      print(" jsjajsj${result}");
      if (result["error"] == null) {
        result["error"] = true;
        result['message'] = result["message"];
      }
    } catch (error) {
//      print(error.toString());
      result['error'] = true;
      result['message'] = error.toString();
    }

    if (result['error'] == false) {
      result["message"] = result["message"];
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> registerStep2({
    firstName,
    lastName,
    phoneNumber,
    email,
    residentialAddress,
  }) async {
    Map<String, dynamic> result = Map();
    try {
      result = await Auth().registerStep2(
          firstName: firstName,
          lastName: lastName,
          email: email,
          residentialAddress: residentialAddress,
          phoneNumber: phoneNumber);
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
  Future<Map<String, dynamic>> checkAvailabilty({tagName}) async {
    Map<String, dynamic> result = Map();
    try {
      result = await Auth().checkAvailabilty(tagName: tagName);
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
  Future<Map<String, dynamic>> secureAccount(
      {phone, password, user_tag}) async {
    Map<String, dynamic> result = Map();
    try {
      result = await Auth()
          .secureAccount(password: password, phone: phone, user_tag: user_tag);
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
  Future<Map<String, dynamic>> uploadIdentification(
      {phone, id_type, id_type_url}) async {
    Map<String, dynamic> result = Map();
    try {
      result = await Auth().uploadIdentification(
          phone: phone, id_type: id_type, id_type_url: id_type_url);
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
  Future<Map<String, dynamic>> uploadSelfie({phone, image_url}) async {
    Map<String, dynamic> result = Map();
    try {
      result = await Auth().uploadSelfie(phone: phone, image_url: image_url);
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
  Future<Map<String, dynamic>> verifyBvn({phone, bvn}) async {
    Map<String, dynamic> result = Map();
    try {
      result = await Auth().verifyBvn(phone: phone, bvn: bvn);
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
  Future<Map<String, dynamic>> getContinent() async {
    Map<String, dynamic> result = Map();
    try {
      result = await Auth().getContinent();

      if (result['error'] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      } else if (result['error'] == false) {
        continent = result['continent'];
      }
    } catch (error) {
//      print("error ${error.toString()}");

      result['error'] = true;
      result['message'] = error.toString();
    }

//    print(" rer2$result");
    return result;
  }

  @override
  Future<Map<String, dynamic>> getCountries({id}) async {
    Map<String, dynamic> result = Map();
    try {
      result = await Auth().getCountries(id: id);

      if (result['error'] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please try again';
      } else if (result['error'] == false) {
        flags = result['flags'];
      }
    } catch (error) {
//      print("error ${error.toString()}");

      result['error'] = true;
      result['message'] = error.toString();
    }

    return result;
  }

//  @override
//  Future<Map<String,dynamic >> verifyAccout({token, otp})async {
//    Map<String, dynamic> result = Map();
//    try {
//      result = await Auth().verifyAccout(token: token, otp: otp);
//      print("result$result");
//      if (result["error"] == null) {
//        result["error"] = true;
//        result['message'] = "An error occured, Please try again";
//      }
//    } catch (error) {
//      result['error'] = true;
//      result['message'] = error.toString();
//    }
//
//    if (result['error'] == false) {
//      print("Subhanallah");
//
////      if(result["has_verified_email"]){
//        box.put('user', result['user']);
////      }
//      user = result['user'];
//    }
//
//    print("loginfrom state $user");
//
//    return result;
//  }

}

abstract class AbstractLoginViewModel {
  Future<Map<String, dynamic>> getflag();

  Future<Map<String, dynamic>> login({phone, password});

  Future<Map<String, dynamic>> getCountries({id});

  Future<Map<String, dynamic>> getContinent();

  Future<Map<String, dynamic>> getAuthUser({token});

  Future<Map<String, dynamic>> validateOtp({phone, otp});

  Future<Map<String, dynamic>> registerUserStep1(
      {phone, country, state, bvn, continent});

  Future<Map<String, dynamic>> registerStep2({
    firstName,
    lastName,
    phoneNumber,
    email,
    residentialAddress,
  });

  Future<Map<String, dynamic>> checkAvailabilty({tagName});

  Future<Map<String, dynamic>> getStates({id});

  Future<Map<String, dynamic>> uploadIdentification(
      {phone, id_type, id_type_url});

  Future<Map<String, dynamic>> uploadSelfie({phone, image_url});

  Future<Map<String, dynamic>> verifyBvn({phone, bvn});

  Future<Map<String, dynamic>> secureAccount({phone, password, user_tag});
//  Future<Map<String, dynamic>> verifyAccout({token, otp});
}

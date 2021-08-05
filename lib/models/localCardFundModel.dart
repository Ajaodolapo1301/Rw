//
//class LocalCardFund{
//  int status;
//  String apply_auth;
//  String txnRef;
//  String validate;
//  String message;
//  Meta meta;
//
//  LocalCardFund({this.meta,this.apply_auth, this.message, this.status, this.txnRef, this.validate});
//  factory LocalCardFund.fromJson(Map <String,  dynamic> json)=>LocalCardFund(
//    status: json["status"],
//    apply_auth: json["apply_auth"],
//    txnRef: json["txnRef"],
//    validate: json["validate"],
//    message: json["message"],
//    meta: Meta.fromJson(json["meta"])
//  );
//}
//
//
//
//class Meta{
//  String user_mid;
//  Meta({this.user_mid});
//
//  factory Meta.fromJson(Map <String,  dynamic> json)=>Meta(
//    user_mid: json["user_mid"]
//  );
//}






class LocalCardFund{
  String transaction_ref;
  String auth_mode;
String processor_response;
String auth_model;
String flw_ref;
String tx_ref;
var transaction_id;
  LocalCardFund({this.auth_mode, this.transaction_ref, this.processor_response, this.auth_model, this.flw_ref, this.tx_ref,this.transaction_id});

  factory LocalCardFund.fromJson(Map <String,  dynamic> json)=>LocalCardFund(
    auth_mode: json["auth_mode"] ?? "",
    transaction_ref: json["transaction_ref"] ?? "",
      processor_response:  json["processor_response"] ?? "" ,
      auth_model: json["auth_model"] ?? "",
      flw_ref:  json["flw_ref"] ?? "",
    tx_ref: json["tx_ref"] ?? "",
      transaction_id: json["transaction_id"] ?? ""
  );
}











class LocalCardFund2{
  bool status;
  String message;
  String flutterwave_ref;
  String auth_mode;
  String link;
  LocalCardFund2({this.flutterwave_ref, this.auth_mode, this.status, this.message, this.link});


factory LocalCardFund2.fromJson(Map <String,  dynamic> json)=>LocalCardFund2(
  status: json["status"],
    auth_mode: json ["data"]["auth_mode"],
    flutterwave_ref: json["data"] ["flutterwave_ref"],
  link: json ["data"]["link"],
    message: json["message"]

);

}





//class LocalFundCard2{
//int status;
//String txnRef;
//String auth_type;
//String message;
//
//  LocalFundCard2({this.txnRef, this.auth_type, this.status, this.message});
//
//factory LocalFundCard2.fromJson(Map <String,  dynamic> json)=>LocalFundCard2(
//  status: json["status"],
//  message: json["message"],
//  txnRef: json["txnRef"],
//  auth_type: json["auth_type"]
//
//);
//}





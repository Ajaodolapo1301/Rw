

class ResolveAccountModel {
  String account_name;
  ResolveAccountModel({this.account_name});

  factory ResolveAccountModel.fromJson(Map <String,  dynamic> json)=>ResolveAccountModel(
    account_name: json["account_name"]
  );

}
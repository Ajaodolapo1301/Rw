
class  MobileMoneyModel{
  String network_provider;
  String provider_code;

  MobileMoneyModel({this.network_provider, this.provider_code});

  factory MobileMoneyModel.fromJson(Map <String,  dynamic> json)=>MobileMoneyModel(

    network_provider: json["network_provider"],
    provider_code: json["provider_code"] ?? ""
  );

}


class Banks{
  String bankCode;

  String bankName;

  Banks({this.bankCode, this.bankName});


  factory Banks.fromJson(Map <String,  dynamic> json)=>Banks(
    bankCode: json["bank_code"],
    bankName: json["bank_name"]

  );
}





class BanksAfrica{

  int id;
  String code;

  String name;

  BanksAfrica({this.code, this.id, this.name});


  factory BanksAfrica.fromJson(Map <String,  dynamic> json)=>BanksAfrica(
      id: json["id"],
      code: json["code"],
      name: json["name"]

  );
}
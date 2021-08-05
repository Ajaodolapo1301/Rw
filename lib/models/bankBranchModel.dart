 class BankBranch{
  int id;
  String branch_name;
  String branch_code;
  String swift_code;
  String bic;
  int bank_id;



  BankBranch({this.id, this.bank_id, this.bic, this.branch_code, this.branch_name, this.swift_code});


  factory BankBranch.fromJson(Map <String,  dynamic> json)=>BankBranch(
    id: json["id"],
    bank_id: json["bank_id"],
    bic: json["bic"],
    branch_code: json["branch_code"],
    swift_code: json["swift_code"],
    branch_name: json["branch_name"]
  );


}




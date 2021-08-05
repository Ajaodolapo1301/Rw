 class TransactionFee{
  String country;
  String currency;
  String transfer_fee;

  TransactionFee({this.country, this.currency, this.transfer_fee});

  factory TransactionFee.fromJson(Map <String,  dynamic> json)=>TransactionFee(
    country: json["type_id"],
    currency: json["type_name"],
    transfer_fee: json["transfer_fee"],
  );


 }



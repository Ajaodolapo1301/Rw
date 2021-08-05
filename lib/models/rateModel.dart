


class RateModel{
  bool status;
  String from;
  String to;
  var amount;
  var rate;
  var totalAmount;
  var formated_amount;


  RateModel({this.status, this.amount, this.from, this.rate, this.to, this.totalAmount,this.formated_amount});

  factory RateModel.fromJson(Map <String,  dynamic> json)=>RateModel(
    status: json["status"],
    from: json["data"]["from"],
    to: json["data"]["to"],
    amount: json["data"]["amount"],
    rate: json["data"]["rate"],
      totalAmount: json["data"]["total_amount"],
    formated_amount: json["data"]["formated_amount"]


  );
}


// {"status":true,"data":{"from":"NGN","to":"USD","amount":10,"rate":0,"total_amount":0.03}}
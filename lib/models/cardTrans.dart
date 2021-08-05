class CardTransaction{
int id;
var amount;
var fee;
String product;
String gateway_reference_details;
String reference;
int response_code;
String gateway_reference;
int amount_confirmed;
String narration;
String indicator;
String created_at;
String status;
String response_message;
String currency;

CardTransaction({this.amount, this.id, this.currency, this.amount_confirmed, this.created_at, this.fee, this.gateway_reference, this.gateway_reference_details, this.indicator, this.narration, this.product, this.reference, this.response_code, this.response_message, this.status});

factory CardTransaction.fromJson(Map <String,  dynamic> json)=>CardTransaction(
  id: json["id"],
  amount: json["amount"],
  fee: json["fee"],
  product: json["product"],
  gateway_reference: json["gateway_reference"],
  reference: json["reference"],
  response_code: json["response_code"],
  gateway_reference_details: json["gateway_reference_details"],
  amount_confirmed: json["amount_confirmed"],
  narration: json["narration"],
  indicator: json["indicator"],
  created_at: json["created_at"],
  status: json["status"],
  response_message: json["response_message"],
  currency: json["currency"]

);




}





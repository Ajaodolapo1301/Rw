//
class ASingleVirtualCardModel{
  String id;
  int account_id;
  String  city;
  String state;
String address_1;
  String address_2;
  String zip_code;
  String cvv;
  String currency;
  String masked_pan;
  String card_type;
  String expiration;
  String amount;
  String name_on_card;
  bool is_active;
  String card_hash;
  String card_pan;
  var send_to;
  var bin_check_name;
  String created_at;
  String callback_url;
  ASingleVirtualCardModel({this.id, this.is_active, this.card_hash, this.name_on_card, this.masked_pan,this.amount, this.account_id, this.currency,

    this.card_pan, this.expiration,this.card_type, this.state, this.address_1, this.city, this.address_2, this.cvv, this.zip_code, this.bin_check_name,
    this.callback_url, this.created_at, this.send_to});



  factory ASingleVirtualCardModel.fromJson(Map <String,  dynamic> json)=>ASingleVirtualCardModel(
    id: json["id"],
     account_id:  json["account_id"],
    city: json["city"],
    currency: json["currency"],
    state: json["state"],
    address_1: json["address_1"],
    address_2: json["address_2"],
    zip_code: json["zip_code"],
    callback_url: json["callback_url"],
    cvv: json["cvv"],
    masked_pan: json["masked_pan"],
    card_hash: json["card_hash"],
    card_pan: json["card_pan"],
    is_active: json["is_active"],
    send_to: json["send_to"],
    card_type:  json["card_type"],
    created_at: json["created_at"],
    name_on_card: json["name_on_card"],
    amount: json["amount"],
    expiration: json["expiration"],
    bin_check_name: json["bin_check_name"],
  );

}














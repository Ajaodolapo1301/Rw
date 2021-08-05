
class ReceiveTransfer{
  String country_id;

  Country country;
ReceiveTransfer({this.country, this.country_id});

  factory ReceiveTransfer.fromJson(Map <String,  dynamic> json)=>ReceiveTransfer(
    country: Country.fromJson(json["country"]),
     country_id: json["country_id"]
  );
}



class Country{
  String id;
  String country;
  String symbol;
  String currency;
  String phoneCode;
Country({this.country, this.currency, this.id, this.phoneCode, this.symbol});


  factory Country.fromJson(Map <String,  dynamic> json)=>Country(
      id : json["id"],
      country :json["country"],
      currency :json["currency"],
  symbol : json["symbol"],
  phoneCode :json["phonecode"],


  );



}


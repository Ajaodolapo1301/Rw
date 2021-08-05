class TagFetch{
  String id;
  String country;
  String symbol;
  String currency;
  String phonecode;
  String rate_off;
  String flag;

  TagFetch({this.symbol, this.rate_off, this.phonecode, this.id, this.flag, this.currency, this.country});


  factory TagFetch.fromJson(Map <String,  dynamic> json)=>TagFetch(
    symbol: json["symbol"],
    id: json["id"],
    currency: json["currency"],
    country: json["country"],
    phonecode: json["phonecode"],
    flag: json["flag"],
    rate_off: json["rate_off"],
  );

}


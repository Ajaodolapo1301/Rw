
class ContactList{
 String full_name;
 String user_tag;
 String country_id;
 String country;
String currency;
String symbol;
 ContactList({this.full_name, this.user_tag, this.currency, this.country, this.country_id, this.symbol});

 factory ContactList.fromJson(Map <String,  dynamic> json)=>ContactList(
   full_name: json["full_name"],
   user_tag: json["user_tag"],
  country_id: json["country_id"],
  country: json["country"],
  currency: json["currency"],
  symbol: json["symbol"]

 );
}


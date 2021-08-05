
class Flag{
  String id;
  String country;
  String symbol;
  String currency;
  String phoneCode;
  String flag;
//  List <States> states;

  Flag({this.country, this.currency, this.flag, this.id, this.phoneCode, this.symbol});

  Flag.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    country = json["country"];
    currency = json["currency"];
    symbol = json["symbol"];
    phoneCode = json["phonecode"];
    flag = json["flag"];
//    if (json['states'] != null) {
//      states = new List<States>();
//      json['states'].forEach((v) {
//        states.add(States.fromJson(v));
//      });
//    }
  }

}



class States {
  String state;

  States({this.state});


  States.fromJson(Map<String, dynamic> json) {
    state = json["state"];
  }
}



import 'package:hive/hive.dart';

part 'user.g.dart';



@HiveType()
class User extends HiveObject{

  @HiveField(0)
  String firstName;



  @HiveField(1)
  String email;




  @HiveField(2)
  String token;

  @HiveField(3)
  String phone;

  @HiveField(4)
  String user_mid;


  @HiveField(5)
  String lastName;



  @HiveField(6)
  var balance;

  @HiveField(7)
  String country;


  @HiveField(8)
  String currency;

  @HiveField(9)
  String symbol;

  @HiveField(10)
  String flag;

  @HiveField(11)
  String bankAccount;
  @HiveField(12)
  String bankAaccountNumber;

  @HiveField(13)
  String bankAccountName;
  @HiveField(14)
  String referralCode;

  @HiveField(15)
  String userTag;





  @HiveField(16)
  String profilepic;


  @HiveField(17)
 String continent;



  @HiveField(18)
  bool with_card;

  @HiveField(19)
  bool with_local_card;

  @HiveField(20)
  bool with_mobile_money;

  @HiveField(21)
  bool with_bank_transfer;


  @HiveField(22)
  bool is_compliant;

  @HiveField(23)
  String referral_code ;

  @HiveField(24)
  String country_id ;

  User({this.firstName,  this.referralCode, this.token, this.email,  this.phone, this.user_mid, this.lastName, this.balance, this.bankAaccountNumber, this.bankAccount, this.bankAccountName, this.country, this.currency, this.flag, this.symbol, this.userTag, this.profilepic, this.continent, this.with_bank_transfer, this.with_card, this.with_local_card, this.with_mobile_money, this.is_compliant, this.referral_code, this.country_id});


  factory User.fromJson(Map <String,  dynamic> json)=>User(
      token: json['token'] ?? "",
      firstName :json['user']['firstname'] ?? "",
      lastName: json["user"]["lastname"]  ?? "",
      email : json['user']['email']?? "",
      phone : json['user']['phone_number']?? "",
      user_mid: json["user"]["user_mid"]?? "",
    referralCode: json["user"]["referral_code"]?? "",
    userTag: json["user"]["user_tag"]?? "",
      referral_code: json["user"]["referral_code"] ?? "",
      profilepic: json["user"]["profile_image"] ?? "",



      balance: json["wallet"]["balance"] ?? "",
      currency: json["wallet"]["currency"] ?? "",
      country: json["wallet"]["country"] ?? "",
      symbol: json["wallet"]["symbol"] ?? "",
      flag: json["wallet"]["flag"] ?? "",

      continent: json["wallet"]["continent"] ?? "",

      country_id: json["wallet"]["country_id"] ?? "",
      with_card: json["wallet"]["funding"]["with_card"] ?? "",
      with_local_card: json["wallet"]["funding"]["with_local_card"]?? "",

      with_mobile_money: json["wallet"]["funding"]["with_mobile_money"] ?? "",
      with_bank_transfer: json["wallet"]["funding"]["with_bank_transfer"]?? "",
      is_compliant: json["is_compliant"]?? "",
    bankAccount: json["account"]["bank_account"] ?? "",
      bankAaccountNumber: json["account"]["bank_account_number"] ?? "",
    bankAccountName: json["account"]["bank_account_name"]?? ""
  );



  factory User.fromJson2(Map<String, dynamic> json) => User(
    profilepic: json["user"]["profile_image"] ?? "",
      firstName :json['user']['firstname'] ?? "",
      lastName: json["user"]["lastname"]  ?? "",
      email : json['user']['email']?? "",
      phone : json['user']['phone_number']?? "",
      user_mid: json["user"]["user_mid"]?? "",
      balance: json["wallet"]["balance"] ?? "",
    continent: json["wallet"]["continent"] ?? "",
    country: json["wallet"]["country"] ?? "",
    symbol: json["wallet"]["symbol"] ?? "",
    flag: json["wallet"]["flag"] ?? "",
    bankAccount: json["account"]["bank_account"] ?? "",
    bankAaccountNumber: json["account"]["bank_account_number"] ?? "",
    bankAccountName: json["account"]["bank_account_name"]?? "",
    currency: json["wallet"]["currency"] ?? "",

    country_id: json["wallet"]["country_id"] ?? "",

  );


}



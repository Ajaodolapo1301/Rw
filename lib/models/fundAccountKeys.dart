class FundAccountKey{
  String publishableKey;
  String clientSecret;

  FundAccountKey({this.clientSecret, this.publishableKey});

  factory FundAccountKey.fromJson(Map <String,  dynamic> json)=>FundAccountKey(
      publishableKey: json['publishableKey'],
      clientSecret :json['clientSecret'],

  );
}


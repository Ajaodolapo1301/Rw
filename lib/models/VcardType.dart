 class VirtualcardTypes{
  String type_id;
  String type_name;
  String creation_fee;
  String image_url;
  String description;
  String funding_min;
  String funding_max;
  String termination_fee;
  String termination_rate;

  VirtualcardTypes({this.creation_fee, this.description, this.funding_max, this.funding_min, this.image_url, this.termination_fee, this.termination_rate, this.type_id, this.type_name});


  factory VirtualcardTypes.fromJson(Map <String,  dynamic> json)=>VirtualcardTypes(
      type_id: json["type_id"],
      type_name: json["type_name"],
    creation_fee: json["creation_fee"],
      image_url: json["image_url"],
      description: json["description"],
    funding_max: json["funding_max"],
    funding_min: json["funding_min"],
    termination_fee: json["termination_fee"],
    termination_rate: json["termination_rate"],


  );
 }








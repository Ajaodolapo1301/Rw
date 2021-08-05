
class IncreaseLimitModel{
  String level;
  String package_type;
  String package_name;
  String limit;
  String description;



  IncreaseLimitModel({this.description, this.level, this.limit, this.package_name, this.package_type});

  factory IncreaseLimitModel.fromJson(Map <String,  dynamic> json)=>IncreaseLimitModel(
  level: json["level"],
    package_name: json["package_name"],
      package_type: json["package_type"],
    limit: json["limit"],
    description: json["description"],
  );

}




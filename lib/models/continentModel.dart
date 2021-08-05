

class ContinentModel{
String continent_id;
String continent_name;

ContinentModel({this.continent_id, this.continent_name});

factory ContinentModel.fromJson(Map <String,  dynamic> json)=>ContinentModel(
  continent_id: json["continent_id"],
  continent_name: json["continent_name"]
);

}

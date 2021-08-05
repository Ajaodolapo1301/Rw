






class VirtualCardlist{
  String card_title;
  int id;
  VirtualCardlist({this.card_title, this.id});

  factory VirtualCardlist.fromJson(Map <String,  dynamic> json)=>VirtualCardlist(
    card_title: json["card_title"],
    id: json["id"]

  );
}


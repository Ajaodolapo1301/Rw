

class RequestModel{
  String request_id;
  String requester_tag;
  String sender_tag;
  int amount_requested;
  String narration;
  int id;


  RequestModel({this.id, this.narration, this.amount_requested, this.request_id, this.requester_tag, this.sender_tag});

  factory RequestModel.fromJson(Map <String,  dynamic> json)=>RequestModel(

    request_id: json["request_id"],
    requester_tag: json["requester_tag"],
     sender_tag: json["sender_tag"] ,
    amount_requested: json["amount_requested"],
    narration: json["narration"],
    id: json["id"]

  );


}


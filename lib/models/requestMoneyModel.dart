//RequestMoneyListModel
class RequestMoneyListModel{
  String request_id;
  String firstname;
  String lastname  ;
  String amount_converted;
  String requester_tag;
  String sender_tag;
  String amount_requested;
  String narration;
  String request_status;
  String created_at;
  RequestMoneyListModel({this.amount_requested, this.narration, this.request_id, this.request_status, this.requester_tag, this.sender_tag, this.created_at, this.amount_converted, this.firstname, this.lastname});

  factory RequestMoneyListModel.fromJson(Map <String,  dynamic> json)=>RequestMoneyListModel(

    request_id: json["request_id"],
    request_status: json["request_status"],
    sender_tag: json["sender_tag"],
    amount_requested: json["amount_requested"],
    narration: json["narration"],
    requester_tag: json["requester_tag"],
    created_at: json["created_at"],
     amount_converted: json["amount_converted"],
    firstname: json["firstname"],
    lastname: json["lastname"]
  );
}


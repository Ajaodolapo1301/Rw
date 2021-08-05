





class HistoryModel{
  String id;
  String date;
  String amount;
String transaction_id;
  String remark;

  String type;
    String status;
  HistoryModel({this.remark,this.amount, this.date, this.type, this.id, this.status, this.transaction_id});




  factory HistoryModel.fromJson(Map <String,  dynamic> json)=>HistoryModel(
    id: json["id"],
    date: json["created_at"],
    type: json["type"],
    amount: json["amount"],
    remark: json["remark"],
    status: json["status"],
    transaction_id: json["transaction_id"]

  );

}






class AccountStatement {
  bool status;
  int message;
 List <StatementModel> statementModel;

  AccountStatement({this.status, this.statementModel, this.message});

  AccountStatement.fromJson(Map<String, dynamic> json) {
    status = json['status'];
//    message = int.parse(json["message"]);
    if (json['data'] != null || json['data'] != Null) {
      statementModel = new List<StatementModel>();
      try {
        json['data'].forEach((v) {
          statementModel.add(new StatementModel.fromJson(v));
        });
      } catch (e) {}
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.statementModel != null) {
      data['data'] = this.statementModel.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class StatementModel{
  String id;
  String date;
  String amount;
  String remark;

  String type;
  String status;
  StatementModel({this.remark,this.amount, this.date, this.type, this.id, this.status});




  StatementModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    date = json["created_at"];
    type =json["type"];
    amount = json["amount"];
    remark = json["remark"];
    status = json["status"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["type"] = type;
    data["amount"] =  amount;
   data["remark"] = remark;
    data["status"] = status;
    data["id"] = id;
    data["created_at"] = date;
    return data;
  }
}






import 'package:rex_money/constants/stringsConstants.dart';

class VirtualCardModel{
 String card_id;
 String card_title;
 String designCode;
 String currency;
 String masked_pan;
 String expiration;
 String name_on_card;
 String is_active;

 VirtualCardModel({this.card_id, this.card_title, this.currency,this.designCode, this.expiration, this.is_active, this.masked_pan, this.name_on_card});

 factory VirtualCardModel.fromJson(Map <String,  dynamic> json)=>VirtualCardModel(
   card_id: json["card_id"],
   card_title: json["card_title"],
   designCode: json["design_code"],
   currency:   json["currency"],
   masked_pan: json["masked_pan"],
   expiration:  json["expiration"],
   name_on_card: json["name_on_card"],
     is_active: json["is_active"]

 );
}

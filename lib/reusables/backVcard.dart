
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rex_money/models/aSingleVirtualCardModel.dart';
import 'package:rex_money/models/virtualDollarCard.dart';

class Back extends StatelessWidget {
  final VirtualCardModel virtualCardModel;
  final ASingleVirtualCardModel aSingleVirtualCardModel;
  Back({this.aSingleVirtualCardModel, this.virtualCardModel});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: <Widget>[
        Container(

          margin: const EdgeInsets.only(top: 16),
          height: 48,
          width: double.infinity,
          color: Colors.black,
          child: Center(child: Text(aSingleVirtualCardModel == null ? " " :  aSingleVirtualCardModel.card_pan, style: GoogleFonts.mavenPro(color: Colors.white, fontSize: 20),)),
        ),
//        Container(
//          margin: const EdgeInsets.only(top: 16),
//          child: Row(
//            crossAxisAlignment: CrossAxisAlignment.center,
//            children: <Widget>[
//              Expanded(
//                flex: 9,
//                child: Container(
//                  height: 38,
//                  color: Colors.white70,
//                ),
//              ),
//              Expanded(
//                flex: 3,
//                child: Container(
//                  color: Colors.white,
//                  child: Padding(
//                    padding: const EdgeInsets.all(5),
//                    child: Text(
//                      'XXX',
//
//                      maxLines: 1,
//                  style: TextStyle(color: Colors.black),
//                    ),
//                  ),
//                ),
//              )
//            ],
//          ),
//        ),
//          Expanded(
//            flex: 2,
//            child: Align(
//              alignment: Alignment.bottomRight,
//              child: Padding(
//                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
//                child: getCardTypeIcon(widget.cardNumber),
//              ),
//            ),
//          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          children: [
            Expanded(
              flex: 3,
              child: Container(

                margin: const EdgeInsets.only(top: 16),
                height: 30,
                width: double.infinity,
                color: Colors.grey,
                child: Center(child: Text("", style: GoogleFonts.mavenPro(color: Colors.white),)),
              ),
            ),
            SizedBox(width: 10,),
            Text(aSingleVirtualCardModel == null ? " " :  aSingleVirtualCardModel.cvv),          SizedBox(width: 10,),

          ],
        ),


      ],
    );
  }






}
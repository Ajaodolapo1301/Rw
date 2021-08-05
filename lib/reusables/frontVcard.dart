
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/models/aSingleVirtualCardModel.dart';
import 'package:rex_money/models/virtualDollarCard.dart';





class Front extends StatelessWidget {
  final VirtualCardModel virtualCardModel;
  final String color;
  final ASingleVirtualCardModel aSingleVirtualCardModel;
  Front({this.virtualCardModel, this.aSingleVirtualCardModel, this.color});
  @override
  Widget build(BuildContext context) {
    return Container(

      margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("VIRTUAL USD CARD", style: GoogleFonts.mavenPro(fontWeight: FontWeight.bold, fontSize: 9, color: color =="3F2B4B" ? Colors.white :  kPrimaryColor),),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SvgPicture.asset("images/logorex.svg"),
              )
            ],),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset("images/chip.png"),
              Spacer(),
              SvgPicture.asset("images/rexText.svg", color: color =="3F2B4B" ? Colors.white : null),
              Spacer()
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Card Name", style: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 5, color: color =="3F2B4B" ? Colors.white :  kPrimaryColor),),
                  Text(virtualCardModel.card_title, style: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 9, color: color =="3F2B4B" ? Colors.white :   kPrimaryColor),),
                ],
              ),

              aSingleVirtualCardModel == null ? Container() :     Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Expiration", style: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 5, color: color =="3F2B4B" ? Colors.white :  kPrimaryColor),),

                      Text("${aSingleVirtualCardModel.expiration} ", style: GoogleFonts.raleway(fontSize: 10, fontWeight: FontWeight.bold,color: kPrimaryColor),),
                    ],
                  ),
                  SizedBox(width: 5,),
                  aSingleVirtualCardModel.card_type == "mastercard" ? Image.asset("images/masterRex.png"): Image.asset("images/visaBlue.png")
                ],
              ) ,
            ],
          )
        ],
      ),
    );
  }
}
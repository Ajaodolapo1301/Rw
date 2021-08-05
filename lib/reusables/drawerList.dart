import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rex_money/constants/colorConstants.dart';



class DrawerList extends StatelessWidget {
  final text;
  final subtext;
  final color;
  final colorSub;
  DrawerList({this.subtext, this.text, this.color, this.colorSub});

  @override
  Widget build(BuildContext context) {
    return Container(

      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(text, style: GoogleFonts.raleway(color:   color, fontSize: 13, fontWeight: FontWeight.bold),),
                  Text(subtext, style: GoogleFonts.raleway(color: colorSub, fontSize: 10, fontWeight: FontWeight.w500))
                ],
              ),
          Spacer(),

              IconButton(icon: Icon(Icons.keyboard_arrow_right_sharp, size: 20, color: kPrimaryColor,), onPressed: null)
            ],
          ),

          Divider()
        ],
      ),
    );
  }
}

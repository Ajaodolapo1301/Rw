
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rex_money/constants/colorConstants.dart';

class Voila extends StatefulWidget {
  @override
  _VoilaState createState() => _VoilaState();
}

class _VoilaState extends State<Voila> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            SvgPicture.asset("images/voila.svg"),
            Text("Voila!", style: GoogleFonts.mavenPro(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 36),),
            Text("Account Creation was", style: GoogleFonts.raleway(color: kPrimaryColor,  fontSize: 14),),
        Text("successful, kindly log in!", style: GoogleFonts.raleway(color: kPrimaryColor,  fontSize: 14)),



            Spacer(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.maxFinite,
                height: 50,
                child: RaisedButton(
                  onPressed: () {
//                            if (_formKey.currentState.validate()) {
//            Navigator.push(context, FadeRoute(page: Upload()));
//                            }
                  },
                  child: Text(
                    "SIGN IN",
                    style: GoogleFonts.mavenPro(
                      fontSize: 16,


                    ),
                  ),
                  color: kPrimaryColor,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              ),
            ),

            SizedBox(height: 45),
          ],
        ),
      ),
    );
  }
}

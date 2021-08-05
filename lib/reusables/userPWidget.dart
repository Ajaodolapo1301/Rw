


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/models/contactList.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';

class UserPContainer extends StatelessWidget {
  const UserPContainer({
    Key key,
    @required this.loginState,
    @required this.themeChangeProvider,
  }) : super(key: key);

  final LoginState loginState;
  final DarkThemeProvider themeChangeProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: kprimaryLight.withOpacity(0.1)
      ),
      width: double.infinity,
      height: 94.94,
      child: Row(
        children: [

          SizedBox(width:20,),
          CircleAvatar(
            radius: 30,

            backgroundColor: kprimaryLight.withOpacity(0.5),
            child: Container(
              height: 43,
              width: 40,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image:  NetworkImage(loginState.user.profilepic != null ? loginState.user.profilepic : " " )
                  ),
                  borderRadius: BorderRadius.circular(50)

              ),
//          height: 79,
//            width: 75,
//            child: Image.network(loginState.user.profilepic != null ? loginState.user.profilepic : " " , fit: BoxFit.cover,)
            ),
          ),


          SizedBox(width:10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${loginState.user.firstName} ${loginState.user.lastName}", style: GoogleFonts.raleway(
                color: themeChangeProvider.darkTheme ? kPrimaryDarkText : kPrimaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 19,
              ) ),
              SizedBox(height:5,),
              Row(
                children: [
                  Text(loginState.user.bankAaccountNumber, style: GoogleFonts.raleway(
                    color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  )),

                  SizedBox(width:5,),
                  GestureDetector(

                      onTap: (){
                        Clipboard.setData(new ClipboardData(text: loginState.user.bankAaccountNumber));

                        toast("Copied to Clipboard");



                      },


                      child: SvgPicture.asset("images/copy.svg"))
                ],
              )
            ],
          ),





        ],
      ),
    );
  }
}


class UserContainer extends StatelessWidget {
  const UserContainer({
    Key key,
    @required this.contactList,
    @required this.themeChangeProvider,
    this.index,
    this.selected
  }) : super(key: key);

  final ContactList contactList;
  final DarkThemeProvider themeChangeProvider;
  final  selected;
  final index;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: kprimaryLight.withOpacity(0.1)
          ),
          width: double.infinity,
          height: 66.94,
          child: Row(
            children: [

              SizedBox(width:20,),
              CircleAvatar(
                radius: 26,

                backgroundColor: kprimaryLight.withOpacity(0.5),
                child: Container(
                  child: Text("${contactList.full_name[0] }${contactList.full_name[1]}", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                ),
              ),


              SizedBox(width:10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${contactList.full_name}".toUpperCase(), style: GoogleFonts.mavenPro(
                    color: themeChangeProvider.darkTheme ? kPrimaryDarkText : kPrimaryColor,
                    fontSize: 12,
                  ) ),
                  SizedBox(height:5,),
                  Row(
                    children: [
                      Text( " @${contactList.user_tag}", style: GoogleFonts.raleway(
                        color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 9,
                      )),



                    ],
                  )
                ],
              ),

              Spacer(),
              AnimatedOpacity(opacity: selected == index ? 1:0,
                  duration: Duration(milliseconds: 300),
                  child: Material(
                    elevation: 3,
                    shape: CircleBorder(),
                    child: Container(
                      height: 13,
                      width: 13,
                      child: Icon(Icons.check, size: 10, color: Colors.white,),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle
                      ),
                    ),
                  )),
              SizedBox(width:10,),

            ],
          ),
        ),

        SizedBox(height: 5,)


      ],
    );
  }
}
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloudinary_client/cloudinary_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/animation/fadeRoute.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/providers/appState.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/reusables/dialoPopup.dart';
import 'package:rex_money/reusables/preloader.dart';
import 'package:rex_money/screens/auth/selfie.dart';
import 'package:rex_money/screens/auth/userTag.dart';
import 'package:rex_money/utils/commonUtils.dart';
import 'package:rex_money/utils/exi.dart';
import 'package:rex_money/utils/systemUtils.dart';

class Upload extends StatefulWidget {
  final phone;

  Upload({this.phone});
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {

  String moi;
  int _index;
  LoginState loginState;
  AppState appState;
  File _image;
  List<String> firstVer = [
    'International Passport',
    'Drivers License',
    'National Id',
    'Permanent Voters Card (PVC)'
  ];

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
String picUrl;

  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String error = 'Error';
bool isLoading =false;

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }



  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
    await themeChangeProvider.darkThemePreference.getTheme();
  }


  @override
  Widget build(BuildContext context) {
    loginState = Provider.of<LoginState>(context);
    appState = Provider.of<AppState>(context);
    themeChangeProvider = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
      appBar: AppBar(
          centerTitle: true,
        backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: kprimaryYellow,
          ),
          onPressed: () => Navigator.pop(context),
        ),

        title: Text("Upload ID", style: GoogleFonts.mavenPro(color:  themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor, fontWeight: FontWeight.bold),),
      ),
body: Container(
    height: MediaQuery.of(context).size.height,
  child:   Column(
    children: [
      SizedBox(height: _image == null ?  MediaQuery.of(context).size.height * 0.05 :  MediaQuery.of(context).size.height * 0.02),
  //    SizedBox(height: MediaQuery.of(context).size.height * 0.05),


      _image == null ?   Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "3/4",
              style: GoogleFonts.raleway(color:  themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ) : Container(),
      SizedBox(height:  _image == null ? 10 : 0),
      _image == null ?  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
            color: themeChangeProvider.darkTheme ? kPrimaryDarkTextField : kPrimaryColor.withOpacity(0.1)

            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: DropdownButtonHideUnderline(
                child: new DropdownButton<String>(
                  dropdownColor:  themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
                  isExpanded: true,
                  hint: Text(
                    moi == null ? "Select means of Identity" : moi,
                    style: GoogleFonts.raleway(fontSize: 13, color:  themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,),
                  ),
                  items: (firstVer)
                      .map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value, style: GoogleFonts.raleway(fontSize: 13,   color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor),),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      print(value);
                      moi = value;
                        appState.imagesSelectedType = value;
                      if (moi == 'International Passport') {
                        _index = 0;
                      } else if (moi == 'Drivers License') {
                        _index = 1;
                      } else if (moi == 'National Id') {
                        _index = 2;
                      } else if (moi == 'Proof of residence') {
                        _index = 0;
                      } else if (moi == 'Proof of Address') {
                        _index = 1;
                      } else if (moi == 'Proof of income') {
                        _index = 2;
                      } else {
                        _index = 3;
                      }
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ) :

     Padding(
       padding: const EdgeInsets.only(left: 20),
       child: Row(
         mainAxisAlignment: MainAxisAlignment.start,
         children: [
           Text("$moi preview", style: GoogleFonts.mavenPro(fontSize: 13, color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,),),
         ],
       ),
     ),
//      SizedBox(height: MediaQuery.of(context).size.height * 0.05),

      Column(
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          _image == null
              ? GestureDetector(

              onTap: () {
            if(moi != null){


              getImageByCamera();
//              getImageByGallery();
            }else{
              toast("Pick a document to upload");
            }
          },
              child:  SvgPicture.asset( _index == null ?  "images/snapShot.svg" : _index == 0 ? "images/intlPass.svg" : _index == 1 ? "images/driver.svg" : _index == 2 ? "images/idPic.svg" : "images/snapShot.svg",   color: themeChangeProvider.darkTheme ? kprimaryYellow : null,

                  height:  MediaQuery.of(context).size.height * 0.38
              ), )
              :
                  ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Image.file(
              _image,
              fit: BoxFit.cover,
             height: MediaQuery.of(context).size.height * 0.5 ,
              width: 276,
            ),
          ),


          SizedBox(height: MediaQuery.of(context).size.height * 0.05),

        ],
      ),



//      SizedBox(height: MediaQuery.of(context).size.height * 0.0),

      Spacer(),

   moi == null  ?Container() :   _image == null ?  Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: double.maxFinite,
          height: 50,
          child: RaisedButton(
            onPressed: () {
              if(moi != null){
                getImageByCamera();
              }else{
                toast("Pick a document to upload");
              }
            },
            child: Text(
              "TAKE A PHOTO",
              style: GoogleFonts.mavenPro(
                fontSize: 16,

                  fontWeight: FontWeight.bold
              ),
            ),
            color: kprimaryYellow,
            padding: EdgeInsets.symmetric(vertical: 15),
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
          ),
        ),
      ) :

      Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: double.maxFinite,
          height: 50,
          child: RaisedButton(
            onPressed: ()  async{

          cloud();


            },
            child: Text(
              "PROCEED",
              style: GoogleFonts.mavenPro(
                fontSize: 16,

                  fontWeight: FontWeight.bold
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
      SizedBox(height: 15),
//      moi == null  ?Container() :     _image == null ?   Container(
//        margin: EdgeInsets.symmetric(horizontal: 20),
//        child: SizedBox(
//          width: double.maxFinite,
//          height: 50,
//          child: RaisedButton(
//            onPressed: () {
//              if(moi != null){
//
//  //              chooseImage();
//
//                getImageByGallery();
//              }else{
//                toast("Pick a document to upload");
//              }
//            },
//            child: Text(
//              "Choose from GALLERY".toUpperCase(),
//              style: GoogleFonts.mavenPro(
//                fontSize: 16,
//              ),
//            ),
//            color: kPrimaryColor,
//            padding: EdgeInsets.symmetric(vertical: 15),
//            textColor: Colors.white,
//            shape: RoundedRectangleBorder(
//              borderRadius: BorderRadius.circular(7),
//            ),
//          ),
//        ),
//      ) :Container(),



      SizedBox(height: 35),
    ],
  ),
),
    );
  }


cloud()async{

setState(() {
  isLoading = true;
});

if (isLoading) {
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Preloader();
      });
}



  CloudinaryClient client = new CloudinaryClient("734211642123311", "ghT9LjkHFAsZSCdhpu_Fzo0j9gI","rexwire");



  var response = await client.uploadImage(_image.path, folder: CloudinaryFolderStaging.IdentificationDocument);


  print(response.secure_url);
  setState(() {
    picUrl = response.secure_url;
  });
  var result = await loginState.uploadIdentification(phone: widget.phone ?? "2347067927251", id_type_url: picUrl, id_type:moi);

if (isLoading) {
  Navigator.pop(context, true);
}
    if (result['error'] == true) {
      CommonUtils.showMsg(result["message"], themeChangeProvider, context, _scaffoldKey, Colors.red);
    } else{
      Navigator.push(context, MaterialPageRoute(builder: (context)=> Selfie(
        phone: widget.phone,
      )));
//      showDialog(context: context, child: dialogPopup(
//          themeDark: themeChangeProvider.darkTheme,
//          body:
//          Text(
//            "Successful!! ${ result['message']}",
//            textAlign:
//            TextAlign.center,
//            style: TextStyle(
//                inherit:
//                false,
//                fontSize:
//                18,
//                color:themeChangeProvider.darkTheme ? Colors.white:
//                Colors.black),
//          ),
//          buttonText:
//          "Ok",
//          onPressed:
//              () =>
//              Navigator.push(context, MaterialPageRoute(builder: (context)=> Selfie(
//                phone: widget.phone,
//              )))



    }

  }





//  Navigator.push(context, FadeRoute(page: UserTag(
//  imagePath: picUrl,
//  phone: widget.phone,
//
//  )));




  Future getImageByGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 20, maxHeight: 500.0, maxWidth: 500.0);
    var imag = await fixExifRotation(image.path);
    setState(() {
      _image = imag;
    });

  }

  Future getImageByCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 20, maxHeight: 500.0, maxWidth: 500.0);
    var imag = await fixExifRotation(image.path);
    setState(() {
      _image = imag;
    });

  }


}

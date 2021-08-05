//import 'dart:io';
//
//import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';
//import 'package:rex_money/models/user.dart';
//import 'package:rex_money/providers/darkmode.dart';
//import 'package:google_fonts/google_fonts.dart';
//import 'package:firebase_ml_vision/firebase_ml_vision.dart';
//import 'package:provider/provider.dart';
//
//import 'package:rex_money/constants/colorConstants.dart';
//import 'package:rex_money/providers/appState.dart';
//
//import 'package:rex_money/providers/loginState.dart';
//import 'package:rex_money/reusables/preloader.dart';
//
//
//
//class Selfie extends StatefulWidget {
//  @override
//  _SelfieState createState() => _SelfieState();
//}
//
//class _SelfieState extends State<Selfie> with TickerProviderStateMixin {
//
//  LoginState loginState;
//  AppState appState;
//  final _scaffoldKey = GlobalKey<ScaffoldState>();
//  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
//
//
//
//
//
//  @override
//  void initState() {
//    getCurrentAppTheme();
//    super.initState();
//  }
//
//
//
//  void getCurrentAppTheme() async {
//    themeChangeProvider.darkTheme =
//    await themeChangeProvider.darkThemePreference.getTheme();
//  }
//  FileClass profilePicture = FileClass();
//  String textString = "";
//  @override
//  Widget build(BuildContext context) {
//    loginState = Provider.of<LoginState>(context);
//    appState = Provider.of<AppState>(context);
//    themeChangeProvider = Provider.of<DarkThemeProvider>(context);
//
//    return Scaffold(
//      key: _scaffoldKey,
//      backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
//      appBar: AppBar(
//        centerTitle: true,
//        backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.transparent,
//        leading: IconButton(
//          icon: Icon(
//            Icons.arrow_back,
//            color: kprimaryYellow,
//          ),
//          onPressed: () => Navigator.pop(context),
//        ),
//
//        title: Text("Upload ID", style: GoogleFonts.mavenPro(color:  themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor, fontWeight: FontWeight.bold),),
//      ),
//
//      body: Column(
//        children: [
//          Center(
//            child: Column(
//              children: [
//                Stack(
//                  children: [
////                        info2.profilePicture == "users/default.png"
//                    //Use the condition above when you want to add profile back.
//
//
//            Container(
//            width: 130,
//              height: 130,
//              decoration: BoxDecoration(
//                  color: buttonColor,
//                  shape: BoxShape.circle
//              ),
//            ),
//
////                      ClipRRect(
////                        child: Image.file(
////                          profilePicture.file ,
////                          width: 150,
////                          height: 150,
////                          fit: BoxFit.cover,
////                        ),
////                        borderRadius: BorderRadius.circular(120),
////                      ),
//                    //REMOVE THIS "if(false)" when you want to add profile back
////                        if(false)
//
//            GestureDetector(
//                        onTap: () async {
//                          profilePicture.file = await snapProfilePicture();
//                          print(profilePicture.file);
//                          if (profilePicture.file != null) {
//                            print("Not null");
//                            final image = FirebaseVisionImage.fromFile(
//                                profilePicture.file);
//                            final faceDetector =
//                            FirebaseVision.instance.faceDetector(
//                              FaceDetectorOptions(
//                                mode: FaceDetectorMode.accurate,
//                                enableLandmarks: true,
//                              ),
//                            );
//                            showDialog(
//                              context: context,
//                              barrierDismissible: false,
//                              builder: (BuildContext context) {
//                                return Preloader();
//                              },
//                            );
//                            final fac =
//                            await faceDetector.processImage(image);
//                            Navigator.pop(context);
//                            if (fac.isEmpty) {
//                              textString = "No face detected";
//                            } else if (fac.length > 1) {
//                              textString = "More than one face detected";
//                            } else {
//                              textString = "";
//                            }
//                            print(fac);
//                            print(textString);
//                            if (textString.isNotEmpty) {
//                              setState(() {
//                                profilePicture.file = null;
//                              });
//                            _scaffoldKey.currentState.showSnackBar(SnackBar(
//                                content: Text(
//                                  textString,
//                                  style: GoogleFonts.karla(
//                                      color: Colors.white),
//                                ),
//                                backgroundColor: Colors.red,
//                              ));
//                            }
//                            setState(() {
//                              textString = "";
//                            });
//                            print(profilePicture.file);
//                          }
//                        },
//                        child: Container(
//                          //Padding was added to increase tap region
//                          padding: EdgeInsets.symmetric(
//                            vertical: 10,
//                            horizontal: 10,
//                          ),
//                          child: Image.asset(
//                              "images/back2.png",
//                            width: 35,
//                          ),
//                        ),
//                      ),
//
//                  ],
//                ),
//                if(profilePicture.file != null)FlatButton(
//                  onPressed: (){
//                    setState(() {
//                      profilePicture.file = null;
//                    });
//                  },
//                  child: Text("Reset Image"),
//                ),
//                SizedBox(height: 5),
//
//              ],
//            ),
//          ),
//        ],
//      ),
//    );
//
//
//  }
//  final picker = ImagePicker();
//  Future<File> snapProfilePicture() async {
//    final pickedFile = await picker.getImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
//    if (pickedFile != null) {
//      return File(pickedFile.path);
//    } else {
//      return null;
//    }
//  }
//
//
//}
//class FileClass {
//  File file;
//
//  @override
//  String toString() {
//    super.toString();
//    return "${file.path}";
//  }
//
//  void changeFile(File newFile) {
//    file = newFile;
//  }
//}


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
import 'package:rex_money/screens/auth/userTag.dart';
import 'package:rex_money/utils/commonUtils.dart';
import 'package:rex_money/utils/exi.dart';
import 'package:rex_money/utils/systemUtils.dart';

class Selfie extends StatefulWidget {
  final phone;

  Selfie({this.phone});
  @override
  _SelfieState createState() => _SelfieState();
}

class _SelfieState extends State<Selfie> {




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

        title: Text("Selfie", style: GoogleFonts.mavenPro(color:  themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor, fontWeight: FontWeight.bold),),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child:   Column(
          children: [
            SizedBox(height: _image == null ?  MediaQuery.of(context).size.height * 0.05 :  30),
            //    SizedBox(height: MediaQuery.of(context).size.height * 0.05),


            _image == null ?   Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "4/4",
                    style: GoogleFonts.raleway(color:  themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ) : Container(),


//      SizedBox(height: MediaQuery.of(context).size.height * 0.05),





          Align(
            child: Container(
              height:  MediaQuery.of(context).size.height * 0.5,

              decoration: BoxDecoration(
                color: Color(0xffF2EEF4),
                borderRadius: BorderRadius.circular(200)
              ),
              width: 300,
              child:  _image == null ? Container() :      ClipRRect(
                borderRadius: BorderRadius.circular(200),
//                borderRadius: BorderRadius.all(Radius.elliptical(100, 50)),
                child: Image.file(
                  _image,
                  fit: BoxFit.cover,
                  height:  MediaQuery.of(context).size.height * 0.6,
                  width: 300,
                ),
              ),
            ),
          ),
SizedBox(height: 20,),
          InkWell(
              onTap: ()  {
      getImageByCamera();

//                getImageByGallery();

              },

              child: Material(
                shape: CircleBorder(),
//
                elevation: 0.9,
                child: Container(
                  width: 61,
                  height: 61,
                  decoration: BoxDecoration(
                      color: kPrimaryColor ,
                      borderRadius: BorderRadius.circular(50.0),
                      border: Border.all(color:  kPrimaryColor, width: 4.0,  )
                  ),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          border: Border.all(color: Colors.white, width: 2.0)
                      ),
                      ),
                ),
              ),
            ),


//            Column(
//              children: <Widget>[
//                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
//                _image == null
//                    ? GestureDetector(
//
//                    onTap: () {
//                      if(moi != null){
//
//                      }else{
//                        toast("Pick a document to upload");
//                      }
//                    },
//                    child: SvgPicture.asset("images/snapShot.svg",   color: themeChangeProvider.darkTheme ? kprimaryYellow : null,))
//                    :
//
//
//                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
//
//              ],
//            ),



//      SizedBox(height: MediaQuery.of(context).size.height * 0.0),

            Spacer(),

            _image == null ? Container()



//            Container(
//              margin: EdgeInsets.symmetric(horizontal: 20),
//              child: SizedBox(
//                width: double.maxFinite,
//                height: 50,
//                child: RaisedButton(
//                  onPressed: () {
//                    if(moi != null){
//
//
//                      getImageByCamera();
//                    }else{
//                      toast("Take a Selfie");
//                    }
//                  },
//                  child: Text(
//                    "TAKE A PHOTO",
//                    style: GoogleFonts.mavenPro(
//                      fontSize: 16,
//
//
//                    ),
//                  ),
//                  color: kprimaryYellow,
//                  padding: EdgeInsets.symmetric(vertical: 15),
//                  textColor: Colors.white,
//                  shape: RoundedRectangleBorder(
//                    borderRadius: BorderRadius.circular(7),
//                  ),
//                ),
//              ),
//            )


                :

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
//            _image == null ?   Container(
//              margin: EdgeInsets.symmetric(horizontal: 20),
//              child: SizedBox(
//                width: double.maxFinite,
//                height: 50,
//                child: RaisedButton(
//                  onPressed: () {
//                    if(moi != null){
//
//
//
//                    }else{
//                      toast("Pick a document to upload");
//                    }
//                  },
//                  child: Text(
//                    "GALLERY",
//                    style: GoogleFonts.mavenPro(
//                      fontSize: 16,
//                    ),
//                  ),
//                  color: kPrimaryColor,
//                  padding: EdgeInsets.symmetric(vertical: 15),
//                  textColor: Colors.white,
//                  shape: RoundedRectangleBorder(
//                    borderRadius: BorderRadius.circular(7),
//                  ),
//                ),
//              ),
//            ) :Container(),



            SizedBox(height: 35),
          ],
        ),
      ),
    );
  }


  cloud()async{
    print("uploadinf");
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
    var response = await client.uploadImage(_image.path, folder: CloudinaryFolderStaging.selfie);


    print(response.secure_url);
    setState(() {
      picUrl = response.secure_url;
    });
    var result = await loginState.uploadSelfie(phone: widget.phone ?? "2347067927251", image_url: picUrl, );

    if (isLoading) {
      Navigator.pop(context, true);
    }
    if (result['error'] == true) {
      CommonUtils.showMsg(result["message"], themeChangeProvider, context, _scaffoldKey, Colors.red);
    } else{
      Navigator.push(context, MaterialPageRoute(builder: (context)=> UserTag(
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
//              Navigator.push(context, MaterialPageRoute(builder: (context)=> UserTag(
//                phone: widget.phone,
//              )))
//
//      ));

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
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.front, imageQuality: 20, maxHeight: 500.0, maxWidth: 500.0);
    var imag = await fixExifRotation(image.path);
    setState(() {
      _image = imag;
    });

  }


}

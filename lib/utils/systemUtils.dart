import 'package:flutter/material.dart';

class SystemProperties{

  static const String appPackageAndroid = "co.rexwire";
  static const String appIDIOS = "co.rexWire";

}

class CloudinaryFolderStaging{
  static const String selfie = "staging_user_selfie";
  static const String IdentificationDocument = "staging_user_identification";
  static const String LimitDocument = "staging_user_limit_compliance";
}



class CloudinaryFolderProd {
  static const String selfie = "prod_user_selfie";
  static const String IdentificationDocument = "prod_user_identification";
  static const String LimitDocument = "prod_user_limit_compliance";
}



//
// class SizeConfig {
//   static MediaQueryData _mediaQueryData;
//   static double screenWidth;
//   static double screenHeight;
//   static double blockSizeHorizontal;
//   static double blockSizeVertical;
//
//   static double _safeAreaHorizontal;
//   static double _safeAreaVertical;
//   static double safeBlockHorizontal;
//   static double safeBlockVertical;
//
//   void init(BuildContext context) {
//     _mediaQueryData = MediaQuery.of(context);
//     screenWidth = _mediaQueryData.size.width;
//     screenHeight = _mediaQueryData.size.height;
//     blockSizeHorizontal = screenWidth / 100;
//     blockSizeVertical = screenHeight / 100;
//
//     _safeAreaHorizontal = _mediaQueryData.padding.left +
//         _mediaQueryData.padding.right;
//     _safeAreaVertical = _mediaQueryData.padding.top +
//         _mediaQueryData.padding.bottom;
//     safeBlockHorizontal = (screenWidth -
//         _safeAreaHorizontal) / 100;
//     safeBlockVertical = (screenHeight -
//         _safeAreaVertical) / 100;
//   }
// }
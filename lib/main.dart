import 'dart:convert';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:camera/camera.dart';
import 'package:camera/new/src/common/camera_interface.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:device_info/device_info.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/providers/appState.dart';
import 'package:rex_money/providers/conversionState.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/infiniteScroll.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/providers/transferState.dart';
import 'package:rex_money/providers/virtualCardState.dart';


import 'package:rex_money/screens/auth/splashPage.dart';

import 'package:rex_money/utils/sizeConfig/sizeConfig.dart';
import 'package:rex_money/utils/systemUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_redirect/store_redirect.dart';

import 'constants/colorConstants.dart';
import 'models/user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);

  Hive.registerAdapter(UserAdapter());

  await Hive.openBox("user");
  final box = Hive.box("user");
  User user = box.get('user', defaultValue: null);
  final SharedPreferences sharedPref = await SharedPreferences.getInstance();
  String hasUsedApp = sharedPref.getString("OPEN_APP");
  String token = sharedPref.getString("token");
  bool hasUserUsedApp =
      hasUsedApp != null && hasUsedApp.isNotEmpty ? false : true;
  bool hasUserLogged = token != null && token.isNotEmpty ? true : false;

//  var res = await loginState.getAuthUser(token: loginState.user.token);
//  print("res$res");

  runApp(
    DevicePreview(
      enabled: false,
      //enabled: !kReleaseMode,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LoginState(user)),
          ChangeNotifierProvider(create: (_) => ConversionState()),
          ChangeNotifierProvider(create: (_) => AppState()),
          ChangeNotifierProvider(create: (_) => TransferState()),
          ChangeNotifierProvider(create: (_) => VirtualCardState()),
//        ChangeNotifierProvider(create: (_) => DataProvider()),
        ],
        child: MyApp(
          user: user,
        ),
      ), // Wrap your app
    ),
  );
//  SharedPreferences.setMockInitialValues({});
}

class MyApp extends StatefulWidget {
  final User user;

  MyApp({this.user});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
//  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  var deviceId;
  var myDeviceToken;
  AppState appState;
  LoginState loginState;
  ConversionState conversionState;

//  List<String> numbersToSend = [];
  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];
  Map<String, Color> contactsColorMap = new Map();

  @override
  void initState() {
    getPermissions();
    super.initState();

    getCurrentAppTheme();

    getDeviceDetails().then((value) {
      print(value);
      setState(() {
        appState.deviceId = value[2];
      });
    });
  }

  getPermissions() async {
    if (await Permission.contacts.request().isGranted) {
      getAllContacts();
//      searchController.addListener(() {
//        filterContacts();
//      });
    }
  }

  getAllContacts() async {
    List colors = [Colors.green, Colors.indigo, Colors.yellow, Colors.orange];
    int colorIndex = 0;
    List<Contact> _contacts =
        (await ContactsService.getContacts(withThumbnails: false)).toList();
    _contacts.forEach((contact) {
      Color baseColor = colors[colorIndex];
      contactsColorMap[contact.displayName] = baseColor;
      colorIndex++;
      if (colorIndex == colors.length) {
        colorIndex = 0;
      }
    });


    setState(() {
      _contacts.forEach((element) {
        element.phones.forEach((element) {
          appState.numbersToSend.add(element.value.toString());
        });
      });
    });
    print("number ${appState.numbersToSend}");
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  static Future<List<String>> getDeviceDetails() async {
    String deviceName;
    String deviceVersion;
    String identifier;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.toString();
        identifier = build.androidId; //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor; //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
//if (!mounted) return;
    return [deviceName, deviceVersion, identifier];
  }

  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);
    loginState = Provider.of<LoginState>(context);
    conversionState = Provider.of<ConversionState>(context);
    return ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget child) {
          return LayoutBuilder(
            builder: (context, constraints){

              return OrientationBuilder(
                builder: (context, orientation){
                  SizeConfig().init(constraints, orientation);
                  return  OverlaySupport(
                    child: GestureDetector(
                      onTap: () {
                        FocusScopeNode currentFocus = FocusScope.of(context);

                        if (!currentFocus.hasPrimaryFocus &&
                            currentFocus.focusedChild != null) {
                          currentFocus.focusedChild.unfocus();
                        }
                      },
                      child: MaterialApp(
                          debugShowCheckedModeBanner: false,
                          theme:
                          Styles.themeData(themeChangeProvider.darkTheme, context),
                          home: SplashPage(
                            user: widget.user,
                          )
//                  Self()

//                  SplashPage(
//              user: widget.user,
//              )

                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// class ProviderConfig extends InheritedWidget {
//   final RemoteConfig remote;
//   final Map appConfig = {};
//
//   ProviderConfig({
//     Key key,
//     Widget child,
//     this.remote,
//   }) : super(key: key, child: child);
//
//   @override
//   bool updateShouldNotify(InheritedWidget oldWidget) {
//     print("$remote remotting");
//     return true;
//   }
//
//   static Provider of(BuildContext context) =>
//       (context.inheritFromWidgetOfExactType(Provider) as Provider);
// }
//
// Future<RemoteConfig> setupRemoteConfig() async {
//   print("tttt remote config");
//
//   final RemoteConfig remoteConfig = await RemoteConfig.instance;
// //  String msg ="Dear Customer, Our services are unavailable at the moment. please contact support for more information.";
//
//   remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: false));
//
//   try {
//     await remoteConfig.notifyListeners();
//     await remoteConfig.fetch(expiration: const Duration(seconds: 0));
//     await remoteConfig.activateFetched();
//     await remoteConfig.getBool("android_active");
//     await remoteConfig.getString("current_android_version");
//
//     remoteConfig.setDefaults(<String, dynamic>{
//       'current_ios_version': '1.0.0',
//       'current_android_version': '1.0.0',
//       'ios_active': true,
//       'android_active': true,
//       'android_update_mandatory': true,
//       'ios_update_mandatory': true,
// //      'ios_deactivation_msg':msg,
// //      'android_deactivation_msg':msg,
//     });
//     print("$remoteConfig remote cong");
//     return remoteConfig;
//   } catch (e) {
//     print("${e.toString()} from here");
//     return null;
//   }
// }

//
//void showAndroidExitDialog(BuildContext context, String msg){
//  showDialog(context: context,
//      barrierDismissible: false,
//      useRootNavigator: false,
//      builder: (context){
//        return WillPopScope(
//          onWillPop: ()async{
//            return false;
//          },
//          child: AlertDialog(
//            contentPadding: const EdgeInsets.only(bottom: 50, left: 20, right: 20, top: 10),
//            title: Text("Alert!"),
//            content: Text(msg),
//          ),
//        );
//      });
//}
//
//void showIOSExitDialog(BuildContext context, String msg){
//  showDialog(context: context,
//      barrierDismissible: false,
//      builder: (context){
//        return CupertinoAlertDialog(
//          title: Text("Alert!"),
//          content: Text(msg),
//        );
//      });
//}

void showAndroidUpdateDialog(BuildContext context, bool mandatory) {
  showDialog(
      context: context,
      barrierDismissible: !mandatory,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return !mandatory;
          },
          child: AlertDialog(
            contentPadding:
                const EdgeInsets.only(bottom: 10, left: 20, right: 20, top: 10),
            title: Text("New Version Available"),
            content: Text(
                "Your version of Glade mobile app is currently outdated, Please visit android store to get the latest version"),
            actions: <Widget>[
              (mandatory)
                  ? Container()
                  : FlatButton(
                      child: Text("Later"),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    ),
              FlatButton(
                child: Text("Update Now"),
                onPressed: () {
                  StoreRedirect.redirect(
                      androidAppId: SystemProperties.appPackageAndroid,
                      iOSAppId: SystemProperties.appIDIOS);
                },
              ),
            ],
          ),
        );
      });
  print("mandatory comimg from the back $mandatory");
}

void showIOSUpdateDialog(BuildContext context, bool mandatory) {
  showDialog(
      context: context,
      barrierDismissible: !mandatory,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return !mandatory;
          },
          child: CupertinoAlertDialog(
            title: Text("New Version Available"),
            content: Text(
                "Your version of Glade mobile app is currently outdated. Please visit Apple store to get the latest version"),
            actions: <Widget>[
              (mandatory)
                  ? Container()
                  : FlatButton(
                      child: Text("Later"),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    ),
              FlatButton(
                child: Text("Update Now"),
                onPressed: () {
                  StoreRedirect.redirect(
                      androidAppId: SystemProperties.appPackageAndroid,
                      iOSAppId: SystemProperties.appIDIOS);
                },
              ),
            ],
          ),
        );
      });
}

Future<bool> checkConfig(BuildContext context) async {
  print("popping dialog");
  RemoteConfig config = Provider.of(context).remote;

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String buildnum = packageInfo.buildNumber;

  String version = "${packageInfo.version.trim().replaceAll(".", "")}$buildnum";

  if (Theme.of(context).platform == TargetPlatform.android) {
    String currentVersion = config
        .getString("current_android_version")
        .trim()
        .replaceAll(".", "")
        .replaceAll("+", "");
    String currentIOsVersion = config
        .getString("current_ios_version")
        .trim()
        .replaceAll(".", "")
        .replaceAll("+", "");

    print(
        "currentV${currentVersion.trim().replaceAll(".", "").replaceAll("+", "")}");
    print("userV$version}");

    bool isMandatory = config.getBool("android_update_mandatory");

//    if(!config.getBool("android_active")){
//      if(Provider.of(context).appConfig['showingPopUP']??false){
//        return false;
//      }
//      Provider.of(context).appConfig['showingPopUP'] = true;
//      showAndroidExitDialog(context,Provider.of(context).remote.getString("ios_deactivation_msg"));
//      return false;
//    }

    if (int.parse(currentVersion) > int.parse(version)) {
      // show dialog
      print("current status $isMandatory");
      showAndroidUpdateDialog(context, isMandatory);
    }
  } else if (Theme.of(context).platform == TargetPlatform.iOS) {
    bool isMandatory = config.getBool("ios_update_mandatory");
    String currentIOsVersion = config
        .getString("current_ios_version")
        .trim()
        .replaceAll(".", "")
        .replaceAll("+", "");
//    if (!config.getBool("ios_active")) {
//      if(Provider.of(context).appConfig['showingPopUP']??false){
//        return false;
//      }
//      showIOSExitDialog(context, Provider.of(context).remote.getString("ios_deactivation_msg"));
//      return false;
//    }

    print("$isMandatory iosMand");
    print("$currentIOsVersion currentIos");

    if (int.parse(currentIOsVersion) > int.parse(version)) {
      // show dialog
      showIOSUpdateDialog(context, isMandatory);
    }
  }
  return true;
}

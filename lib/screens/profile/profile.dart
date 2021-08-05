import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/api/profileService.dart';
import 'package:rex_money/reusables/preloader.dart';

import '../../constants/colorConstants.dart';
import '../../providers/darkmode.dart';
import '../../providers/loginState.dart';
import '../../reusables/customTextField.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  LoginState loginState;

  TabController tabController;

  TextEditingController userTagTec;

  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  var passwordKey = GlobalKey<FormState>();

  @override
  void initState() {
    getCurrentAppTheme();
    tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    themeChangeProvider = Provider.of<DarkThemeProvider>(context);
    loginState = Provider.of<LoginState>(context);
    if (userTagTec == null) {
      userTagTec = TextEditingController(text: loginState.user.userTag);
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor:
            themeChangeProvider.darkTheme ? Colors.black : Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(18.0),
          child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset("images/leftIcon.svg")),
        ),
        centerTitle: true,
        title: Text(
          "Profile",
          style: GoogleFonts.mavenPro(color: kPrimaryColor, fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              CircleAvatar(
                radius: 75,
                backgroundColor: kprimaryLight.withOpacity(0.4),
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(loginState.user.profilepic != null
                            ? loginState.user.profilepic
                            : " ")),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text("${loginState.user.firstName} ${loginState.user.lastName}",
                  style: GoogleFonts.raleway(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(loginState.user.bankAaccountNumber,
                      style: GoogleFonts.raleway(
                        color: themeChangeProvider.darkTheme
                            ? Colors.white
                            : kPrimaryColor.withOpacity(0.4),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      )),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(
                        new ClipboardData(
                          text: loginState.user.bankAaccountNumber,
                        ),
                      );

                      toast("Copied to Clipboard");
                    },
                    child: SvgPicture.asset(
                      "images/copy.svg",
                    ),
                  )
                ],
              ),
              SizedBox(height: 15),
              Stack(
                overflow: Overflow.visible,
                children: [
                  Positioned.fill(
                    top: 46,
                    bottom: 0,
                    child: Container(
                      height: 1,
                      color: Colors.grey[200],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: TabBar(
                      indicatorColor: kOwe,
                      controller: tabController,
                      labelColor: kPrimaryColor,
                      unselectedLabelColor: kprimaryLight,
                      tabs: [
                        Tab(
                          child: Text(
                            "Personal",
                            style: GoogleFonts.mavenPro(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Password",
                            style: GoogleFonts.mavenPro(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    Form(
                      key: formKey,
                      child: ListView(
                        padding: EdgeInsets.all(10),
                        children: [
                          CustomTextField(
                            header: "User Tag",
                            controller: userTagTec,
                            prefixText: "@ ",
                            color: kprimaryLight,
                            validator: (v) {
                              if (v.trim().isEmpty) {
                                return "Tag cannot be empty";
                              }
                              if (v.trim() == loginState.user.userTag) {
                                return "Nothing to update";
                              }
                            },
                          ),
                          CustomTextField(
                            header: "Limit",
                          ),
                          SizedBox(height: 10),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: SizedBox(
                              width: double.maxFinite,
                              height: 50,
                              child: RaisedButton(
                                onPressed: () {
                                  if (formKey.currentState.validate()) {
                                    updateProfile(context);
                                  }
                                },
                                child: Text(
                                  "UPDATE PROFILE",
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
                        ],
                      ),
                    ),
                    Form(
                      key: passwordKey,
                      child: ListView(
                        padding: EdgeInsets.all(10),
                        children: [
                          CustomTextField(
                            header: "Old Password",
                            controller: passwordController,
                            validator: (v) {
                              if (v.trim().isEmpty) {
                                return "Old password is required";
                              }

                              return null;
                            },
                          ),
                          CustomTextField(
                            header: "New Password",
                            controller: newPasswordController,
                            validator: (v) {
                              if (v.trim().isEmpty) {
                                return "New password is required";
                              }

                              return null;
                            },
                          ),
                          CustomTextField(
                            header: "Confirm Password",
                            controller: confirmPasswordController,
                            validator: (v) {
                              if (v != newPasswordController.text) {
                                return "Passwords don't match";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: SizedBox(
                              width: double.maxFinite,
                              height: 50,
                              child: RaisedButton(
                                onPressed: () {
                                  if (passwordKey.currentState.validate()) {
                                    updatePassword(context);
                                  }
                                },
                                child: Text(
                                  "UPDATE PASSWORD",
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
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void updateProfile(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Preloader();
      },
    );
    bool worked = await ProfileService.changeUserTag(
        token: loginState.user.token, newUserTag: userTagTec.text.trim());
    Navigator.pop(context);
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content:
            Text(worked ? "Tag Updated" : "Something went wrong. Try again."),
        backgroundColor: worked ? Colors.purple : Colors.red,
      ),
    );
    if (worked) {
      loginState.tag = userTagTec.text.trim();
    }
  }

  void updatePassword(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Preloader();
      },
    );
    List worked = await ProfileService.changePassword(
      token: loginState.user.token,
      newPassword: newPasswordController.text,
      oldPassword: passwordController.text,
    );
    Navigator.pop(context);

    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content:
        Text(worked.last),
        backgroundColor: worked.first ? Colors.purple : Colors.red,
      ),
    );
  }
}

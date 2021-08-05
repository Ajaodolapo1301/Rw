
import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/animation/fadeRoute.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/models/aSingleVirtualCardModel.dart';
import 'package:rex_money/models/tagFetch.dart';

import 'package:rex_money/providers/appState.dart';
import 'package:rex_money/providers/conversionState.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/providers/loginState.dart';
import 'package:rex_money/providers/transferState.dart';
import 'package:rex_money/providers/virtualCardState.dart';
import 'package:rex_money/reusables/customTextField.dart';
import 'package:rex_money/reusables/dialoPopup.dart';
import 'package:rex_money/reusables/preloader.dart';
import 'package:rex_money/reusables/userPWidget.dart';
import 'package:rex_money/screens/auth/login.dart';
import 'package:rex_money/screens/home.dart';
import 'package:rex_money/screens/state/notifSuccess.dart';
import 'package:rex_money/utils/commonUtils.dart';
import 'package:stream_transform/stream_transform.dart';



class RequestMoneyTag extends StatefulWidget {

  final amount;
  final narration;
  RequestMoneyTag({this.amount, this.narration});

  @override
  _RequestMoneyTagState createState() => _RequestMoneyTagState();
}

class _RequestMoneyTagState extends State<RequestMoneyTag> with AfterLayoutMixin<RequestMoneyTag> {


  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _formKey = new GlobalKey<FormState>();
  AppState appState;

  var clear = false;
  TagFetch tagFetch;
  bool  error = false;
  DarkThemeProvider darkThemeProvider;
  LoginState loginState;
  bool isRequesting = false;
bool tegError = false;
  bool isButtonDisaled = true;
  ConversionState conversionState;
  ASingleVirtualCardModel aSingleVirtualCardModel;
  bool freezingLoading = false;
  bool isFetchingLoading = false;
  VirtualCardState virtualCardState;
  TransferState transferState;
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  TextEditingController _tagName = TextEditingController();
  StreamController<String> streamController = StreamController();
  bool userTagLoading = false;
  int _selectedCard = -1;
  @override
  void initState() {
    getCurrentAppTheme();

    streamController.stream
        .transform(debounce(Duration(milliseconds: 1000)))
        .listen((s) => _validateTag());
    super.initState();
  }



  _validateTag() {
//    print("called tag");
    if (_tagName.text.length > 3 ) {
      getUserTag();
    }else{
      // some other code here
    }
  }


  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
    await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    transferState = Provider.of<TransferState>(context);
    themeChangeProvider = Provider.of<DarkThemeProvider>(context);
    loginState = Provider.of<LoginState>(context);
    conversionState = Provider.of<ConversionState>(context);
    virtualCardState = Provider.of<VirtualCardState>(context);
    appState = Provider.of<AppState>(context);

//    print("${widget.amount} hhhhhhh");
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Colors
          .white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Request Money", style: GoogleFonts.mavenPro(
          color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
          fontSize: 17,),),
        backgroundColor: themeChangeProvider.darkTheme ? kPrimaryDark : Colors
            .transparent,
        leading:  IconButton(icon: Icon(Icons.arrow_back, color: kprimaryYellow,),onPressed: ()=>Navigator.pop(context),),
      ),


      body: Column(

        children: [

          Container(
//            width: 340,
            child: Form(
              key: _formKey,
              child: CustomTextField(

                suffix: userTagLoading ? CupertinoActivityIndicator() : error ? CommonUtils.checkCancel() : tagFetch != null ? CommonUtils.checkMArk() : null,
                color: kPrimaryColor.withOpacity(0.1),
                header: "Recipient Tag",
                hint:  "ajaodlp ",
                prefixText: "@",

                onChanged: (value){
                  setState(() {


                    userTagLoading = false;
                    clear = true;
                    _selectedCard = -1;
                    tagFetch = null;
                    isButtonDisaled = true;
                    streamController.add(value);
                  });

                },

                type: FieldType.text,

                controller: _tagName,
                validator: (value) {
                  if (value.isEmpty) {
                    return "tag name is required";
                  }
//
//                if (value.length <= 5) {
//                  return "Invalid Amount";
//                }

                  return null;
                },


              ),
            ),
          ),

        transferState.contactList == null ||  transferState.contactList.length == 0 ? Container() :        Text("PEOPLE YOU CAN REQUEST MONEY FROM", style: GoogleFonts.mavenPro(fontSize: 9, color: themeChangeProvider.darkTheme ? kprimaryYellow : kPrimaryColor),),

SizedBox(height: 20,),


          transferState.contactList == null ||       transferState.contactList.length == 0 ? Container() :       Expanded(
            child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: transferState.contactList.length,
                itemBuilder: (context, index){
                  return  InkWell(
                    onTap: (){
                      setState(() {
                        _tagName.text = transferState.contactList[index].user_tag;
              isButtonDisaled = false;
                        _selectedCard = index;
                      });
                    },
                    child:  UserContainer(
                      selected: _selectedCard,

                      index: index,
                      themeChangeProvider: themeChangeProvider, contactList: transferState.contactList[index],),
                  );


//                InkWell(
//                onTap: (){
//                  setState(() {
//
//                    _tagName.text = transferState.contactList[index].user_tag;
//              isButtonDisaled = false;
//                  });
//                },
//                child: UserContainer(
//
//
//                  themeChangeProvider: themeChangeProvider, contactList: transferState.contactList[index],),
//              );

                }),
          ),








//          SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.maxFinite,
              height: 50,
              child: RaisedButton(
                disabledColor:  isButtonDisaled ?   kprimaryLight : kPrimaryColor,
                onPressed: isButtonDisaled ? null  : ()  {


                if(_formKey.currentState.validate()){
                  requestMoney();

                }

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

          SizedBox(height: 20,),

        ],




      ),
    );
  }







  void requestMoney()async {
//    print("called request");
    if (error != true) {
      setState(() {
        isRequesting = true;
      });
      if (isRequesting) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Preloader();
            });
      }
      var result = await transferState.requestForMoney(
          token: loginState.user.token,
          request_from: _tagName.text,
          amount: widget.amount,
          narration: widget.narration);
      if (isRequesting) {
        Navigator.pop(context, true);
      }
      if (result["error"] == false) {

        Navigator.push(context, MaterialPageRoute(builder: (context) => Notif(
          message: "Request Sent",

          fromReqSent:  true,
        )));

//        CommonUtils.showSuccessDialog(context: context,
//            themeChangeProvider: themeChangeProvider,
//            text: "Request Sent",
//            onClose: () {
//              Navigator.push(
//                  context, MaterialPageRoute(builder: (context) => Home()));
//            });
      } else {
        CommonUtils.showMsg(result["message"], themeChangeProvider, context, _scaffoldKey, kPrimaryColor  );
      }
    }
  }

  void  getUserTag() async{
    setState(() {
      userTagLoading = true;

    });

    var result2 = await transferState.fetchToTransfer(token: loginState.user.token, userTag: _tagName.text);
//    print(result2);

    if(result2["error"] && result2["message"]=="You are not authorized to make this request"){
//      print("jdjdjdhd");
      showDialog(
          barrierDismissible: false,
          context: context, child: dialogPopup(

          themeDark: themeChangeProvider.darkTheme,
          body:
          Text(
            "Session ended, Please Login again",
            textAlign:
            TextAlign.center,
            style: TextStyle(
                inherit:
                false,
                fontSize:
                18,
                color: themeChangeProvider.darkTheme ? Colors.white:
                Colors.black),
          ),
          buttonText:
          "Ok",
          onPressed:
              ()
              {
                final box = Hive.box("user");
                box.put('user', null);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                        (Route<dynamic> route) => false);
              }






      ));
    }


   else if(result2["error"] == false){
      setState(() {
        error = false;
        userTagLoading = false;
        tagFetch = result2["balance"];
        _selectedCard = -1;
      isButtonDisaled = false;
      });
    }else{
      setState(() {

        error = true;
        userTagLoading = false;
      });
    }




  }

  @override
  void afterFirstLayout(BuildContext context) async {
//    print(numbersToSend[0].runtimeType);
//    Iterable<Contact> contacts = await ContactsService.getContacts();
//    print(contacts);
  }
}

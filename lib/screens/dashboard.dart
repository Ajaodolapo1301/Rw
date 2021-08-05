//    return Scaffold(
//      backgroundColor:
//          themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
//      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//      drawer: Draw(),
//
//      key: scaffoldKey,
//
////      body: Container(
////        height: MediaQuery.of(context).size.height,
////        child: SingleChildScrollView(
////          physics: NeverScrollableScrollPhysics(),
////          child: Stack(
////            children: [
////
////              Column(
////                children: [
////                  Container(
//////                    height: MediaQuery.of(context).size.height*0.54,
//////                      height: MediaQuery.of(context).size.height*0.55,
//////                    height: 400,
////                    decoration: BoxDecoration(
////                      image: DecorationImage(
////                        fit: BoxFit.cover,
////                        image: AssetImage("images/backgr.png"),
////                      ),
////                    ),
////                    width: double.infinity,
////                    child: Stack(
////                      overflow: Overflow.visible,
////                      children: [
////
////
////                        Column(
////                          crossAxisAlignment: CrossAxisAlignment.start,
////                          children: <Widget>[
////                            Container(
////                              margin: EdgeInsets.all(20),
////                              width: double.infinity,
////                              child: Column(
////                                children: [
////                                  SizedBox(
////                                    height: 40,
////                                  ),
////                                  Row(
////                                    mainAxisAlignment:
////                                    MainAxisAlignment.spaceBetween,
////                                    children: [
////                                      GestureDetector(
////                                          onTap: () => scaffoldKey.currentState
////                                              .openDrawer(),
////                                          child: SvgPicture.asset(
////                                              "images/menu.svg")),
////                                      GestureDetector(
////                                        onTap:(){
////                                          appState.moneyRequest = false;
////                                          Navigator.push(context, FadeRoute(page: NotificationScreen()));
////
////                                        },
////                                        child:
////
////
////
////                                        Stack(
////                                          children: <Widget>[
////                                            Icon(Icons.notifications, color: kprimaryYellow, ),
////                                            if ( appState.moneyRequest)
////                                              Padding(
////                                                padding: const EdgeInsets.only(right: 10),
////                                                child: CircleAvatar(
////                                                  radius: 3.0,
////                                                  backgroundColor: Colors.red,
////                                                  foregroundColor: Colors.white,
////                                                  child:Icon(
////                                                    Icons.notifications,
////                                                    color: kprimaryYellow,
////                                                  ),
////                                                ),
////                                              ),
////                                          ],
////                                        ),
////
////                                      )],
////                                  ),
////
////                                  SizedBox(
////                                    height: 30,
////                                  ),
////                                  Row(
////                                    children: [
////                                      loginState != null    ?        GestureDetector(
////                                        onTap: () {
////                                          Navigator.push(context,
////                                              FadeRoute(page: ProfileScreen()));
////                                        },
////                                        child: CircleAvatar(
////                                          radius: 30,
////                                          backgroundImage: NetworkImage( loginState.user.profilepic),
////                                        ),
////                                      )  : Container(),
////                                      SizedBox(
////                                        width: 10,
////                                      ),
////                                      Column(
////                                        crossAxisAlignment:
////                                        CrossAxisAlignment.start,
////                                        children: [
////                                          Text.rich(
////                                              TextSpan(children: [
////                                                TextSpan(
////
////                                                    text: "${loginState.user.firstName} ",
////                                                    style: GoogleFonts.mavenPro(
////                                                      color: Colors.white,
////                                                      fontWeight: FontWeight.bold,
////                                                      fontSize: 24,
////                                                    )),
////                                                TextSpan(
////                                                    text: loginState.user.lastName,
////                                                    style: GoogleFonts.mavenPro(
////                                                        color: kprimaryYellow,
////                                                        fontSize: 24,
////                                                        fontWeight: FontWeight.bold)),
////                                              ])),
////                                          Text.rich(TextSpan(children: [
////                                            TextSpan(
////                                                text: "Welcome back ",
////                                                style: GoogleFonts.raleway(
////                                                  color: Colors.white,
////                                                  fontSize: 14,
////                                                )),
////                                            TextSpan(
////                                                text:
////                                                "@${loginState.user.userTag}",
////                                                style: GoogleFonts.raleway(
////                                                    color: Colors.white,
////                                                    fontSize: 14,
////                                                    fontWeight: FontWeight.bold)),
////                                          ])),
////                                        ],
////                                      )
////                                    ],
////                                  )
////                                ],
////                              ),
////                            ),
////
////
////                          ],
////                        ),
////
////
////                      ],
////                    ),
////                  ),
////
////                  Container(
//////                height: 200,
////                    child: Material(
////                      color: themeChangeProvider.darkTheme
////                          ? Colors.white
////                          : Colors.white,
////                      borderRadius: BorderRadius.only(
////                        topLeft: Radius.circular(15),
////                        topRight: Radius.circular(15),
////                      ),
////                      elevation: 0.0,
////                      child: Container(
////                        height: 00,
////                        decoration: BoxDecoration(
////                            color: themeChangeProvider.darkTheme
////                                ? kPrimaryDark
////                                : Colors.white,
////                            borderRadius: BorderRadius.only(
////                              topLeft: Radius.circular(15),
////                              topRight: Radius.circular(15),
////                            )),
////                        width: MediaQuery.of(context).size.width,
////                        child: Column(
//////                          mainAxisAlignment: MainAxisAlignment.center,
////                          children: <Widget>[
////                            SizedBox(height: 10,),
////                            Container(
////
////                              margin: EdgeInsets.only(right: 15, left: 15),
////                              width: double.infinity,
//////                              height: 149.34,
////                              height: MediaQuery.of(context).size.height * 0.23,
////                              decoration: BoxDecoration(
////                                  borderRadius: BorderRadius.all(Radius.circular(10)),
////                                  image: DecorationImage(
////                                      fit: BoxFit.cover,
////                                      image: AssetImage("images/Dashcard.png"))),
////                              child: Column(
////                                children: [
////                                  SizedBox(
////                                    height: 20,
////                                  ),
////                                  Text(
////                                    "${loginState.user.currency} ACCOUNT",
////                                    style: GoogleFonts.mavenPro(
////                                        fontSize: 12,
////                                        color: Colors.white,
////                                        letterSpacing: 10.0),
////                                  ),
////                                  SizedBox(
////                                    height: 20,
////                                  ),
////                                  Padding(
////                                    padding: const EdgeInsets.only(left: 10),
////                                    child: Row(
////                                      mainAxisAlignment:
////                                      MainAxisAlignment.center,
////                                      crossAxisAlignment:
////                                      CrossAxisAlignment.baseline,
////                                      textBaseline: TextBaseline.alphabetic,
////                                      children: [
////                                        Text("${loginState.user.symbol} ",
////                                            style: GoogleFonts.mavenPro(
////                                                fontSize: 20,
////                                                fontWeight: FontWeight.w500,
////                                                color: Colors.white,
////                                                letterSpacing: 1.0)),
////                                        Text(
////                                          "${MyUtils.getFormattedAmount(double.parse(loginState.user.balance.toString()))}",
////                                          style: GoogleFonts.mavenPro(
////                                              fontSize: 54,
////                                              fontWeight: FontWeight.w500,
////                                              color: Colors.white,
////                                              letterSpacing: 1.0),
////                                        ),
////                                      ],
////                                    ),
////                                  ),
////                                  Text(
////                                    "Available Balance",
////                                    style: GoogleFonts.mavenPro(
////                                        fontSize: 14,
////                                        color: Colors.white,
////                                        letterSpacing: 1.0),
////                                  ),
////                                ],
////                              ),
////                            )
////                          ],
////                        ),
////                      ),
////                    ),
////                  ),
////
//////              Container(
//////                color: kPrimaryColor.withOpacity(0.2),
//////                height: 36,
//////                child: Padding(
//////                  padding: const EdgeInsets.only(right: 20, left: 20),
//////                  child: Row(
//////                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//////                    children: [
//////                      Text(
//////                        "RECENT ACTIVITY",
//////                        style: GoogleFonts.mavenPro(
//////                            fontSize: 14,
//////                            color: themeChangeProvider.darkTheme
//////                                ? kPrimaryDarkText
//////                                : kPrimaryColor,
//////                            letterSpacing: 1.0),
//////                      ),
//////                      GestureDetector(
//////                          onTap: () {
//////                            Navigator.push(
//////                                context,
//////                                SizeRoute(
//////                                    page: Transaction(
//////                                      transactionHistory: transactionHistory,
//////                                      loading: transactionLoading,
//////                                    )));
//////                          },
//////                          child: Text(
//////                            "see more",
//////                            style: GoogleFonts.mavenPro(
//////                                fontSize: 14,
//////                                color: themeChangeProvider.darkTheme
//////                                    ? kPrimaryDarkText
//////                                    : kPrimaryColor,
//////                                fontWeight: FontWeight.bold),
//////                          )),
//////                    ],
//////                  ),
//////                ),
//////              ),
////                  SizedBox(
////                    height: 10,
////                  ),
//////              transactionLoading
//////                  ? CupertinoActivityIndicator()
//////                  : Container(
//////                margin: EdgeInsets.only(right: 10, left: 10),
//////                          height: MediaQuery.of(context).size.height/ 4,
////////                height: 340,
//////                child: MediaQuery.removePadding(
//////                  context: context,
//////                  removeTop: true,
//////                  child: ListView.builder(
////////                      physics: NeverScrollableScrollPhysics(),
//////                    itemCount: transactionHistory.length >= 5
//////                        ? 5
//////                        : transactionHistory.length,
//////                    itemBuilder: (BuildContext context, index) {
//////                      var e = transactionHistory[index];
//////                      return transactionHistory[index].type ==
//////                          "credit"
//////                          ? HistoryCredit(
//////                        colorSub: themeChangeProvider.darkTheme
//////                            ? Colors.white
//////                            : kPrimaryColor,
//////                        color: themeChangeProvider.darkTheme
//////                            ? kPrimaryDarkText
//////                            : kprimaryLight,
//////                        date: e.date,
//////                        text: e.remark,
//////                        currencyType: loginState.user.currency,
//////                        amount: e.amount,
//////                      )
//////                          : HistoryDebit(
//////                        colorSub: themeChangeProvider.darkTheme
//////                            ? Colors.white
//////                            : kPrimaryColor,
//////                        color: themeChangeProvider.darkTheme
//////                            ? kPrimaryDarkText
//////                            : kprimaryLight,
//////                        date: e.date,
//////                        text: e.remark,
//////                        currencyType: loginState.user.currency,
//////                        amount: e.amount,
//////                      );
//////                    },
//////                  ),
//////                ),
//////              )
////                ],
////
////              ),
////              Positioned(
////                top: 190,
////                child: Container(
//////                          child: ,
////                  height: 200,
////                  width: double.maxFinite,
////                  decoration: BoxDecoration(
////                    color: themeChangeProvider.darkTheme ? Colors.black : Colors.red,
////                    borderRadius: BorderRadius.only(
////                      topLeft: Radius.circular(20),
////                      topRight: Radius.circular(20),
////                    ),
////                  ),
////                ),
////              ),
////            ],
////          ),
////        ),
////      ),
//body: Container(
////  color: Colors.white,
//  height: MediaQuery.of(context).size.height,
//  child:   Container(
//      height: 300,
//    decoration: BoxDecoration(
//      image: DecorationImage(
//        image: AssetImage(
//
//  //        isDark
//  //            ? "assets/update_2020_june/dashboard_bg_dark.png"
//              "images/backgr.png",
//        ),
//        fit: BoxFit.cover,
//      ),
//    ),
//    child: Stack(
//      overflow: Overflow.visible,
//      children: <Widget>[
//        Column(
//          children: <Widget>[
//            SizedBox(height: 20),
//            Container(
//              margin: EdgeInsets.all(20),
//              child: Column(
//                children: [
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[
//                      Builder(builder: (context) {
//                        return IconButton(
//                          icon: Icon(
//                            Icons.menu,
//                            color: Colors.white,
//                          ),
//                          onPressed: () {
//                            Scaffold.of(context).openDrawer();
//                          },
//                        );
//                      }),
//            GestureDetector(
//                                              onTap:(){
//                                                appState.moneyRequest = false;
//                                                Navigator.push(context, FadeRoute(page: NotificationScreen()));
//
//                                              },
//                                              child:
//
//
//
//                                              Stack(
//                                                children: <Widget>[
//                                                  Icon(Icons.notifications, color: kprimaryYellow, ),
//                                                  if ( appState.moneyRequest)
//                                                    Padding(
//                                                      padding: const EdgeInsets.only(right: 10),
//                                                      child: CircleAvatar(
//                                                        radius: 3.0,
//                                                        backgroundColor: Colors.red,
//                                                        foregroundColor: Colors.white,
//                                                        child:Icon(
//                                                          Icons.notifications,
//                                                          color: kprimaryYellow,
//                                                        ),
//                                                      ),
//                                                    ),
//                                                ],
//                                              ),
//    )
//
//
//
//
//
//                    ],
//                  ),
//
//                  SizedBox(height: 20),
//              Row(
//                                      children: [
//                                        loginState != null    ?        GestureDetector(
//                                          onTap: () {
//                                            Navigator.push(context,
//                                                FadeRoute(page: ProfileScreen()));
//                                          },
//                                          child: CircleAvatar(
//                                            radius: 30,
//                                            backgroundImage: NetworkImage( loginState.user.profilepic),
//                                          ),
//                                        )  : Container(),
//                                        SizedBox(
//                                          width: 10,
//                                        ),
//                                        Column(
//                                          crossAxisAlignment:
//                                          CrossAxisAlignment.start,
//                                          children: [
//                                            Text.rich(
//                                                TextSpan(children: [
//                                                  TextSpan(
//
//                                                      text: "${loginState.user.firstName} ",
//                                                      style: GoogleFonts.mavenPro(
//                                                        color: Colors.white,
//                                                        fontWeight: FontWeight.bold,
//                                                        fontSize: 24,
//                                                      )),
//                                                  TextSpan(
//                                                      text: loginState.user.lastName,
//                                                      style: GoogleFonts.mavenPro(
//                                                          color: kprimaryYellow,
//                                                          fontSize: 24,
//                                                          fontWeight: FontWeight.bold)),
//                                                ])),
//                                            Text.rich(TextSpan(children: [
//                                              TextSpan(
//                                                  text: "Welcome back ",
//                                                  style: GoogleFonts.raleway(
//                                                    color: Colors.white,
//                                                    fontSize: 14,
//                                                  )),
//                                              TextSpan(
//                                                  text:
//                                                  "@${loginState.user.userTag}",
//                                                  style: GoogleFonts.raleway(
//                                                      color: Colors.white,
//                                                      fontSize: 14,
//                                                      fontWeight: FontWeight.bold)),
//                                            ])),
//                                          ],
//                                        )
//                                      ],
//                                    )
//                ],
//              ),
//            ),
//  //          SizedBox(height: 120),
//
//  //                   CONTAINER  UNDERNEETH
//            Container(
//              height: 200,
//              width: double.maxFinite,
//              decoration: BoxDecoration(
//                color: themeChangeProvider.darkTheme ? Colors.black : Colors.white,
//                borderRadius: BorderRadius.only(
//                  topLeft: Radius.circular(20),
//                  topRight: Radius.circular(20),
//                ),
//              ),
//              child: Container(
//  //                height: 200,
//                    child: Material(
//                      color: themeChangeProvider.darkTheme
//                          ? Colors.white
//                          : Colors.white,
//                      borderRadius: BorderRadius.only(
//                        topLeft: Radius.circular(15),
//                        topRight: Radius.circular(15),
//                      ),
//                      elevation: 0.0,
//                      child: Container(
//                        height: 00,
//                        decoration: BoxDecoration(
//                            color: themeChangeProvider.darkTheme
//                                ? kPrimaryDark
//                                : Colors.white,
//                            borderRadius: BorderRadius.only(
//                              topLeft: Radius.circular(15),
//                              topRight: Radius.circular(15),
//                            )),
//                        width: MediaQuery.of(context).size.width,
//                        child: Column(
//  //                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
//                            SizedBox(height: 10,),
//                            Container(
//
//                              margin: EdgeInsets.only(right: 15, left: 15),
//                              width: double.infinity,
//  //                              height: 149.34,
//                              height: MediaQuery.of(context).size.height * 0.23,
//                              decoration: BoxDecoration(
//                                  borderRadius: BorderRadius.all(Radius.circular(10)),
//                                  image: DecorationImage(
//                                      fit: BoxFit.cover,
//                                      image: AssetImage("images/Dashcard.png"))),
//                              child: Column(
//                                children: [
//                                  SizedBox(
//                                    height: 20,
//                                  ),
//                                  Text(
//                                    "${loginState.user.currency} ACCOUNT",
//                                    style: GoogleFonts.mavenPro(
//                                        fontSize: 12,
//                                        color: Colors.white,
//                                        letterSpacing: 10.0),
//                                  ),
//                                  SizedBox(
//                                    height: 20,
//                                  ),
//                                  Padding(
//                                    padding: const EdgeInsets.only(left: 10),
//                                    child: Row(
//                                      mainAxisAlignment:
//                                      MainAxisAlignment.center,
//                                      crossAxisAlignment:
//                                      CrossAxisAlignment.baseline,
//                                      textBaseline: TextBaseline.alphabetic,
//                                      children: [
//                                        Text("${loginState.user.symbol} ",
//                                            style: GoogleFonts.mavenPro(
//                                                fontSize: 20,
//                                                fontWeight: FontWeight.w500,
//                                                color: Colors.white,
//                                                letterSpacing: 1.0)),
//                                        Text(
//                                          "${MyUtils.getFormattedAmount(double.parse(loginState.user.balance.toString()))}",
//                                          style: GoogleFonts.mavenPro(
//                                              fontSize: 54,
//                                              fontWeight: FontWeight.w500,
//                                              color: Colors.white,
//                                              letterSpacing: 1.0),
//                                        ),
//                                      ],
//                                    ),
//                                  ),
//                                  Text(
//                                    "Available Balance",
//                                    style: GoogleFonts.mavenPro(
//                                        fontSize: 14,
//                                        color: Colors.white,
//                                        letterSpacing: 1.0),
//                                  ),
//                                ],
//                              ),
//                            )
//                          ],
//                        ),
//                      ),
//                    ),
//                  ),
//
//
//
//            ),
//
//            Column(
//              children: [
//                Container(
//                  color: kPrimaryColor.withOpacity(0.2),
//                  child:       Container(
//                    color: kPrimaryColor.withOpacity(0.2),
//                    height: 36,
//                    child: Padding(
//                      padding: const EdgeInsets.only(right: 20, left: 20),
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        children: [
//                          Text(
//                            "RECENT ACTIVITY",
//                            style: GoogleFonts.mavenPro(
//                                fontSize: 14,
//                                color: themeChangeProvider.darkTheme  ? kPrimaryDarkText
//                                    : kPrimaryColor,
//                                letterSpacing: 1.0),
//                          ),
//                          GestureDetector(
//                              onTap: () {
//                                Navigator.push(
//                                    context,
//                                    SizeRoute(
//                                        page: Transaction(
//                                          transactionHistory: transactionHistory,
//                                          loading: transactionLoading,
//                                        )));
//                              },
//                              child: Text(
//                                "see more",
//                                style: GoogleFonts.mavenPro(
//                                    fontSize: 14,
//                                    color: themeChangeProvider.darkTheme
//                                        ? kPrimaryDarkText
//                                        : kPrimaryColor,
//                                    fontWeight: FontWeight.bold),
//                              )),
//                        ],
//                      ),
//                    ),
//                  ),
//
//                ),
//
//
//                SizedBox(
//                      height: 10,
//                    ),
//                transactionLoading
//                    ? CupertinoActivityIndicator()
//                    : SingleChildScrollView(
//                      child: Column(
//                        children: [
//                          Container(
//                  color: Colors.white,
//                  margin: EdgeInsets.only(right: 10, left: 10),
//                                  height: MediaQuery.of(context).size.height/ 3,
//  //                height: 340,
//                  child: MediaQuery.removePadding(
//                          context: context,
//                          removeTop: true,
//                          child: ListView.builder(
//  //                      physics: NeverScrollableScrollPhysics(),
//                            itemCount: transactionHistory.length >= 5
//                                ? 5
//                                : transactionHistory.length,
//                            itemBuilder: (BuildContext context, index) {
//                              var e = transactionHistory[index];
//                              return transactionHistory[index].type ==
//                                  "credit"
//                                  ? HistoryCredit(
//                                colorSub: themeChangeProvider.darkTheme
//                                    ? Colors.white
//                                    : kPrimaryColor,
//                                color: themeChangeProvider.darkTheme
//                                    ? kPrimaryDarkText
//                                    : kprimaryLight,
//                                date: e.date,
//                                text: e.remark,
//                                currencyType: loginState.user.currency,
//                                amount: e.amount,
//                              )
//                                  : HistoryDebit(
//                                colorSub: themeChangeProvider.darkTheme
//                                    ? Colors.white
//                                    : kPrimaryColor,
//                                color: themeChangeProvider.darkTheme
//                                    ? kPrimaryDarkText
//                                    : kprimaryLight,
//                                date: e.date,
//                                text: e.remark,
//                                currencyType: loginState.user.currency,
//                                amount: e.amount,
//                              );
//                            },
//                          ),
//                  ),
//                ),
//                        ],
//                      ),
//                    )
//                  ],
//
//                ),
//
//  //
//  //            ],
//  //          )
//  //        ],
//  //      ),
//
//
//
//
//
//
//
//
//
//                  ],
//
//                ),
//
//
//
//
//
//
//
//
//      ],
//    ),
//  ),
//),
//      floatingActionButton: Container(
//        margin: EdgeInsets.only(top: 20),
//        height: 60.0,
//        width: 60.0,
//        child: FittedBox(
//          child: FloatingActionButton(
//              backgroundColor: kPrimaryColor,
//              child: SvgPicture.asset(
//                "images/aero.svg",
//                height: 26,
//                width: 26,
//              ),
//              onPressed: () {
//                Navigator.push(context, FadeRoute(page: SendMoney()));
//              }),
//        ),
//      ),
//
//      bottomNavigationBar: Container(
//
//        color: themeChangeProvider.darkTheme ? kPrimaryDark : Colors.white,
//        child: Column(
//          mainAxisSize: MainAxisSize.min,
//
//
//          children: <Widget>[
//            Container(
//              height: 0.4,
//              color: Colors.grey,
//            ),
//            Container(
//              color: themeChangeProvider.darkTheme
//                  ? Color(0xff2C272E)
//                  : Colors.white,
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                crossAxisAlignment: CrossAxisAlignment.center,
//                children: List.generate(
//                  5,
//                  (index) => index == selectedIndex
//                      ? Expanded(
//                        child: Container(
//                            child: GestureDetector(
//                              child: Padding(
//                                padding: EdgeInsets.all(0),
//                                child: getSelectedWidget(index),
//                              ),
//                              onTap: () {
//                                setBottomItem(index);
//                              },
//                            ),
//                          ),
//                      )
//                      :  Container(
//                    child: GestureDetector(
//                      child: Padding(
//                        padding: EdgeInsets.all(0),
//                        child: getSelectedWidget(index),
//                      ),
//                      onTap: () {
//                        setBottomItem(index);
//                        setBottomItem(0);
//                        if (index == 1) {
//                          Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                  builder: (_) => ReceiveMoney(
////                                      appState: appState,
//                                  )));
//                        } else if (index == 2) {
//                          Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                  builder: (_) => SendMoney()));
//                        } else if (index == 3 && loginState.user.country == "Nigeria") {
//                          CommonUtils.modalBottomSheetMenu(context: context, body: buildModal(text: "Account Information", subText: loginState.user.bankAaccountNumber, themeChangeProvider: themeChangeProvider ), darkThemeProvider: themeChangeProvider );
//                        }else if((index == 3 && loginState.user.country != "Nigeria")){
//                          Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                  builder: (_) => FundAccount()));
//
//                        }
//                        else if (index == 4) {
//                          print(index);
//                          Navigator.push(context,
//                              MaterialPageRoute(builder: (_) => Cards()));
//                        }
//                      },
//                    ),
//                  ),
//                ),
//              ),
//            ),
//          ],
//        ),
//      ),
//
////      bottomNavigationBar: BottomNavigationBar(
////        type: BottomNavigationBarType.fixed,
////        currentIndex: _selectedIndex,
////        unselectedItemColor: kPrimaryColor.withOpacity(0.5),
////        iconSize: 30.0,
////        onTap: (int index){
////          setState(() {
////            _selectedIndex = index;
////          });
////        },
////        items: <BottomNavigationBarItem>[
////          BottomNavigationBarItem(
////
////            icon: SvgPicture.asset("images/home.svg", height: 17,),
////
////            title: GestureDetector(
////              onTap: (){
////
////                Navigator.push(context, FadeRoute(page:    Transaction(), ));
////              }
////              ,
////              child: Container(
////                  margin: EdgeInsets.only(top: 5),
////                  child: Text('Home')),
////            ),
////          ),
////          BottomNavigationBarItem(
////            icon: SvgPicture.asset("images/request.svg", height: 17,),
////            title: Container(
////                margin: EdgeInsets.only(top: 5),
////
////                child: Text('Rate')),
////          ),
////          BottomNavigationBarItem(
////            icon: SvgPicture.asset("images/jj.svg",height: 17,),
////            title: Text(''),
////          ),
////          BottomNavigationBarItem(
////            icon: SvgPicture.asset("images/request.svg", height: 17,),
////            title: Container(
////                margin: EdgeInsets.only(top: 5),
////                child: Text('Fund Wallet')),
////          ),
////
////          BottomNavigationBarItem(
////            icon: SvgPicture.asset("images/card.svg", height: 17,),
////
////
////            title: Container(
////                margin: EdgeInsets.only(top: 5),
////                child: Text('Cards')),
////          ),
////        ],
////
////
////      ),
////      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//    );
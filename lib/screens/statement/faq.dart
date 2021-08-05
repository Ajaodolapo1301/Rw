import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/providers/darkmode.dart';


class FaqScreen extends StatefulWidget {



  @override
  _FaqScreenState createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

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

    themeChangeProvider = Provider.of<DarkThemeProvider>(context);



    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:
          themeChangeProvider.darkTheme ? kPrimaryDark : Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: kprimaryYellow,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "FAQ",
            style: GoogleFonts.mavenPro(
                color:
                themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
                fontSize: 20),
          ),
        ),

        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
//                InkWell(
//                  onTap: () => Navigator.pop(context),
//                  child: Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: Icon(
//                      Icons.arrow_back,
//                    ),
//                  ),
//                ),

                SizedBox(
                  height: 5,
                ),
                ...List.generate(DriverFaq.driverFaqList.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: FaqItem(
                      question: DriverFaq.driverFaqList[index].question,
                      answer: DriverFaq.driverFaqList[index].answer,
                    ),
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FaqItem extends StatefulWidget {
  final String question;
  final String answer;

  const FaqItem({Key key, this.question, this.answer}) : super(key: key);

  @override
  _FaqItemState createState() => _FaqItemState();
}

class _FaqItemState extends State<FaqItem> {
  Color textColor = kPrimaryColor;
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        widget.question,
        style: GoogleFonts.mavenPro(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      backgroundColor: MyColors.grey.withOpacity(0.2),
      onExpansionChanged: (expanded) {
        setState(() {
          if (expanded) {
//            textColor = MyColors.accentColorDeep;
          } else {
            textColor = kPrimaryColor;
          }
        });
      },
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 15.0, bottom: 10.0, right: 15.0),
            child: Text(
              widget.answer,
              style: GoogleFonts.mavenPro(
                fontSize: 14,
                color: kPrimaryColor,
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DriverFaq {
  final String question;
  final String answer;

  DriverFaq({this.answer, this.question});

  static List<DriverFaq> driverFaqList = [
    DriverFaq(
      question: 'Can I use RexWire on my desktop and mobile devices?',
      answer:"Yes , though you need to sign up through our website. Enter your details online and make sure you choose ‘Business’ as your account type. The app is available for iPhone and Android devices and can be downloaded from the App Store or Google Play now."

    ),
    DriverFaq(
      question: 'What countries can I send money to, and when will it get there?',
      answer:
      'Ghana, Kenya, Uganda, Zambia,  Zimbabwe, Tanzania, Rwanda ,Nigeria, United State, United Kingdom, Canada, Germany, France, Italy, Spain, Netherlands, Belgium, Austria, Estonia, Ireland, Cyprus, Malta, Australia, Switzerland. Hongkong, Malaysia, Singapore, and they received the transferred amount in minutes',
    ),
    DriverFaq(
      question: 'My transfer is ‘processing’, what do I do in the event of this scenario?',
      answer: "We will contact you by email if there is any unexpected delay to your transfer. "
    ),
    DriverFaq(
      question: 'Why does RexWire need to verify me??',
      answer: "As a financially regulated company we are required by law to verify all of our customers.The type of verification we will need can be different depending on  your country."
    ),
    DriverFaq(
      question:
      'What exchange rate will I get?',
      answer: "The best in the market is what we give to our users, so be rest assure you'll get better rates at all time."
    ),
    DriverFaq(
      question:
      'I have a limited company. Can I use RexWire?',
      answer: "you can join the waitlist here to be the first to know when it’s available. This will give limited companies the same low costs, bank-level security."
    ),

  ];
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

Color buttonColor = Color(0xff00ACEC);
Color headerColor = Color(0xff0D3E53);
Color smallTextColor = Color(0xffB3B3B3);
Color textFieldBackgroundColor = kPrimaryColor.withOpacity(0.1);
Color orangeColor = Color(0xffF87831);
Color greenColor = Color(0xff1AD88C);
Color modalWindowColor = Color(0xff335d6e);
Color ourBluishGreyColor = Color(0xff6D767D);

class PinEntryTextField extends StatefulWidget {
  final String lastPin;
  final int fields;
  final onSubmit;
  final fieldWidth;
  final fontSize;
  final isTextObscure;
  final showFieldAsBox;
  final bool isDark;

  final Function(List<TextEditingController> cont) getCont;

  PinEntryTextField(
      {this.lastPin,
        this.fields: 4,
        this.onSubmit,
        this.fieldWidth: 40.0,
        this.fontSize: 20.0,
        this.isTextObscure: false,
        this.showFieldAsBox: false,
        this.getCont, this.isDark})
      : assert(fields > 0);

  @override
  State createState() {
    return PinEntryTextFieldState();
  }
}

class PinEntryTextFieldState extends State<PinEntryTextField> {
  List<String> _pin;
  List<FocusNode> _focusNodes;
  List<TextEditingController> _textControllers;

  Widget textfields = Container();

//  Future initDark() async{
//    print("initing isDarl");
//    var pref = await SharedPreferences.getInstance();
//    setState(() {
//      isDark = pref.getBool("isDark") ?? false;
//      print(isDark);
//    });
//  }

  bool isDark = true;

  @override
  void initState() {
    super.initState();
//    initDark();
    _pin = List<String>(widget.fields);
    _focusNodes = List<FocusNode>(widget.fields);
    _textControllers = List<TextEditingController>(widget.fields);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (widget.lastPin != null) {
          for (var i = 0; i < widget.lastPin.length; i++) {
            _pin[i] = widget.lastPin[i];
          }
        }
//        initDark();
        textfields = generateTextFields(context);
      });
    });
  }

  @override
  void dispose() {
    _textControllers.forEach((TextEditingController t) => t.dispose());
    super.dispose();
  }

  Widget generateTextFields(BuildContext context) {
    List<Widget> textFields = List.generate(widget.fields, (int i) {
      return buildTextField(i, context);
    });

    if (_pin.first != null) {
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    }

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        verticalDirection: VerticalDirection.down,
        children: textFields);
  }

  void clearTextFields() {
    _textControllers.forEach(
            (TextEditingController tEditController) => tEditController.clear());
    _pin.clear();
  }


  Widget buildTextField(int i, BuildContext context) {
//    initDark();
    if (_focusNodes[i] == null) {
      _focusNodes[i] = FocusNode();
    }
    if (_textControllers[i] == null) {
      _textControllers[i] = TextEditingController();
      if (widget.lastPin != null) {
        _textControllers[i].text = widget.lastPin[i];
      }
    }

    _focusNodes[i].addListener(() {
      if (_focusNodes[i].hasFocus) {}
    });

    final String lastDigit = _textControllers[i].text;



    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
          color: widget.isDark ? Color(0xff191D20) : textFieldBackgroundColor,
          borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.only(right: 10.0),
      child: Center(
        child: TextField(
          controller: _textControllers[i],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: widget.isDark ? Colors.white : Colors.black,
              fontSize: widget.fontSize),
          focusNode: _focusNodes[i],
          obscureText: widget.isTextObscure,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            counterText: "",
          ),
          onChanged: (String str) {
            setState(() {
              _pin[i] = str;
            });
            if (i + 1 != widget.fields) {
              _focusNodes[i].unfocus();
              if (lastDigit != null && _pin[i] == '') {
                FocusScope.of(context).requestFocus(_focusNodes[i - 1]);
              } else {
                FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
              }
            } else {
              _focusNodes[i].unfocus();
              if (lastDigit != null && _pin[i] == '') {
                FocusScope.of(context).requestFocus(_focusNodes[i - 1]);
              }
            }
            if (_pin.every((String digit) => digit != null && digit != '')) {
              widget.onSubmit(_pin.join());
            }
          },
          onSubmitted: (String str) {
            if (_pin.every((String digit) => digit != null && digit != '')) {
              widget.onSubmit(_pin.join());
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    widget.getCont(_textControllers);
    return textfields;
  }
}

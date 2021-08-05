import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/providers/darkmode.dart';
import 'package:rex_money/reusables/form.dart';
import 'package:rex_money/utils/sizeConfig/sizeConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
class CustomTextField extends StatefulWidget {
  final String header;
  final String hint;
  final FieldType type;
  final List<String> dropDownFields;
  final VoidCallback onTap;
  final Color dropDownValueColor;
  final Function(String value) onChanged;
  final Function(String value) onSaved;
  final Function(String value) validator;
  final int minLines;
  final int maxLines;
  final Color color;
  final VoidCallback onEditingComplete;
  final Function(String value) onFieldSubmitted;
  final FocusNode focusNode;
  final bool enabled;
  final int maxLength;
  final TextEditingController controller;
  final bool headerLess;
  final bool readOnly;
  final Widget prefix;
  final  prefixText;
  final Widget prefixIcon;
  final Widget suffix;
  final bool obscureText;
  final List<TextInputFormatter> textInputFormatters;

  const CustomTextField({
    Key key,
    this.readOnly = false,
    this.header,
    this.onSaved,
    this.prefixIcon,
    this.hint,
    this.type = FieldType.text,
    this.dropDownFields,
    this.onTap,
    this.dropDownValueColor,
    this.onChanged,
    this.validator,
    this.minLines = 1,
    this.maxLines = 1,
    this.color ,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.focusNode,
    this.enabled = true,
    this.maxLength,
    this.prefixText,
    this.controller,
    this.headerLess = false,
    this.prefix,
    this.textInputFormatters, this.suffix, this.obscureText = false
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool showingPassword = false;
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
    await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    themeChangeProvider = Provider.of<DarkThemeProvider>(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              !widget.headerLess
                  ? Text(


                widget.header,
                style: GoogleFonts.mavenPro(
                  fontWeight: widget.type == FieldType.card || widget.type == FieldType.cardNum ?  FontWeight.bold  : FontWeight.bold ,
                  fontSize: 1.6 * SizeConfig.widthMultiplier,

                  color: themeChangeProvider.darkTheme ? Colors.white :  kPrimaryColor,

                ),
              )
                  : SizedBox(),
              SizedBox(height: !widget.headerLess ? 4 : 0),
              Container(
                padding: EdgeInsets.only(
                    left: widget.type == FieldType.dropdown ? 10 : 0,
                    top: 5,
                    bottom: 5),
                decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(5),
                    color: widget.type == FieldType.dropdown
                        ? themeChangeProvider.darkTheme  ? kPrimaryDarkTextField : kPrimaryColor.withOpacity(0.1) ?? textFieldBackgroundColor
                        : null),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: getField(),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget getField() {
    if (widget.type == FieldType.dropdown) {
      return GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 10),
                child: getPrefix(),
              ),

              Expanded(
                child: Text(
                  widget.hint,
                  style: GoogleFonts.raleway(
                    color: themeChangeProvider.darkTheme ? kPrimaryDarkText : kPrimaryColor,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 10),
                child: getSuffixIconForField(),
              )
            ],
          ),
        ),
      );
    }
    return TextFormField(


      readOnly: widget.readOnly,
      controller: widget.controller,
      enabled: widget.enabled,
      focusNode: widget.focusNode,
      inputFormatters: widget.textInputFormatters,
      keyboardType: getTextInputType(),
      obscureText: widget.obscureText,
      onTap: widget.onTap,
      onSaved: widget.onSaved,
      maxLength: widget.maxLength,
      onChanged: widget.onChanged,
      validator: widget.validator,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      onEditingComplete: widget.onEditingComplete,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        prefixText: widget.prefixText,
          prefixStyle: GoogleFonts.raleway(
            color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
            fontSize: 15,
          ) ,

          suffixStyle:  GoogleFonts.raleway(
            color: themeChangeProvider.darkTheme ? Colors.white : kPrimaryColor,
            fontSize: 15,
          ) ,
          hintText: widget.hint,
          hintStyle: GoogleFonts.raleway(
            color: themeChangeProvider.darkTheme ? Colors.grey : smallTextColor,
            fontSize: 15,
          ),
          prefixIcon: widget.prefixIcon ?? getPrefix(),
//          prefix: widget.prefix,
          suffixIcon: widget.suffix ?? getSuffixIconForField(),
          fillColor: themeChangeProvider.darkTheme  ? kPrimaryDarkTextField : kPrimaryColor.withOpacity(0.1),
          filled: true,
          contentPadding: EdgeInsets.only(left: 10, top: 20),
          border: FormBorder(
            borderRadius: BorderRadius.circular(5),
          )),
      style: GoogleFonts.raleway(

        color: themeChangeProvider.darkTheme  ? Colors.white : kPrimaryColor,
        fontSize: 15,
      ),
    );
  }

  TextInputType getTextInputType() {
    switch (widget.type) {
      case FieldType.email:
        return TextInputType.emailAddress;
        break;
      case FieldType.phone:
        return TextInputType.phone;
        break;
      case FieldType.cardNum:
        return TextInputType.number;
        break;
      case FieldType.number:
        return TextInputType.number;
      default:
        return TextInputType.text;
        break;
    }
  }

  Widget getSuffixIconForField() {
    switch (widget.type) {
      case FieldType.password:
        {
          return GestureDetector(
            child: Icon(
              showingPassword ? Icons.visibility_off : Icons.visibility,
            ),
            onTap: () {
              setState(() {
                showingPassword = !showingPassword;
              });
            },
          );
        }
      case FieldType.dropdown:
        {
          return GestureDetector(
            child: Icon(
              Icons.keyboard_arrow_down,
            ),
            onTap: widget.onTap,

          );
        }
      default:
        return SizedBox();
    }
  }





  Widget getPrefix() {
    switch (widget.type) {
      case FieldType.email:
        {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: SvgPicture.asset(
              "images/purse.svg",
              color: themeChangeProvider.darkTheme ? kprimaryYellow : kPrimaryColor,
            ),
          );
        }


      case FieldType.phone:
        {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: SvgPicture.asset(
                "images/phone.svg",
              color: themeChangeProvider.darkTheme ? kprimaryYellow : null,
            ),
          );
        }

      case FieldType.password:
        {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: SvgPicture.asset(
                "images/padlock.svg",

              color: themeChangeProvider.darkTheme ? kprimaryYellow : null,
            ),
          );
        }
      case FieldType.name:
        {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: SvgPicture.asset(
                "images/person.svg",
              color: themeChangeProvider.darkTheme ? kprimaryYellow : null,
            ),
          );
        }
//      case FieldType.dropdown:
//        {
//          return GestureDetector(
//            child: Icon(
//              Icons.keyboard_arrow_down,
//            ),
//            onTap: () {},
//          );
//        }
      default:
        return null;
    }
  }
}

enum FieldType { text, email, phone, password, dropdown, number, name, card ,cardNum }
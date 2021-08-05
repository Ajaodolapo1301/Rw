import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:rex_money/constants/colorConstants.dart';

class Button extends StatelessWidget {
  Button({
    @required this.onPressed,
    this.text,
    this.widthFactor,
    this.disable,
    this.color = kPrimaryColor,
    this.expand = true,
    this.isOutlined = false, this.disableColor,
  });

  final GestureTapCallback onPressed;
  final String text;
  final double widthFactor;
  final bool disable;
  final bool expand;
  final bool isOutlined;
  final Color color;
  final Color disableColor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: ButtonTheme(
        child: IgnorePointer(
          ignoring: disable == null ? false : disable,
          child: SizedBox(
            width: expand ? double.maxFinite : 100,
            child: isOutlined
                ? OutlineButton(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                text == null ? "" : text,
                style: GoogleFonts.workSans(
                  color: Colors.grey,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              onPressed: onPressed,
            )
                : FlatButton(
              padding: EdgeInsets.symmetric(vertical: 20),
              color: disable == null
                  ? color
                  : disable ? Color(0xff191D20) : color,
              disabledColor: disableColor ??  Colors.grey,
              child: Text(
                text == null ? "" : text,
                style: GoogleFonts.workSans(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              onPressed: onPressed,
            ),
          ),
        ),
      ),
    );
  }
}
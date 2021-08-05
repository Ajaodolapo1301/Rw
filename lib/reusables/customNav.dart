import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/models/darkmode.dart';
import 'package:rex_money/providers/darkmode.dart';

class CustomBottomNav extends StatefulWidget {
  final Function(int index) onChanged;
  final DarkThemeProvider themeProvider;

  const CustomBottomNav({Key key, this.onChanged, this.themeProvider})
      : super(key: key);

  @override
  _CustomBottomNavState createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    //List<String> labels = ["Home", "Request" ,"Fund wallet", "Card"];
    List<String> labels = ["Home","Request","Rate","Card"];

    return BottomAppBar(
      color: widget.themeProvider.darkTheme ? kPrimaryDark : Colors.white,
      shape: CircularNotchedRectangle(),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(4, (index) {
          return Container(
            margin: EdgeInsets.only(right:  index == 1  ? 15: 0, left: index == 2 ? 15: 0),
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: Material(
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(360)),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    this.index = index;
                  });
                  widget.onChanged(index);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "images/${labels[index].toLowerCase().replaceAll(" ", "_")}.svg",
                        width: 20,
                        height: 20,
                      ),
                      SizedBox(height: 5),
                      Text(
                        labels[index],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: kPrimaryColor),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

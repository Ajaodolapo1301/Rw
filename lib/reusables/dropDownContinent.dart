import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/models/continentModel.dart';
import 'package:rex_money/models/flags.dart';
import 'package:rex_money/providers/darkmode.dart';

enum DropDownEdgeType { normal, top, bottom }

class DropDownContinent extends StatefulWidget {
  final List<ContinentModel> items;
  final double position;
  final double height;
  final bool forcePosition;
  final bool forceHeight;
  final Function(String value, String id) onSelect;

  const DropDownContinent({Key key, this.items, this.position, this.onSelect, this.forcePosition = false, this.height, this.forceHeight = false})
      : super(key: key);

  @override
  _DropDownContinentState createState() => _DropDownContinentState();
}

class _DropDownContinentState extends State<DropDownContinent> {

  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
//  void initDark() async {
//    var pref = await SharedPreferences.getInstance();
//    setState(() {
//      isDark = pref.getBool("isDark") ?? false;
//    });
//  }

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
    var radius = Radius.circular(10);
    return Positioned(
      top: widget.forcePosition ? widget.position : MediaQuery.of(context).size.height <= 710 && widget.items.length > 2
          ? 0
          : widget.position,
      left: 0,
      right: 0,
      child: Container(
        margin: EdgeInsets.all(20),
        height: widget.forceHeight ? widget.height : widget.items.length < 7 ? 180: 400,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200], width: 2.0),
            borderRadius: BorderRadius.circular(10),
            color: themeChangeProvider.darkTheme ? Color(0xff191D20) : Colors.white),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: List.generate(
            widget.items.length,
                (index) {
              DropDownEdgeType type;
              if (index == 0) {
                type = DropDownEdgeType.top;
              } else if (index == widget.items.length - 1) {
                type = DropDownEdgeType.bottom;
              } else {
                type = DropDownEdgeType.normal;
              }
              return Material(
                color: themeChangeProvider.darkTheme ? Color(0xff191D20) : Colors.white,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () {
                    widget.onSelect(widget.items[index].continent_name, widget.items[index].continent_id);
                  },
                  borderRadius: getDropDownItemBorderRadius(type, radius),
                  child: Column(
                    children: <Widget>[
                      ListTile(

                        title: Text(
                          widget.items[index].continent_name,
                          style: TextStyle(
                              fontSize: 17,
                              color: themeChangeProvider.darkTheme ? Colors.white : Colors.black),
                        ),
                      ),
                      getDropDownDivider(widget.items, index)
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  BorderRadius getDropDownItemBorderRadius(
      DropDownEdgeType type, Radius radius) {
    switch (type) {
      case DropDownEdgeType.top:
        {
          return BorderRadius.only(
            topRight: radius,
            topLeft: radius,
          );
        }
      case DropDownEdgeType.bottom:
        {
          return BorderRadius.only(bottomLeft: radius, bottomRight: radius);
        }
      default:
        return BorderRadius.circular(0);
    }
  }

  Widget getDropDownDivider(List<ContinentModel> theList, int index) {
    return index == theList.length - 1
        ? SizedBox()
        : Container(
      color: Colors.grey[200],
      height: 1,
    );
  }
}
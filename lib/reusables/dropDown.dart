import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rex_money/models/flags.dart';
import 'package:rex_money/providers/darkmode.dart';

enum DropDownEdgeType { normal, top, bottom }

class DropDown extends StatefulWidget {
  final List<Flag> items;
  final double position;
  final double height;
  final bool forcePosition;
  final bool forceHeight;
  final Function(String value, String id,String flagPic, String phoneCode) onSelect;

  const DropDown({Key key, this.items, this.position, this.onSelect, this.forcePosition = false, this.height, this.forceHeight = false})
      : super(key: key);

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {

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
      top: widget.forcePosition ? widget.position : MediaQuery.of(context).size.height <= 410 && widget.items.length > 2
          ? 0
          : widget.position,
      left: 0,
      right: 0,
      child: Container(
        margin: EdgeInsets.all(20),
        height: widget.forceHeight ? widget.height : widget.items.length < 5 ? 205: 450,
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
                    widget.onSelect(widget.items[index].country, widget.items[index].id , widget.items[index].flag, widget.items[index].phoneCode);
                  },
                  borderRadius: getDropDownItemBorderRadius(type, radius),
                  child: Column(
                    children: <Widget>[
                      ListTile(

                        leading: Container(
                            height: 16,
                            width: 25,
                            child: SvgPicture.network(widget.items[index].flag)),
                        title: Text(
                          widget.items[index].country,
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

  Widget getDropDownDivider(List<Flag> theList, int index) {
    return index == theList.length - 1
        ? SizedBox()
        : Container(
      color: Colors.grey[200],
      height: 1,
    );
  }
}
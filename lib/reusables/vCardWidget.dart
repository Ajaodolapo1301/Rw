
import 'package:flutter/material.dart';

class VirtualCardWidget extends StatelessWidget {
  final Widget child;
  final Color color;
    double height ;
  VirtualCardWidget({this.child, this.color, this.height});
  @override
  Widget build(BuildContext context) {
    return Container(
//      height: MediaQuery.of(context).size.height * 0.24,
      height: 200,
      width: double.infinity,
      margin: EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 0),
      child: Material(
        borderRadius: BorderRadius.circular(15),
        color: color,
        elevation: 1,
        child: child,
      ),
    );
  }
}
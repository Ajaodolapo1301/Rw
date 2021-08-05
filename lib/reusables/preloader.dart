
import 'package:flutter/material.dart';

class Preloader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
//          color: Colors.white,
          width: 90.0,
          alignment: Alignment.center,
          child: Image(
//            color: Colors.white,
            image: AssetImage('images/rexLoader.gif'),
          ),
        ));
  }
}
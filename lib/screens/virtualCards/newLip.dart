import 'package:flutter/material.dart';




class NewFlip extends StatefulWidget {
  @override
  _NewFlipState createState() => _NewFlipState();
}

class _NewFlipState extends State<NewFlip> with SingleTickerProviderStateMixin {


  AnimationController _animationController;
  Animation<double> _animation;
  AnimationStatus _animationStatus = AnimationStatus.dismissed;


  @override
  void initState() {
    _animationController =  AnimationController(vsync: this, duration:  Duration(seconds: 1));
    _animation = Tween<double>(end: 1, begin: 0).animate(_animationController)
    ..addListener(() {
      setState(() {});
    })

    ..addStatusListener((status) {
      _animationStatus = status;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

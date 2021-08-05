
import 'package:flutter/material.dart';
import 'package:rex_money/constants/colorConstants.dart';

class KeyPad extends StatelessWidget {
  final Decoration decoration;

  final Decoration buttonDecoration;

  final ValueChanged<String> addInput;

  final ValueChanged removeInput;

  final ValueChanged clear;

  final List<int> numbers;

  final TextStyle buttonTextStyle;

  KeyPad(this.numbers, this.addInput, this.removeInput, this.clear,
      [this.decoration, this.buttonDecoration, this.buttonTextStyle]);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildRow(numbers.sublist(0, 3)),
          _buildRow(numbers.sublist(3, 6)),
          _buildRow(numbers.sublist(6, 9)),
          _buildLastRow()
        ],
      ),
    );
  }

  Widget _buildRow(List<int> inputs) {
    return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: inputs
            .map((value) => Container(
            width: 60.0,
            height: 60.0,
//                decoration: new BoxDecoration(
//                  color: Colors.white,
//                  borderRadius: new BorderRadius.circular(100.0),
//                ),
            child:Material(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: Colors.white,
                shape: CircleBorder(),
                child:  IconButton(
                  highlightColor: kPrimaryColor,
                  splashColor: MyColors.accentColor,
                  icon: Text(value.toString(), style: buttonTextStyle),
                  onPressed: () => addInput(value.toString()),
                )
            )))
            .toList(),
      ),
    );
  }

  Widget _buildLastRow() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () => clear(null),
          ),
          Container(
              width: 60.0,
              height: 60.0,
//                decoration: new BoxDecoration(
//                  color: Colors.white,
//                  borderRadius: new BorderRadius.circular(100.0),
//                ),
              child: Material(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: Colors.white,
                  shape: CircleBorder(),
                  child: IconButton(
                    highlightColor: MyColors.accentColor,
                    splashColor: MyColors.accentColor,
                    icon: Text(numbers.last.toString(), style: buttonTextStyle),
                    onPressed: () => addInput(numbers.last.toString()),
                  ))),
          IconButton(
            icon: Icon(
              Icons.backspace,
              color: Colors.white,
            ),
            onPressed: () => removeInput(null),
          ),
        ],
      ),
    );
  }
}
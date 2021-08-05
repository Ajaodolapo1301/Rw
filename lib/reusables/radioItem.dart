
import 'package:flutter/material.dart';
import 'package:rex_money/constants/colorConstants.dart';
import 'package:rex_money/models/radioModel.dart';

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        new Container(
            margin: new EdgeInsets.all(15.0),
            child: Container(
              child: Row(
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        color: _item.button,
                        borderRadius: BorderRadius.circular(2),
                        border: Border.all(color: Colors.grey)),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(_item.text),
                  Spacer(),

                  Container(
                    decoration: BoxDecoration(
                        color: _item.isSelected ? _item.button : Colors.transparent ,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: kprimaryLight)
                    ),
                    height: 20,
                    width: 20,
                    child: _item.isSelected ?  Icon(Icons.check, size: 14, color: _item.button == Colors.white ? Colors.black: Colors.white ) : Container(),
                  )

                ],
              ),
            )),
        Divider()

      ],
    );
  }


  Color colorPink(){
    return Colors.white;
  }


}
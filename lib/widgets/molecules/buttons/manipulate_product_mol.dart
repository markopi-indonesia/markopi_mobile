

import 'package:flutter/material.dart';
import 'package:markopi_mobile/helpers/custom_widget.dart';
import 'package:markopi_mobile/helpers/helper.dart';

class ManipulateProductButtonMol extends StatelessWidget {
  final VoidCallback onAddPressed;
  final VoidCallback onRemovePressed;
  final int totalGoods;

  const ManipulateProductButtonMol({Key key, this.totalGoods, this.onAddPressed, this.onRemovePressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        InkWell(
          onTap: onRemovePressed,
          child: Container(
            width: 30,
            decoration: BoxDecoration(
              borderRadius:
              BorderRadius.circular(5),
              border: Border.all(
                  color: Colors.grey,
                  width: 0.5),
            ),
            height: 30,
            child: Center(
                child: Icon(Icons.remove,size: 15,)),
          ),
        ),
        CustomWidget.emptyHSpace(10.0),
        Text(
          totalGoods.toString(),
          style: Style14Black,
        ),
        CustomWidget.emptyHSpace(10.0),
        InkWell(
          onTap: onAddPressed,
          child: Container(
            width: 30,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius:
              BorderRadius.circular(5),

            ),
            height: 30,
            child: Center(
                child: Icon(
                  Icons.add,
                  size: 15,
                  color: Colors.white,
                )),
          ),
        ),
      ],
    );
  }
}

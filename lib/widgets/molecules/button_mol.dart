

import 'package:flutter/material.dart';

class MolButton{
  BuildContext context;

  MolButton(this.context):assert(context!=null);

  Widget blueButton({
    @required VoidCallback onPressed,
    @required Widget child,
    })
  {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: LinearGradient(
          colors: [
            Color(0xFF677EEA),
            Color(0xFF64B7FF),

          ]
        )
      ),
      child: FlatButton(
        child: child,
        onPressed: onPressed,
      ),
    );
  }
  Widget greenButton({
    @required VoidCallback onPressed,
    @required Widget child,
    })
  {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
          gradient: LinearGradient(
              colors: [
                Color(0xFF66EB8F),
                Color(0xFF01FF5F),

              ]
          ),
      ),
      child: FlatButton(
        child: child,
        onPressed: onPressed,
      ),
    );
  }

  Widget button({
    @required VoidCallback onPressed,
    @required Widget child,
    Color color
    })
  {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: color
        ),
        child: FlatButton(
          child: child,
          onPressed: onPressed,
        ),
      );
  }
}
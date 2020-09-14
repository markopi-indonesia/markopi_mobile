

import 'package:flutter/material.dart';

class CustomWidget{
  static showLoadingDialog(BuildContext context){
    return showDialog(
        context: context,
        barrierDismissible:false ,
        child: Center(
          child: CircularProgressIndicator(),));
  }

  // Space
  static Widget emptyVSpace (space){
    return Padding(padding: EdgeInsets.only(top: space),);
  }

  static Widget emptyHSpace (space){
    return Padding(padding: EdgeInsets.only(left: space),);
  }

  static Widget fillemptyVSpace (){
    return Expanded(child: emptyVSpace(0.0));
  }
}
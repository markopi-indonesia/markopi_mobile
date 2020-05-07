

import 'package:flutter/material.dart';
import 'package:markopi_mobile/helpers/colors.dart';

class OrgFAB{
  final BuildContext context;

  OrgFAB(this.context):assert(context!=null);

  Widget fab({
    @required VoidCallback onPressed,
    @required Widget child,
    Color color = CustomColor.accentColor,
  }){
    return FloatingActionButton(
      backgroundColor: color,
      onPressed: onPressed,
      child: child,
    );
  }
}
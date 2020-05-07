

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markopi_mobile/helpers/custom_widget.dart';
import 'package:markopi_mobile/helpers/helper.dart';
import 'package:markopi_mobile/helpers/style.dart';
import 'package:markopi_mobile/route.dart';
import 'package:markopi_mobile/widgets/widgets.dart';
import 'package:markopi_mobile/components/header_back.dart';

class ChoosePathScreen extends StatefulWidget {
  @override
  _ChoosePathScreenState createState() => _ChoosePathScreenState();
}

class _ChoosePathScreenState extends State<ChoosePathScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light.copyWith(systemNavigationBarColor:Colors.white,statusBarColor:Colors.white),

      child: Scaffold(
        appBar: HeaderBack(),
        body: Container(
          color: Colors.white,
          width: double.maxFinite,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  height: 50,
                  width: 150,
                  child: MolButton(context).blueButton(
                      onPressed: ()=>_pathNavigationButtonPressed(false),
                      child: Text(
                        "Penjualan",
                        style: Style14WhiteBold,
                      )
                  )
              ),
              CustomWidget.emptyVSpace(20.0),
              Container(
                  height: 50,
                  width: 150,
                  child: MolButton(context).blueButton(
                      onPressed: ()=>_pathNavigationButtonPressed(true),
                      child: Text(
                        "Pembelian",
                        style: Style14WhiteBold,
                      )
                  )
              ),


            ],
          ),
        ),
      ),
    );
  }

  void _searchButtonPressed(){
    print("search button tapped");
  }
  void _pathNavigationButtonPressed(bool isPurchaseMode){
    if(!isPurchaseMode)
    Navigator.pushNamed(context, AppRoute.CURRENT_PRODUCT_ROUTE,
        arguments: {"isPurchaseMode":false}
    );
    else
      Navigator.pushNamed(context, AppRoute.CURRENT_PRODUCT_ROUTE,
          arguments: {"isPurchaseMode":true});
  }

}


import 'package:flutter/material.dart';
import 'package:markopi_mobile/helpers/helper.dart';
import 'package:markopi_mobile/route.dart';
import 'package:markopi_mobile/widgets/organisms/app_bar_org.dart';
import 'package:markopi_mobile/widgets/organisms/fab_org.dart';

import 'current_product_gridview.dart';

class CurrentProductScreen extends StatefulWidget {
  final bool isPurchaseMode;

  const CurrentProductScreen({this.isPurchaseMode=false});
  @override
  _CurrentProductScreenState createState() => _CurrentProductScreenState();
}

class _CurrentProductScreenState extends State<CurrentProductScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrgAppBar(context)
          .appBar(
            title:widget.isPurchaseMode?"Pembelian": "Penjualan",
            hasSearch: true,
            blueMode: false,
            onPressedSearch: _searchButtonPressed,
            elevation: 0),
      body: Container(
        child: CurrentProductGridView(isPurchaseMode: widget.isPurchaseMode,),
      ),
      floatingActionButton: !widget.isPurchaseMode? OrgFAB(context)
          .fab(
          onPressed: _fabPressed,
          child: Icon(Icons.add,color: Colors.white,)
          ):
          Container(),

    );
  }

  void _searchButtonPressed(){
    print("search button tapped");
  }

  void _fabPressed(){
    Navigator.pushNamed(context, AppRoute.MANIPULATE_PRODUCT_ROUTE,arguments: {"isEdit":false});
    print("fab button tapped");

  }
}

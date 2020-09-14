

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:markopi_mobile/factory/dummy/seeder.dart';
import 'package:markopi_mobile/factory/models/products/product.dart';
import 'package:markopi_mobile/helpers/converter.dart';
import 'package:markopi_mobile/helpers/helper.dart';
import 'package:markopi_mobile/route.dart';

class CurrentProductGridView extends StatefulWidget {
  final bool isPurchaseMode;

  const CurrentProductGridView({Key key, this.isPurchaseMode}) : super(key: key);
  @override
  _CurrentProductGridViewState createState() => _CurrentProductGridViewState();
}

class _CurrentProductGridViewState extends State<CurrentProductGridView> {
  List<Product> _products = [];
  @override
  void initState() {
    super.initState();
    _products = Seeder.seedProduct();
  }
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 20.0,
          childAspectRatio: 0.7),
      itemCount: _products.length,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(20),
      itemBuilder: (context, i){
        return InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: (){
            if(widget.isPurchaseMode)
              Navigator.pushNamed(context, AppRoute.SHOW_PRODUCT_ROUTE,arguments: {"isPurchaseMode":true});
            else
              Navigator.pushNamed(context, AppRoute.SHOW_PRODUCT_ROUTE,arguments: {"isPurchaseMode":false});
          },
          child: Container(
            height: 100,
            padding: EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 150,
                  width: 180,

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CachedNetworkImage(
                      placeholder:(context, url) => Center(child: CircularProgressIndicator()),
                      imageUrl: _products[i].image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                CustomWidget.emptyVSpace(10.0),
                Text(_products[i].name,style: Style16GreyBold,),
                Text(_products[i].subName,style: Style14Grey,),
                Text(Converter().priceFormat(_products[i].price)+" /${_products[i].perAmount}",style: Style14Grey,),
              ],
            ),
          ),
        );
      },
    );
  }
}

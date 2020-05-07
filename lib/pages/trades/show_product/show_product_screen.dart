

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markopi_mobile/helpers/converter.dart';
import 'package:markopi_mobile/helpers/custom_widget.dart';
import 'package:markopi_mobile/helpers/helper.dart';
import 'package:markopi_mobile/route.dart';
import 'package:markopi_mobile/widgets/molecules/button_mol.dart';
import 'package:markopi_mobile/widgets/organisms/app_bar_org.dart';

class ShowProductScreen extends StatefulWidget{
  final bool isPurchaseMode;

  const ShowProductScreen({Key key, this.isPurchaseMode=false}) : super(key: key);
  @override
  _ShowProductScreenState createState() => _ShowProductScreenState();
}

class _ShowProductScreenState extends State<ShowProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrgAppBar(context).appBar(
          title: "",
          elevation: 0,
          blueMode: false
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _updateFab(),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 25),
        children: <Widget>[
          CustomWidget.emptyVSpace(20.0),
          Center(
            child: Container(
              height: 150,
              width: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: CachedNetworkImage(
                  imageUrl: "https://as2.ftcdn.net/jpg/02/17/33/97/500_F_217339703_f8t8l574PCixzcWy4i1O64LR2MXQScYx.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          CustomWidget.emptyVSpace(20.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Kopi Robusta",style: Style20Black,),
              CustomWidget.emptyVSpace(10.0),
              Text(Converter().priceFormat(75000.0)+" /Kg",style: Style18BlueBold,)
            ],
          ),
          CustomWidget.emptyVSpace(20.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Informasi Produk",style: Style18BlackBold,),
              CustomWidget.emptyVSpace(5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Jumlah stok",style: Style16Grey,),
                  Text("50",style: Style16Grey,),

                ],
              ),
              CustomWidget.emptyVSpace(5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Satuan",style: Style16Grey,),
                  Text("Kilogram",style: Style16Grey,),

                ],
              ),
            ],
          ),
          CustomWidget.emptyVSpace(20.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Deskripsi Produk",style: Style18BlackBold,),
              CustomWidget.emptyVSpace(10.0),
              Text("Kulit kopi belum dikupas",style: Style16Grey,),
            ],
          )

        ],
      ),
    );
  }

  Widget _updateFab(){
    return Container(
      height: 45,
      child: MolButton(context).blueButton(
          onPressed: (){ 
            if(!widget.isPurchaseMode)
            Navigator.pushNamed(
                context,
                AppRoute.MANIPULATE_PRODUCT_ROUTE,
                arguments: {"isEdit":true});
            else {
              Navigator.pushNamed(
                  context,
                  AppRoute.PURCHASE_ROUTE);
            }
          },
          child: Text(widget.isPurchaseMode?"Beli": "Ubah",style: Style14WhiteBold,)),
    );
  }
}

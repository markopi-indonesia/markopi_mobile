
import 'package:flutter/material.dart';
import 'package:markopi_mobile/helpers/helper.dart';
import 'package:markopi_mobile/route.dart';
import 'package:markopi_mobile/widgets/molecules/button_mol.dart';
import 'package:markopi_mobile/widgets/organisms/app_bar_org.dart';

class PurchaseAddressListScreen extends StatefulWidget {
  final bool hasAddress;
  final bool hasTwoAddress;

  const PurchaseAddressListScreen({Key key, this.hasAddress=false, this.hasTwoAddress=false}) : super(key: key);

  @override
  _PurchaseAddressListScreenState createState() => _PurchaseAddressListScreenState();
}

class _PurchaseAddressListScreenState extends State<PurchaseAddressListScreen> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        if(widget.hasAddress){
          Navigator.pushReplacementNamed(context, AppRoute.PURCHASE_DETAIL_ROUTE,arguments: {"hasAdress":true});
          return false;
        }

        return true;
      },
      child: Scaffold(
        appBar: OrgAppBar(context).appBar(
          title: "Alamat",
          blueMode: false,
          elevation: 0,
          useCustomOnBackPressed: true,
          onPressedBackButton: (){
            if(widget.hasAddress){
              Navigator.pushReplacementNamed(context, AppRoute.PURCHASE_DETAIL_ROUTE,arguments: {"hasAdress":true});
              return;
            }
            Navigator.pushReplacementNamed(context, AppRoute.PURCHASE_DETAIL_ROUTE,arguments: {"hasAdress":false});


          }
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: 10),
          children: <Widget>[
            widget.hasAddress? _addressCard(
                "Alexius Manik",
                "(Kampus Institut Teknologi)",
                "+62131238409182",
                "Kampus Institut Teknologi Del Jl. Sisingamangaraja Sitoluama, Laguboti, Toba Samosir, 22381",
            ):Container(),
            widget.hasTwoAddress? _addressCard(
                "Putra Marbun",
                "",
                "+62131238409182",
                "Jalan Gotong Royong Parapat, Girsang Sipangan Bolon, 21174",
            ):Container(),
          ],
        ),
        floatingActionButton: Container(
          height: 40,
          child: MolButton(context).blueButton(
              onPressed: ()=>widget.hasAddress?
              Navigator.pushReplacementNamed(
                  context,
                  AppRoute.PURCHASE_ADD_ADDRESS_ROUTE,
                  arguments: {"twoAddress":true}
                  ):Navigator.pushReplacementNamed(
                  context,
                  AppRoute.PURCHASE_ADD_ADDRESS_ROUTE,
                  arguments: {"twoAddress":false}
              ),
              child: Text("Tambah alamat",style: Style14WhiteBold,)),
        ),
      ),
    );

  }

  Widget _addressCard(name,shortPlace,phone,place){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 5),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color:Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1),spreadRadius: 2,blurRadius: 8)
            ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(name,style: Style14BlackBold,),
                CustomWidget.emptyHSpace(10.0),
                Expanded(child: Text(shortPlace,style: Style14Black,overflow: TextOverflow.ellipsis,)),
              ],
            ),
            CustomWidget.emptyVSpace(10.0),
            Text(phone,style: Style14Grey,),
            CustomWidget.emptyVSpace(10.0),
            Text(place,style: Style12Grey,)
          ],
        ),
      ),
    );
  }
}

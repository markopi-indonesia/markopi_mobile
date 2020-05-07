
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:markopi_mobile/helpers/converter.dart';
import 'package:markopi_mobile/helpers/helper.dart';
import 'package:markopi_mobile/route.dart';
import 'package:markopi_mobile/widgets/molecules/button_mol.dart';
import 'package:markopi_mobile/widgets/molecules/outline_textfield.dart';
import 'package:markopi_mobile/widgets/organisms/app_bar_org.dart';

class PurchaseScreen extends StatefulWidget {
  @override
  _PurchaseScreenState createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  final productAmountCon = new TextEditingController();
  final productNoteCon = new TextEditingController();

  String initialAmount="1";

  @override
  void initState() {
    super.initState();
    productAmountCon.text = initialAmount;
  }

  @override
  void dispose() {
    productAmountCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrgAppBar(context).appBar(
        title: "",
        blueMode: false,
        elevation: 0
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 25,vertical: 15),
        children: <Widget>[
          _headerScreen(),
          CustomWidget.emptyVSpace(20.0),
          _bodyScreen(),
        ],
      ),
      bottomSheet: _bottomCart(),
    );
  }

  Widget _headerScreen(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
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
        CustomWidget.emptyHSpace(20.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Kopi Robusta",style: Style20Black,),
            CustomWidget.emptyVSpace(10.0),
            Text(Converter().priceFormat(75000.0)+" /Kg",style: Style18Blue,)

          ],
        )
      ],
    );
  }

  Widget _bodyScreen(){
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                  child: Text("Jumlah",style: Style16Grey,)),
              Expanded(
                flex: 1,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: (){
                          if(int.parse(productAmountCon.text)!=1){
                            productAmountCon.text=(int.parse(productAmountCon.text)-1).toString();
                          }
                          setState(() {

                          });
                        },
                        child: Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey,width: 1)
                          ),
                          child: Center(
                            child: Icon(Icons.remove,color: Colors.grey,),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: productAmountCon,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: (){
                          productAmountCon.text=(int.parse(productAmountCon.text)+1).toString();
                          setState(() {

                          });
                        },
                        child: Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: CustomColor.accentColor,width: 1)
                          ),
                          child: Center(
                            child: Icon(Icons.add,color: CustomColor.accentColor,),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          CustomWidget.emptyVSpace(20.0),
          Row(
            children: <Widget>[
              Text("Stok terbatas!",style: Style16BlackBold,),
              CustomWidget.emptyHSpace(10.0),
              Text("Tersedia 100 kg",style: Style14Black,)
            ],
          ),
          CustomWidget.emptyVSpace(20.0),
          MolTextField(context).outlineTextField(
              controller: productNoteCon,
              hint: "Catatan untuk penjual (Opsional)",
              lines: 5,
          ),
        ],
      ),
    );
  }

  Widget _bottomCart(){
    return FractionallySizedBox(
      heightFactor: 0.15,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25,),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Harga Barang",style: Style12Grey,),
                  Text(Converter().priceFormat(double.parse(productAmountCon.text)*75000),style: Style14Blue,),

                ],
              ),
            ),
            Container(
              height: 40,
              child: MolButton(context).blueButton(
                  onPressed: ()=>Navigator.pushNamed(
                      context,
                      AppRoute.PURCHASE_DETAIL_ROUTE,
                      arguments: {"hasAdress":false}
                  ),
                  child: Text("Selanjutnya",style: Style14WhiteBold,)),
            )
          ],
        ),
      ),
    );
  }
}

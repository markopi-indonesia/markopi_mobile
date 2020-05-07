import 'package:flutter/material.dart';
import 'package:markopi_mobile/helpers/custom_widget.dart';
import 'package:markopi_mobile/helpers/style.dart';
import 'package:markopi_mobile/pages/trades/purchases/payment/payment_card_list.dart';
import 'package:markopi_mobile/route.dart';
import 'package:markopi_mobile/widgets/organisms/app_bar_org.dart';
import 'package:markopi_mobile/widgets/widgets.dart';

class PurchasePaymentScreen extends StatefulWidget {
  @override
  _PurchasePaymentScreenState createState() => _PurchasePaymentScreenState();
}

class _PurchasePaymentScreenState extends State<PurchasePaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrgAppBar(context).appBar(
        title: "Pembayaran",
        blueMode: false,
        elevation: 0
      ),
      body:Column(
        children: <Widget>[
          CustomWidget.emptyVSpace(20.0),
          PaymentCardList(),
          CustomWidget.emptyVSpace(100.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Total Tagihan",style: Style16GreyDark,),
                    Text("Rp. 880.000",style: Style16GreyDark,)
                  ],
                ),
                Container(
                  height: 1,
                  color: Colors.grey[300],
                  width: double.maxFinite,
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          height: 50,
          width: double.maxFinite,
          child: MolButton(context).blueButton(
              onPressed: ()=>Navigator.pushNamed(context, AppRoute.PURCHASE_PROOF_ROUTE),
              child: Text("Upload Bukti Pembayaran",style: Style14WhiteBold,)),
        ),
      ),
    );
  }
}

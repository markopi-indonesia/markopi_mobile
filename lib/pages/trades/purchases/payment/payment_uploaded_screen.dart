

import 'package:flutter/material.dart';
import 'package:markopi_mobile/helpers/helper.dart';
import 'package:markopi_mobile/route.dart';
import 'package:markopi_mobile/widgets/widgets.dart';

class PaymentUploadedProofScreen extends StatefulWidget {
  @override
  _PaymentUploadedProofScreenState createState() => _PaymentUploadedProofScreenState();
}

class _PaymentUploadedProofScreenState extends State<PaymentUploadedProofScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Konfirmasi",style: Style16GreyDark,),
            Text("Bukti pembayaran berhasil diupload",style: Style14Grey,),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          height: 50,
          width: double.maxFinite,
          child: MolButton(context).blueButton(
              onPressed: ()=>Navigator.pushNamedAndRemoveUntil(context, AppRoute.HOME_ROUTE,(r)=>false),
              child: Text("Beranda",style: Style14WhiteBold,)),
        ),
      ),
    );
  }
}

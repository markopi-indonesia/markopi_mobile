import 'package:flutter/material.dart';
import 'package:markopi_mobile/components/header_back.dart';
import 'package:markopi_mobile/helpers/helper.dart';
import 'package:markopi_mobile/route.dart';
import 'package:markopi_mobile/widgets/molecules/button_mol.dart';
import 'package:markopi_mobile/widgets/organisms/app_bar_org.dart';

class PaymentProofScreen extends StatefulWidget {
  @override
  _PaymentProofScreenState createState() => _PaymentProofScreenState();
}

class _PaymentProofScreenState extends State<PaymentProofScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderBack(),
      body: Center(
        child: Container(
          height: 50,
          child: MolButton(context).blueButton(
              onPressed: () {},
              child: Text(
                "Upload Gambar",
                style: Style14WhiteBold,
              )),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          height: 50,
          width: double.maxFinite,
          child: MolButton(context).blueButton(
              onPressed: () => Navigator.pushNamed(
                  context, AppRoute.PURCHASE_UPLOADED_PROOF_ROUTE),
              child: Text(
                "Konfirmasi",
                style: Style14WhiteBold,
              )),
        ),
      ),
    );
  }
}

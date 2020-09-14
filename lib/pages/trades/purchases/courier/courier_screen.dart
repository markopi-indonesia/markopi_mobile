import 'package:flutter/material.dart';
import 'package:markopi_mobile/pages/trades/purchases/courier/courier_list.dart';
import 'package:markopi_mobile/widgets/molecules/button_mol.dart';
import 'package:markopi_mobile/widgets/organisms/app_bar_org.dart';
import 'package:markopi_mobile/components/header_back.dart';

class PurchaseCourierScreen extends StatefulWidget {
  @override
  _PurchaseCourierScreenState createState() => _PurchaseCourierScreenState();
}

class _PurchaseCourierScreenState extends State<PurchaseCourierScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderBack(),
      body: PurchaseCourierList(),
    );
  }
}

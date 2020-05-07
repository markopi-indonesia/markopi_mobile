

import 'package:flutter/material.dart';
import 'package:markopi_mobile/helpers/converter.dart';
import 'package:markopi_mobile/helpers/helper.dart';
import 'package:markopi_mobile/route.dart';
import 'package:markopi_mobile/widgets/molecules/molecules.dart';
import 'package:markopi_mobile/widgets/molecules/outline_textfield.dart';
import 'package:markopi_mobile/widgets/organisms/app_bar_org.dart';

class PurchaseAddAddressScreen extends StatefulWidget {
  final bool twoAddress;

  const PurchaseAddAddressScreen({Key key, this.twoAddress=false}) : super(key: key);
  @override
  _PurchaseAddAddressScreenState createState() => _PurchaseAddAddressScreenState();
}

class _PurchaseAddAddressScreenState extends State<PurchaseAddAddressScreen> {
  final nameCon = new TextEditingController();
  final addressCon = new TextEditingController();
  final postalCodeCon = new TextEditingController();
  final phoneNumCon = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrgAppBar(context).appBar(
        title: "Buat alamat",
        blueMode: false,
        elevation: 0
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 10),
        children: <Widget>[
          _addressFields("Nama",nameCon,"Contoh : Putra Marbun"),
          _addressFields("Alamat",addressCon,"Contoh : Jalan Gotong Royong"),
          _addressFields("Kode Pos",postalCodeCon,"Contoh : 21174"),
          _addressFields("Nomor Telepon",phoneNumCon,"Contoh : 6212312316576"),
        ],
      ),
      floatingActionButton: MolButton(context).blueButton(
          onPressed: ()=>!widget.twoAddress?
          Navigator.pushReplacementNamed(
              context,
              AppRoute.PURCHASE_ADDRESS_LIST_ROUTE,
              arguments: {"hasAddress":true,"hasTwoAddress":false}
          ):Navigator.pushReplacementNamed(
              context,
              AppRoute.PURCHASE_ADDRESS_LIST_ROUTE,
              arguments: {"hasAddress":true,"hasTwoAddress":true}
          ),
          child: Text("Tambah alamat",style: Style14WhiteBold,)),
    );
  }

  Widget _addressFields(title,controller,hint){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title,style: Style14Black,),
          CustomWidget.emptyVSpace(10.0),
          Container(
            child: MolTextField(context).
            outlineTextField(

                controller: controller,
                textInputType: TextInputType.number,
                hint: hint,
                validator: (v){
                  if(v.isEmpty){
                    return "kolom ini tidak boleh kosong!";
                  }
                  return null;
                }
            ),
          )
        ],
      ),
    );
  }
}

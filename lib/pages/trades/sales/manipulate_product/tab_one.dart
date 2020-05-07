

import 'package:flutter/material.dart';
import 'package:markopi_mobile/helpers/custom_widget.dart';
import 'package:markopi_mobile/helpers/style.dart';
import 'package:markopi_mobile/widgets/molecules/button_mol.dart';
import 'package:markopi_mobile/widgets/molecules/outline_textfield.dart';

import 'manipulate_product.dart';

class ManipulateProductTabOne extends StatefulWidget {
  final ManipulateProductScreenState parent;

  const ManipulateProductTabOne({Key key, this.parent}) : super(key: key);
  @override
  _ManipulateProductTabOneState createState() => _ManipulateProductTabOneState();
}

class _ManipulateProductTabOneState extends State<ManipulateProductTabOne> {
  TextEditingController productNameCon = TextEditingController();
  TextEditingController productAmountCon=TextEditingController();
  TextEditingController productPriceCon=TextEditingController();
  TextEditingController productDescriptionCon=TextEditingController();

  @override
  void dispose() {
    productNameCon.dispose();
    productAmountCon.dispose();
    productPriceCon.dispose();
    productDescriptionCon.dispose();
    super.dispose();
  }

  String initialUnit;

  @override
  void initState() {
    super.initState();
    if(widget.parent.isEdit){
      productNameCon.text="Kopi Robusta";
      productAmountCon.text="15";
      productPriceCon.text="80.000";
      productDescriptionCon.text="Kopi robusta adalah kopi";
      initialUnit = "Kilogram";
    }
  }
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 25),
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        CustomWidget.emptyVSpace(15.0),
        _productName(),
        CustomWidget.emptyVSpace(15.0),
        Row(
          children: <Widget>[
            Expanded(
              child: _productAmount(),
            ),
            Expanded(
              child: _productUnit(),
            )
          ],
        ),
        CustomWidget.emptyVSpace(15.0),
        _productPricePerPiece(),
        CustomWidget.emptyVSpace(15.0),
        _productDescription(),
        CustomWidget.emptyVSpace(85.0),

      ],
    );
  }



  Widget _productName(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Nama produk kopi",style: Style14Black,),
        CustomWidget.emptyVSpace(10.0),
        Container(
          child: MolTextField(context).
          outlineTextField(
              controller: productNameCon,
              hint: "Contoh : Robusta",
              validator: (v){
                if(v.isEmpty){
                  return "kolom ini tidak boleh kosong!";
                }
                return null;
              }
          ),
        )
      ],
    );
  }
  
  Widget _productAmount(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Masukkan jumlah",style: Style14Black,),
          CustomWidget.emptyVSpace(10.0),
          Container(
            width: 150,
            child: MolTextField(context).
            outlineTextField(

                controller: productAmountCon,
                textInputType: TextInputType.number,
                hint: "Contoh : 15",
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

  Widget _productUnit(){
    return Container(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Satuan",style: Style14Black,),
          CustomWidget.emptyVSpace(10.0),
          DropdownButtonFormField<String>(
            isDense: true,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 18
                ),
                border: OutlineInputBorder()
            ),
            hint: Text("Pilih satuan"),
            value: initialUnit,
            items: <String>['Miligram', 'Gram', 'Kilogram'].map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
            onChanged: (_) {},
          ),
        ],
      ),
    );
  }

  Widget _productPricePerPiece(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Harga persatuan",style: Style14Black,),
        CustomWidget.emptyVSpace(10.0),
        Container(
          width: 150,
          height: 50,
          child: MolTextField(context).
          outlineTextField(
              prefix: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Text("Rp ",style: Style14Grey,),
              ),
              controller: productPriceCon,
              textInputType: TextInputType.number,
              hint: "",
              validator: (v){
                if(v.isEmpty){
                  return "kolom ini tidak boleh kosong!";
                }
                return null;
              }
          ),
        )
      ],
    );
  }

  Widget _productDescription(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Deskripsi",style: Style14Black,),
        CustomWidget.emptyVSpace(10.0),
        Container(
          child: MolTextField(context).
          outlineTextField(
              controller: productDescriptionCon,
              hint: "Contoh : Kopi robusta memiliki cita rasa yang kuat dan cenderung lebih pahit dibanding arabika",
              lines: 5,
              validator: (v){
                if(v.isEmpty){
                  return "kolom ini tidak boleh kosong!";
                }
                return null;
              }
          ),
        )
      ],
    );
  }
}

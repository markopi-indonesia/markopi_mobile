import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markopi_mobile/factory/models/order/user_detail.dart';
import 'package:markopi_mobile/factory/models/shipping/shipping_address.dart';
import 'package:markopi_mobile/helpers/helper.dart';
import 'package:markopi_mobile/resources/trades/user_order_details/bloc/user_order_detail_bloc.dart';
import 'package:markopi_mobile/resources/trades/user_order_details/bloc/user_order_detail_event.dart';
import 'package:markopi_mobile/resources/trades/user_order_details/bloc/user_order_detail_state.dart';
import 'package:markopi_mobile/route.dart';
import 'package:markopi_mobile/widgets/molecules/molecules.dart';
import 'package:markopi_mobile/widgets/molecules/outline_textfield.dart';
import 'package:markopi_mobile/components/header_back.dart';
import 'package:uuid/uuid.dart';

class PurchaseManipulateAddressScreen extends StatefulWidget {
  final ShippingAddressModel shippingAddress;
  const PurchaseManipulateAddressScreen({Key key, this.shippingAddress,})
      : super(key: key);
  @override
  _PurchaseManipulateAddressScreenState createState() =>
      _PurchaseManipulateAddressScreenState();
}

class _PurchaseManipulateAddressScreenState extends State<PurchaseManipulateAddressScreen> {
  TextEditingController titleCon;
  TextEditingController nameCon;
  TextEditingController addressCon;
  TextEditingController postalCodeCon;
  TextEditingController phoneNumCon ;

  UserOrderDetailModel userOrderDetailModel;

  GlobalKey<FormState> _formState;

  @override
  void initState() {
    _formState = new GlobalKey<FormState>();
    titleCon = new TextEditingController();
    nameCon = new TextEditingController();
    addressCon = new TextEditingController();
    postalCodeCon = new TextEditingController();
    phoneNumCon = new TextEditingController();
    BlocProvider.of<UserOrderDetailBloc>(context)..add(LoadUserOrderDetail());
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderBack(),
      body: BlocBuilder<UserOrderDetailBloc,UserOrderDetailState>(
        builder:(context, state) {
          if(state is UserOrderDetailLoaded){
            print(state.userDetail.toJson());
            userOrderDetailModel = state.userDetail;
            return Form(
              key: _formState,
              onChanged: () {
                if(_formState.currentState.validate()){

                }
              },
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 10),
                children: <Widget>[
                  _addressFields("Judul Alamat", titleCon, "Contoh : Rumah,Nama instansi",false),
                  _addressFields("Nama", nameCon, "Contoh : Putra Marbun",false),
                  _addressFields("Alamat", addressCon, "Contoh : Jalan Gotong Royong",false),
                  _addressFields("Kode Pos", postalCodeCon, "Contoh : 21174",true),
                  _addressFields(
                      "Nomor Telepon", phoneNumCon, "Contoh : 6212312316576",true),
                  CustomWidget.emptyVSpace(100.0),
                ],
              ),
            );
          }

          return Center(child: CircularProgressIndicator(),);
        }
      ),
      floatingActionButton: MolButton(context).blueButton(
          onPressed: () {
            if(_formState.currentState.validate()) {
              var temp = ShippingAddressModel(
                id: Uuid().v4(),
                deliveryName: nameCon.text,
                address: addressCon.text,
                postalCode: postalCodeCon.text,
                phoneNumber: phoneNumCon.text,
                addressTitle: titleCon.text,
              );
              userOrderDetailModel.shippingAddresses.data.add(temp);
              print(userOrderDetailModel.toJson());
              BlocProvider.of<UserOrderDetailBloc>(context)
                ..add(UpdateUserOrderDetail(
                    addressListModel: userOrderDetailModel.shippingAddresses,
                    context: context
                )
                );

              Navigator.pushReplacementNamed(
                  context, AppRoute.PURCHASE_ADDRESS_LIST_ROUTE);

            } else {
              CustomWidget.showFlushBar(context, "Isi semua kolom yang kosong!");
            }


          },
          child: Text(
            "Tambah alamat",
            style: Style14WhiteBold,
          )),
    );
  }

  Widget _addressFields(title, controller, hint,isNumber) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Style14Black,
          ),
          CustomWidget.emptyVSpace(10.0),
          Container(
            child: MolTextField(context).outlineTextField(
                controller: controller,
                textInputType: isNumber? TextInputType.number:TextInputType.text,
                hint: hint,
                validator: (v) {
                  if (v.isEmpty) {
                    return "kolom ini tidak boleh kosong!";
                  }
                  return null;
                }),
          )
        ],
      ),
    );
  }
}

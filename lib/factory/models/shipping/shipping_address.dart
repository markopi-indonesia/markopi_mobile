

import 'package:equatable/equatable.dart';


class ShippingAddressListModel extends Equatable{
  List<ShippingAddressModel> data;

  ShippingAddressListModel({this.data});
  @override
  List<Object> get props => [data];

  factory ShippingAddressListModel.fromJson(Map<String,dynamic> json)=>ShippingAddressListModel(
    data: List.from(json['shipping_addresses'].map((e)=>ShippingAddressModel.fromJson(e))),
  );


  toJson()=>{
    "shipping_addresses":List.from(data.map((e) => e.toJson())),
  };
}

class ShippingAddressModel extends Equatable{
  final String id;
  final String deliveryName;
  final String addressTitle;
  final String address;
  final String postalCode;
  final String phoneNumber;

  ShippingAddressModel( {this.id,this.addressTitle,this.phoneNumber, this.deliveryName, this.address, this.postalCode});

  @override
  List<Object> get props => [deliveryName,address,postalCode,id,phoneNumber,addressTitle];

  factory ShippingAddressModel.fromJson(Map<String,dynamic> json)=>ShippingAddressModel(
    id:json['id']??"",
    postalCode:json['postal_code']??"",
    address: json['address']??"",
    deliveryName: json['delivery_name']??"",
    phoneNumber: json['phone_number']??"",
    addressTitle: json['address_title']??""
  );

  toJson()=>{
    "id":id??"",
    "delivery_name":deliveryName??"",
    "address":address??"",
    "postal_code":postalCode??"",
    "phone_number":phoneNumber??"",
    "address_title":addressTitle??"",
  };

}
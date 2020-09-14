

import 'package:equatable/equatable.dart';
import 'package:markopi_mobile/factory/data/couriers.dart';
import 'package:markopi_mobile/factory/models/couriers/couriers.dart';
import 'package:markopi_mobile/factory/models/shipping/shipping_address.dart';
import 'package:markopi_mobile/factory/models/shipping/shipping_method.dart';
import 'package:markopi_mobile/models/user.dart';

class UserOrderDetailModel extends Equatable{
  UserModel user;
  String notes;
  String chosenIdAddress;
  int chosenShippingIdMethod;
  ShippingAddressListModel shippingAddresses;
  UserOrderDetailModel({this.chosenIdAddress, this.user, this.notes,this.chosenShippingIdMethod,this.shippingAddresses});

  factory UserOrderDetailModel.fromJson(Map<String,dynamic> json)=> UserOrderDetailModel(
    user: UserModel.fromJson(json['user']),
    notes: json['notes'],
    chosenIdAddress: json['choosen_id_address'],
    chosenShippingIdMethod: json['shipping_id_method'],
    shippingAddresses: ShippingAddressListModel.fromJson(json['shipping_addresses']),

  );

  toJson()=>{
    "user":user.toJson(),
    "notes":notes,
    "choosen_id_address":chosenIdAddress,
    "shipping_id_method":chosenShippingIdMethod,
    "shipping_addresses":shippingAddresses.toJson(),
  };

  @override
  List<Object> get props => [user,notes,chosenShippingIdMethod,chosenIdAddress];


  ShippingAddressModel get chosenAddress => shippingAddresses.data.firstWhere((element) => element.id==chosenIdAddress);
  CourierModel get chosenShippingMethod => Couriers.couriers.firstWhere((element) => element.id==chosenShippingIdMethod);
}
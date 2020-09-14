

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:googleapis/admin/directory_v1.dart';
import 'package:markopi_mobile/factory/models/order/user_detail.dart';
import 'package:markopi_mobile/factory/models/shipping/shipping_address.dart';
import 'package:markopi_mobile/factory/models/shipping/shipping_method.dart';
import 'package:markopi_mobile/models/user.dart';

class UserOrderDetailEvent extends Equatable{
  @override
  List<Object> get props => [];

}

class LoadUserOrderDetail extends UserOrderDetailEvent{
  final BuildContext context;

  LoadUserOrderDetail({this.context});
  @override
  List<Object> get props => [context];
}
class AddUserOrderDetail extends UserOrderDetailEvent{}
class UpdateUserOrderDetail extends UserOrderDetailEvent{
  final BuildContext context;
  final UserModel user;
  final String notes;
  final String chosenIdAddress;
  final int chosenIdShippingMethod;
  final ShippingAddressListModel addressListModel;

  UpdateUserOrderDetail({this.chosenIdAddress,  this.context,this.user, this.notes, this.chosenIdShippingMethod, this.addressListModel});
  @override
  List<Object> get props => [chosenIdAddress,context,user,notes,chosenIdShippingMethod,addressListModel];
}
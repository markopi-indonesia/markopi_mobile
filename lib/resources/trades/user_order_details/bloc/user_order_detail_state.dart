

import 'package:equatable/equatable.dart';
import 'package:markopi_mobile/factory/models/order/user_detail.dart';

class UserOrderDetailState extends Equatable{
  @override
  List<Object> get props => [];
}

class UserOrderDetailInitial extends UserOrderDetailState{}
class UserOrderDetailLoading extends UserOrderDetailState{}
class UserOrderDetailError extends UserOrderDetailState{}
class UserOrderDetailLoaded extends UserOrderDetailState{
  final UserOrderDetailModel userDetail;

  UserOrderDetailLoaded({this.userDetail});

  @override
  List<Object> get props => [userDetail];
}

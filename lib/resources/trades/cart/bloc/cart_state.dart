

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:markopi_mobile/factory/models/cart/cart.dart';
import 'package:markopi_mobile/factory/models/products/product.dart';

class CartState extends Equatable{
  @override
  List<Object> get props => [];

}


class CartInitial extends CartState{}
class CartLoading extends CartState{}
class CartError extends CartState{}
class CartLoaded extends CartState{
  final CartModel cart;

  CartLoaded({@required this.cart});
  @override
  List<Object> get props => [cart];

  List<ProductModel> get filteredProduct => cart.products.toSet().toList();
}
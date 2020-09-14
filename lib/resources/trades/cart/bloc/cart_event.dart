



import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:markopi_mobile/factory/models/products/product.dart';
import 'package:markopi_mobile/models/purchase.dart';

class CartEvent extends Equatable{
  @override
  List<Object> get props => [];

}

class LoadCart extends CartEvent{
  final BuildContext context;

  LoadCart({this.context});

  @override
  List<Object> get props => [context];
}
class AddItem extends CartEvent{
  final BuildContext context;
  final ProductModel item;

  AddItem({this.context,this.item, });

  @override
  List<Object> get props =>[item,context];
}
class RemoveItem extends CartEvent{
  final BuildContext context;
  final ProductModel item;

  RemoveItem({this.context,this.item, });

  @override
  List<Object> get props =>[item,context];
}

class ClearCart extends CartEvent{
  final BuildContext context;

  ClearCart({this.context});

  @override
  List<Object> get props =>[context];
}
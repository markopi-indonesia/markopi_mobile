import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:markopi_mobile/factory/models/cart/cart.dart';
import 'package:markopi_mobile/factory/models/order/user_detail.dart';
import 'package:markopi_mobile/factory/models/products/product.dart';
import 'package:markopi_mobile/helpers/constants.dart';

import 'cache.dart';

class DataCartProvider{
  final BuildContext context;
  DataCartProvider(this.context);

  Future<bool> saveCartToCache(CartModel cart)async{
    try {
      await Cache.setCache(key: CART_CACHE_ID, data: jsonEncode(cart.toJson()));
    } catch (e){
      return false;
    }
    return true;
  }

  Future<bool> saveUserDetailToCache(UserOrderDetailModel userDetail)async{
    print("Data : "+jsonEncode(userDetail.toJson()));
    try {
      await Cache.setCache(key: USER_DETAIL_CACHE_ID, data: jsonEncode(userDetail.toJson()));
    } catch (e){
      print(e.toString());
      return false;
    }
    return true;
  }

  Future<CartModel> getCartFromCache()async{
    CartModel cart = new CartModel(products: []);
    try {
      var json= await Cache.getCache(key: CART_CACHE_ID,);
      var decoded = jsonDecode(json);
      if(decoded!=null){
        decoded.forEach((e){
          cart.products.add(ProductModel.fromJson(e));
        });
        print(cart.products.length);
      } else return null;
    } catch (e){
      return null;
    }
    return cart;
  }

  Future<UserOrderDetailModel> getUserDetailCache()async{
    UserOrderDetailModel userDetail = new UserOrderDetailModel();
    try {
      var json= await Cache.getCache(key: USER_DETAIL_CACHE_ID,);
      var decoded = jsonDecode(json);
      if(decoded!=null){
        userDetail = UserOrderDetailModel.fromJson(decoded);
      }
      else return null;
    } catch (e){
      print(e.toString());
      return null;
    }
    return userDetail;
  }
}